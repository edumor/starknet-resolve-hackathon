#[starknet::contract]
mod Escrow {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        escrows: LegacyMap<u256, EscrowData>,
        escrow_count: u256,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct EscrowData {
        id: u256,
        payer: ContractAddress,
        payee: ContractAddress,
        arbiter: ContractAddress,
        token: ContractAddress,
        amount: u256,
        deadline: u64,
        status: EscrowStatus,
    }

    #[derive(Drop, Serde, starknet::Store, PartialEq)]
    enum EscrowStatus {
        Active,
        Released,
        Refunded,
        Disputed,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        EscrowCreated: EscrowCreated,
        EscrowReleased: EscrowReleased,
        EscrowRefunded: EscrowRefunded,
        DisputeRaised: DisputeRaised,
    }

    #[derive(Drop, starknet::Event)]
    struct EscrowCreated {
        escrow_id: u256,
        payer: ContractAddress,
        payee: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct EscrowReleased {
        escrow_id: u256,
        payee: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct EscrowRefunded {
        escrow_id: u256,
        payer: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct DisputeRaised {
        escrow_id: u256,
        raised_by: ContractAddress,
    }

    #[abi(embed_v0)]
    impl EscrowImpl of super::IEscrow<ContractState> {
        fn create_escrow(
            ref self: ContractState,
            payee: ContractAddress,
            arbiter: ContractAddress,
            token: ContractAddress,
            amount: u256,
            deadline: u64
        ) -> u256 {
            let escrow_id = self.escrow_count.read() + 1;
            let payer = get_caller_address();

            let escrow = EscrowData {
                id: escrow_id,
                payer,
                payee,
                arbiter,
                token,
                amount,
                deadline,
                status: EscrowStatus::Active,
            };

            self.escrows.write(escrow_id, escrow);
            self.escrow_count.write(escrow_id);

            self.emit(EscrowCreated { escrow_id, payer, payee, amount });
            escrow_id
        }

        fn release_funds(ref self: ContractState, escrow_id: u256) {
            let mut escrow = self.escrows.read(escrow_id);
            let caller = get_caller_address();
            
            assert(
                caller == escrow.payer || caller == escrow.arbiter,
                'Not authorized to release'
            );
            assert(escrow.status == EscrowStatus::Active, 'Escrow not active');

            escrow.status = EscrowStatus::Released;
            self.escrows.write(escrow_id, escrow);

            self.emit(EscrowReleased { 
                escrow_id, 
                payee: escrow.payee, 
                amount: escrow.amount 
            });
        }

        fn refund(ref self: ContractState, escrow_id: u256) {
            let mut escrow = self.escrows.read(escrow_id);
            let caller = get_caller_address();
            
            assert(
                caller == escrow.arbiter || get_block_timestamp() > escrow.deadline,
                'Not authorized to refund'
            );
            assert(escrow.status == EscrowStatus::Active, 'Escrow not active');

            escrow.status = EscrowStatus::Refunded;
            self.escrows.write(escrow_id, escrow);

            self.emit(EscrowRefunded { 
                escrow_id, 
                payer: escrow.payer, 
                amount: escrow.amount 
            });
        }

        fn raise_dispute(ref self: ContractState, escrow_id: u256) {
            let mut escrow = self.escrows.read(escrow_id);
            let caller = get_caller_address();
            
            assert(
                caller == escrow.payer || caller == escrow.payee,
                'Not authorized'
            );
            assert(escrow.status == EscrowStatus::Active, 'Escrow not active');

            escrow.status = EscrowStatus::Disputed;
            self.escrows.write(escrow_id, escrow);

            self.emit(DisputeRaised { escrow_id, raised_by: caller });
        }

        fn get_escrow(self: @ContractState, escrow_id: u256) -> EscrowData {
            self.escrows.read(escrow_id)
        }
    }
}

#[starknet::interface]
trait IEscrow<TContractState> {
    fn create_escrow(
        ref self: TContractState,
        payee: ContractAddress,
        arbiter: ContractAddress,
        token: ContractAddress,
        amount: u256,
        deadline: u64
    ) -> u256;
    fn release_funds(ref self: TContractState, escrow_id: u256);
    fn refund(ref self: TContractState, escrow_id: u256);
    fn raise_dispute(ref self: TContractState, escrow_id: u256);
    fn get_escrow(self: @TContractState, escrow_id: u256) -> Escrow::EscrowData;
}
