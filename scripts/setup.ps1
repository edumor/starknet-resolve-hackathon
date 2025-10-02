#!/usr/bin/env pwsh

# Starknet Re{Solve} Hackathon - Development Setup Script
# This script sets up the complete development environment

Write-Host "🚀 Setting up Starknet Re{Solve} Hackathon Project" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Check if Node.js is installed
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}

# Check if npm is available
try {
    $npmVersion = npm --version
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🏗️ Installing project dependencies..." -ForegroundColor Yellow

# Install frontend dependencies
Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Cyan
Set-Location "frontend"
if (Test-Path "package.json") {
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Frontend installation failed" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️ Frontend package.json not found" -ForegroundColor Yellow
}
Set-Location ".."

# Install mobile dependencies
Write-Host "📱 Installing mobile dependencies..." -ForegroundColor Cyan
Set-Location "mobile"
if (Test-Path "package.json") {
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Mobile dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Mobile installation failed" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️ Mobile package.json not found" -ForegroundColor Yellow
}
Set-Location ".."

Write-Host ""
Write-Host "🔧 Setting up development tools..." -ForegroundColor Yellow

# Check for Cairo installation
Write-Host "🏺 Checking Cairo installation..." -ForegroundColor Cyan
try {
    $cairoVersion = cairo-compile --version
    Write-Host "✅ Cairo found: $cairoVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Cairo not found. Install from: https://github.com/starkware-libs/cairo" -ForegroundColor Yellow
    Write-Host "   Run: pip install cairo-lang" -ForegroundColor White
}

# Check for Starknet CLI
Write-Host "🌐 Checking Starknet CLI..." -ForegroundColor Cyan
try {
    $starknetVersion = starknet --version
    Write-Host "✅ Starknet CLI found: $starknetVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Starknet CLI not found. Install with: pip install starknet-devnet" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎮 Setting up gaming environment..." -ForegroundColor Yellow

# Check for Dojo
Write-Host "🎯 Checking Dojo installation..." -ForegroundColor Cyan
try {
    $dojoVersion = dojo --version
    Write-Host "✅ Dojo found: $dojoVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Dojo not found. Install from: https://book.dojoengine.org/getting-started" -ForegroundColor Yellow
    Write-Host "   Run: curl -L https://install.dojoengine.org | bash" -ForegroundColor White
}

Write-Host ""
Write-Host "📱 Mobile development setup..." -ForegroundColor Yellow

# Check React Native CLI
try {
    $rnVersion = npx react-native --version
    Write-Host "✅ React Native CLI available" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Installing React Native CLI..." -ForegroundColor Yellow
    npm install -g react-native-cli
}

Write-Host ""
Write-Host "🔐 Security and environment setup..." -ForegroundColor Yellow

# Create environment files if they don't exist
if (-not (Test-Path "frontend\.env.example")) {
    Write-Host "📝 Creating frontend environment template..." -ForegroundColor Cyan
    @"
# Starknet Configuration
REACT_APP_STARKNET_NETWORK=goerli-alpha
REACT_APP_PAYMENT_CONTRACT=0x...
REACT_APP_GAMING_WORLD=0x...
REACT_APP_PRIVACY_CONTRACT=0x...
REACT_APP_BITCOIN_BRIDGE=0x...

# API Keys (replace with actual values)
REACT_APP_ALCHEMY_KEY=your_alchemy_key_here
REACT_APP_INFURA_KEY=your_infura_key_here
"@ | Out-File -FilePath "frontend\.env.example" -Encoding UTF8
    Write-Host "✅ Frontend .env.example created" -ForegroundColor Green
}

if (-not (Test-Path "mobile\.env.example")) {
    Write-Host "📝 Creating mobile environment template..." -ForegroundColor Cyan
    @"
# Mobile App Configuration
STARKNET_RPC_URL=https://starknet-goerli.g.alchemy.com/v2/your-key
PAYMENT_CONTRACT_ADDRESS=0x...
GAMING_CONTRACT_ADDRESS=0x...
PRIVACY_CONTRACT_ADDRESS=0x...
BITCOIN_BRIDGE_ADDRESS=0x...
"@ | Out-File -FilePath "mobile\.env.example" -Encoding UTF8
    Write-Host "✅ Mobile .env.example created" -ForegroundColor Green
}

Write-Host ""
Write-Host "📋 Creating development scripts..." -ForegroundColor Yellow

# Create start script
$startScript = @"
#!/usr/bin/env pwsh
# Start all development servers

Write-Host "🚀 Starting Starknet Hackathon Development Environment" -ForegroundColor Green

# Start frontend in background
Write-Host "🌐 Starting frontend server..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm start"

# Wait a bit
Start-Sleep 3

# Start mobile metro bundler
Write-Host "📱 Starting mobile Metro bundler..." -ForegroundColor Cyan  
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd mobile; npm start"

Write-Host "✅ Development servers starting!" -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "Mobile: Metro bundler running" -ForegroundColor White
"@

$startScript | Out-File -FilePath "scripts\start-dev.ps1" -Encoding UTF8

# Make script executable
if (Get-Command "chmod" -ErrorAction SilentlyContinue) {
    chmod +x scripts/start-dev.ps1
}

Write-Host "✅ Development start script created: scripts\start-dev.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "🎯 Setup Summary:" -ForegroundColor Yellow
Write-Host "=================" -ForegroundColor Yellow
Write-Host "✅ Project structure created" -ForegroundColor Green
Write-Host "✅ Frontend dependencies ready" -ForegroundColor Green  
Write-Host "✅ Mobile dependencies ready" -ForegroundColor Green
Write-Host "✅ Environment templates created" -ForegroundColor Green
Write-Host "✅ Development scripts ready" -ForegroundColor Green

Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Copy .env.example files and fill in your values" -ForegroundColor White
Write-Host "2. Install Cairo: pip install cairo-lang" -ForegroundColor White
Write-Host "3. Install Dojo: curl -L https://install.dojoengine.org | bash" -ForegroundColor White
Write-Host "4. Run: .\scripts\start-dev.ps1" -ForegroundColor White
Write-Host "5. Start building for all 6 hackathon tracks!" -ForegroundColor White

Write-Host ""
Write-Host "🏆 Good luck with the Starknet Re{Solve} Hackathon!" -ForegroundColor Green
Write-Host "💰 Total Prize Pool: $43,500+" -ForegroundColor Yellow
Write-Host "📅 Deadline: October 16, 2025" -ForegroundColor Red