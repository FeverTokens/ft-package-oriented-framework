# Quick Release Guide

## ✅ Publish Stable Release

1. Go to **Actions** → **Publish Stable Release**
2. Click **Run workflow**
3. Enter:
   - **Version**: `X.Y.Z` (e.g., `0.1.0`, `1.0.0`)
   - **Release notes**: Optional markdown
4. Click **Run workflow**

**Result:** Published to npm with `@latest` tag

**Install:**

```bash
npm install -g @fevertokens/packages
```

---

## 📋 Required Setup (One-time)

### 1. Add NPM_TOKEN Secret

1. Generate npm token: https://www.npmjs.com/settings/YOUR_USERNAME/tokens
   - Type: **Automation**
   - Scope: **Read and write**
2. Go to GitHub: **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `NPM_TOKEN`
5. Value: Paste your token
6. Click **Add secret**

### 2. Verify Permissions

- npm account must have publish access to `@fevertokens/packages`
- GitHub Actions must have write permissions (Settings → Actions → General)

---

## 📦 Version Examples

### Semantic Versioning

- **Patch**: `0.0.14` → `0.0.15` (bug fixes)
- **Minor**: `0.0.15` → `0.1.0` (new features)
- **Major**: `0.1.0` → `1.0.0` (breaking changes)

---

## ⚡ Quick Commands

```bash
# Install latest stable
npm install -g @fevertokens/packages

# Install specific version
npm install -g @fevertokens/packages@0.1.0

# Check version
fever --version

# View available versions
npm view @fevertokens/packages versions
```
