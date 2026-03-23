# Version Release Procedure

This document describes the complete release workflow for plugin-dev.

## Version Files

Version must be synchronized across these files on release:

- `plugins/plugin-dev/.claude-plugin/plugin.json` (source of truth)
- `.claude-plugin/marketplace.json` (metadata.version AND plugins[0].version)
- `CLAUDE.md` (version line)

```bash
# Verify version consistency
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

## Release Steps

### 1. Create Release Branch

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create release branch
git checkout -b release/v0.x.x
```

### 2. Update Version Numbers

Update version in **all version files** (must match):

- `plugins/plugin-dev/.claude-plugin/plugin.json` (source of truth)
- `.claude-plugin/marketplace.json` (metadata.version AND plugins[0].version)
- `CLAUDE.md` (version line)

```bash
# Find current version to replace
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json

# Update all version files, then verify
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

### 3. Update Documentation

- `CHANGELOG.md` - Add release notes following Keep a Changelog format:
  1. Review commits since last release: `git log v0.x.x..HEAD --oneline`
  2. Organize into sections: Added, Changed, Fixed, Security, Performance, Documentation
  3. Group related changes and reference PR numbers
  4. Add version comparison links at bottom of file
- Any other relevant documentation

> **Note**: The README.md version badge updates automatically from GitHub releases.

### 4. Test and Validate

```bash
# Lint markdown files
markdownlint-cli2 '**/*.md'

# Verify version consistency
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md

# Load plugin locally and test
claude --plugin-dir plugins/plugin-dev

# Test skills load correctly by asking trigger questions
# Test workflow commands: /plugin-dev:create-plugin, /plugin-dev:create-marketplace
# Test agents trigger appropriately
```

### 5. Commit and Create PR

```bash
# Commit version bump and documentation updates
git add .
git commit -m "chore: prepare release v0.x.x"

# Push release branch
git push origin release/v0.x.x

# Create pull request
gh pr create --title "chore: prepare release v0.x.x" \
  --body "Version bump to v0.x.x

## Changes
- [List major changes]
- [List bug fixes]
- [List documentation updates]

## Checklist
- [x] Version updated in plugin.json, marketplace.json, CLAUDE.md
- [x] CHANGELOG.md updated with release notes
- [x] Markdownlint passes
- [x] Plugin tested locally
"
```

### 6. Merge and Create Release

After PR review and approval:

```bash
# Merge PR via GitHub UI or:
gh pr merge --squash  # or --merge or --rebase based on preference

# Create GitHub Release (this also creates the tag atomically)
gh release create v0.x.x \
  --target main \
  --title "v0.x.x" \
  --notes-file - <<'EOF'
## Summary

Brief description of the release focus.

## What's Changed

[Copy relevant sections from CHANGELOG.md]

**Full Changelog**: https://github.com/sjnims/plugin-dev/compare/v0.x-1.x...v0.x.x
EOF
```

**Note**: Main branch is protected and requires PRs. All version bumps must go through the release branch workflow. The `--target main` flag ensures the tag is created on the correct commit.

**Publishing**: The entire repository acts as a marketplace. The `plugins/plugin-dev/` directory is the distributable plugin unit.
