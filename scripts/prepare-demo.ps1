#!/usr/bin/env pwsh
# 🎬 Demo Preparation Script for Starknet Re{Solve} Hackathon
# This script helps prepare everything needed for the demo video

Write-Host "🚀 Starknet Re{Solve} Hackathon - Demo Preparation" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "frontend/package.json")) {
    Write-Host "❌ Error: Please run this script from the project root directory" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Project directory confirmed" -ForegroundColor Green

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

Write-Host "`n📋 Checking Prerequisites..." -ForegroundColor Yellow

# Check Node.js
if (Test-Command "node") {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js not found. Please install Node.js 18+" -ForegroundColor Red
    exit 1
}

# Check npm
if (Test-Command "npm") {
    $npmVersion = npm --version
    Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
} else {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}

Write-Host "`n📦 Installing/Updating Dependencies..." -ForegroundColor Yellow

# Install frontend dependencies
Push-Location frontend
try {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
        Pop-Location
        exit 1
    }
} finally {
    Pop-Location
}

Write-Host "`n🔧 Preparing Demo Environment..." -ForegroundColor Yellow

# Create demo checklist
$checklistContent = @"
# 🎬 Demo Recording Checklist

## Before Recording
- [ ] Browser cache cleared
- [ ] Wallet extension installed (Argent X or Braavos)
- [ ] Wallet unlocked and connected to Sepolia testnet
- [ ] Screen recording software ready (OBS/Camtasia/QuickTime)
- [ ] Audio levels tested
- [ ] Script reviewed and practiced
- [ ] Backup plan ready

## During Recording
- [ ] Follow 3-minute timeline strictly
- [ ] Speak clearly and at moderate pace
- [ ] Show actual functionality, not just screenshots
- [ ] Keep cursor movements smooth and visible
- [ ] Avoid personal information exposure

## Technical Setup
- [ ] Resolution: 1080p recommended
- [ ] Frame rate: 30fps minimum
- [ ] Audio: Clear microphone, no background noise
- [ ] Browser: Chrome/Firefox, 100% zoom
- [ ] Network: Stable connection for wallet operations

## Demo Flow
1. **0:00-0:30**: Project overview and 6-track coverage
2. **0:30-1:00**: Architecture and code structure
3. **1:00-1:30**: Live wallet connection demo
4. **1:30-2:30**: Each track feature (15s each)
5. **2:30-3:00**: Technical highlights and innovation

## Post-Recording
- [ ] Video under 3 minutes
- [ ] Audio synchronized
- [ ] File format: MP4/MOV
- [ ] File size: <100MB for Devpost
- [ ] Quality check completed
- [ ] Uploaded to submission platform
"@

$checklistContent | Out-File -FilePath "docs/DEMO_CHECKLIST.md" -Encoding UTF8
Write-Host "✅ Demo checklist created: docs/DEMO_CHECKLIST.md" -ForegroundColor Green

# Create quick start script for demo
$demoStartScript = @"
#!/usr/bin/env pwsh
# Quick start script for demo recording

Write-Host "🎬 Starting Starknet Hackathon Demo Environment..." -ForegroundColor Cyan

# Start frontend server
Push-Location frontend
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm start" -WindowStyle Normal
Pop-Location

Write-Host "✅ Frontend server starting at http://localhost:3000" -ForegroundColor Green
Write-Host "🔗 Open browser and navigate to localhost:3000" -ForegroundColor Yellow
Write-Host "📋 Follow the checklist in docs/DEMO_CHECKLIST.md" -ForegroundColor Yellow

# Wait a bit then open browser
Start-Sleep -Seconds 3
Start-Process "http://localhost:3000"

Write-Host "`n🎯 Demo Tips:" -ForegroundColor Cyan
Write-Host "- Connect your Starknet wallet first" -ForegroundColor White
Write-Host "- Navigate through all 6 track pages" -ForegroundColor White
Write-Host "- Show wallet connection debug info" -ForegroundColor White
Write-Host "- Keep to 3-minute limit" -ForegroundColor White
Write-Host "`nGood luck! 🚀" -ForegroundColor Green
"@

$demoStartScript | Out-File -FilePath "scripts/start-demo.ps1" -Encoding UTF8
Write-Host "✅ Demo start script created: scripts/start-demo.ps1" -ForegroundColor Green

Write-Host "`n🎯 Demo Video Requirements Summary:" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
Write-Host "📏 Duration: Maximum 3 minutes" -ForegroundColor White
Write-Host "📺 Format: MP4, MOV, or AVI" -ForegroundColor White
Write-Host "📦 Size: Under 100MB for Devpost" -ForegroundColor White
Write-Host "🎥 Resolution: 1080p recommended" -ForegroundColor White
Write-Host "📅 Deadline: Oct 15, 2025, 11:00 PM PDT" -ForegroundColor White

Write-Host "`n📚 Resources Created:" -ForegroundColor Green
Write-Host "- docs/DEMO_VIDEO_SCRIPT.md - Complete script and timeline" -ForegroundColor White
Write-Host "- docs/DEMO_CHECKLIST.md - Recording checklist" -ForegroundColor White
Write-Host "- scripts/start-demo.ps1 - Quick demo environment setup" -ForegroundColor White

Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Review the script: docs/DEMO_VIDEO_SCRIPT.md" -ForegroundColor White
Write-Host "2. Install screen recording software (OBS Studio recommended)" -ForegroundColor White
Write-Host "3. Practice the demo 2-3 times" -ForegroundColor White
Write-Host "4. Run: .\scripts\start-demo.ps1" -ForegroundColor White
Write-Host "5. Record your awesome demo!" -ForegroundColor White

Write-Host "`n✨ Your project covers ALL 6 tracks and is eligible for $43,500+ in prizes!" -ForegroundColor Green
Write-Host "Good luck with your demo video! 🏆" -ForegroundColor Cyan