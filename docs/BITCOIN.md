# Bitcoin Track Documentation

## Overview

The Bitcoin track provides a trustless, bidirectional bridge between Bitcoin and Starknet, enabling Bitcoin holders to access DeFi opportunities on Starknet while maintaining security through cryptographic proofs.

## Architecture

### Bridge Components

1. **Bitcoin Relay**: Verifies Bitcoin block headers on Starknet
2. **Lock Contract**: Holds Bitcoin on Bitcoin network
3. **Wrapped BTC**: ERC20 token on Starknet (1:1 with BTC)
4. **Proof System**: SPV proofs for transaction verification

### Flow Diagrams

#### Deposit Flow

```
Bitcoin Network          Bridge Validators          Starknet
     |                          |                        |
     | 1. User sends BTC        |                        |
     |    to lock address       |                        |
     |------------------------->|                        |
     |                          |                        |
     | 2. Transaction confirmed |                        |
     |    (6+ confirmations)    |                        |
     |                          |                        |
     |                          | 3. Submit proof        |
     |                          |----------------------->|
     |                          |                        |
     |                          |    4. Verify proof     |
     |                          |    5. Mint wBTC        |
     |                          |<-----------------------|
     |                          |                        |
     |                          | 6. User receives wBTC  |
```

#### Withdrawal Flow

```
Starknet                 Bridge Validators          Bitcoin Network
     |                          |                        |
     | 1. Burn wBTC             |                        |
     |------------------------->|                        |
     |                          |                        |
     | 2. Withdrawal request    |                        |
     |    processed             |                        |
     |                          |                        |
     |                          | 3. Sign BTC tx         |
     |                          |----------------------->|
     |                          |                        |
     |                          | 4. Broadcast tx        |
     |                          |    Send BTC to user    |
     |                          |                        |
```

## Contracts

### BTCBridge.cairo

Main bridge contract on Starknet.

#### Key Functions

```cairo
fn initiate_deposit(
    ref self: ContractState,
    btc_tx_hash: felt252,
    amount: u256,
    proof: Array<felt252>
) -> u256
```

**Parameters:**
- `btc_tx_hash`: Bitcoin transaction hash
- `amount`: BTC amount (in satoshis)
- `proof`: SPV proof (Merkle path + block header)

**Process:**
1. Verify proof structure
2. Create pending deposit
3. Wait for confirmations
4. Emit `DepositInitiated` event

```cairo
fn confirm_deposit(ref self: ContractState, deposit_id: u256, confirmations: u32)
```

Called by validators once Bitcoin transaction has sufficient confirmations.

**Minimum Confirmations:** 6 blocks (~60 minutes)

```cairo
fn request_withdrawal(
    ref self: ContractState,
    btc_address: felt252,
    amount: u256
) -> u256
```

User requests withdrawal by burning wBTC.

**Process:**
1. Verify wBTC balance
2. Burn wBTC tokens
3. Create withdrawal request
4. Emit `WithdrawalRequested` event

```cairo
fn complete_withdrawal(
    ref self: ContractState,
    withdrawal_id: u256,
    btc_tx_hash: felt252
)
```

Validators complete withdrawal after broadcasting Bitcoin transaction.

### WrappedBTC.cairo (ERC20)

Standard ERC20 token with mint/burn capabilities.

```cairo
#[starknet::interface]
trait IWrappedBTC<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
    fn burn(ref self: TContractState, from: ContractAddress, amount: u256);
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
}
```

Properties:
- **Name**: Wrapped Bitcoin
- **Symbol**: wBTC
- **Decimals**: 8 (same as Bitcoin)
- **Supply**: Backed 1:1 by locked Bitcoin

## SPV (Simplified Payment Verification)

### What is SPV?

SPV allows verifying Bitcoin transactions without running a full node:

1. **Block Headers**: Store only block headers (80 bytes each)
2. **Merkle Proofs**: Prove transaction inclusion
3. **Difficulty Check**: Verify proof-of-work

### Merkle Proof Structure

```rust
struct MerkleProof {
    tx_hash: [u8; 32],           // Transaction hash
    merkle_root: [u8; 32],       // Block merkle root
    merkle_path: Vec<[u8; 32]>,  // Sibling hashes
    tx_index: u32,               // Position in block
}
```

### Verification Process

```cairo
fn verify_spv_proof(
    tx_hash: felt252,
    merkle_root: felt252,
    merkle_path: Array<felt252>,
    tx_index: u32
) -> bool {
    let mut computed_hash = tx_hash;
    let mut index = tx_index;
    
    for sibling in merkle_path {
        if index % 2 == 0 {
            computed_hash = hash(computed_hash, sibling);
        } else {
            computed_hash = hash(sibling, computed_hash);
        }
        index = index / 2;
    }
    
    computed_hash == merkle_root
}
```

## Security Model

### Multi-Signature Validators

Bridge uses multi-sig for security:

- **Validator Set**: 7 trusted validators
- **Threshold**: 5 of 7 signatures required
- **Rotation**: Validators can be rotated via governance
- **Slashing**: Malicious behavior leads to stake slashing

### Time Locks

Withdrawals have time locks:

- **Request Time**: Withdrawal requested
- **Challenge Period**: 24 hours for fraud proofs
- **Execution**: After challenge period, withdrawal completes

### Emergency Pause

Circuit breaker for critical issues:

```cairo
fn pause_bridge(ref self: ContractState)
fn unpause_bridge(ref self: ContractState)
```

Controlled by multi-sig governance.

### Fraud Proofs

Anyone can submit fraud proof:

```cairo
fn submit_fraud_proof(
    ref self: ContractState,
    deposit_id: u256,
    counter_proof: Array<felt252>
)
```

If valid:
- Deposit is rejected
- Whistleblower receives reward
- Malicious validator slashed

## Lightning Network Integration

### Payment Channels

Support Lightning Network for instant transfers:

```cairo
struct LightningChannel {
    channel_id: felt252,
    capacity: u256,
    local_balance: u256,
    remote_balance: u256,
}
```

### Benefits

- **Instant Transfers**: No waiting for confirmations
- **Lower Fees**: Off-chain transactions
- **Higher Throughput**: Many TPS

### Implementation

1. **Open Channel**: Lock BTC in channel
2. **Off-Chain Updates**: Fast bilateral updates
3. **Close Channel**: Settle final state on-chain

## Use Cases

### 1. Bitcoin DeFi

Access Starknet DeFi with Bitcoin:

- **Lending**: Collateralize wBTC, borrow USDC
- **Trading**: Swap wBTC for other tokens
- **Yield Farming**: Provide liquidity with wBTC
- **Derivatives**: Trade Bitcoin perpetuals

### 2. Fast Bitcoin Payments

Use Starknet L2 for fast settlements:

- Send wBTC instantly
- Settle with low fees
- Convert back to BTC when needed

### 3. Bitcoin Savings

Earn yield on Bitcoin holdings:

- Deposit BTC
- Stake wBTC in yield protocols
- Accumulate rewards
- Withdraw BTC + rewards

### 4. Cross-Chain Arbitrage

Trade between Bitcoin and Starknet:

- Price differences between chains
- MEV opportunities
- Market making

## Integration Guide

### For Users

```typescript
import { BTCBridge } from './contracts';

// Deposit Bitcoin
const bitcoinTx = await sendBitcoin(lockAddress, amount);
await waitForConfirmations(bitcoinTx, 6);

const proof = await generateSPVProof(bitcoinTx);
const depositId = await bridge.initiate_deposit(
    bitcoinTx.hash,
    amount,
    proof
);

// Wait for validators to confirm
await waitForDeposit(depositId);

// Receive wBTC on Starknet
const balance = await wBTC.balance_of(userAddress);

// Later, withdraw...
const withdrawalId = await bridge.request_withdrawal(
    btcAddress,
    amount
);

// Wait for withdrawal to complete
await waitForWithdrawal(withdrawalId);
```

### For Validators

```typescript
// Monitor Bitcoin network
bitcoin.on('block', async (block) => {
    const deposits = await findPendingDeposits(block);
    
    for (const deposit of deposits) {
        if (deposit.confirmations >= 6) {
            await bridge.confirm_deposit(
                deposit.id,
                deposit.confirmations
            );
        }
    }
});

// Process withdrawals
starknet.on('WithdrawalRequested', async (event) => {
    const withdrawal = await bridge.get_withdrawal(event.id);
    
    // Create Bitcoin transaction
    const btcTx = await createBitcoinTx(
        withdrawal.btc_address,
        withdrawal.amount
    );
    
    // Multi-sig signing
    const signed = await multiSigSign(btcTx);
    
    // Broadcast to Bitcoin network
    await bitcoin.broadcast(signed);
    
    // Update Starknet
    await bridge.complete_withdrawal(
        event.id,
        btcTx.hash
    );
});
```

## Testing

### Unit Tests

```bash
cd contracts
scarb test bitcoin
```

### Integration Tests

Requires Bitcoin testnet:

```bash
# Start Bitcoin testnet node
bitcoind -testnet

# Run integration tests
npm run test:bitcoin
```

## Monitoring

### Metrics

- Total Bitcoin locked
- Number of active deposits/withdrawals
- Bridge TVL (Total Value Locked)
- Average deposit/withdrawal time
- Validator activity

### Alerts

- Large withdrawals (> 10 BTC)
- Failed SPV verifications
- Validator downtime
- Unusual activity patterns

## Gas Costs

Estimated gas costs:

| Operation | Gas Cost |
|-----------|----------|
| Initiate Deposit | ~150k |
| Confirm Deposit | ~100k |
| Request Withdrawal | ~120k |
| Complete Withdrawal | ~100k |

## Future Enhancements

- [ ] Support for Bitcoin inscriptions (Ordinals)
- [ ] BRC-20 token bridging
- [ ] Recursive covenants for advanced contracts
- [ ] Taproot address support
- [ ] Atomic swaps
- [ ] Cross-chain DEX integration
- [ ] Bitcoin script verification on Starknet
- [ ] Submarine swaps
- [ ] Lightning Network full integration

## Resources

- [Bitcoin SPV](https://bitcoin.org/en/operating-modes-guide#simplified-payment-verification-spv)
- [BTC Relay](https://github.com/ethereum/btcrelay)
- [Lightning Network](https://lightning.network/)
- [Bitcoin Bridge Designs](https://blog.cosmos.network/bitcoin-bridge-design)
