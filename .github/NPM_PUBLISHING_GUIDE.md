# NPM Publishing Guide

This guide explains how to publish `@fevertokens/packages` to npm for use as a smart contract library.

## Overview

The package is configured to be published to npm similar to `@openzeppelin/contracts`, allowing developers to install and import FeverTokens contracts in their projects.

## Setup Requirements

### 1. NPM Account and Package Access
- Create an npm account at https://www.npmjs.com/signup
- Request access to the `@fevertokens` scope or create it
- Generate an npm access token with publish permissions

### 2. GitHub Repository Configuration
1. Go to your GitHub repository Settings → Secrets and variables → Actions
2. Add a new repository secret:
   - Name: `NPM_TOKEN`
   - Value: Your npm access token

## Publishing Methods

### Method 1: Automated Publishing (Recommended)

Use the GitHub Actions workflow for consistent, automated releases:

1. Navigate to the Actions tab in GitHub
2. Select "Publish Stable Release" workflow
3. Click "Run workflow"
4. Fill in the inputs:
   - **Version**: Semantic version number (e.g., `1.0.0`, `1.2.3`)
   - **Release notes**: Optional description of changes
5. Click "Run workflow"

The workflow automatically:
- ✅ Validates version format
- ✅ Installs dependencies
- ✅ Compiles Solidity contracts
- ✅ Runs linters and format checks
- ✅ Publishes to npm with `--access public`
- ✅ Creates git tag and GitHub release
- ✅ Pushes version bump to main branch

### Method 2: Manual Publishing

For local testing or manual releases:

```bash
# 1. Ensure clean working directory
git status

# 2. Compile contracts
npm run compile

# 3. Run quality checks
npm run lint
npm run format:check

# 4. Test the package locally (optional but recommended)
npm pack
# This creates a .tgz file you can test in another project:
# npm install /path/to/fevertokens-packages-1.0.0.tgz

# 5. Update version (follows semantic versioning)
npm version patch   # 1.0.0 → 1.0.1
npm version minor   # 1.0.0 → 1.1.0
npm version major   # 1.0.0 → 2.0.0
# Or specify exact version:
npm version 1.2.3

# 6. Publish to npm
npm publish --access public

# 7. Push changes and tags
git push origin main --follow-tags
```

## Testing Before Publishing

### Local Package Testing with npm link (Recommended for Development)

Use `npm link` to create a symlink for active development and testing:

```bash
# 1. In the @fevertokens/packages directory, create a global symlink
cd /Users/youssef/Public/project/feverToken/@ft/packages
npm link

# 2. In your test project, link to the package
cd /path/to/your-test-project
npm link @fevertokens/packages

# 3. Now you can import and use the contracts
# Any changes to the contracts will be immediately available
```

**Advantages of npm link:**
- ✅ Changes are reflected immediately (no need to rebuild/repack)
- ✅ Great for active development
- ✅ Easy to set up and tear down
- ✅ Works like the real npm package

**To unlink when done:**
```bash
# In your test project
npm unlink @fevertokens/packages

# In the @fevertokens/packages directory (optional)
npm unlink
```

### Local Package Testing with npm pack (For Final Verification)

Use `npm pack` to test exactly what will be published:

```bash
# 1. In the @fevertokens/packages directory
npm pack

# This creates: fevertokens-packages-0.0.1.tgz

# 2. In a test project, install the tarball
cd /path/to/your-test-project
npm install /Users/youssef/Public/project/feverToken/@ft/packages/fevertokens-packages-0.0.1.tgz

# 3. Test importing contracts
```

**When to use npm pack:**
- ✅ Final verification before publishing
- ✅ Testing the exact published package contents
- ✅ Sharing with others without npm registry

### Test Project Example

```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import "@fevertokens/packages/contracts/token/ERC20/IERC20.sol";
import "@fevertokens/packages/contracts/security/ReentrancyGuard.sol";
import "@fevertokens/packages/contracts/diamond/base/DiamondBase.sol";

contract MyToken is IERC20 {
    // Your implementation
}
```

### Comparison: npm link vs npm pack

| Feature | npm link | npm pack |
|---------|----------|----------|
| **Use case** | Active development | Final testing |
| **Updates** | Instant | Manual repack needed |
| **Setup** | Quick symlink | Install tarball |
| **Accuracy** | Development version | Exact published version |
| **Best for** | Iterative development | Pre-publish verification |

### Dry Run Publishing

Test the publishing process without actually publishing:

```bash
npm publish --dry-run
```

This shows exactly what files will be included in the package.

## Package Configuration

### Files Included in Package
Defined in `package.json` `files` field:
- `/contracts/**/*.sol` - All Solidity contracts
- `/LICENSE` - Apache 2.0 license
- `/README.md` - Package documentation

### Files Excluded from Package
Defined in `.npmignore`:
- Development configuration files
- Build artifacts (cache, artifacts, typechain)
- GitHub workflows and scripts
- Test files
- Node modules
- Local environment files

## Version Management

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes to contract interfaces
- **MINOR** (0.X.0): New features, backward compatible
- **PATCH** (0.0.X): Bug fixes, backward compatible

Example progression:
```
1.0.0 → Initial release
1.0.1 → Bug fix in ReentrancyGuard
1.1.0 → Add new ERC20 extension
2.0.0 → Breaking change to Diamond architecture
```

## Post-Publishing

After successful publishing:

1. **Verify on npm**: https://www.npmjs.com/package/@fevertokens/packages
2. **Test installation**: `npm install @fevertokens/packages`
3. **Update documentation**: Ensure README and examples reflect latest version
4. **Announce release**: Update users about new features/fixes

## Troubleshooting

### "You do not have permission to publish"
- Ensure your npm account has access to `@fevertokens` scope
- Check that `NPM_TOKEN` secret is properly configured
- Verify token has publish permissions

### "Version already exists"
- You cannot republish the same version
- Bump version number: `npm version patch`
- Or unpublish if within 24 hours: `npm unpublish @fevertokens/packages@1.0.0`

### "Compilation errors"
- Fix Solidity compilation issues: `npm run compile`
- Check for syntax errors: `npm run lint:sol`

### "Format check failed"
- Run formatter: `npm run format`
- Verify: `npm run format:check`

## Best Practices

1. **Always test locally** before publishing
2. **Use GitHub Actions** for consistency
3. **Write meaningful release notes**
4. **Follow semantic versioning strictly**
5. **Never publish** with uncommitted changes
6. **Review published files** with `npm pack` or `--dry-run`
7. **Keep CHANGELOG** updated with version history

## Security Considerations

- **Never commit** npm tokens or credentials
- **Use npm tokens** with least required permissions (publish-only)
- **Enable 2FA** on your npm account
- **Review dependencies** before publishing
- **Audit contracts** before major releases

## Resources

- npm documentation: https://docs.npmjs.com/
- Semantic Versioning: https://semver.org/
- Package.json reference: https://docs.npmjs.com/cli/v10/configuring-npm/package-json
