#!/bin/bash

# Deployment script for Dojo game world

set -e

echo "🎮 Deploying Starknet Battles Game"
echo "================================="

# Check if sozo is installed
if ! command -v sozo &> /dev/null; then
    echo "❌ Sozo not found. Please install Dojo: curl -L https://install.dojoengine.org | bash"
    exit 1
fi

# Check if torii is installed
if ! command -v torii &> /dev/null; then
    echo "⚠️  Torii not found. Indexer won't start automatically."
fi

# Set network (default to local)
NETWORK=${1:-local}
echo "📡 Network: $NETWORK"

cd dojo

# Build world
echo ""
echo "🔨 Building Dojo world..."
sozo build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ World built successfully"

# Migrate (deploy)
echo ""
echo "🚀 Migrating world to $NETWORK..."
if [ "$NETWORK" = "local" ]; then
    sozo migrate
else
    sozo migrate --network $NETWORK
fi

if [ $? -ne 0 ]; then
    echo "❌ Migration failed"
    exit 1
fi

echo "✅ World deployed successfully"

# Extract world address
WORLD_ADDRESS=$(sozo inspect world | grep "Address:" | awk '{print $2}')
echo ""
echo "🌍 World Address: $WORLD_ADDRESS"

# Start indexer (Torii) if available and on local network
if command -v torii &> /dev/null && [ "$NETWORK" = "local" ]; then
    echo ""
    echo "📊 Starting Torii indexer..."
    echo "   World: $WORLD_ADDRESS"
    echo ""
    echo "🎯 Run this command in a separate terminal:"
    echo "   torii --world $WORLD_ADDRESS"
fi

echo ""
echo "✅ Dojo deployment complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Note the world address above"
echo "   2. Update frontend with world address"
echo "   3. Start Torii indexer if not running"
echo "   4. Test game functionality"
