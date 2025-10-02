#[starknet::contract]
mod BTCBridge {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use core::starknet::storage::Map;

    #[storage]
    struct Storage {
        owner: ContractAddress,
        wrapped_btc_supply: u256,
        deposits: Map<felt252, Deposit>, // BTC tx hash => Deposit
        withdrawals: Map<u256, Withdrawal>,
        withdrawal_count: u256,
        guardians: Map<ContractAddress, bool>,
        guardian_count: u32,
        required_confirmations: u32,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Deposit {
        btc_tx_hash: felt252,
        user: ContractAddress,
        amount: u256,
        confirmations: u32,
        claimed: bool,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Withdrawal {
        id: u256,
        user: ContractAddress,
        amount: u256,
        btc_address: felt252,
        processed: bool,
        guardian_approvals: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositInitiated: DepositInitiated,
        DepositConfirmed: DepositConfirmed,
        WithdrawalRequested: WithdrawalRequested,
        WithdrawalProcessed: WithdrawalProcessed,
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
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalRequested {
        withdrawal_id: u256,
        user: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalProcessed {
        withdrawal_id: u256,
        btc_address: felt252,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        required_confirmations: u32,
    ) {
        self.owner.write(owner);
        self.required_confirmations.write(required_confirmations);
        self.withdrawal_count.write(0);
        self.guardian_count.write(0);
    }

    #[abi(embed_v0)]
    impl BTCBridgeImpl of super::IBTCBridge<ContractState> {
        // Guardian reports BTC deposit on Bitcoin network
        fn report_deposit(
            ref self: ContractState,
            btc_tx_hash: felt252,
            user: ContractAddress,
            amount: u256,
        ) {
            let caller = get_caller_address();
            assert(self.guardians.entry(caller).read(), 'Not a guardian');

            let mut deposit = self.deposits.entry(btc_tx_hash).read();
            
            if deposit.amount == 0 {
                // New deposit
                deposit = Deposit {
                    btc_tx_hash,
                    user,
                    amount,
                    confirmations: 1,
                    claimed: false,
                };
                
                self.emit(DepositInitiated { btc_tx_hash, user, amount });
            } else {
                // Existing deposit, increment confirmations
                deposit.confirmations += 1;
            }

            self.deposits.entry(btc_tx_hash).write(deposit);

            // If enough confirmations, mint wrapped BTC
            if deposit.confirmations >= self.required_confirmations.read() && !deposit.claimed {
                self._mint_wrapped_btc(user, amount);
                deposit.claimed = true;
                self.deposits.entry(btc_tx_hash).write(deposit);
                
                self.emit(DepositConfirmed { btc_tx_hash, user });
            }
        }

        // User requests withdrawal to BTC address
        fn request_withdrawal(
            ref self: ContractState,
            amount: u256,
            btc_address: felt252,
        ) -> u256 {
            let caller = get_caller_address();
            let withdrawal_id = self.withdrawal_count.read() + 1;

            let withdrawal = Withdrawal {
                id: withdrawal_id,
                user: caller,
                amount,
                btc_address,
                processed: false,
                guardian_approvals: 0,
            };

            self.withdrawals.entry(withdrawal_id).write(withdrawal);
            self.withdrawal_count.write(withdrawal_id);

            // Burn wrapped BTC
            self._burn_wrapped_btc(caller, amount);

            self.emit(WithdrawalRequested { 
                withdrawal_id, 
                user: caller, 
                amount 
            });

            withdrawal_id
        }

        // Guardian approves withdrawal
        fn approve_withdrawal(ref self: ContractState, withdrawal_id: u256) {
            let caller = get_caller_address();
            assert(self.guardians.entry(caller).read(), 'Not a guardian');

            let mut withdrawal = self.withdrawals.entry(withdrawal_id).read();
            assert(!withdrawal.processed, 'Already processed');

            withdrawal.guardian_approvals += 1;

            if withdrawal.guardian_approvals >= self.required_confirmations.read() {
                withdrawal.processed = true;
                
                self.emit(WithdrawalProcessed { 
                    withdrawal_id, 
                    btc_address: withdrawal.btc_address 
                });
            }

            self.withdrawals.entry(withdrawal_id).write(withdrawal);
        }

        // Owner adds guardian
        fn add_guardian(ref self: ContractState, guardian: ContractAddress) {
            assert(get_caller_address() == self.owner.read(), 'Not owner');
            
            if !self.guardians.entry(guardian).read() {
                self.guardians.entry(guardian).write(true);
                self.guardian_count.write(self.guardian_count.read() + 1);
            }
        }

        fn get_deposit(self: @ContractState, btc_tx_hash: felt252) -> Deposit {
            self.deposits.entry(btc_tx_hash).read()
        }

        fn get_withdrawal(self: @ContractState, withdrawal_id: u256) -> Withdrawal {
            self.withdrawals.entry(withdrawal_id).read()
        }

        fn get_wrapped_btc_supply(self: @ContractState) -> u256 {
            self.wrapped_btc_supply.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _mint_wrapped_btc(ref self: ContractState, to: ContractAddress, amount: u256) {
            let current_supply = self.wrapped_btc_supply.read();
            self.wrapped_btc_supply.write(current_supply + amount);
            // In real implementation, would mint ERC20 tokens
        }

        fn _burn_wrapped_btc(ref self: ContractState, from: ContractAddress, amount: u256) {
            let current_supply = self.wrapped_btc_supply.read();
            assert(current_supply >= amount, 'Insufficient supply');
            self.wrapped_btc_supply.write(current_supply - amount);
            // In real implementation, would burn ERC20 tokens
        }
    }
}

#[starknet::interface]
trait IBTCBridge<TContractState> {
    fn report_deposit(
        ref self: TContractState,
        btc_tx_hash: felt252,
        user: starknet::ContractAddress,
        amount: u256,
    );
    fn request_withdrawal(
        ref self: TContractState,
        amount: u256,
        btc_address: felt252,
    ) -> u256;
    fn approve_withdrawal(ref self: TContractState, withdrawal_id: u256);
    fn add_guardian(ref self: TContractState, guardian: starknet::ContractAddress);
    fn get_deposit(self: @TContractState, btc_tx_hash: felt252) -> BTCBridge::Deposit;
    fn get_withdrawal(self: @TContractState, withdrawal_id: u256) -> BTCBridge::Withdrawal;
    fn get_wrapped_btc_supply(self: @TContractState) -> u256;
}
