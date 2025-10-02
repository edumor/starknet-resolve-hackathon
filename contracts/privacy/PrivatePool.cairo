#[starknet::contract]
mod PrivatePool {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        pool_balance: u256,
        commitments: LegacyMap<felt252, bool>,
        nullifiers: LegacyMap<felt252, bool>,
        deposits: LegacyMap<u256, Deposit>,
        deposit_count: u256,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Deposit {
        commitment: felt252,
        amount: u256,
        timestamp: u64,
        withdrawn: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositMade: DepositMade,
        WithdrawalMade: WithdrawalMade,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositMade {
        commitment: felt252,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalMade {
        nullifier: felt252,
        recipient: ContractAddress,
        amount: u256,
    }

    #[abi(embed_v0)]
    impl PrivatePoolImpl of super::IPrivatePool<ContractState> {
        fn deposit(ref self: ContractState, commitment: felt252, amount: u256) {
            assert(!self.commitments.read(commitment), 'Commitment already exists');
            assert(amount > 0, 'Amount must be positive');

            self.commitments.write(commitment, true);
            self.pool_balance.write(self.pool_balance.read() + amount);

            let deposit_id = self.deposit_count.read() + 1;
            let deposit = Deposit {
                commitment,
                amount,
                timestamp: starknet::get_block_timestamp(),
                withdrawn: false,
            };

            self.deposits.write(deposit_id, deposit);
            self.deposit_count.write(deposit_id);

            self.emit(DepositMade { commitment, amount });
        }

        fn withdraw(
            ref self: ContractState,
            nullifier: felt252,
            recipient: ContractAddress,
            amount: u256,
            proof: Array<felt252>
        ) {
            assert(!self.nullifiers.read(nullifier), 'Nullifier already used');
            assert(amount <= self.pool_balance.read(), 'Insufficient pool balance');

            // In a real implementation, verify the zero-knowledge proof here
            // For now, we just check basic conditions
            assert(proof.len() > 0, 'Invalid proof');

            self.nullifiers.write(nullifier, true);
            self.pool_balance.write(self.pool_balance.read() - amount);

            self.emit(WithdrawalMade { nullifier, recipient, amount });
        }

        fn is_commitment_used(self: @ContractState, commitment: felt252) -> bool {
            self.commitments.read(commitment)
        }

        fn is_nullifier_used(self: @ContractState, nullifier: felt252) -> bool {
            self.nullifiers.read(nullifier)
        }

        fn get_pool_balance(self: @ContractState) -> u256 {
            self.pool_balance.read()
        }
    }
}

#[starknet::interface]
trait IPrivatePool<TContractState> {
    fn deposit(ref self: TContractState, commitment: felt252, amount: u256);
    fn withdraw(
        ref self: TContractState,
        nullifier: felt252,
        recipient: ContractAddress,
        amount: u256,
        proof: Array<felt252>
    );
    fn is_commitment_used(self: @TContractState, commitment: felt252) -> bool;
    fn is_nullifier_used(self: @TContractState, nullifier: felt252) -> bool;
    fn get_pool_balance(self: @TContractState) -> u256;
}
