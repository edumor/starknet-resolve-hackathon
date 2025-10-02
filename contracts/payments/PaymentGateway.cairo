#[starknet::contract]
mod PaymentGateway {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use core::traits::Into;

    #[storage]
    struct Storage {
        owner: ContractAddress,
        merchants: LegacyMap<ContractAddress, bool>,
        payments: LegacyMap<u256, Payment>,
        payment_count: u256,
        merchant_balances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Payment {
        id: u256,
        merchant: ContractAddress,
        customer: ContractAddress,
        token: ContractAddress,
        amount: u256,
        timestamp: u64,
        status: PaymentStatus,
    }

    #[derive(Drop, Serde, starknet::Store, PartialEq)]
    enum PaymentStatus {
        Pending,
        Completed,
        Refunded,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PaymentCreated: PaymentCreated,
        PaymentCompleted: PaymentCompleted,
        PaymentRefunded: PaymentRefunded,
        MerchantRegistered: MerchantRegistered,
    }

    #[derive(Drop, starknet::Event)]
    struct PaymentCreated {
        payment_id: u256,
        merchant: ContractAddress,
        customer: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct PaymentCompleted {
        payment_id: u256,
        merchant: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct PaymentRefunded {
        payment_id: u256,
        customer: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct MerchantRegistered {
        merchant: ContractAddress,
        timestamp: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl PaymentGatewayImpl of super::IPaymentGateway<ContractState> {
        fn register_merchant(ref self: ContractState) {
            let merchant = get_caller_address();
            assert(!self.merchants.read(merchant), 'Already registered');
            
            self.merchants.write(merchant, true);
            self.emit(MerchantRegistered { 
                merchant, 
                timestamp: get_block_timestamp() 
            });
        }

        fn create_payment(
            ref self: ContractState,
            merchant: ContractAddress,
            token: ContractAddress,
            amount: u256
        ) -> u256 {
            assert(self.merchants.read(merchant), 'Merchant not registered');
            assert(amount > 0, 'Amount must be positive');

            let payment_id = self.payment_count.read() + 1;
            let customer = get_caller_address();
            
            let payment = Payment {
                id: payment_id,
                merchant,
                customer,
                token,
                amount,
                timestamp: get_block_timestamp(),
                status: PaymentStatus::Pending,
            };

            self.payments.write(payment_id, payment);
            self.payment_count.write(payment_id);

            self.emit(PaymentCreated { 
                payment_id, 
                merchant, 
                customer, 
                amount 
            });

            payment_id
        }

        fn complete_payment(ref self: ContractState, payment_id: u256) {
            let mut payment = self.payments.read(payment_id);
            assert(payment.status == PaymentStatus::Pending, 'Payment not pending');
            
            payment.status = PaymentStatus::Completed;
            self.payments.write(payment_id, payment);

            let merchant = payment.merchant;
            let token = payment.token;
            let current_balance = self.merchant_balances.read((merchant, token));
            self.merchant_balances.write((merchant, token), current_balance + payment.amount);

            self.emit(PaymentCompleted { 
                payment_id, 
                merchant, 
                amount: payment.amount 
            });
        }

        fn refund_payment(ref self: ContractState, payment_id: u256) {
            let mut payment = self.payments.read(payment_id);
            let caller = get_caller_address();
            
            assert(caller == payment.merchant, 'Only merchant can refund');
            assert(payment.status == PaymentStatus::Completed, 'Payment not completed');
            
            payment.status = PaymentStatus::Refunded;
            self.payments.write(payment_id, payment);

            let merchant = payment.merchant;
            let token = payment.token;
            let current_balance = self.merchant_balances.read((merchant, token));
            self.merchant_balances.write((merchant, token), current_balance - payment.amount);

            self.emit(PaymentRefunded { 
                payment_id, 
                customer: payment.customer, 
                amount: payment.amount 
            });
        }

        fn get_payment(self: @ContractState, payment_id: u256) -> Payment {
            self.payments.read(payment_id)
        }

        fn is_merchant(self: @ContractState, address: ContractAddress) -> bool {
            self.merchants.read(address)
        }

        fn get_merchant_balance(
            self: @ContractState,
            merchant: ContractAddress,
            token: ContractAddress
        ) -> u256 {
            self.merchant_balances.read((merchant, token))
        }
    }
}

#[starknet::interface]
trait IPaymentGateway<TContractState> {
    fn register_merchant(ref self: TContractState);
    fn create_payment(
        ref self: TContractState,
        merchant: ContractAddress,
        token: ContractAddress,
        amount: u256
    ) -> u256;
    fn complete_payment(ref self: TContractState, payment_id: u256);
    fn refund_payment(ref self: TContractState, payment_id: u256);
    fn get_payment(self: @TContractState, payment_id: u256) -> PaymentGateway::Payment;
    fn is_merchant(self: @TContractState, address: ContractAddress) -> bool;
    fn get_merchant_balance(
        self: @TContractState,
        merchant: ContractAddress,
        token: ContractAddress
    ) -> u256;
}
