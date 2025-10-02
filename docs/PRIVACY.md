# Privacy Track Documentation

## Overview

The Privacy track implements advanced cryptographic primitives for private transactions, anonymous voting, and confidential smart contracts on Starknet using zero-knowledge proofs.

## Core Concept

Traditional blockchain transactions are fully transparent, exposing:
- Sender and receiver addresses
- Transaction amounts
- Transaction history

Our privacy solution breaks these links using:
- **Commitments**: Hide transaction details
- **Nullifiers**: Prevent double-spending
- **Zero-Knowledge Proofs**: Prove validity without revealing data

## Contracts

### PrivatePool.cairo

Anonymous liquidity pool for private transactions.

#### How It Works

1. **Deposit Phase**
   ```cairo
   deposit(commitment: felt252, amount: u256)
   ```
   - User generates secret: `secret = random()`
   - Creates commitment: `commitment = hash(secret)`
   - Deposits amount with commitment
   - Commitment stored on-chain, secret kept private

2. **Withdraw Phase**
   ```cairo
   withdraw(nullifier: felt252, recipient: ContractAddress, amount: u256, proof: Array<felt252>)
   ```
   - User generates nullifier: `nullifier = hash(secret, index)`
   - Creates ZK proof proving knowledge of secret
   - Withdraws to any address
   - Nullifier prevents double-spending

#### Privacy Properties

- **Anonymity Set**: All depositors are indistinguishable
- **No Link**: Deposits and withdrawals cannot be connected
- **Censorship Resistant**: Anyone can withdraw with valid proof
- **Trustless**: No trusted setup required

### Zero-Knowledge Proofs

#### Proof System

Using STARK proofs native to Starknet:

```
Public Inputs:
- commitment (on-chain)
- nullifier (new)
- amount

Private Inputs:
- secret (known only to user)

Proof Statement:
"I know a secret such that:
 1. hash(secret) == commitment
 2. hash(secret, index) == nullifier
 3. amount is valid"
```

#### Verification

```cairo
fn verify_proof(
    commitment: felt252,
    nullifier: felt252,
    amount: u256,
    proof: Array<felt252>
) -> bool
```

Verifies the proof on-chain without revealing the secret.

## Use Cases

### 1. Anonymous Donations

Donate to causes without revealing identity:

```typescript
// Donor
const secret = generateSecret();
const commitment = hash(secret);
await privatePool.deposit(commitment, amount);

// Organization withdraws anonymously
const nullifier = hash(secret, index);
const proof = generateProof(secret, commitment);
await privatePool.withdraw(nullifier, orgAddress, amount, proof);
```

### 2. Private Payroll

Companies can pay salaries privately:

1. Company deposits to private pool
2. Employees withdraw to their addresses
3. Amounts and recipients remain private
4. Tax compliance via off-chain reports

### 3. Anonymous Voting

DAO governance with private votes:

```cairo
struct Vote {
    commitment: felt252,  // Hide vote choice
    weight: u256,         // Public voting power
}

fn cast_vote(commitment: felt252, weight: u256)
fn reveal_vote(nullifier: felt252, choice: u8, proof: Array<felt252>)
```

Properties:
- Vote choice hidden until reveal
- Prevents vote buying/coercion
- Fair tallying process

### 4. Confidential Auctions

Sealed-bid auctions with privacy:

1. **Bid Phase**: Submit encrypted bids
2. **Reveal Phase**: Reveal winning bid only
3. **Settlement**: Winner pays, others get refunds

### 5. Private DeFi

Use DeFi protocols privately:

- **Private Swaps**: Trade without revealing amounts
- **Private Lending**: Borrow/lend anonymously
- **Private Yield**: Stake tokens privately

## Cryptographic Primitives

### Pedersen Commitments

```cairo
fn pedersen_commit(value: felt252, randomness: felt252) -> felt252
```

Properties:
- **Hiding**: Cannot determine value from commitment
- **Binding**: Cannot change value after commitment
- **Additively Homomorphic**: `commit(a) + commit(b) = commit(a + b)`

### Hash Functions

Using Poseidon hash optimized for STARK proofs:

```cairo
fn poseidon_hash(inputs: Array<felt252>) -> felt252
```

Benefits:
- STARK-friendly (efficient in circuits)
- Collision-resistant
- Preimage-resistant

### Merkle Trees

Efficient membership proofs:

```cairo
struct MerkleProof {
    leaf: felt252,
    path: Array<felt252>,
    indices: Array<bool>,
}

fn verify_merkle_proof(proof: MerkleProof, root: felt252) -> bool
```

## Security Considerations

### Attack Vectors

1. **Timing Attacks**
   - Mitigation: Constant-time operations
   - Random delays in withdrawals

2. **Amount Analysis**
   - Mitigation: Fixed denomination pools
   - Multiple pool sizes (0.1, 1, 10, 100 ETH)

3. **Graph Analysis**
   - Mitigation: Larger anonymity sets
   - Mixing protocols

4. **Side Channels**
   - Mitigation: Use privacy-preserving RPCs
   - Tor/VPN for network privacy

### Best Practices

1. **Use Fixed Denominations**: Deposit 1 ETH, 10 ETH, etc.
2. **Wait Before Withdrawing**: Larger anonymity set
3. **Use Different Addresses**: Don't reuse addresses
4. **Multiple Hops**: Chain multiple private pools
5. **Privacy-Preserving Tools**: VPN, Tor, privacy browsers

## Performance

### Gas Costs

- Deposit: ~100k gas
- Withdraw: ~150k gas (proof verification)
- Pool creation: ~50k gas

### Proof Generation

- Time: 2-5 seconds on modern hardware
- Size: ~50kb compressed proof
- Verification: Fast on-chain (STARK native)

## Integration Guide

### For Users

```typescript
import { PrivatePool } from './contracts';

// Generate secret
const secret = crypto.randomBytes(32);
const commitment = poseidon.hash([secret]);

// Deposit
const tx = await privatePool.deposit(commitment, amount);
await tx.wait();

// Store secret securely!
// Later, withdraw...

const nullifier = poseidon.hash([secret, index]);
const proof = await generateProof(secret, commitment);
await privatePool.withdraw(nullifier, recipient, amount, proof);
```

### For Developers

```cairo
#[starknet::interface]
trait IPrivatePool<TContractState> {
    fn deposit(ref self: TContractState, commitment: felt252, amount: u256);
    fn withdraw(
        ref self: TContractState,
        nullifier: felt252,
        recipient: ContractAddress,
        amount: u256,
        proof: Array<felt252>
    );
}
```

## Testing

```bash
cd contracts
scarb test privacy
```

## Compliance

Privacy doesn't mean illegal:

- **Selective Disclosure**: Prove properties without revealing data
- **Audit Trails**: Off-chain records for compliance
- **Regulatory Compliance**: Work with legal frameworks
- **KYC Integration**: Optional identity verification

## Future Enhancements

- [ ] Multi-asset support (ERC20s, NFTs)
- [ ] Shielded staking/yield
- [ ] Private messaging protocol
- [ ] Privacy-preserving DEX
- [ ] Anonymous credentials
- [ ] Private smart contract execution
- [ ] Cross-chain privacy bridges
- [ ] Mobile wallet integration

## Resources

- [STARK Documentation](https://starkware.co/stark/)
- [Tornado Cash Research](https://tornado.cash)
- [Zero-Knowledge Proof Resources](https://zkp.science/)
- [Privacy on Blockchains](https://research.paradigm.xyz)
