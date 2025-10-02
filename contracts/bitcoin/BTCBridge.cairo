#[starknet::contract]
mod BTCBridge {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        wrapped_btc: ContractAddress,
        deposits: LegacyMap<u256, BTCDeposit>,
        deposit_count: u256,
        withdrawals: LegacyMap<u256, BTCWithdrawal>,
        withdrawal_count: u256,
        total_locked: u256,
        min_confirmations: u32,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct BTCDeposit {
        id: u256,
        depositor: ContractAddress,
        btc_tx_hash: felt252,
        amount: u256,
        confirmations: u32,
        timestamp: u64,
        status: DepositStatus,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct BTCWithdrawal {
        id: u256,
        withdrawer: ContractAddress,
        btc_address: felt252,
        amount: u256,
        timestamp: u64,
        status: WithdrawalStatus,
    }

    #[derive(Drop, Serde, starknet::Store, PartialEq)]
    enum DepositStatus {
        Pending,
        Confirmed,
        Minted,
    }

    #[derive(Drop, Serde, starknet::Store, PartialEq)]
    enum WithdrawalStatus {
        Requested,
        Processing,
        Completed,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositInitiated: DepositInitiated,
        DepositConfirmed: DepositConfirmed,
        WithdrawalRequested: WithdrawalRequested,
        WithdrawalCompleted: WithdrawalCompleted,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositInitiated {
        deposit_id: u256,
        depositor: ContractAddress,
        btc_tx_hash: felt252,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositConfirmed {
        deposit_id: u256,
        confirmations: u32,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalRequested {
        withdrawal_id: u256,
        withdrawer: ContractAddress,
        btc_address: felt252,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalCompleted {
        withdrawal_id: u256,
        btc_tx_hash: felt252,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        wrapped_btc: ContractAddress,
        min_confirmations: u32
    ) {
        self.owner.write(owner);
        self.wrapped_btc.write(wrapped_btc);
        self.min_confirmations.write(min_confirmations);
    }

    #[abi(embed_v0)]
    impl BTCBridgeImpl of super::IBTCBridge<ContractState> {
        fn initiate_deposit(
            ref self: ContractState,
            btc_tx_hash: felt252,
            amount: u256,
            proof: Array<felt252>
        ) -> u256 {
            assert(amount > 0, 'Amount must be positive');
            assert(proof.len() > 0, 'Proof required');

            let deposit_id = self.deposit_count.read() + 1;
            let depositor = get_caller_address();

            let deposit = BTCDeposit {
                id: deposit_id,
                depositor,
                btc_tx_hash,
                amount,
                confirmations: 0,
                timestamp: get_block_timestamp(),
                status: DepositStatus::Pending,
            };

            self.deposits.write(deposit_id, deposit);
            self.deposit_count.write(deposit_id);

            self.emit(DepositInitiated { deposit_id, depositor, btc_tx_hash, amount });
            deposit_id
        }

        fn confirm_deposit(ref self: ContractState, deposit_id: u256, confirmations: u32) {
            assert(get_caller_address() == self.owner.read(), 'Only owner can confirm');

            let mut deposit = self.deposits.read(deposit_id);
            assert(deposit.status == DepositStatus::Pending, 'Deposit not pending');

            deposit.confirmations = confirmations;
            
            if confirmations >= self.min_confirmations.read() {
                deposit.status = DepositStatus::Confirmed;
                self.total_locked.write(self.total_locked.read() + deposit.amount);
            }

            self.deposits.write(deposit_id, deposit);
            self.emit(DepositConfirmed { deposit_id, confirmations });
        }

        fn request_withdrawal(
            ref self: ContractState,
            btc_address: felt252,
            amount: u256
        ) -> u256 {
            assert(amount > 0, 'Amount must be positive');
            assert(amount <= self.total_locked.read(), 'Insufficient bridge balance');

            let withdrawal_id = self.withdrawal_count.read() + 1;
            let withdrawer = get_caller_address();

            let withdrawal = BTCWithdrawal {
                id: withdrawal_id,
                withdrawer,
                btc_address,
                amount,
                timestamp: get_block_timestamp(),
                status: WithdrawalStatus::Requested,
            };

            self.withdrawals.write(withdrawal_id, withdrawal);
            self.withdrawal_count.write(withdrawal_id);

            self.emit(WithdrawalRequested { 
                withdrawal_id, 
                withdrawer, 
                btc_address, 
                amount 
            });
            withdrawal_id
        }

        fn complete_withdrawal(
            ref self: ContractState,
            withdrawal_id: u256,
            btc_tx_hash: felt252
        ) {
            assert(get_caller_address() == self.owner.read(), 'Only owner can complete');

            let mut withdrawal = self.withdrawals.read(withdrawal_id);
            assert(
                withdrawal.status == WithdrawalStatus::Requested,
                'Withdrawal not requested'
            );

            withdrawal.status = WithdrawalStatus::Completed;
            self.withdrawals.write(withdrawal_id, withdrawal);

            self.total_locked.write(self.total_locked.read() - withdrawal.amount);

            self.emit(WithdrawalCompleted { withdrawal_id, btc_tx_hash });
        }

        fn get_deposit(self: @ContractState, deposit_id: u256) -> BTCDeposit {
            self.deposits.read(deposit_id)
        }

        fn get_withdrawal(self: @ContractState, withdrawal_id: u256) -> BTCWithdrawal {
            self.withdrawals.read(withdrawal_id)
        }

        fn get_total_locked(self: @ContractState) -> u256 {
            self.total_locked.read()
        }
    }
}

#[starknet::interface]
trait IBTCBridge<TContractState> {
    fn initiate_deposit(
        ref self: TContractState,
        btc_tx_hash: felt252,
        amount: u256,
        proof: Array<felt252>
    ) -> u256;
    fn confirm_deposit(ref self: TContractState, deposit_id: u256, confirmations: u32);
    fn request_withdrawal(
        ref self: TContractState,
        btc_address: felt252,
        amount: u256
    ) -> u256;
    fn complete_withdrawal(ref self: TContractState, withdrawal_id: u256, btc_tx_hash: felt252);
    fn get_deposit(self: @TContractState, deposit_id: u256) -> BTCBridge::BTCDeposit;
    fn get_withdrawal(self: @TContractState, withdrawal_id: u256) -> BTCBridge::BTCWithdrawal;
    fn get_total_locked(self: @TContractState) -> u256;
}
