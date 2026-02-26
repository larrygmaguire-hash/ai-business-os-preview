# AI Business OS

**Engine version:** v1.5.3

A ready-made Claude Code workspace for non-technical businesses. Provides folder structure, commands, skills, rules, and documentation so you can start using Claude Code productively from day one.

## Quick Start

1. Click **"Use this template"** on GitHub to create your own copy
2. Clone your new repository
3. Open it in VS Code with Claude Code installed
4. Run `/setup` to personalise your workspace
5. Run `/day` to start your first session

## What's Included

### Folder Structure
```
your-biz-os/
├── Projects/          Active work, workflows, and archive
├── Documentation/     Templates and reports
├── Infrastructure/    Scripts and automation
└── Clients/           Client/customer folders
```

### Commands
| Command | Purpose |
|---------|---------|
| `/setup` | First-time personalisation wizard |
| `/day` | Morning briefing — sync, scan projects, suggest priorities |
| `/night` | End-of-session — summarise work, commit, push |
| `/status` | Overview of all projects and recent activity |
| `/sync` | Quick commit and push |
| `/newproject` | Create a new project folder |
| `/newclient` | Create a new client folder |
| `/update` | Check for and apply engine updates |

### Skills
- **Drafting documents** — proposals, reports, briefs, memos
- **Meeting notes** — structured summaries from meeting content
- **Processing PDFs** — extract, merge, split with automatic large-file handling (5-level scale)
- **Client setup** — new client onboarding
- **Status reports** — workspace activity summaries
- **Creating skills** — build your own custom skills

### Rules
- Blocked commands (destructive action safeguards)
- Content defaults (language, tone, formality)
- File conventions (placement and naming)
- Autonomy levels (when Claude acts vs asks)
- Checkpoint protocol (standardised approval points)

## Project Tracking

AI Business OS includes lightweight project tracking out of the box — project IDs, status values, a `state.json` file, and `/day`, `/night`, `/status` commands that read and update project state.

### Upgrade: PRIMA Plugin

[PRIMA](https://github.com/larrygmaguire-hash/prima-plugin) (Project Recording, Indexing, Memory Agent) upgrades the built-in tracking with:

- Session memory — where you stopped, what you did last, searchable history
- Automatic checkpoints — structured progress snapshots written silently to disk
- Enhanced `/day`, `/night`, `/status` with priority routing, overdue detection, and recommended actions
- `/resume` command — pick up exactly where you left off
- Duplicate detection — prevents accidental project duplication
- Richer state management — priorities, pending items, session history with project cross-references

The base commands work without PRIMA. PRIMA replaces them with fuller versions.

## Optional: Session Memory (Prima Memory)

Install [Prima Memory](https://github.com/larrygmaguire-hash/prima-memory) for conversation history search:

```bash
git clone https://github.com/larrygmaguire-hash/prima-memory.git ~/.prima-memory
cd ~/.prima-memory && npm install && npm run build
```

Then add to `~/.claude.json`:
```json
{
  "mcpServers": {
    "prima-memory": {
      "type": "stdio",
      "command": "node",
      "args": ["~/.prima-memory/dist/index.js"]
    }
  }
}
```

This gives Claude searchable access to past sessions — useful for recalling decisions, tracking file changes, and maintaining continuity across sessions. Prima Memory supersedes claude-mems, looking upstream to the original for updates.

## Updating

AI Business OS separates **engine files** (rules, skills, commands, scripts) from **client files** (your CLAUDE.md, state, configuration). Engine updates never touch your customisations.

An `engine-manifest.json` lists every file owned by the template. Only files in the manifest are updated — your custom skills, projects, client data, and configuration are never touched. Backups are saved before every update and can be rolled back.

### How updates are delivered

There are two models depending on your arrangement:

**Managed workspaces** — Larry maintains your workspace on your behalf. He clones your repository, applies engine updates, and pushes the changes. You receive updates automatically the next time you pull or start a session. No action required on your part.

**Self-service workspaces** — You manage your own updates. Run `/update` in Claude Code to check for new engine versions and apply them. Your repository needs read access to the upstream template (configured automatically on first run).

### Running updates yourself

To check for and apply updates:

```
/update
```

Or from the terminal:

```bash
bash Infrastructure/Scripts/update-engine.sh
```

| Flag | Purpose |
|------|---------|
| `--dry-run` | Preview changes without applying |
| `--rollback` | Restore the previous engine version |
| `--force` | Apply without confirmation prompt |

## Requirements

- [VS Code](https://code.visualstudio.com/)
- [Claude Code](https://claude.com/claude-code) (VS Code extension)
- Git
- A GitHub account (for template cloning and sync)

## Documentation

Full documentation is in `.claude/docs/`:
- [Getting Started](.claude/docs/getting-started.md)
- [Folder Structure](.claude/docs/folder-structure.md)
- [Available Automations](.claude/docs/available-automations.md)
- [Capabilities Reference](.claude/docs/capabilities-reference.md)
- [Glossary](.claude/docs/glossary.md)

## Licence

Copyright Larry G. Maguire / Human Performance. All rights reserved.

This software is provided under a proprietary licence. Unauthorised copying, distribution, or modification is not permitted without a valid licence. Contact hello@humanperformance.ie for licensing enquiries.

## Author

Larry G. Maguire — [Human Performance](https://humanperformance.ie)
