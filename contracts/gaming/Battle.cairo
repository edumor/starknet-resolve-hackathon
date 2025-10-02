#[starknet::contract]
mod Battle {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        battles: LegacyMap<u256, BattleData>,
        battle_count: u256,
        character_contract: ContractAddress,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct BattleData {
        id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        character1: u256,
        character2: u256,
        winner: ContractAddress,
        timestamp: u64,
        status: BattleStatus,
    }

    #[derive(Drop, Serde, starknet::Store, PartialEq)]
    enum BattleStatus {
        Pending,
        InProgress,
        Completed,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BattleCreated: BattleCreated,
        BattleStarted: BattleStarted,
        BattleCompleted: BattleCompleted,
    }

    #[derive(Drop, starknet::Event)]
    struct BattleCreated {
        battle_id: u256,
        player1: ContractAddress,
        character1: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct BattleStarted {
        battle_id: u256,
        player2: ContractAddress,
        character2: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct BattleCompleted {
        battle_id: u256,
        winner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, character_contract: ContractAddress) {
        self.character_contract.write(character_contract);
    }

    #[abi(embed_v0)]
    impl BattleImpl of super::IBattle<ContractState> {
        fn create_battle(ref self: ContractState, character_id: u256) -> u256 {
            let battle_id = self.battle_count.read() + 1;
            let player1 = get_caller_address();

            let battle = BattleData {
                id: battle_id,
                player1,
                player2: starknet::contract_address_const::<0>(),
                character1: character_id,
                character2: 0,
                winner: starknet::contract_address_const::<0>(),
                timestamp: get_block_timestamp(),
                status: BattleStatus::Pending,
            };

            self.battles.write(battle_id, battle);
            self.battle_count.write(battle_id);

            self.emit(BattleCreated { battle_id, player1, character1: character_id });
            battle_id
        }

        fn join_battle(ref self: ContractState, battle_id: u256, character_id: u256) {
            let mut battle = self.battles.read(battle_id);
            let player2 = get_caller_address();

            assert(battle.status == BattleStatus::Pending, 'Battle not pending');
            assert(player2 != battle.player1, 'Cannot battle yourself');

            battle.player2 = player2;
            battle.character2 = character_id;
            battle.status = BattleStatus::InProgress;
            
            self.battles.write(battle_id, battle);

            self.emit(BattleStarted { battle_id, player2, character2: character_id });
        }

        fn execute_battle(ref self: ContractState, battle_id: u256) {
            let mut battle = self.battles.read(battle_id);
            assert(battle.status == BattleStatus::InProgress, 'Battle not in progress');

            // Simple battle logic based on character stats
            // In a real implementation, this would use character stats from Character contract
            let random_seed = get_block_timestamp();
            let winner = if random_seed % 2 == 0 {
                battle.player1
            } else {
                battle.player2
            };

            battle.winner = winner;
            battle.status = BattleStatus::Completed;
            self.battles.write(battle_id, battle);

            self.emit(BattleCompleted { battle_id, winner });
        }

        fn get_battle(self: @ContractState, battle_id: u256) -> BattleData {
            self.battles.read(battle_id)
        }
    }
}

#[starknet::interface]
trait IBattle<TContractState> {
    fn create_battle(ref self: TContractState, character_id: u256) -> u256;
    fn join_battle(ref self: TContractState, battle_id: u256, character_id: u256);
    fn execute_battle(ref self: TContractState, battle_id: u256);
    fn get_battle(self: @TContractState, battle_id: u256) -> Battle::BattleData;
}
