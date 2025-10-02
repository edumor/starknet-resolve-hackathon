# Starknet Re{Solve} Hackathon - Setup Guide

## 🚀 Quick Setup Commands

### Install Frontend Dependencies
```powershell
cd frontend
npm install
```

### Install Mobile Dependencies  
```powershell
cd mobile
npm install
```

### Start Development Servers
```powershell
# Frontend
cd frontend
npm start

# Mobile (Android)
cd mobile  
npm run android

# Mobile (iOS)
cd mobile
npm run ios
```

### Smart Contract Development
```powershell
# Install Starknet tools
pip install cairo-lang

# Compile contracts
starknet-compile contracts/payment_system.cairo --output contracts/payment_system.json

# Deploy to testnet
starknet deploy --contract contracts/payment_system.json --network alpha-goerli
```

### Gaming with Dojo
```powershell
# Install Dojo
curl -L https://install.dojoengine.org | bash
dojoup

# Build gaming contracts
cd gaming
dojo build

# Migrate to local testnet
dojo migrate
```

## 🔧 Development Tools Setup

### Cairo Development
1. Install Rust: https://rustup.rs/
2. Install Cairo: `curl -L https://github.com/starkware-libs/cairo/releases/download/v2.0.0/cairo-lang-2.0.0-x86_64-pc-windows-msvc.tar.gz`
3. Add to PATH

### React Development
1. Node.js 18+: https://nodejs.org/
2. VS Code with extensions:
   - Cairo
   - Solidity
   - React snippets
   - TypeScript

### Mobile Development
1. React Native CLI: `npm install -g react-native-cli`
2. Android Studio (for Android)
3. Xcode (for iOS, Mac only)

## 🛠️ Deployment Scripts

### Frontend Deployment (Vercel)
```powershell
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel
```

### Contract Deployment
```powershell
# Set environment variables
$env:STARKNET_NETWORK = "alpha-goerli"
$env:STARKNET_WALLET = "starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount"

# Deploy payment system
starknet deploy --contract contracts/payment_system.json --inputs 0x123... 10

# Deploy privacy system
starknet deploy --contract privacy/private_identity.json
```

## 🧪 Testing Commands

### Frontend Tests
```powershell
cd frontend
npm test
```

### Contract Tests
```powershell
# Cairo tests
cairo-test contracts/

# Integration tests
pytest tests/
```

### Mobile Tests
```powershell
cd mobile
npm test

# E2E tests
npm run test:e2e
```

## 📱 Mobile Development

### Android Setup
```powershell
cd mobile

# Install dependencies
npm install

# Start Metro bundler
npm start

# Run on Android (new terminal)
npm run android
```

### iOS Setup (macOS only)
```powershell
cd mobile

# Install iOS dependencies
cd ios && pod install && cd ..

# Run on iOS
npm run ios
```

## 🔐 Environment Configuration

### Frontend Environment (.env)
```
REACT_APP_STARKNET_NETWORK=goerli-alpha
REACT_APP_PAYMENT_CONTRACT=0x...
REACT_APP_GAMING_WORLD=0x...
REACT_APP_PRIVACY_CONTRACT=0x...
REACT_APP_BITCOIN_BRIDGE=0x...
```

### Mobile Environment
```
STARKNET_RPC_URL=https://starknet-goerli.g.alchemy.com/v2/your-key
PAYMENT_CONTRACT_ADDRESS=0x...
```

## 🏗️ Build Commands

### Production Builds
```powershell
# Frontend production build
cd frontend
npm run build

# Mobile production builds
cd mobile

# Android APK
npm run build:android

# iOS (macOS only)
npm run build:ios
```

## 🔍 Debugging

### Frontend Debugging
```powershell
# Start with debugging
cd frontend
npm start

# Open browser dev tools
# React DevTools extension recommended
```

### Mobile Debugging
```powershell
# React Native Debugger
npm install -g react-native-debugger

# Chrome DevTools
# Shake device -> Debug JS Remotely
```

### Contract Debugging
```powershell
# Local Starknet devnet
starknet-devnet --host 127.0.0.1 --port 5050

# Deploy to local network
starknet deploy --network http://127.0.0.1:5050 --contract contracts/payment_system.json
```

## 📋 Pre-Hackathon Checklist

- [ ] All dependencies installed
- [ ] Frontend running on localhost:3000
- [ ] Mobile app building successfully  
- [ ] Smart contracts compiling
- [ ] Wallet connection working
- [ ] Git repository initialized
- [ ] Documentation updated

## 🆘 Troubleshooting

### Common Issues

**Frontend not starting:**
```powershell
# Clear cache
cd frontend
rm -rf node_modules package-lock.json
npm install
```

**Mobile build fails:**
```powershell
# Clean React Native
cd mobile
npm run clean
npm install
```

**Cairo compilation errors:**
```powershell
# Update Cairo
curl -L https://github.com/starkware-libs/cairo/releases/latest
```

**Wallet connection issues:**
- Install Braavos or ArgentX
- Switch to Goerli testnet
- Get testnet ETH from faucet

### Getting Help
- Starknet Discord: https://discord.gg/starknet
- Documentation: https://docs.starknet.io
- GitHub Issues: Create issue in this repo

---

**Ready to build the future of Web3! 🚀**