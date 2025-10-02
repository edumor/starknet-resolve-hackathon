# Contributing to Starknet Re{Solve} Hackathon Project

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect different viewpoints and experiences

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported
2. Use the issue template
3. Provide detailed reproduction steps
4. Include environment details (OS, Node version, etc.)

### Suggesting Enhancements

1. Check if the enhancement has been suggested
2. Provide a clear description of the feature
3. Explain the use case and benefits
4. Include mockups or examples if applicable

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/edumor/starknet-resolve-hackathon.git
   cd starknet-resolve-hackathon
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding standards
   - Write tests for new features
   - Update documentation as needed

4. **Test your changes**
   ```bash
   # Test Cairo contracts
   cd contracts && scarb test
   
   # Test frontend
   cd frontend && npm test
   
   # Test mobile
   cd mobile && npm test
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `test:` Test additions or changes
   - `refactor:` Code refactoring
   - `style:` Code style changes
   - `chore:` Build process or auxiliary tool changes

6. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- Node.js 18+
- Scarb (Cairo package manager)
- Dojo CLI
- Starknet Foundry
- Git

### Installation

```bash
# Clone repository
git clone https://github.com/edumor/starknet-resolve-hackathon.git
cd starknet-resolve-hackathon

# Install dependencies
npm install

# Setup Cairo contracts
cd contracts
scarb build

# Setup frontend
cd ../frontend
npm install

# Setup mobile
cd ../mobile
npm install
```

## Coding Standards

### Cairo

- Follow Cairo naming conventions
- Use meaningful variable names
- Add comments for complex logic
- Write comprehensive tests
- Use events for important state changes

### TypeScript/React

- Use TypeScript for type safety
- Follow ESLint configuration
- Use functional components with hooks
- Implement proper error handling
- Write unit tests for components

### Git

- One feature per PR
- Keep commits atomic and focused
- Write descriptive commit messages
- Rebase on main before submitting PR
- Resolve conflicts before requesting review

## Testing

### Cairo Contracts

```bash
cd contracts
scarb test
```

### Frontend

```bash
cd frontend
npm test
npm run test:coverage
```

### Mobile

```bash
cd mobile
npm test
```

## Documentation

- Update README.md for major changes
- Add JSDoc/Cairo doc comments
- Update relevant markdown files in docs/
- Include examples for new features

## Review Process

1. Automated CI checks must pass
2. Code review by maintainers
3. Address feedback and requested changes
4. Final approval and merge

## Questions?

- Open an issue for discussion
- Join our Discord community
- Check existing documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing! 🚀
