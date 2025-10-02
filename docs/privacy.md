# Privacy Track Documentation

## Overview
The Privacy Track implements zero-knowledge proof functionality on Starknet, enabling users to make private transactions while maintaining the security guarantees of public blockchains.

## Smart Contract: PrivateTransfer

### Location
`contracts/privacy/private_transfer.cairo`

### Concept
The contract uses a commitment-nullifier scheme similar to Tornado Cash:
1. Users deposit tokens by creating a commitment (hash of a secret)
2. Commitments are stored in a Merkle tree
3. Users can withdraw to any address by proving they know a valid secret
4. A nullifier prevents double-spending the same commitment

### Key Features

#### Commitment-Based Deposits
- Users create a commitment: `commitment = hash(secret, nullifier)`
- Deposit tokens by submitting the commitment
- Commitment is added to the Merkle tree

#### Zero-Knowledge Withdrawals
- Prove knowledge of secret without revealing it
- Submit nullifier to prevent double-spending
- Withdraw to any address (breaks the link)

#### Privacy Guarantees
- Transaction amounts are private
- Sender-receiver link is broken
- Anonymity set grows with each deposit

### Contract Functions

#### `deposit(commitment: felt252)`
Creates a private deposit.

**Parameters:**
- `commitment`: Hash of secret and nullifier

**Process:**
1. Verify commitment doesn't exist
2. Add commitment to storage
3. Update Merkle tree (simplified in demo)
4. Emit Deposit event

#### `withdraw(nullifier: felt252, recipient: ContractAddress, proof: Span<felt252>)`
Withdraws funds privately using ZK proof.

**Parameters:**
- `nullifier`: Unique identifier to prevent double-spending
- `recipient`: Address to receive funds
- `proof`: Zero-knowledge proof components

**Process:**
1. Verify nullifier not used
2. Verify ZK proof (simplified in demo)
3. Mark nullifier as used
4. Transfer funds to recipient
5. Emit Withdrawal event

#### `commitment_exists(commitment: felt252) -> bool`
Checks if a commitment exists in the tree.

#### `nullifier_used(nullifier: felt252) -> bool`
Checks if a nullifier has been spent.

#### `get_merkle_root() -> felt252`
Returns current Merkle root for proof generation.

## Privacy Mechanism

### Commitment Scheme
```
secret = random 256-bit number
nullifier = random 256-bit number
commitment = poseidon_hash(secret, nullifier)
```

### Proof Generation (Off-chain)
1. User generates secret and nullifier during deposit
2. For withdrawal, user computes:
   - Commitment from stored secret and nullifier
   - Merkle proof that commitment exists
   - ZK proof showing knowledge without revealing

### Proof Verification (On-chain)
The contract verifies:
1. Nullifier hasn't been used before
2. Commitment exists in Merkle tree
3. Proof is valid for given public inputs

## Security Considerations

### Anonymity Set
- Larger deposit set = stronger privacy
- Mix deposits across time to avoid timing analysis
- Use relayers to hide withdrawal source

### Best Practices
- Never reuse secrets or nullifiers
- Store secrets securely offline
- Use multiple deposits for large amounts
- Wait random time before withdrawal

### Limitations (Demo)
This demo implementation simplifies:
- ZK proof verification (real implementation needs Cairo-native ZK verification)
- Merkle tree updates (should use efficient tree structure)
- Relayer integration (for hiding transaction source)

## Use Cases

### Private Transactions
Send funds without revealing sender or amount.

### Anonymous Donations
Make donations without public attribution.

### Confidential Business Payments
Keep sensitive business transactions private.

### Privacy-Preserving DeFi
Participate in DeFi while maintaining privacy.

## Integration Example

### Deposit Flow
```typescript
// Generate secret and nullifier
const secret = randomBytes(32);
const nullifier = randomBytes(32);

// Compute commitment
const commitment = poseidonHash([secret, nullifier]);

// Store secret offline (critical!)
saveSecretOffline({ secret, nullifier, commitment });

// Deposit on-chain
await contract.deposit(commitment);
```

### Withdrawal Flow
```typescript
// Load secret from secure storage
const { secret, nullifier } = loadSecretFromStorage();

// Generate ZK proof (off-chain)
const proof = await generateZKProof(secret, nullifier, merkleTree);

// Withdraw to new address
await contract.withdraw(nullifier, newAddress, proof);
```

## Future Enhancements

### Full ZK Implementation
- Complete ZK-SNARK circuit in Cairo
- Efficient Merkle tree with batch updates
- Optimized proof verification

### Additional Features
- Variable denomination pools
- Multi-asset support
- Compliance modes for regulated users
- Encrypted notes/memos

### Relayer Network
- Anonymous withdrawal service
- Gas payment from recipient
- Decentralized relayer network

### Advanced Privacy
- Ring signatures for enhanced anonymity
- Stealth addresses
- Confidential smart contracts
