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