# Contributing to Starknet Re{Solve} Hackathon Project

Thank you for your interest in contributing to our comprehensive hackathon submission! 🎉

## 🎯 Project Overview

This project covers **ALL 6 tracks** of the Starknet Re{Solve} Hackathon:
- 💳 Next-Gen Payments
- 📱 Mobile-First dApps  
- 🎮 On-Chain Gaming
- 🔒 Privacy & Identity
- ₿ Bitcoin Unleashed
- 🚀 Open Innovation

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- Starknet wallet (Argent X or Braavos)
- Git

### Setup
```bash
git clone https://github.com/edumor/starknet-resolve-hackathon.git
cd starknet-resolve-hackathon
cd frontend && npm install
npm start
```

## 📋 How to Contribute

### 1. Issues
- Check existing issues before creating new ones
- Use our issue templates for bug reports and feature requests
- Label issues with appropriate track tags

### 2. Pull Requests
- Fork the repository
- Create a feature branch: `git checkout -b feature/amazing-feature`
- Follow our PR template
- Ensure all checks pass

### 3. Code Style

#### Frontend (React/TypeScript)
```typescript
// Use TypeScript interfaces
interface PaymentData {
  recipient: string;
  amount: string;
  fee: string;
}

// Use proper naming conventions
const processPayment = async (data: PaymentData) => {
  // Implementation
};
```

#### Smart Contracts (Cairo)
```cairo
// Use clear function names and documentation
/// Process a payment with ultra-low fees
/// @param recipient The address to receive payment
/// @param amount The amount to transfer
fn process_payment(
    ref self: ContractState,
    recipient: ContractAddress,
    amount: u256
) -> bool {
    // Implementation
}
```

## 🏗️ Project Structure

```
├── contracts/          # Cairo smart contracts
├── frontend/          # React application
├── mobile/           # React Native app
├── gaming/           # Dojo gaming contracts
├── privacy/          # Privacy implementations
├── bitcoin/          # Bitcoin integration
└── docs/            # Documentation
```

## 🧪 Testing

### Frontend Testing
```bash
cd frontend
npm test
npm run type-check
```

### Smart Contract Testing
```bash
# Testing with Starknet tools
starknet-compile contracts/payment_system.cairo
```

## 📝 Commit Guidelines

Use conventional commits:
```
feat(payments): add ultra-low fee calculation
fix(wallet): resolve connection timeout issue
docs(readme): update setup instructions
test(gaming): add battle system tests
```

### Commit Types
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `test`: Adding tests
- `refactor`: Code refactoring
- `style`: Code formatting
- `ci`: CI/CD changes

## 🎯 Track-Specific Guidelines

### 💳 Payments Track
- Focus on ultra-low fees (0.1% target)
- Ensure instant settlement
- Test with multiple wallet types

### 🎮 Gaming Track
- Use Dojo framework patterns
- Implement energy-based mechanics
- Test multiplayer functionality

### 🔒 Privacy Track
- Implement zero-knowledge proofs
- Use proper nullifier patterns
- Ensure anonymous credentials

### ₿ Bitcoin Track
- Focus on cross-chain security
- Implement multi-signature patterns
- Test bridge functionality

### 📱 Mobile Track
- Mobile-first responsive design
- Test on actual devices
- Implement QR code functionality

### 🚀 Innovation Track
- Creative and experimental features
- Document innovative approaches
- Consider user experience

## 🏆 Hackathon Specific

### Prize Pool Considerations
- Ensure contributions help with multiple tracks
- Focus on judge evaluation criteria
- Maintain professional code quality

### Demo Preparation
- Test all features thoroughly
- Prepare for 3-minute demo video
- Document unique innovations

## 📞 Communication

- **GitHub Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions
- **Discussions**: General questions and ideas

## 🙏 Recognition

All contributors will be recognized in:
- Project documentation
- Hackathon submission
- Future project iterations

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## ✅ Checklist for Contributors

Before submitting:
- [ ] Code follows project style guidelines
- [ ] Tests pass locally
- [ ] Documentation updated if needed
- [ ] PR template completed
- [ ] Appropriate track labels added
- [ ] No sensitive information committed

Thank you for contributing to our hackathon success! 🚀