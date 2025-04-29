# FeverTokens Package-oriented Framework

## Introduction
Functional scalability in Web3 addresses the limits of EVM byte-code size and the complexity of monolithic contracts. FeverTokens’ Package-oriented Framework extends EIP-2535 (Diamond Standard) to deliver modular, versioned, and individually upgradeable smart contract packages.

## Functional Scalability Challenge
- **EVM byte-code size limits:** Monolithic contracts hit the 24 KB size cap, forcing workarounds or multiple proxies.  
- **Maintenance pain points:** Large codebases become hard to audit, test, and upgrade.  
- **Proxy design shortcomings:** Naïve proxies bundle unrelated logic, leading to tangled upgrades and higher risk.

## Framework Overview
The Package-oriented paradigm decomposes application logic into cohesive packages—each a collection of composable, reusable contracts. It builds on EIP-2535’s facet routing, adding standardized package metadata and tooling for on-chain, off-chain, and cross-chain components.

## Architecture
Applications break down into **packages**, each grouping:
- **Interfaces (internal & external)**
- **Storage layouts**
- **Internal logic contracts**
- **External package contracts**

### Facets vs Packages
- **Facets:** EIP-2535 units of function selectors.  
- **Packages:** Higher-level modules that bundle facets with metadata, storage definitions, and tooling.

## Standard Package Structure
```bash
/contracts/Package
  ├── IPackageInternal.sol      # Internal interface: structs, enums, events, errors
  ├── IPackage.sol              # External interface: external functions (inherits IPackageInternal)
  ├── PackageStorage.sol        # Library: Storage layout & slot management
  ├── PackageInternal.sol       # Abstract Contract: Internal logic implementations (inherits IPackageInternal & imports PackageStorage)
  └── Package.sol               # Contract: deployable package (inherits IPackage and PackageInternal)
```

### Implementation Pattern

The framework implements this pattern across various domains:

- **Base Package**: The `contracts/package/PackageInternal.sol` provides the foundation for all packages, integrating initialization patterns, reentrancy protection, and meta-transaction support.

- **Domain-Specific Packages**: Multiple domain packages like `access/ownable`, `token/ERC20`, and `security/ReentrancyGuard` follow the standard structure.

### Real-World Example

For example, the ERC20 token package follows this pattern:
```bash
/contracts/token/ERC20
  ├── base/
  │   ├── IERC20BaseInternal.sol    # Internal token interfaces
  │   ├── IERC20Base.sol            # External token interfaces
  │   ├── ERC20BaseStorage.sol      # Token storage layout
  │   ├── ERC20BaseInternal.sol     # Internal implementations
  │   └── ERC20Base.sol             # Deployable base token
  ├── extensions/                   # Optional token extensions
  └── ERC20.sol                     # Complete token implementation
```

## Diamond Standard Integration

The framework builds on EIP-2535 (Diamond Standard) as its foundation:

- **Diamond Proxy**: The `contracts/diamond/Diamond.sol` serves as the core proxy implementation.
- **Diamond Facets**: Components like `DiamondCut`, `DiamondLoupe`, and `DiamondFallback` handle different aspects of the diamond pattern.
- **Package Integration**: Packages are deployed as facets that can be added to diamonds through the diamond cut mechanism.

### Diamond Architecture Benefits

1. **Unlimited Contract Size**: Overcome the 24KB contract size limit by distributing logic across facets
2. **Selective Upgradeability**: Replace or upgrade specific facets without touching others
3. **Function Collision Prevention**: Diamond's selector-based routing prevents function signature collisions
4. **Flexible Storage**: Structured storage patterns prevent slot collisions between packages

## Key Benefits
- **Modularity & independent upgradeability**

- **Enhanced flexibility & adaptability**

- **Unified terminology & efficient data management**

- **Seamless on-chain + off-chain (oracle & multi-chain) support**

## Getting Started
### Prerequisites
- Node.js v16+
- Hardhat v2.x or Foundry v0.5+
- Solidity ^0.8.0

### Installation
```bash
git clone https://github.com/fevertokens/fevertokens-packages.git
cd fevertokens-packages
npm install
npm run compile
```

## License

This project is licensed under the [MIT License](./LICENSE). You are free to use, modify, and distribute it under the conditions specified in the license file.
