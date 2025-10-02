#[starknet::contract]
mod Character {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        characters: LegacyMap<u256, CharacterData>,
        character_count: u256,
        owner_characters: LegacyMap<(ContractAddress, u256), u256>,
        owner_character_count: LegacyMap<ContractAddress, u256>,
    }

    #[derive(Drop, Serde, starknet::Store, Copy)]
    struct CharacterData {
        id: u256,
        owner: ContractAddress,
        health: u32,
        attack: u32,
        defense: u32,
        speed: u32,
        level: u32,
        experience: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CharacterMinted: CharacterMinted,
        CharacterUpgraded: CharacterUpgraded,
        CharacterTransferred: CharacterTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct CharacterMinted {
        character_id: u256,
        owner: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct CharacterUpgraded {
        character_id: u256,
        new_level: u32,
    }

    #[derive(Drop, starknet::Event)]
    struct CharacterTransferred {
        character_id: u256,
        from: ContractAddress,
        to: ContractAddress,
    }

    #[abi(embed_v0)]
    impl CharacterImpl of super::ICharacter<ContractState> {
        fn mint_character(ref self: ContractState) -> u256 {
            let character_id = self.character_count.read() + 1;
            let owner = get_caller_address();

            let character = CharacterData {
                id: character_id,
                owner,
                health: 100,
                attack: 10,
                defense: 10,
                speed: 10,
                level: 1,
                experience: 0,
            };

            self.characters.write(character_id, character);
            self.character_count.write(character_id);

            let owner_count = self.owner_character_count.read(owner);
            self.owner_characters.write((owner, owner_count), character_id);
            self.owner_character_count.write(owner, owner_count + 1);

            self.emit(CharacterMinted { character_id, owner });
            character_id
        }

        fn add_experience(ref self: ContractState, character_id: u256, exp: u256) {
            let mut character = self.characters.read(character_id);
            assert(character.owner == get_caller_address(), 'Not character owner');

            character.experience += exp;

            // Level up logic: every 100 exp = 1 level
            let new_level = 1 + (character.experience / 100).try_into().unwrap();
            if new_level > character.level {
                character.level = new_level;
                character.health = 100 + (new_level - 1) * 10;
                character.attack = 10 + (new_level - 1) * 2;
                character.defense = 10 + (new_level - 1) * 2;
                character.speed = 10 + (new_level - 1) * 1;

                self.emit(CharacterUpgraded { character_id, new_level });
            }

            self.characters.write(character_id, character);
        }

        fn transfer_character(ref self: ContractState, character_id: u256, to: ContractAddress) {
            let mut character = self.characters.read(character_id);
            let from = get_caller_address();
            assert(character.owner == from, 'Not character owner');

            character.owner = to;
            self.characters.write(character_id, character);

            self.emit(CharacterTransferred { character_id, from, to });
        }

        fn get_character(self: @ContractState, character_id: u256) -> CharacterData {
            self.characters.read(character_id)
        }

        fn get_owner_characters(
            self: @ContractState,
            owner: ContractAddress
        ) -> Array<u256> {
            let count = self.owner_character_count.read(owner);
            let mut characters = ArrayTrait::new();
            let mut i: u256 = 0;

            loop {
                if i >= count {
                    break;
                }
                let character_id = self.owner_characters.read((owner, i));
                characters.append(character_id);
                i += 1;
            };

            characters
        }
    }
}

#[starknet::interface]
trait ICharacter<TContractState> {
    fn mint_character(ref self: TContractState) -> u256;
    fn add_experience(ref self: TContractState, character_id: u256, exp: u256);
    fn transfer_character(ref self: TContractState, character_id: u256, to: ContractAddress);
    fn get_character(self: @TContractState, character_id: u256) -> Character::CharacterData;
    fn get_owner_characters(self: @TContractState, owner: ContractAddress) -> Array<u256>;
}
