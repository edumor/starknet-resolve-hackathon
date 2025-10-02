use starknet::ContractAddress;

#[dojo::interface]
trait IGameActions {
    fn create_player(ref world: IWorldDispatcher, name: felt252);
    fn create_character(ref world: IWorldDispatcher, character_type: u8) -> u256;
    fn start_battle(ref world: IWorldDispatcher, character1_id: u256, character2_id: u256) -> u256;
    fn attack(ref world: IWorldDispatcher, battle_id: u256);
    fn level_up_character(ref world: IWorldDispatcher, character_id: u256);
}

#[dojo::contract]
mod game_actions {
    use super::IGameActions;
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use starknet_resolve::models::{Player, Character, Battle, Item};

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create_player(ref world: IWorldDispatcher, name: felt252) {
            let caller = get_caller_address();
            
            let player = Player {
                address: caller,
                name,
                level: 1,
                experience: 0,
                wins: 0,
                losses: 0,
            };

            set!(world, (player));
        }

        fn create_character(ref world: IWorldDispatcher, character_type: u8) -> u256 {
            let caller = get_caller_address();
            assert!(character_type >= 1 && character_type <= 3, "Invalid character type");
            
            // Generate character ID (in real implementation, use proper ID generation)
            let character_id: u256 = get_block_timestamp().into();
            
            let (attack, defense, health) = match character_type {
                1 => (120, 80, 1000), // Warrior
                2 => (150, 50, 800),  // Mage
                3 => (100, 70, 900),  // Archer
                _ => (100, 60, 900),  // Default
            };

            let character = Character {
                id: character_id,
                owner: caller,
                character_type,
                level: 1,
                attack,
                defense,
                health,
                max_health: health,
            };

            set!(world, (character));
            character_id
        }

        fn start_battle(
            ref world: IWorldDispatcher,
            character1_id: u256,
            character2_id: u256,
        ) -> u256 {
            let caller = get_caller_address();
            
            let character1: Character = get!(world, character1_id, Character);
            let character2: Character = get!(world, character2_id, Character);
            
            assert!(character1.owner == caller, "Not character owner");
            
            let battle_id: u256 = get_block_timestamp().into();
            
            let battle = Battle {
                id: battle_id,
                player1: character1.owner,
                player2: character2.owner,
                character1_id,
                character2_id,
                winner: starknet::contract_address_const::<0>(),
                timestamp: get_block_timestamp(),
                completed: false,
            };

            set!(world, (battle));
            battle_id
        }

        fn attack(ref world: IWorldDispatcher, battle_id: u256) {
            let mut battle: Battle = get!(world, battle_id, Battle);
            assert!(!battle.completed, "Battle already completed");
            
            let mut char1: Character = get!(world, battle.character1_id, Character);
            let mut char2: Character = get!(world, battle.character2_id, Character);
            
            // Simple battle logic: character with higher attack wins
            let damage1 = if char1.attack > char2.defense {
                char1.attack - char2.defense
            } else {
                1
            };
            
            let damage2 = if char2.attack > char1.defense {
                char2.attack - char1.defense
            } else {
                1
            };
            
            // Apply damage
            if char2.health > damage1 {
                char2.health -= damage1;
            } else {
                char2.health = 0;
            }
            
            if char1.health > damage2 {
                char1.health -= damage2;
            } else {
                char1.health = 0;
            }
            
            // Determine winner
            if char2.health == 0 {
                battle.winner = battle.player1;
                battle.completed = true;
                
                let mut player1: Player = get!(world, battle.player1, Player);
                player1.wins += 1;
                player1.experience += 100;
                set!(world, (player1));
            } else if char1.health == 0 {
                battle.winner = battle.player2;
                battle.completed = true;
                
                let mut player2: Player = get!(world, battle.player2, Player);
                player2.wins += 1;
                player2.experience += 100;
                set!(world, (player2));
            }
            
            set!(world, (battle, char1, char2));
        }

        fn level_up_character(ref world: IWorldDispatcher, character_id: u256) {
            let caller = get_caller_address();
            let mut character: Character = get!(world, character_id, Character);
            
            assert!(character.owner == caller, "Not character owner");
            
            character.level += 1;
            character.attack += 10;
            character.defense += 5;
            character.max_health += 50;
            character.health = character.max_health;
            
            set!(world, (character));
        }
    }
}
