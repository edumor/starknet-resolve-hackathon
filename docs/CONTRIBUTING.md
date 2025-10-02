# Contributing to Starknet Re{Solve} Hackathon

Thank you for your interest in contributing to this project! This guide will help you get started.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)

## Code of Conduct

### Our Standards
- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive criticism
- Prioritize the community's best interests

### Unacceptable Behavior
- Harassment or discriminatory language
- Trolling or inflammatory comments
- Publishing others' private information
- Other conduct inappropriate in a professional setting

## Getting Started

### Prerequisites
- Node.js 18+ and npm
- Rust and Cargo
- Scarb (Cairo package manager)
- Dojo CLI (for gaming track)
- Git and GitHub account

### Fork and Clone
```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/starknet-resolve-hackathon.git
cd starknet-resolve-hackathon

# Add upstream remote
git remote add upstream https://github.com/edumor/starknet-resolve-hackathon.git
```

### Install Dependencies
```bash
# Install frontend dependencies
cd frontend
npm install

# Install contract dependencies
cd ../contracts
scarb build

# Install Dojo dependencies
cd ../dojo
sozo build
```

## Development Workflow

### 1. Create a Branch
```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

### 2. Make Changes
- Write clean, documented code
- Follow existing code style
- Add tests for new features
- Update documentation

### 3. Test Your Changes
```bash
# Test contracts
cd contracts
scarb test

# Test frontend
cd ../frontend
npm test

# Test Dojo
cd ../dojo
sozo test
```

### 4. Commit Your Changes
```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add new feature description"
```

#### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(payments): add multi-token support
fix(gaming): resolve battle calculation bug
docs(bitcoin): update bridge documentation
```

### 5. Push and Create PR
```bash
# Push to your fork
git push origin feature/your-feature-name

# Create Pull Request on GitHub
```

## Pull Request Process

### Before Submitting
- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No merge conflicts with main

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe testing performed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests pass
- [ ] No new warnings

## Screenshots (if applicable)
```

### Review Process
1. Maintainer reviews your PR
2. Feedback may be provided
3. Make requested changes
4. Once approved, PR will be merged

## Coding Standards

### Cairo/Starknet
- Follow Cairo style guide
- Use descriptive variable names
- Add comments for complex logic
- Include NatSpec documentation
- Handle errors appropriately

```cairo
/// @notice Creates a new invoice for payment
/// @param amount The payment amount in token units
/// @param token The token contract address
/// @return The created invoice ID
fn create_invoice(
    ref self: ContractState,
    amount: u256,
    token: ContractAddress,
) -> u256 {
    // Implementation
}
```

### TypeScript/React
- Use TypeScript for type safety
- Follow React best practices
- Use functional components and hooks
- Keep components small and focused
- Add PropTypes or TypeScript interfaces

```typescript
interface InvoiceProps {
  invoiceId: string;
  amount: bigint;
  onPay: (id: string) => Promise<void>;
}

export function Invoice({ invoiceId, amount, onPay }: InvoiceProps) {
  // Component implementation
}
```

### File Organization
```
contracts/
  ├── payments/          # Payment track contracts
  ├── privacy/           # Privacy track contracts
  ├── bitcoin/           # Bitcoin track contracts
  └── innovation/        # Innovation track contracts

frontend/
  ├── src/
  │   ├── components/    # Shared components
  │   ├── mobile/        # Mobile-specific
  │   ├── gaming/        # Gaming-specific
  │   └── payments/      # Payment-specific

docs/
  ├── payments.md        # Track documentation
  ├── gaming.md
  └── ...
```

## Testing Guidelines

### Contract Tests
```cairo
#[test]
fn test_create_invoice() {
    let contract = deploy_contract();
    let invoice_id = contract.create_invoice(1000, token_address);
    assert(invoice_id > 0, 'Invoice not created');
}
```

### Frontend Tests
```typescript
import { render, screen, fireEvent } from '@testing-library/react';

describe('PaymentsTrack', () => {
  it('renders payment form', () => {
    render(<PaymentsTrack />);
    expect(screen.getByText('Create Invoice')).toBeInTheDocument();
  });

  it('creates invoice on submit', async () => {
    render(<PaymentsTrack />);
    const button = screen.getByText('Create Invoice');
    fireEvent.click(button);
    // Assert invoice created
  });
});
```

### Test Coverage
- Aim for >80% code coverage
- Test happy paths
- Test error cases
- Test edge cases
- Mock external dependencies

## Track-Specific Guidelines

### Payments Track
- Ensure multi-token support
- Test invoice creation and payment flows
- Validate balance calculations

### Mobile Track
- Test on real mobile devices
- Verify PWA installation
- Check offline functionality
- Test touch interactions

### Gaming Track
- Follow Dojo best practices
- Test battle mechanics
- Verify NFT minting
- Check game state consistency

### Privacy Track
- Review cryptographic implementations
- Test commitment/nullifier logic
- Verify proof generation

### Bitcoin Track
- Test multi-sig functionality
- Verify deposit confirmations
- Check withdrawal approvals

### Innovation Track
- Test dynamic fee calculations
- Verify flash loan safety
- Check liquidity math

## Documentation

### Code Comments
- Explain "why" not "what"
- Document complex algorithms
- Add TODOs with context
- Use consistent formatting

### README Updates
- Keep installation instructions current
- Update feature lists
- Add new sections as needed
- Include screenshots

### API Documentation
- Document all public functions
- Include parameter descriptions
- Provide usage examples
- Note any side effects

## Questions or Issues?

- Check existing issues first
- Use issue templates
- Provide reproduction steps
- Include system information

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing to Starknet Re{Solve}! 🚀
