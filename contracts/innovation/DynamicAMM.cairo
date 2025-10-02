#[starknet::contract]
mod DynamicAMM {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        token_a: ContractAddress,
        token_b: ContractAddress,
        reserve_a: u256,
        reserve_b: u256,
        liquidity_providers: LegacyMap<ContractAddress, u256>,
        total_liquidity: u256,
        fee_rate: u256, // basis points (e.g., 30 = 0.3%)
        dynamic_fee_enabled: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        LiquidityAdded: LiquidityAdded,
        LiquidityRemoved: LiquidityRemoved,
        Swap: Swap,
        FeeUpdated: FeeUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct LiquidityAdded {
        provider: ContractAddress,
        amount_a: u256,
        amount_b: u256,
        liquidity: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct LiquidityRemoved {
        provider: ContractAddress,
        amount_a: u256,
        amount_b: u256,
        liquidity: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Swap {
        user: ContractAddress,
        token_in: ContractAddress,
        token_out: ContractAddress,
        amount_in: u256,
        amount_out: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct FeeUpdated {
        old_fee: u256,
        new_fee: u256,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        token_a: ContractAddress,
        token_b: ContractAddress,
        initial_fee_rate: u256
    ) {
        self.token_a.write(token_a);
        self.token_b.write(token_b);
        self.fee_rate.write(initial_fee_rate);
        self.dynamic_fee_enabled.write(true);
    }

    #[abi(embed_v0)]
    impl DynamicAMMImpl of super::IDynamicAMM<ContractState> {
        fn add_liquidity(
            ref self: ContractState,
            amount_a: u256,
            amount_b: u256
        ) -> u256 {
            let provider = get_caller_address();
            let total_liquidity = self.total_liquidity.read();

            let liquidity = if total_liquidity == 0 {
                // Initial liquidity
                self._sqrt(amount_a * amount_b)
            } else {
                // Proportional liquidity
                let liquidity_a = (amount_a * total_liquidity) / self.reserve_a.read();
                let liquidity_b = (amount_b * total_liquidity) / self.reserve_b.read();
                if liquidity_a < liquidity_b {
                    liquidity_a
                } else {
                    liquidity_b
                }
            };

            self.reserve_a.write(self.reserve_a.read() + amount_a);
            self.reserve_b.write(self.reserve_b.read() + amount_b);
            self.liquidity_providers.write(
                provider,
                self.liquidity_providers.read(provider) + liquidity
            );
            self.total_liquidity.write(total_liquidity + liquidity);

            self.emit(LiquidityAdded { provider, amount_a, amount_b, liquidity });
            liquidity
        }

        fn remove_liquidity(ref self: ContractState, liquidity: u256) -> (u256, u256) {
            let provider = get_caller_address();
            let provider_liquidity = self.liquidity_providers.read(provider);
            assert(provider_liquidity >= liquidity, 'Insufficient liquidity');

            let total_liquidity = self.total_liquidity.read();
            let amount_a = (liquidity * self.reserve_a.read()) / total_liquidity;
            let amount_b = (liquidity * self.reserve_b.read()) / total_liquidity;

            self.reserve_a.write(self.reserve_a.read() - amount_a);
            self.reserve_b.write(self.reserve_b.read() - amount_b);
            self.liquidity_providers.write(provider, provider_liquidity - liquidity);
            self.total_liquidity.write(total_liquidity - liquidity);

            self.emit(LiquidityRemoved { provider, amount_a, amount_b, liquidity });
            (amount_a, amount_b)
        }

        fn swap_a_to_b(ref self: ContractState, amount_in: u256) -> u256 {
            let amount_out = self._get_amount_out(
                amount_in,
                self.reserve_a.read(),
                self.reserve_b.read()
            );

            self.reserve_a.write(self.reserve_a.read() + amount_in);
            self.reserve_b.write(self.reserve_b.read() - amount_out);

            // Update dynamic fee if enabled
            if self.dynamic_fee_enabled.read() {
                self._update_dynamic_fee();
            }

            self.emit(Swap {
                user: get_caller_address(),
                token_in: self.token_a.read(),
                token_out: self.token_b.read(),
                amount_in,
                amount_out,
            });

            amount_out
        }

        fn swap_b_to_a(ref self: ContractState, amount_in: u256) -> u256 {
            let amount_out = self._get_amount_out(
                amount_in,
                self.reserve_b.read(),
                self.reserve_a.read()
            );

            self.reserve_b.write(self.reserve_b.read() + amount_in);
            self.reserve_a.write(self.reserve_a.read() - amount_out);

            // Update dynamic fee if enabled
            if self.dynamic_fee_enabled.read() {
                self._update_dynamic_fee();
            }

            self.emit(Swap {
                user: get_caller_address(),
                token_in: self.token_b.read(),
                token_out: self.token_a.read(),
                amount_in,
                amount_out,
            });

            amount_out
        }

        fn get_reserves(self: @ContractState) -> (u256, u256) {
            (self.reserve_a.read(), self.reserve_b.read())
        }

        fn get_liquidity(self: @ContractState, provider: ContractAddress) -> u256 {
            self.liquidity_providers.read(provider)
        }

        fn get_fee_rate(self: @ContractState) -> u256 {
            self.fee_rate.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _get_amount_out(
            self: @ContractState,
            amount_in: u256,
            reserve_in: u256,
            reserve_out: u256
        ) -> u256 {
            let fee_rate = self.fee_rate.read();
            let amount_in_with_fee = amount_in * (10000 - fee_rate);
            let numerator = amount_in_with_fee * reserve_out;
            let denominator = (reserve_in * 10000) + amount_in_with_fee;
            numerator / denominator
        }

        fn _update_dynamic_fee(ref self: ContractState) {
            // Simple dynamic fee logic based on liquidity utilization
            // In production, this would be more sophisticated
            let reserve_a = self.reserve_a.read();
            let reserve_b = self.reserve_b.read();
            let ratio = if reserve_a > reserve_b {
                (reserve_a * 100) / reserve_b
            } else {
                (reserve_b * 100) / reserve_a
            };

            let old_fee = self.fee_rate.read();
            let new_fee = if ratio > 200 {
                50 // 0.5% for high imbalance
            } else if ratio > 150 {
                40 // 0.4%
            } else {
                30 // 0.3% normal
            };

            if new_fee != old_fee {
                self.fee_rate.write(new_fee);
                self.emit(FeeUpdated { old_fee, new_fee });
            }
        }

        fn _sqrt(self: @ContractState, x: u256) -> u256 {
            if x == 0 {
                return 0;
            }
            let mut z = (x + 1) / 2;
            let mut y = x;
            loop {
                if z >= y {
                    break;
                }
                y = z;
                z = (x / z + z) / 2;
            };
            y
        }
    }
}

#[starknet::interface]
trait IDynamicAMM<TContractState> {
    fn add_liquidity(ref self: TContractState, amount_a: u256, amount_b: u256) -> u256;
    fn remove_liquidity(ref self: TContractState, liquidity: u256) -> (u256, u256);
    fn swap_a_to_b(ref self: TContractState, amount_in: u256) -> u256;
    fn swap_b_to_a(ref self: TContractState, amount_in: u256) -> u256;
    fn get_reserves(self: @TContractState) -> (u256, u256);
    fn get_liquidity(self: @TContractState, provider: ContractAddress) -> u256;
    fn get_fee_rate(self: @TContractState) -> u256;
}
