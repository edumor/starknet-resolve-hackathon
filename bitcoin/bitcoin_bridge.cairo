#[starknet::contract]
mod BitcoinBridge {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    
    #[storage]
    struct Storage {
        owner: ContractAddress,
        // Bitcoin transaction hash -> Starknet transaction status
        btc_deposits: LegacyMap<felt252, DepositStatus>,
        // User -> wrapped BTC balance
        wrapped_btc_balances: LegacyMap<ContractAddress, u256>,
        // Withdrawal requests
        withdrawal_requests: LegacyMap<u256, WithdrawalRequest>,
        withdrawal_counter: u256,
        // Oracle for BTC/ETH price feed
        btc_price_oracle: ContractAddress,
        // Minimum confirmations required
        min_confirmations: u8,
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct DepositStatus {
        user: ContractAddress,
        amount: u256,
        confirmations: u8,
        timestamp: u64,
        processed: bool,
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct WithdrawalRequest {
        user: ContractAddress,
        amount: u256,
        btc_address: felt252,
        timestamp: u64,
        processed: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositInitiated: DepositInitiated,
        DepositConfirmed: DepositConfirmed,
        WithdrawalRequested: WithdrawalRequested,
        WithdrawalProcessed: WithdrawalProcessed,
        PriceUpdated: PriceUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositInitiated {
        btc_tx_hash: felt252,
        user: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositConfirmed {
        btc_tx_hash: felt252,
        user: ContractAddress,
        wrapped_amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalRequested {
        request_id: u256,
        user: ContractAddress,
        amount: u256,
        btc_address: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalProcessed {
        request_id: u256,
        btc_tx_hash: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct PriceUpdated {
        new_price: u256,
        timestamp: u64,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        oracle: ContractAddress,
        min_confirmations: u8
    ) {
        self.owner.write(owner);
        self.btc_price_oracle.write(oracle);
        self.min_confirmations.write(min_confirmations);
    }

    #[external(v0)]
    fn initiate_deposit(
        ref self: ContractState,
        btc_tx_hash: felt252,
        amount: u256,
        user: ContractAddress
    ) {
        // Only oracle can initiate deposits
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can initiate');

        let deposit = DepositStatus {
            user,
            amount,
            confirmations: 0,
            timestamp: get_block_timestamp(),
            processed: false,
        };

        self.btc_deposits.write(btc_tx_hash, deposit);
        self.emit(DepositInitiated { btc_tx_hash, user, amount });
    }

    #[external(v0)]
    fn confirm_deposit(ref self: ContractState, btc_tx_hash: felt252, confirmations: u8) {
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can confirm');

        let mut deposit = self.btc_deposits.read(btc_tx_hash);
        assert(!deposit.processed, 'Deposit already processed');

        deposit.confirmations = confirmations;

        if confirmations >= self.min_confirmations.read() {
            // Process the deposit
            deposit.processed = true;
            
            // Mint wrapped BTC
            let current_balance = self.wrapped_btc_balances.read(deposit.user);
            self.wrapped_btc_balances.write(deposit.user, current_balance + deposit.amount);

            self.emit(DepositConfirmed {
                btc_tx_hash,
                user: deposit.user,
                wrapped_amount: deposit.amount,
            });
        }

        self.btc_deposits.write(btc_tx_hash, deposit);
    }

    #[external(v0)]
    fn request_withdrawal(ref self: ContractState, amount: u256, btc_address: felt252) {
        let caller = get_caller_address();
        let current_balance = self.wrapped_btc_balances.read(caller);
        assert(current_balance >= amount, 'Insufficient balance');

        // Burn wrapped BTC
        self.wrapped_btc_balances.write(caller, current_balance - amount);

        // Create withdrawal request
        let request_id = self.withdrawal_counter.read() + 1;
        self.withdrawal_counter.write(request_id);

        let request = WithdrawalRequest {
            user: caller,
            amount,
            btc_address,
            timestamp: get_block_timestamp(),
            processed: false,
        };

        self.withdrawal_requests.write(request_id, request);

        self.emit(WithdrawalRequested {
            request_id,
            user: caller,
            amount,
            btc_address,
        });
    }

    #[external(v0)]
    fn process_withdrawal(ref self: ContractState, request_id: u256, btc_tx_hash: felt252) {
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can process');

        let mut request = self.withdrawal_requests.read(request_id);
        assert(!request.processed, 'Already processed');

        request.processed = true;
        self.withdrawal_requests.write(request_id, request);

        self.emit(WithdrawalProcessed { request_id, btc_tx_hash });
    }

    #[external(v0)]
    fn swap_btc_to_strk(
        ref self: ContractState,
        btc_amount: u256,
        strk_token: ContractAddress,
        min_strk_amount: u256
    ) {
        let caller = get_caller_address();
        let btc_balance = self.wrapped_btc_balances.read(caller);
        assert(btc_balance >= btc_amount, 'Insufficient BTC balance');

        // Get current BTC price from oracle
        let btc_price = self._get_btc_price();
        let strk_amount = (btc_amount * btc_price) / 100000000; // Convert from satoshis
        
        assert(strk_amount >= min_strk_amount, 'Slippage too high');

        // Burn BTC
        self.wrapped_btc_balances.write(caller, btc_balance - btc_amount);

        // Transfer STRK
        let strk = IERC20Dispatcher { contract_address: strk_token };
        strk.transfer(caller, strk_amount);
    }

    #[view]
    fn get_btc_balance(self: @ContractState, user: ContractAddress) -> u256 {
        self.wrapped_btc_balances.read(user)
    }

    #[view]
    fn get_deposit_status(self: @ContractState, btc_tx_hash: felt252) -> DepositStatus {
        self.btc_deposits.read(btc_tx_hash)
    }

    #[view]
    fn get_withdrawal_request(self: @ContractState, request_id: u256) -> WithdrawalRequest {
        self.withdrawal_requests.read(request_id)
    }

    // Private helper function
    fn _get_btc_price(self: @ContractState) -> u256 {
        // Placeholder - in production, call actual price oracle
        50000_u256 // $50,000 per BTC
    }
}