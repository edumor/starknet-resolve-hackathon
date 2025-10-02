# Payments Track Documentation

## Overview

The Payments track provides a comprehensive payment infrastructure on Starknet, enabling merchants and users to process payments efficiently with multiple tokens.

## Contracts

### PaymentGateway.cairo

The main payment processing contract that handles:

- **Merchant Registration**: Merchants can register to accept payments
- **Payment Creation**: Create payment requests with specified amounts and tokens
- **Payment Completion**: Mark payments as completed after processing
- **Refund Processing**: Merchants can refund completed payments
- **Balance Management**: Track merchant balances across different tokens

#### Key Functions

```cairo
fn register_merchant(ref self: ContractState)
```
Register the caller as a merchant in the system.

```cairo
fn create_payment(
    ref self: ContractState,
    merchant: ContractAddress,
    token: ContractAddress,
    amount: u256
) -> u256
```
Create a new payment request. Returns the payment ID.

```cairo
fn complete_payment(ref self: ContractState, payment_id: u256)
```
Complete a pending payment and credit the merchant's balance.

```cairo
fn refund_payment(ref self: ContractState, payment_id: u256)
```
Refund a completed payment (merchant only).

#### Events

- `PaymentCreated`: Emitted when a new payment is created
- `PaymentCompleted`: Emitted when a payment is completed
- `PaymentRefunded`: Emitted when a payment is refunded
- `MerchantRegistered`: Emitted when a new merchant registers

### Escrow.cairo

Secure escrow service with arbiter-based dispute resolution.

#### Key Functions

```cairo
fn create_escrow(
    ref self: ContractState,
    payee: ContractAddress,
    arbiter: ContractAddress,
    token: ContractAddress,
    amount: u256,
    deadline: u64
) -> u256
```
Create a new escrow with specified terms.

```cairo
fn release_funds(ref self: ContractState, escrow_id: u256)
```
Release funds to the payee (payer or arbiter only).

```cairo
fn refund(ref self: ContractState, escrow_id: u256)
```
Refund funds to payer (arbiter or after deadline).

```cairo
fn raise_dispute(ref self: ContractState, escrow_id: u256)
```
Raise a dispute for arbiter resolution.

## Use Cases

### 1. E-commerce Payments

Merchants can integrate the payment gateway to accept crypto payments:

1. Merchant registers on the platform
2. Customer creates payment with merchant address
3. Customer sends tokens to contract
4. Merchant completes payment after fulfilling order
5. Funds are credited to merchant balance

### 2. Freelance Payments with Escrow

Protect both parties in freelance work:

1. Client creates escrow with freelancer and arbiter
2. Funds are locked in escrow
3. Freelancer completes work
4. Client releases funds, or dispute is raised
5. Arbiter resolves disputes if necessary

### 3. Subscription Services

Implement recurring payments:

1. Merchant sets up subscription terms
2. Users authorize recurring payments
3. Automatic payments processed at intervals
4. Users can cancel anytime

## Security Features

- **Access Control**: Only merchants can refund their payments
- **Status Checks**: Payments can only be completed once
- **Balance Tracking**: Accurate balance management per merchant per token
- **Time Locks**: Escrow with deadline-based automatic refunds
- **Dispute Resolution**: Arbiter system for conflict resolution

## Integration Guide

### For Merchants

1. **Register**: Call `register_merchant()` to enable your address
2. **Accept Payments**: Customers call `create_payment()` with your address
3. **Complete Orders**: After fulfilling orders, call `complete_payment()`
4. **Handle Refunds**: Call `refund_payment()` for customer refunds
5. **Withdraw**: Transfer your accumulated balance

### For Customers

1. **Create Payment**: Call `create_payment()` with merchant address and amount
2. **Transfer Tokens**: Send the exact amount to the contract
3. **Track Status**: Query payment status with `get_payment()`
4. **Request Refund**: Contact merchant for refund processing

## Testing

Run tests with:

```bash
cd contracts
scarb test
```

## Deployment

Deploy to testnet:

```bash
cd contracts
scarb build
starkli deploy target/dev/PaymentGateway.sierra.json --constructor-calldata <owner>
```

## Gas Optimization

- Uses `LegacyMap` for efficient storage
- Events for off-chain indexing
- Minimal storage updates per transaction
- Batch operations where possible

## Future Enhancements

- [ ] Payment splitting for multiple recipients
- [ ] Recurring payment automation
- [ ] Multi-signature for large payments
- [ ] Payment requests with QR codes
- [ ] Invoice generation and tracking
- [ ] Integration with stablecoins (USDC, USDT)
- [ ] Fee structure for platform sustainability
