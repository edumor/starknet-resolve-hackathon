#[starknet::contract]
mod PaymentSystem {
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    
    #[storage]
    struct Storage {
        owner: ContractAddress,
        fee_rate: u256, // Fee rate in basis points (1/10000)
        total_processed: u256,
        user_balances: LegacyMap<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PaymentProcessed: PaymentProcessed,
        FeesCollected: FeesCollected,
    }

    #[derive(Drop, starknet::Event)]
    struct PaymentProcessed {
        from: ContractAddress,
        to: ContractAddress,
        amount: u256,
        fee: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct FeesCollected {
        collector: ContractAddress,
        amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, fee_rate: u256) {
        self.owner.write(owner);
        self.fee_rate.write(fee_rate); // Ultra-low fee: 10 basis points = 0.1%
    }

    #[external(v0)]
    fn process_payment(
        ref self: ContractState,
        to: ContractAddress,
        amount: u256,
        token_contract: ContractAddress
    ) {
        let caller = get_caller_address();
        let fee = (amount * self.fee_rate.read()) / 10000_u256;
        let net_amount = amount - fee;

        // Transfer tokens
        let token = IERC20Dispatcher { contract_address: token_contract };
        token.transfer_from(caller, to, net_amount);
        token.transfer_from(caller, get_contract_address(), fee);

        // Update balances
        let current_balance = self.user_balances.read(to);
        self.user_balances.write(to, current_balance + net_amount);
        
        let total = self.total_processed.read();
        self.total_processed.write(total + amount);

        // Emit event
        self.emit(PaymentProcessed { from: caller, to, amount, fee });
    }

    #[external(v0)]
    fn get_payment_info(self: @ContractState) -> (u256, u256) {
        (self.fee_rate.read(), self.total_processed.read())
    }

    #[external(v0)]
    fn get_user_balance(self: @ContractState, user: ContractAddress) -> u256 {
        self.user_balances.read(user)
    }
}