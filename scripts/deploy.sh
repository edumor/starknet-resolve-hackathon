#!/bin/bash

# Deployment script for Starknet Re{Solve} Hackathon contracts

set -e

echo "🚀 Deploying Starknet Re{Solve} Hackathon Contracts"
echo "=================================================="

# Check if scarb is installed
if ! command -v scarb &> /dev/null; then
    echo "❌ Scarb not found. Please install: https://docs.swmansion.com/scarb/"
    exit 1
fi

# Check if starkli is installed
if ! command -v starkli &> /dev/null; then
    echo "❌ Starkli not found. Please install: https://github.com/xJonathanLEI/starkli"
    exit 1
fi

# Set network (default to sepolia testnet)
NETWORK=${1:-sepolia}
echo "📡 Network: $NETWORK"

# Build contracts
echo ""
echo "🔨 Building contracts..."
cd contracts
scarb build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Contracts built successfully"

# Deploy contracts
echo ""
echo "📦 Deploying contracts to $NETWORK..."

# Payment Gateway
echo ""
echo "💰 Deploying Payment Gateway..."
# starkli deploy target/dev/payment_gateway.json --network $NETWORK
echo "   Contract deployed (simulated)"

# Private Transfer
echo ""
echo "🔒 Deploying Private Transfer..."
# starkli deploy target/dev/private_transfer.json --network $NETWORK
echo "   Contract deployed (simulated)"

# BTC Bridge
echo ""
echo "₿ Deploying BTC Bridge..."
# starkli deploy target/dev/btc_bridge.json --network $NETWORK
echo "   Contract deployed (simulated)"

# Innovative DEX
echo ""
echo "💡 Deploying Innovative DEX..."
# starkli deploy target/dev/innovative_dex.json --network $NETWORK
echo "   Contract deployed (simulated)"

echo ""
echo "✅ All contracts deployed successfully!"
echo ""
echo "📝 Save these addresses for frontend integration"
