# Label Management

This document describes the label system for plugin-dev.

## Files

- **labels.yml**: Source of truth for all repository labels
- **LABELS.md**: This documentation file
- **workflows/sync-labels.yml**: Automated workflow that syncs label definitions on push to main

## Label Categories

### Type Labels

Standard GitHub labels for issue/PR classification:

| Label           | Color                                                    | Description                                |
| --------------- | -------------------------------------------------------- | ------------------------------------------ |
| `bug`           | ![#d73a4a](https://placehold.co/15x15/d73a4a/d73a4a.png) | Something isn't working                    |
| `documentation` | ![#0075ca](https://placehold.co/15x15/0075ca/0075ca.png) | Improvements or additions                  |
| `duplicate`     | ![#cfd3d7](https://placehold.co/15x15/cfd3d7/cfd3d7.png) | Already exists                             |
| `enhancement`   | ![#a2eeef](https://placehold.co/15x15/a2eeef/a2eeef.png) | New feature or request                     |
| `invalid`       | ![#e4e669](https://placehold.co/15x15/e4e669/e4e669.png) | Doesn't seem right                         |
| `question`      | ![#d876e3](https://placehold.co/15x15/d876e3/d876e3.png) | Further information requested              |
| `refactor`      | ![#fef65b](https://placehold.co/15x15/fef65b/fef65b.png) | Code restructuring without behavior change |
| `chore`         | ![#c5def5](https://placehold.co/15x15/c5def5/c5def5.png) | Maintenance tasks                          |
| `wontfix`       | ![#ffffff](https://placehold.co/15x15/ffffff/ffffff.png) | Will not be worked on                      |

### Component Labels

Identify which part of the codebase (cool blue/purple tones):

| Label                   | Color                                                    | Description          |
| ----------------------- | -------------------------------------------------------- | -------------------- |
| `component:agent`       | ![#0052cc](https://placehold.co/15x15/0052cc/0052cc.png) | Agents layer         |
| `component:command`     | ![#5319e7](https://placehold.co/15x15/5319e7/5319e7.png) | Commands layer       |
| `component:docs`        | ![#d4c5f9](https://placehold.co/15x15/d4c5f9/d4c5f9.png) | Documentation files  |
| `component:hook`        | ![#006b75](https://placehold.co/15x15/006b75/006b75.png) | Hooks layer          |
| `component:skill`       | ![#1d76db](https://placehold.co/15x15/1d76db/1d76db.png) | Skills layer         |
| `component:marketplace` | ![#0366d6](https://placehold.co/15x15/0366d6/0366d6.png) | Marketplace manifest |
| `component:mcp`         | ![#032f62](https://placehold.co/15x15/032f62/032f62.png) | MCP integration      |

### Scope Labels

Labels for plugin development concerns (warm coral/pink family):

| Label              | Color                                                    | Description                       |
| ------------------ | -------------------------------------------------------- | --------------------------------- |
| `scope:triggering` | ![#e91e63](https://placehold.co/15x15/e91e63/e91e63.png) | Trigger phrase/description issues |
| `scope:validation` | ![#f44336](https://placehold.co/15x15/f44336/f44336.png) | Plugin validation concerns        |

### Priority Labels

Urgency classification (heat map: hot → cool):

| Label               | Color                                                    | Description                     |
| ------------------- | -------------------------------------------------------- | ------------------------------- |
| `priority:critical` | ![#b60205](https://placehold.co/15x15/b60205/b60205.png) | Blocking, security, or breaking |
| `priority:high`     | ![#d93f0b](https://placehold.co/15x15/d93f0b/d93f0b.png) | Important but not blocking      |
| `priority:medium`   | ![#fbca04](https://placehold.co/15x15/fbca04/fbca04.png) | Should be addressed             |
| `priority:low`      | ![#0e8a16](https://placehold.co/15x15/0e8a16/0e8a16.png) | Nice to have                    |

### Status Labels

Current work state:

| Label                 | Color                                                    | Description              |
| --------------------- | -------------------------------------------------------- | ------------------------ |
| `status:blocked`      | ![#e99695](https://placehold.co/15x15/e99695/e99695.png) | Blocked by dependencies  |
| `status:in-progress`  | ![#90caf9](https://placehold.co/15x15/90caf9/90caf9.png) | Work in progress         |
| `status:needs-repro`  | ![#f9c4f4](https://placehold.co/15x15/f9c4f4/f9c4f4.png) | Needs reproduction steps |
| `status:needs-review` | ![#fff3b3](https://placehold.co/15x15/fff3b3/fff3b3.png) | Ready for review         |
| `status:needs-design` | ![#c5cae9](https://placehold.co/15x15/c5cae9/c5cae9.png) | Needs design decision    |
| `status:analyzed`     | ![#a5d6a7](https://placehold.co/15x15/a5d6a7/a5d6a7.png) | Analyzed by Claude       |
| `needs-analysis`      | ![#b39ddb](https://placehold.co/15x15/b39ddb/b39ddb.png) | Request Claude analysis  |

### Effort Labels

Time estimates:

| Label           | Color                                                    | Description |
| --------------- | -------------------------------------------------------- | ----------- |
| `effort:small`  | ![#c2e0c6](https://placehold.co/15x15/c2e0c6/c2e0c6.png) | < 1 hour    |
| `effort:medium` | ![#bfdadc](https://placehold.co/15x15/bfdadc/bfdadc.png) | 1-4 hours   |
| `effort:large`  | ![#f9d0c4](https://placehold.co/15x15/f9d0c4/f9d0c4.png) | > 4 hours   |

### Community Labels

| Label              | Color                                                    | Description                |
| ------------------ | -------------------------------------------------------- | -------------------------- |
| `good first issue` | ![#7057ff](https://placehold.co/15x15/7057ff/7057ff.png) | Good for newcomers         |
| `help wanted`      | ![#008672](https://placehold.co/15x15/008672/008672.png) | Extra attention needed     |
| `idea`             | ![#f9a825](https://placehold.co/15x15/f9a825/f9a825.png) | Feature idea or suggestion |
| `showcase`         | ![#6f42c1](https://placehold.co/15x15/6f42c1/6f42c1.png) | Community showcase         |

### Dependency Labels

| Label            | Color                                                    | Description            |
| ---------------- | -------------------------------------------------------- | ---------------------- |
| `dependencies`   | ![#0366d6](https://placehold.co/15x15/0366d6/0366d6.png) | Dependency updates     |
| `github-actions` | ![#000000](https://placehold.co/15x15/000000/000000.png) | GitHub Actions updates |

### Category Labels

Type of change:

| Label          | Color                                                    | Description                     |
| -------------- | -------------------------------------------------------- | ------------------------------- |
| `breaking`     | ![#bd2130](https://placehold.co/15x15/bd2130/bd2130.png) | Breaking change (major version) |
| `automation`   | ![#28a745](https://placehold.co/15x15/28a745/28a745.png) | CI/CD and workflow improvements |
| `optimization` | ![#2188ff](https://placehold.co/15x15/2188ff/2188ff.png) | Performance improvements        |

### Workflow Labels

| Label     | Color                                                    | Description            |
| --------- | -------------------------------------------------------- | ---------------------- |
| `triage`  | ![#ededed](https://placehold.co/15x15/ededed/ededed.png) | Needs initial review   |
| `stale`   | ![#ededed](https://placehold.co/15x15/ededed/ededed.png) | No recent activity     |
| `pinned`  | ![#fef2c0](https://placehold.co/15x15/fef2c0/fef2c0.png) | Never mark as stale    |
| `roadmap` | ![#0e8a16](https://placehold.co/15x15/0e8a16/0e8a16.png) | Long-term roadmap item |

### Special Labels

| Label        | Color                                                    | Description               |
| ------------ | -------------------------------------------------------- | ------------------------- |
| `experiment` | ![#ff6ec7](https://placehold.co/15x15/ff6ec7/ff6ec7.png) | Experimental/testing      |
| `security`   | ![#ee0701](https://placehold.co/15x15/ee0701/ee0701.png) | Security-related          |
| `reverted`   | ![#666666](https://placehold.co/15x15/666666/666666.png) | Merged but later reverted |

## Label Application Guidelines

### Required Labels

Every issue and PR should have:

1. **One type label**: bug, enhancement, documentation, refactor, chore, etc.
2. **One priority label**: priority:critical, priority:high, priority:medium, priority:low
3. **One effort label**: effort:small, effort:medium, effort:large

### Contextual Labels

Apply when relevant:

- **Component labels**: When the change affects specific plugin components
- **Scope labels**: When the change affects triggering or validation
- **Status labels**: To track work progress
- **Category labels**: For breaking changes, automation, or optimization work
- **Community labels**: For contributor-friendly issues

### Label Combinations

Common label combinations for plugin-dev:

| Scenario                    | Labels                                            |
| --------------------------- | ------------------------------------------------- |
| Skill not triggering        | `bug`, `component:skill`, `scope:triggering`      |
| New agent feature           | `enhancement`, `component:agent`, `priority:*`    |
| Marketplace manifest issue  | `bug`, `component:marketplace`, `priority:*`      |
| Validation script fix       | `bug`, `component:docs`, `automation`             |
| MCP integration enhancement | `enhancement`, `component:mcp`, `effort:*`        |
| Hook development docs       | `documentation`, `component:hook`, `effort:small` |
| Command triggering bug      | `bug`, `component:command`, `scope:triggering`    |
| Plugin architecture design  | `enhancement`, `status:needs-design`, `roadmap`   |
| Dependabot PR               | `chore`, `dependencies`, `effort:small`           |

## Managing Labels

### Adding a New Label

1. **Update labels.yml** (source of truth):

   ```yaml
   - name: "new-label"
     color: "ff6ec7"
     description: "Description here"
   ```

2. **Update LABELS.md** with the new label documentation

3. **Create a PR** - the workflow runs in dry-run mode to preview

4. **Merge to main** - the label is created automatically

### Updating a Label

1. **Update labels.yml** with new color/description
2. **Update LABELS.md** documentation
3. **Create a PR** - preview changes in dry-run mode
4. **Merge to main** - changes applied automatically

### Deleting a Label

Deleting labels requires manual action - the automated workflow only creates and updates labels (never deletes) for safety.

1. **Remove from labels.yml**
2. **Remove from LABELS.md**
3. **Delete from GitHub manually**:

   ```bash
   gh label delete "label-name" --yes
   ```

## Color Scheme Rationale

| Category  | Color Family           | Rationale                                    |
| --------- | ---------------------- | -------------------------------------------- |
| Type      | GitHub defaults        | Familiar to all GitHub users                 |
| Component | Cool blues/purples     | Technical, structural feel                   |
| Scope     | Warm coral/pink        | Distinct from components, user-facing issues |
| Priority  | Heat map (red → green) | Intuitive urgency indication                 |
| Status    | Soft pastels           | Non-distracting state indicators             |
| Effort    | Green → red gradient   | Easy (green) to hard (red)                   |
| Category  | Semantic colors        | Breaking=red, automation=green               |
| Workflow  | Neutral greys          | Background process labels                    |

## Label Naming Conventions

- **Prefixed labels**: Use colons for categories (`component:`, `scope:`, `priority:`, `status:`, `effort:`)
- **Standard labels**: Keep GitHub defaults as-is (`bug`, `help wanted`, `good first issue`)
- **Multi-word labels**: Use hyphens for custom labels, keep spaces for GitHub ecosystem compatibility
- **Case**: All lowercase

## Label Count

Current total: **~49 labels**

Balanced for good organization without overwhelming contributors. Check `labels.yml` for the complete list.
