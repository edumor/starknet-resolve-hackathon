#[dojo::contract]
mod GameWorld {
    use starknet::{ContractAddress, get_caller_address};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    
    #[derive(Model, Copy, Drop, Serde)]
    struct Player {
        #[key]
        address: ContractAddress,
        level: u32,
        experience: u64,
        health: u32,
        energy: u32,
        last_action: u64,
    }

    #[derive(Model, Copy, Drop, Serde)]
    struct GameItem {
        #[key]
        id: u32,
        name: felt252,
        rarity: u8,
        power: u32,
        owner: ContractAddress,
    }

    #[derive(Model, Copy, Drop, Serde)]
    struct GameStats {
        #[key]
        world: ContractAddress,
        total_players: u32,
        total_items: u32,
        highest_level: u32,
    }

    #[abi(embed_v0)]
    impl GameWorldImpl of IGameWorld<ContractState> {
        fn create_player(self: @ContractState, world: IWorldDispatcher) {
            let caller = get_caller_address();
            let current_time = starknet::get_block_timestamp();
            
            let player = Player {
                address: caller,
                level: 1,
                experience: 0,
                health: 100,
                energy: 100,
                last_action: current_time,
            };

            set!(world, (player));
        }

        fn battle(self: @ContractState, world: IWorldDispatcher, opponent: ContractAddress) -> bool {
            let caller = get_caller_address();
            let mut player = get!(world, caller, Player);
            let mut opponent_player = get!(world, opponent, Player);
            
            assert(player.energy >= 20, 'Not enough energy');
            assert(opponent_player.health > 0, 'Opponent defeated');

            // Simple battle logic
            let player_power = player.level * 10 + player.health / 2;
            let opponent_power = opponent_player.level * 10 + opponent_player.health / 2;
            
            let victory = player_power > opponent_power;
            
            if victory {
                player.experience += 50;
                player.energy -= 20;
                opponent_player.health -= 25;
                
                // Level up check
                if player.experience >= player.level * 100 {
                    player.level += 1;
                    player.health = 100;
                    player.experience = 0;
                }
            } else {
                player.health -= 25;
                player.energy -= 20;
                opponent_player.experience += 25;
            }

            set!(world, (player, opponent_player));
            victory
        }

        fn craft_item(self: @ContractState, world: IWorldDispatcher, item_type: u8) -> u32 {
            let caller = get_caller_address();
            let mut player = get!(world, caller, Player);
            
            assert(player.energy >= 30, 'Not enough energy to craft');
            assert(player.level >= 3, 'Level too low to craft');

            let mut stats = get!(world, starknet::get_contract_address(), GameStats);
            let item_id = stats.total_items + 1;

            let item = GameItem {
                id: item_id,
                name: 'Crafted Item',
                rarity: item_type,
                power: player.level * (item_type.into() + 1),
                owner: caller,
            };

            player.energy -= 30;
            stats.total_items += 1;

            set!(world, (player, item, stats));
            item_id
        }

        fn recover_energy(self: @ContractState, world: IWorldDispatcher) {
            let caller = get_caller_address();
            let mut player = get!(world, caller, Player);
            let current_time = starknet::get_block_timestamp();
            
            // Recover 1 energy per minute
            let time_passed = current_time - player.last_action;
            let energy_recovered = time_passed / 60;
            
            player.energy = if player.energy + energy_recovered.into() > 100 {
                100
            } else {
                player.energy + energy_recovered.into()
            };
            
            player.last_action = current_time;
            set!(world, (player));
        }
    }

    #[starknet::interface]
    trait IGameWorld<TContractState> {
        fn create_player(self: @TContractState, world: IWorldDispatcher);
        fn battle(self: @TContractState, world: IWorldDispatcher, opponent: ContractAddress) -> bool;
        fn craft_item(self: @TContractState, world: IWorldDispatcher, item_type: u8) -> u32;
        fn recover_energy(self: @TContractState, world: IWorldDispatcher);
    }
}