use starknet::ContractAddress;

// Player model
#[derive(Model, Copy, Drop, Serde)]
struct Player {
    #[key]
    address: ContractAddress,
    name: felt252,
    level: u32,
    experience: u64,
    wins: u32,
    losses: u32,
}

// Character NFT model
#[derive(Model, Copy, Drop, Serde)]
struct Character {
    #[key]
    id: u256,
    owner: ContractAddress,
    character_type: u8, // 1: Warrior, 2: Mage, 3: Archer
    level: u32,
    attack: u32,
    defense: u32,
    health: u32,
    max_health: u32,
}

// Battle model
#[derive(Model, Copy, Drop, Serde)]
struct Battle {
    #[key]
    id: u256,
    player1: ContractAddress,
    player2: ContractAddress,
    character1_id: u256,
    character2_id: u256,
    winner: ContractAddress,
    timestamp: u64,
    completed: bool,
}

// Item NFT model
#[derive(Model, Copy, Drop, Serde)]
struct Item {
    #[key]
    id: u256,
    owner: ContractAddress,
    item_type: u8, // 1: Weapon, 2: Armor, 3: Potion
    rarity: u8, // 1: Common, 2: Rare, 3: Epic, 4: Legendary
    bonus_stat: u32,
}
