# Payments Track Documentation

## Overview
The Payments Track provides a comprehensive decentralized payment gateway built on Starknet, enabling businesses and individuals to accept multi-token payments with instant settlements.

## Smart Contract: PaymentGateway

### Location
`contracts/payments/payment_gateway.cairo`

### Features

#### 1. Invoice Management
- Create invoices with custom amounts and token types
- Track invoice status (pending, paid, cancelled)
- Automatic balance updates for merchants

#### 2. Multi-Token Support
- ETH, STRK, USDC, USDT
- Easy to add new token support
- Automatic conversion capabilities

#### 3. Payment Processing
- Instant payment confirmations
- Low-fee L2 transactions
- Automatic receipt generation

### Contract Functions

#### `create_invoice(amount: u256, token: ContractAddress) -> u256`
Creates a new invoice for payment collection.

**Parameters:**
- `amount`: Payment amount in token's smallest unit
- `token`: Token contract address

**Returns:** Invoice ID

#### `pay_invoice(invoice_id: u256)`
Pays an existing invoice.

**Parameters:**
- `invoice_id`: ID of the invoice to pay

#### `withdraw(token: ContractAddress, amount: u256)`
Allows merchants to withdraw their collected funds.

**Parameters:**
- `token`: Token to withdraw
- `amount`: Amount to withdraw

#### `get_invoice(invoice_id: u256) -> Invoice`
Retrieves invoice details.

#### `get_merchant_balance(merchant: ContractAddress, token: ContractAddress) -> u256`
Gets merchant's balance for a specific token.

## Integration Guide

### 1. Deploy Contract
```bash
cd contracts
scarb build
starkli deploy target/dev/payment_gateway.json
```

### 2. Create Invoice (Merchant)
```typescript
const invoiceId = await contract.create_invoice(
  amount,
  tokenAddress
);
```

### 3. Pay Invoice (Customer)
```typescript
await contract.pay_invoice(invoiceId);
```

### 4. Withdraw Funds (Merchant)
```typescript
await contract.withdraw(tokenAddress, amount);
```

## Use Cases

### E-commerce Integration
- Accept crypto payments on your online store
- Automatic token conversion
- Real-time settlement

### Freelance Payments
- Invoice clients professionally
- Built-in escrow for milestone payments
- Dispute resolution support

### Subscription Services
- Recurring payment automation
- Multi-tier pricing support
- Automatic billing cycles

### Team Payroll
- Multi-recipient payment splitting
- Automatic salary distribution
- Token conversion at payment time

## Security Features

- Non-reentrancy protection
- Owner-controlled token whitelist
- Balance verification before withdrawal
- Event emission for transparency

## Future Enhancements

- Payment splitting for multiple recipients
- Escrow service integration
- Dispute resolution mechanism
- Invoice expiration dates
- Discount codes support
- Refund functionality
