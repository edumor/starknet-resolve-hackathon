# Gaming Track Documentation

## Overview

The Gaming track features "Starknet Battles," a fully on-chain strategy game built with Dojo's Entity Component System (ECS) framework. Players mint NFT characters, battle each other, and earn rewards.

## Architecture

### Dojo Integration

Dojo provides:
- **Entity Component System**: Efficient on-chain state management
- **Katana**: Local Starknet node for development
- **Torii**: Automatic indexing of game state
- **Optimistic Updates**: Responsive gameplay with instant feedback

### Game Loop

1. **Mint Character**: Create unique NFT character
2. **Level Up**: Gain experience through battles
3. **Create Battle**: Challenge other players
4. **Join Battle**: Accept challenges
5. **Execute Combat**: On-chain battle resolution
6. **Earn Rewards**: Experience and potential token rewards

## Contracts

### Character.cairo

NFT character management with upgradeable attributes.

#### Character Attributes

```cairo
struct CharacterData {
    id: u256,
    owner: ContractAddress,
    health: u32,        // Base: 100
    attack: u32,        // Base: 10
    defense: u32,       // Base: 10
    speed: u32,         // Base: 10
    level: u32,         // Base: 1
    experience: u256,   // XP gained
}
```

#### Key Functions

```cairo
fn mint_character(ref self: ContractState) -> u256
```
Mint a new character NFT with base attributes.

```cairo
fn add_experience(ref self: ContractState, character_id: u256, exp: u256)
```
Add experience to a character. Auto-levels up at 100 XP per level.

**Level Up Formula:**
- Health: 100 + (level - 1) * 10
- Attack: 10 + (level - 1) * 2
- Defense: 10 + (level - 1) * 2
- Speed: 10 + (level - 1) * 1

```cairo
fn transfer_character(ref self: ContractState, character_id: u256, to: ContractAddress)
```
Transfer character ownership (enables trading).

### Battle.cairo

Turn-based battle system with provably fair outcomes.

#### Battle States

```cairo
enum BattleStatus {
    Pending,      // Created, waiting for opponent
    InProgress,   // Opponent joined
    Completed,    // Battle finished
}
```

#### Key Functions

```cairo
fn create_battle(ref self: ContractState, character_id: u256) -> u256
```
Create a new battle with your character.

```cairo
fn join_battle(ref self: ContractState, battle_id: u256, character_id: u256)
```
Join an existing battle as opponent.

```cairo
fn execute_battle(ref self: ContractState, battle_id: u256)
```
Execute the battle and determine winner (uses block timestamp for randomness).

## Game Mechanics

### Character Progression

Characters level up through experience:

- **Level 1**: Base stats (100 HP, 10 ATK, 10 DEF, 10 SPD)
- **Level 2**: 110 HP, 12 ATK, 12 DEF, 11 SPD (requires 100 XP)
- **Level 3**: 120 HP, 14 ATK, 14 DEF, 12 SPD (requires 200 XP)
- **Level N**: Progressive stat increases

### Battle System

Current implementation uses simple randomness:
- Random seed from block timestamp
- Winner determined by 50/50 chance
- Future: Implement stat-based combat calculations

**Planned Combat Formula:**
```
damage = attacker.attack - defender.defense
hit_chance = (attacker.speed / (attacker.speed + defender.speed)) * 100
```

### Rewards

Winners receive:
- **Experience Points**: 50 XP per victory
- **Tokens**: Prize pool distribution (planned)
- **Leaderboard Rank**: Global rankings
- **Tournament Prizes**: Special event rewards

## Dojo Components

### Entities

Characters and battles are Dojo entities with components:

```rust
#[component]
struct CharacterComponent {
    health: u32,
    attack: u32,
    defense: u32,
    speed: u32,
}

#[component]
struct BattleComponent {
    player1: ContractAddress,
    player2: ContractAddress,
    winner: ContractAddress,
}
```

### Systems

Game logic implemented as Dojo systems:

- **MintSystem**: Character creation
- **BattleSystem**: Combat resolution
- **ExperienceSystem**: XP and leveling
- **RewardSystem**: Prize distribution

## Frontend Integration

### Using Dojo SDK

```typescript
import { DojoProvider } from '@dojoengine/core';

const provider = new DojoProvider({
  rpcUrl: 'http://localhost:5050',
  toriiUrl: 'http://localhost:8080',
});

// Mint character
const tx = await provider.execute({
  contractName: 'Character',
  entrypoint: 'mint_character',
});

// Query characters
const characters = await provider.getEntities({
  component: 'CharacterComponent',
  filter: { owner: address },
});
```

### Real-time Updates

Torii indexer provides GraphQL API for real-time data:

```graphql
subscription {
  battles(where: { status: "Pending" }) {
    id
    player1
    character1
    timestamp
  }
}
```

## Tournament System

### Structure

1. **Registration Period**: Players register with entry fee
2. **Bracket Generation**: Automated seeding based on level
3. **Battle Rounds**: Elimination brackets
4. **Prize Distribution**: Top 8 players share prize pool

### Prize Pool

- 1st Place: 50%
- 2nd Place: 25%
- 3rd-4th Place: 12.5% each
- 5th-8th Place: Split remaining

## Marketplace

Players can trade characters:

1. **List Character**: Set price and list for sale
2. **Browse Listings**: Filter by level, stats, price
3. **Purchase**: Buy listed characters
4. **Royalties**: Original minter receives 5% royalty

## Testing

### Unit Tests

```bash
cd dojo
sozo test
```

### Integration Tests

```bash
katana &
sozo migrate
npm test
```

## Deployment

### Local Development

```bash
# Start Katana node
katana --disable-fee

# Deploy world
cd dojo
sozo migrate

# Start Torii indexer
torii --world <world_address>
```

### Testnet Deployment

```bash
sozo migrate --rpc-url https://testnet.starknet.io
```

## Future Enhancements

- [ ] Advanced combat calculations based on stats
- [ ] Special abilities and skills
- [ ] Equipment and items system
- [ ] Team battles (3v3, 5v5)
- [ ] Seasonal ranking resets
- [ ] Character breeding/fusion
- [ ] Achievement system
- [ ] Guild features
- [ ] Spectator mode
- [ ] Replay system
