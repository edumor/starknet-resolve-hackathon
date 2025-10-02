#[starknet::contract]
mod PaymentGateway {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use core::starknet::storage::{Map, StoragePathEntry};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        invoices: Map<u256, Invoice>,
        invoice_count: u256,
        merchant_balances: Map<(ContractAddress, ContractAddress), u256>, // (merchant, token) => balance
        supported_tokens: Map<ContractAddress, bool>,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Invoice {
        id: u256,
        merchant: ContractAddress,
        payer: ContractAddress,
        amount: u256,
        token: ContractAddress,
        status: u8, // 0: pending, 1: paid, 2: cancelled
        created_at: u64,
        paid_at: u64,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        InvoiceCreated: InvoiceCreated,
        InvoicePaid: InvoicePaid,
        PaymentWithdrawn: PaymentWithdrawn,
    }

    #[derive(Drop, starknet::Event)]
    struct InvoiceCreated {
        invoice_id: u256,
        merchant: ContractAddress,
        amount: u256,
        token: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct InvoicePaid {
        invoice_id: u256,
        payer: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct PaymentWithdrawn {
        merchant: ContractAddress,
        token: ContractAddress,
        amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.invoice_count.write(0);
    }

    #[abi(embed_v0)]
    impl PaymentGatewayImpl of super::IPaymentGateway<ContractState> {
        fn create_invoice(
            ref self: ContractState,
            amount: u256,
            token: ContractAddress,
        ) -> u256 {
            let caller = get_caller_address();
            let invoice_id = self.invoice_count.read() + 1;
            
            let invoice = Invoice {
                id: invoice_id,
                merchant: caller,
                payer: starknet::contract_address_const::<0>(),
                amount,
                token,
                status: 0,
                created_at: get_block_timestamp(),
                paid_at: 0,
            };

            self.invoices.entry(invoice_id).write(invoice);
            self.invoice_count.write(invoice_id);

            self.emit(InvoiceCreated { 
                invoice_id, 
                merchant: caller, 
                amount, 
                token 
            });

            invoice_id
        }

        fn pay_invoice(ref self: ContractState, invoice_id: u256) {
            let mut invoice = self.invoices.entry(invoice_id).read();
            assert(invoice.status == 0, 'Invoice not pending');

            let caller = get_caller_address();
            invoice.payer = caller;
            invoice.status = 1;
            invoice.paid_at = get_block_timestamp();
            
            self.invoices.entry(invoice_id).write(invoice);

            // Update merchant balance
            let current_balance = self.merchant_balances.entry((invoice.merchant, invoice.token)).read();
            self.merchant_balances.entry((invoice.merchant, invoice.token)).write(current_balance + invoice.amount);

            self.emit(InvoicePaid { 
                invoice_id, 
                payer: caller, 
                amount: invoice.amount 
            });
        }

        fn withdraw(ref self: ContractState, token: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let balance = self.merchant_balances.entry((caller, token)).read();
            assert(balance >= amount, 'Insufficient balance');

            self.merchant_balances.entry((caller, token)).write(balance - amount);

            self.emit(PaymentWithdrawn { 
                merchant: caller, 
                token, 
                amount 
            });
        }

        fn get_invoice(self: @ContractState, invoice_id: u256) -> Invoice {
            self.invoices.entry(invoice_id).read()
        }

        fn get_merchant_balance(
            self: @ContractState,
            merchant: ContractAddress,
            token: ContractAddress,
        ) -> u256 {
            self.merchant_balances.entry((merchant, token)).read()
        }
    }
}

#[starknet::interface]
trait IPaymentGateway<TContractState> {
    fn create_invoice(
        ref self: TContractState,
        amount: u256,
        token: starknet::ContractAddress,
    ) -> u256;
    fn pay_invoice(ref self: TContractState, invoice_id: u256);
    fn withdraw(ref self: TContractState, token: starknet::ContractAddress, amount: u256);
    fn get_invoice(self: @TContractState, invoice_id: u256) -> PaymentGateway::Invoice;
    fn get_merchant_balance(
        self: @TContractState,
        merchant: starknet::ContractAddress,
        token: starknet::ContractAddress,
    ) -> u256;
}
