# Changelog

All notable changes to AI Business OS engine files are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.7.0] — 2026-02-28

### Added

- Engine Protection system — six-layer protection for critical engine files
- `critical` array in `engine-manifest.json` — machine-readable list of files essential to AI Business OS operation
- `.claude/rules/engine-protection.md` — Claude rule preventing modification of critical files, directing users to create companion files instead
- `ENGINE CRITICAL` markers on all critical files (FRAMEWORK.md, autonomy-levels, blocked-commands, checkpoint-protocol, settings.json, update script, pre-commit hook, install script)
- Pre-commit hook now warns (client repos) or informs (template repo) when critical files are staged for commit
- Engine health check in `/status` — compares critical file hashes against last backup to detect drift
- Three-way merge for non-critical engine files during `/update` — preserves client modifications alongside upstream changes
- File Ownership and Engine Protection section in getting-started.md
- PRIMA Plugin updates integrated into `/update` — single command now checks and applies both engine and PRIMA updates via `prima-upstream` remote
- `.claude/prima-manifest.json` added to `primaManaged[]` in engine manifest — engine updates skip this file
- PRIMA dry-run preview in `--dry-run` mode — shows PRIMA file changes alongside engine changes
- Windows/WSL requirements section in getting-started.md and README.md

### Changed

- `update-engine.sh` — critical files always overwrite; non-critical files with local modifications are merged via `git merge-file`; conflict files are flagged for manual resolution; PRIMA update phase runs after engine phase using `prima-upstream` remote
- `update.md` command — describes combined engine + PRIMA update flow, PRIMA SSH error handling
- `pre-commit-hook.sh` — added critical file detection with interactive confirmation for client repos
- `install-hooks.sh` — now works for both template and client repos (critical file protection for clients, full manifest management for template)
- `status-report` skill — now includes engine health check section

## [1.6.1] — 2026-02-27

### Changed

- Updated `.claude/commands/newclient.md`
- Updated `Infrastructure/Scripts/prima/validate-state.sh`

## [1.6.0] — 2026-02-27

### Added

- `Finance/CLAUDE.md`
- `Legal/CLAUDE.md`
- `Marketing/CLAUDE.md`
- `Operations/CLAUDE.md`
- `Products/CLAUDE.md`
- `Sales/CLAUDE.md`

### Changed

- Updated `.claude/docs/folder-structure.md`
- Updated `.claude/rules/file-conventions.md`
- Updated `README.md`

## [1.5.5] — 2026-02-27

### Changed

- Updated `.claude/docs/getting-started.md`
- Updated `.gitignore`
- Updated `README.md`

## [1.5.4] — 2026-02-26

### Changed

- Updated `README.md`

## [1.5.3] — 2026-02-26

### Changed

- Updated `README.md`

## [1.5.2] — 2026-02-26

### Changed

- `/newproject` — added Step 3 (Rules and Skills) to the project creation wizard. Users are now prompted to associate project-specific rules and skills during setup. Existing files are detected automatically; new ones are flagged for creation at completion.
- CLAUDE.md template updated — `## Rules` and `## Skills` sections now use tables showing file path and existence status when items are added
- Engine manifest: registered `/timeline` as PRIMA-managed (file provided by PRIMA Plugin, not the engine)

---

## [1.5.0] — 2026-02-25

### Added

- `processing-pdfs` skill — extract text, merge, split, fill forms, and annotate PDF files
- 5-level PDF Processing Scale (Trivial → Massive) with mandatory size/page check before reading any PDF
- Chunked reading, `qpdf` splitting, and parallel agent workflows for large files (Scale 3+)
- Bulk Extract-Summarise-Release workflow for processing multiple PDFs without context overflow
- PDF form filling with annotation-based and fillable field approaches
- `.claude/rules/pdf-scale.md`
- `.claude/skills/processing-pdfs/references/forms.md`
- `.claude/skills/processing-pdfs/references/reference.md`
- `.claude/skills/processing-pdfs/references/workflows.md`
- `.claude/skills/processing-pdfs/scripts/` — 8 utility scripts for form filling and validation

### Changed

- Updated `.claude/FRAMEWORK.md`
- Updated `Infrastructure/Scripts/prima/backup-state.sh`
- Updated `Infrastructure/Scripts/prima/validate-state.sh`
- Updated `README.md`

## [1.3.0] — 2026-02-24

### Added

- `.claude/commands/install-pack.md`

### Changed

- Updated `.claude/docs/available-automations.md`
- Updated `.claude/docs/getting-started.md`

## [1.2.0] — 2026-02-24

### Added

- `/install-pack` command — browse, select, and install extension packs from within Claude Code
- Extension Packs section in getting-started.md and available-automations.md
- Pack catalogue browsing via GitHub fetch when no path argument is provided

## [1.1.1] — 2026-02-23

### Changed

- Pre-commit hook now auto-updates the version badge in README.md

## [1.1.0] — 2026-02-23

### Added

- Pre-commit hook for automatic manifest management (`Infrastructure/Scripts/pre-commit-hook.sh`)
- Hook installer script (`Infrastructure/Scripts/install-hooks.sh`)
- New engine files are auto-detected and added to the manifest on commit
- Version bumps automatically: minor for new files, patch for modifications
- Interactive changelog prompt (1 = approve, 2 = edit, 3 = skip)

## [1.0.0] — 2026-02-23

### Added

- Engine update system: `engine-manifest.json`, `update-engine.sh`, `/update` command
- CHANGELOG.md for tracking engine versions
- `/status` now displays engine version
- Automated backup before each engine update (`.claude/engine-backups/`)
- Dry-run and rollback support for safe updates
- PRIMA detection — skips PRIMA-managed files when PRIMA Plugin is installed

### How It Works

Engine files (rules, skills, commands, agents, docs, scripts) are listed in `.claude/engine-manifest.json`. Running `/update` or `Infrastructure/Scripts/update-engine.sh` fetches the latest versions from the upstream template and applies them. Client files (CLAUDE.md, state.json, integrations.json) are never touched.
