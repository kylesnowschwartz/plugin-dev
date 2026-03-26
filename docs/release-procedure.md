# Version Release Procedure

This document describes the release workflow for plugin-dev.

## How Distribution Works

This repo is a plugin marketplace. Users install by pointing Claude Code at
the git repo — it clones `main` and reads `marketplace.json`. No GitHub
releases, tags, or release branches needed. Push to `main` and users get the
update on next plugin refresh.

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

### 1. Update Version Numbers

Update version in **all version files** (must match):

```bash
# Find current version to replace
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json

# Update all version files, then verify
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

### 2. Update CHANGELOG.md

Add release notes following Keep a Changelog format:

1. Review commits since last release: `git log --oneline` (find previous version bump)
2. Organize into sections: Added, Changed, Fixed
3. Group related changes

### 3. Lint and Verify

```bash
# Lint markdown files
markdownlint '**/*.md' --ignore node_modules

# Verify version consistency
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

### 4. Commit and Push

```bash
git add -u
git commit -m "feat: release v0.x.x

Brief description of changes."

git push
```

Users receive the update on next plugin refresh or reinstall.
