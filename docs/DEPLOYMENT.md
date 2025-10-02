# Deployment Guide

Complete guide for deploying the Starknet Re{Solve} Hackathon project to various networks.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Network Configuration](#network-configuration)
- [Smart Contract Deployment](#smart-contract-deployment)
- [Dojo World Deployment](#dojo-world-deployment)
- [Frontend Deployment](#frontend-deployment)
- [Post-Deployment](#post-deployment)

## Prerequisites

### Required Tools
```bash
# Install Scarb (Cairo package manager)
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

# Install Starkli (Starknet CLI)
curl https://get.starkli.sh | sh
starkliup

# Install Dojo
curl -L https://install.dojoengine.org | bash
dojoup

# Install Node.js and npm
# https://nodejs.org/
```

### Account Setup
```bash
# Create Starknet account (if needed)
starkli account fetch <ACCOUNT_ADDRESS> --output account.json

# Create signer
starkli signer keystore new signer.json

# Set environment variables
export STARKNET_ACCOUNT=account.json
export STARKNET_RPC=<RPC_URL>
```

## Network Configuration

### Testnet (Sepolia)
```bash
# RPC URL
export STARKNET_RPC="https://starknet-sepolia.public.blastapi.io"

# Block Explorer
https://sepolia.starkscan.co/
```

### Mainnet
```bash
# RPC URL
export STARKNET_RPC="https://starknet-mainnet.public.blastapi.io"

# Block Explorer
https://starkscan.co/
```

### Local Devnet
```bash
# Install and run devnet
cargo install starknet-devnet
starknet-devnet --seed 0

# RPC URL
export STARKNET_RPC="http://localhost:5050"
```

## Smart Contract Deployment

### 1. Build Contracts
```bash
cd contracts
scarb build
```

Verify build artifacts in `target/dev/`:
- `payment_gateway.json`
- `private_transfer.json`
- `btc_bridge.json`
- `innovative_dex.json`

### 2. Deploy Contracts

#### Option A: Using Deployment Script
```bash
# Deploy to Sepolia testnet
./scripts/deploy.sh sepolia

# Deploy to mainnet
./scripts/deploy.sh mainnet
```

#### Option B: Manual Deployment

**Payment Gateway**
```bash
# Declare contract
CLASS_HASH=$(starkli declare target/dev/payment_gateway.json)

# Deploy with owner address
PAYMENT_GATEWAY=$(starkli deploy $CLASS_HASH <OWNER_ADDRESS>)
echo "Payment Gateway: $PAYMENT_GATEWAY"
```

**Private Transfer**
```bash
CLASS_HASH=$(starkli declare target/dev/private_transfer.json)
PRIVATE_TRANSFER=$(starkli deploy $CLASS_HASH)
echo "Private Transfer: $PRIVATE_TRANSFER"
```

**BTC Bridge**
```bash
CLASS_HASH=$(starkli declare target/dev/btc_bridge.json)
BTC_BRIDGE=$(starkli deploy $CLASS_HASH <OWNER_ADDRESS> <REQUIRED_CONFIRMATIONS>)
echo "BTC Bridge: $BTC_BRIDGE"
```

**Innovative DEX**
```bash
CLASS_HASH=$(starkli declare target/dev/innovative_dex.json)
INNOVATIVE_DEX=$(starkli deploy $CLASS_HASH <OWNER_ADDRESS>)
echo "Innovative DEX: $INNOVATIVE_DEX"
```

### 3. Verify Deployments
```bash
# Check contract exists
starkli contract $PAYMENT_GATEWAY

# Verify owner (example)
starkli call $PAYMENT_GATEWAY owner
```

### 4. Save Addresses
Create `contracts/deployments.json`:
```json
{
  "sepolia": {
    "payment_gateway": "0x...",
    "private_transfer": "0x...",
    "btc_bridge": "0x...",
    "innovative_dex": "0x..."
  },
  "mainnet": {
    "payment_gateway": "0x...",
    "private_transfer": "0x...",
    "btc_bridge": "0x...",
    "innovative_dex": "0x..."
  }
}
```

## Dojo World Deployment

### 1. Build Dojo World
```bash
cd dojo
sozo build
```

### 2. Deploy to Network

#### Local Devnet
```bash
# Start local devnet first
starknet-devnet --seed 0

# Deploy
sozo migrate
```

#### Sepolia Testnet
```bash
sozo migrate --network sepolia
```

#### Mainnet
```bash
sozo migrate --network mainnet
```

### 3. Start Indexer (Torii)
```bash
# Get world address from migration output
WORLD_ADDRESS=<WORLD_ADDRESS>

# Start Torii
torii --world $WORLD_ADDRESS
```

### 4. Save Configuration
Create `dojo/deployments.json`:
```json
{
  "sepolia": {
    "world_address": "0x...",
    "game_actions": "0x...",
    "torii_url": "http://..."
  },
  "mainnet": {
    "world_address": "0x...",
    "game_actions": "0x...",
    "torii_url": "http://..."
  }
}
```

## Frontend Deployment

### 1. Configure Environment
Create `frontend/.env.production`:
```env
VITE_NETWORK=sepolia
VITE_RPC_URL=https://starknet-sepolia.public.blastapi.io

# Contract Addresses
VITE_PAYMENT_GATEWAY=0x...
VITE_PRIVATE_TRANSFER=0x...
VITE_BTC_BRIDGE=0x...
VITE_INNOVATIVE_DEX=0x...

# Dojo Configuration
VITE_DOJO_WORLD=0x...
VITE_TORII_URL=http://...
```

### 2. Build Frontend
```bash
cd frontend
npm install
npm run build
```

Build output in `frontend/dist/`

### 3. Deploy to Hosting

#### Vercel
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel --prod
```

#### Netlify
```bash
# Install Netlify CLI
npm i -g netlify-cli

# Deploy
cd frontend
netlify deploy --prod --dir=dist
```

#### IPFS/Fleek
```bash
# Install Fleek CLI
npm i -g @fleek-platform/cli

# Deploy
cd frontend/dist
fleek site deploy
```

### 4. Configure Domain
- Set up custom domain in hosting platform
- Configure DNS records
- Enable HTTPS
- Set up CDN (optional)

## Post-Deployment

### 1. Verify Deployment
- [ ] All contracts accessible on explorer
- [ ] Frontend loads correctly
- [ ] Wallet connection works
- [ ] Contract interactions functional
- [ ] Dojo world accessible

### 2. Initialize Contracts

**BTC Bridge - Add Guardians**
```bash
starkli invoke $BTC_BRIDGE add_guardian <GUARDIAN_ADDRESS>
```

**Innovative DEX - Add Initial Liquidity**
```bash
# Approve tokens
starkli invoke $TOKEN0 approve $INNOVATIVE_DEX <AMOUNT>
starkli invoke $TOKEN1 approve $INNOVATIVE_DEX <AMOUNT>

# Add liquidity
starkli invoke $INNOVATIVE_DEX add_liquidity $TOKEN0 $TOKEN1 <AMOUNT0> <AMOUNT1>
```

### 3. Monitoring Setup

#### Contract Events
Monitor contract events using:
- Apibara for indexing
- Custom event listeners
- Block explorer webhooks

#### Torii Indexer
Ensure Torii is running and accessible:
```bash
curl http://<TORII_URL>/health
```

#### Frontend Analytics
- Set up Google Analytics
- Configure error tracking (Sentry)
- Monitor performance (Lighthouse CI)

### 4. Security Checklist
- [ ] Contract ownership verified
- [ ] Guardian addresses correct (BTC Bridge)
- [ ] Token approvals reasonable
- [ ] No private keys in code
- [ ] Environment variables secure
- [ ] HTTPS enabled
- [ ] Access controls in place

### 5. Documentation Updates
- [ ] Update README with deployed addresses
- [ ] Add deployment date and network
- [ ] Document any configuration changes
- [ ] Update API documentation
- [ ] Add troubleshooting section

## Troubleshooting

### Contract Deployment Fails
```bash
# Check account balance
starkli balance <ACCOUNT_ADDRESS>

# Verify RPC connection
curl $STARKNET_RPC -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"starknet_chainId","params":[],"id":1}'

# Check account deployment
starkli account fetch <ACCOUNT_ADDRESS>
```

### Frontend Build Issues
```bash
# Clear cache
rm -rf node_modules dist .vite
npm install

# Check environment variables
cat .env.production

# Build with verbose output
npm run build -- --debug
```

### Dojo Migration Issues
```bash
# Clean build
sozo clean
sozo build

# Check account
sozo account list

# Verify network
sozo migrate --dry-run
```

## Mainnet Considerations

### Before Mainnet Deployment
1. **Thorough Testing**
   - Test on Sepolia extensively
   - Conduct security audits
   - Perform load testing

2. **Security Review**
   - External security audit
   - Bug bounty program
   - Emergency pause mechanisms

3. **Gas Optimization**
   - Optimize contract code
   - Batch operations where possible
   - Consider L1 gas costs

4. **Backup Plan**
   - Document rollback procedures
   - Set up monitoring alerts
   - Prepare incident response

### Mainnet Deployment Steps
1. Deploy contracts with multi-sig owner
2. Verify all contracts on explorer
3. Initialize with production parameters
4. Test with small amounts first
5. Gradually increase limits
6. Monitor continuously

## Support

For deployment issues:
- Check documentation at `/docs`
- Review troubleshooting section
- Open GitHub issue
- Contact team on Discord

## Maintenance

### Regular Updates
- Monitor for Starknet upgrades
- Update dependencies regularly
- Review and rotate keys
- Backup deployment data

### Emergency Procedures
- Have pause functionality ready
- Know how to contact guardians
- Document emergency contacts
- Test recovery procedures

---

**🚀 Happy Deploying!**
