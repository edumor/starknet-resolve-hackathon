# Gaming Track Documentation

## Overview
The Gaming Track features a fully on-chain strategy game built with the Dojo engine, demonstrating how Starknet enables complex game logic to run entirely on-chain with provably fair outcomes.

## Game: Starknet Battles

### Location
`dojo/src/`

### Game Features

#### Character System
Three distinct character classes with unique stats:

**Warrior**
- Attack: 120
- Defense: 80
- Health: 1000
- Best for: Tank and sustained combat

**Mage**
- Attack: 150
- Defense: 50
- Health: 800
- Best for: High damage output

**Archer**
- Attack: 100
- Defense: 70
- Health: 900
- Best for: Balanced gameplay

#### Battle System
- Turn-based PvP battles
- Damage calculation based on attack/defense
- Character progression through wins
- Experience points and leveling

#### NFT Integration
- All characters are NFTs
- Tradeable on open markets
- Items as NFT assets
- Provable ownership

### Dojo Architecture

#### Models (ECS Components)

**Player Model**
```cairo
struct Player {
    address: ContractAddress,
    name: felt252,
    level: u32,
    experience: u64,
    wins: u32,
    losses: u32,
}
```

**Character Model**
```cairo
struct Character {
    id: u256,
    owner: ContractAddress,
    character_type: u8,
    level: u32,
    attack: u32,
    defense: u32,
    health: u32,
    max_health: u32,
}
```

**Battle Model**
```cairo
struct Battle {
    id: u256,
    player1: ContractAddress,
    player2: ContractAddress,
    character1_id: u256,
    character2_id: u256,
    winner: ContractAddress,
    timestamp: u64,
    completed: bool,
}
```

### Game Actions (Systems)

#### `create_player(name: felt252)`
Creates a new player profile.

#### `create_character(character_type: u8) -> u256`
Mints a new character NFT.

**Parameters:**
- `character_type`: 1 = Warrior, 2 = Mage, 3 = Archer

**Returns:** Character ID

#### `start_battle(character1_id: u256, character2_id: u256) -> u256`
Initiates a battle between two characters.

**Returns:** Battle ID

#### `attack(battle_id: u256)`
Executes an attack in an active battle.

#### `level_up_character(character_id: u256)`
Increases character level and stats.

## Development Setup

### Install Dojo
```bash
curl -L https://install.dojoengine.org | bash
dojoup
```

### Build World
```bash
cd dojo
sozo build
```

### Deploy to Local
```bash
sozo migrate
```

### Run Indexer (Torii)
```bash
torii --world <WORLD_ADDRESS>
```

## Game Mechanics

### Battle Resolution
1. Characters exchange damage simultaneously
2. Damage = attacker's attack - defender's defense (minimum 1)
3. Health reduced by damage amount
4. Battle continues until one character reaches 0 health
5. Winner receives experience points

### Character Progression
- Gain 100 XP per battle won
- Level up increases stats:
  - Attack +10
  - Defense +5
  - Max Health +50
  - Health restored to max

### Item System (Future)
- Weapons: Increase attack
- Armor: Increase defense
- Potions: Restore health
- Rarity tiers: Common, Rare, Epic, Legendary

## Frontend Integration

### Connect to Dojo
```typescript
import { setup } from "./dojo/setup";

const dojoContext = await setup();
```

### Create Character
```typescript
await dojoContext.account.execute({
  contractAddress: systems.actions,
  entrypoint: "create_character",
  calldata: [characterType]
});
```

### Query Game State
```typescript
const player = await dojoContext.network.provider.getEntity(
  "Player",
  playerAddress
);
```

## Why On-Chain Gaming?

### True Ownership
- Players own their characters and items as NFTs
- Assets can be sold or traded on any marketplace
- No central authority can take away your items

### Provably Fair
- All game logic runs on-chain
- Outcomes are verifiable
- No hidden mechanics or cheating

### Composability
- Game assets work across multiple games
- Build on top of existing game logic
- Create derivative games and mods

### Player-Driven Economy
- Players earn real value from gameplay
- Item trading creates real markets
- Community governance over game rules

## Future Enhancements

- Co-op PvE modes
- Guild system
- Tournament brackets
- Ranked leaderboards
- Special events and seasons
- Crafting system
- Character customization
- More character classes
