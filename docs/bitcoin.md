# Bitcoin Track Documentation

## Overview
The Bitcoin Track implements a trustless bridge between Bitcoin and Starknet, enabling BTC holders to use their assets in the Starknet DeFi ecosystem while maintaining security through a multi-signature guardian system.

## Smart Contract: BTCBridge

### Location
`contracts/bitcoin/btc_bridge.cairo`

### Architecture

#### Multi-Sig Guardian Model
- Multiple trusted guardians manage bridge security
- Requires M-of-N approvals for operations
- Prevents single point of failure
- Transparent guardian management

#### Wrapped BTC
- 1:1 backed representation of BTC on Starknet
- ERC20 compatible token
- Redeemable for real BTC anytime
- Transparent reserves

### Key Components

#### Deposit Flow
1. User sends BTC to multi-sig address
2. Guardians monitor Bitcoin network
3. After confirmations, guardians report deposit
4. Once threshold met, wrapped BTC is minted
5. User receives WBTC on Starknet

#### Withdrawal Flow
1. User requests withdrawal with BTC address
2. Wrapped BTC is burned immediately
3. Guardians review and approve request
4. After threshold approvals, BTC is sent
5. User receives BTC on Bitcoin network

### Contract Functions

#### `report_deposit(btc_tx_hash: felt252, user: ContractAddress, amount: u256)`
Guardian reports BTC deposit on Bitcoin network.

**Parameters:**
- `btc_tx_hash`: Bitcoin transaction hash
- `user`: Starknet address to receive WBTC
- `amount`: Amount of BTC deposited (in satoshis)

**Access:** Only guardians

**Process:**
1. Verify caller is guardian
2. Check if new or existing deposit
3. Increment confirmation count
4. If threshold reached, mint WBTC

#### `request_withdrawal(amount: u256, btc_address: felt252) -> u256`
User requests BTC withdrawal.

**Parameters:**
- `amount`: Amount of WBTC to withdraw
- `btc_address`: Bitcoin address to receive funds

**Returns:** Withdrawal request ID

**Process:**
1. Burn user's WBTC immediately
2. Create withdrawal request
3. Emit event for guardians

#### `approve_withdrawal(withdrawal_id: u256)`
Guardian approves withdrawal request.

**Parameters:**
- `withdrawal_id`: ID of withdrawal to approve

**Access:** Only guardians

**Process:**
1. Verify caller is guardian
2. Increment approval count
3. If threshold reached, mark as processed
4. Emit event for off-chain processing

#### `add_guardian(guardian: ContractAddress)`
Owner adds new guardian to the bridge.

**Parameters:**
- `guardian`: Address of new guardian

**Access:** Only owner

#### `get_deposit(btc_tx_hash: felt252) -> Deposit`
Retrieves deposit information.

#### `get_withdrawal(withdrawal_id: u256) -> Withdrawal`
Retrieves withdrawal information.

#### `get_wrapped_btc_supply() -> u256`
Returns total wrapped BTC in circulation.

## Guardian System

### Guardian Responsibilities
- Monitor Bitcoin network for deposits
- Report deposits to Starknet contract
- Verify withdrawal requests
- Approve legitimate withdrawals
- Manage multi-sig Bitcoin wallet

### Guardian Selection
- Reputable entities in crypto space
- Geographic distribution
- Technical capabilities
- Economic stake in protocol

### Threshold Configuration
- Typically 5-of-7 or 7-of-11
- Balance security vs. liveness
- Adjustable by governance

## Security Features

### Multi-Signature Protection
- No single guardian can move funds
- Requires threshold of approvals
- Transparent on-chain record

### Deposit Verification
- Multiple guardian confirmations required
- Bitcoin transaction verification
- Sufficient block confirmations

### Withdrawal Security
- Immediate WBTC burn prevents double-spend
- Multi-sig approval process
- Time delays for large withdrawals (optional)

### Reserve Transparency
- All BTC deposits verifiable on Bitcoin
- All WBTC minted tracked on Starknet
- 1:1 backing auditable at any time

## Bitcoin Integration

### Monitoring Deposits
Guardians run Bitcoin full nodes to:
- Monitor multi-sig address for deposits
- Verify transaction confirmations
- Extract deposit data (amount, user)
- Report to Starknet contract

### Processing Withdrawals
After on-chain approval:
1. Guardians coordinate off-chain
2. Create Bitcoin transaction
3. Sign with threshold signatures
4. Broadcast to Bitcoin network

### Lightning Network
Future integration enables:
- Fast BTC deposits via Lightning
- Instant WBTC minting
- Lightning withdrawals
- Reduced on-chain fees

## Use Cases

### DeFi on Starknet
- Use BTC as collateral for loans
- Provide BTC liquidity to DEXs
- Earn yield on BTC holdings
- Participate in Starknet DeFi

### Trading
- Trade BTC on Starknet DEXs
- Low fees compared to L1
- Fast settlement times
- Better liquidity through aggregation

### Payments
- Use BTC for Starknet transactions
- Lower fees than Bitcoin L1
- Faster confirmations
- Programmable BTC

## Comparison with Other Bridges

### vs. Centralized Bridges
- **Pro:** Multi-sig vs. single custodian
- **Pro:** Transparent operations
- **Con:** Slower than centralized

### vs. tBTC/RenBTC
- **Pro:** Starknet-native
- **Pro:** Lower fees
- **Similar:** Guardian-based security

### vs. RSK/Liquid
- **Pro:** Access to Starknet ecosystem
- **Con:** Not a Bitcoin sidechain
- **Different:** L2 vs. sidechain model

## Integration Guide

### For Users

#### Deposit BTC
1. Generate Starknet address or connect wallet
2. Get unique Bitcoin deposit address
3. Send BTC to deposit address
4. Wait for confirmations (6 blocks)
5. Receive WBTC on Starknet

#### Withdraw BTC
1. Connect Starknet wallet with WBTC
2. Enter Bitcoin address and amount
3. Approve WBTC burn transaction
4. Wait for guardian approvals
5. Receive BTC to Bitcoin address

### For Developers

#### Query Bridge State
```typescript
// Check if deposit is confirmed
const deposit = await bridge.get_deposit(btcTxHash);

// Check wrapped BTC supply
const supply = await bridge.get_wrapped_btc_supply();

// Monitor withdrawal status
const withdrawal = await bridge.get_withdrawal(withdrawalId);
```

#### Integrate WBTC
```typescript
// WBTC is ERC20 compatible
const wbtc = new Contract(WBTC_ADDRESS, ERC20_ABI, provider);
const balance = await wbtc.balanceOf(userAddress);
```

## Future Enhancements

### Technical Improvements
- Lightning Network integration
- Bitcoin SPV proofs on Starknet
- Optimistic verification model
- Batch processing for efficiency

### Features
- Multi-hop swaps (BTC -> WBTC -> other)
- Flash loans with WBTC
- BTC-backed stablecoins
- Ordinals/BRC-20 bridging

### Governance
- DAO-controlled guardian set
- On-chain governance for parameters
- Emergency pause mechanism
- Insurance fund for bridge risks
