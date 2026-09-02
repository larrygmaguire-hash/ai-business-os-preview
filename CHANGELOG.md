# Changelog

All notable changes to AI Business OS engine files are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.4.1] — 2026-08-17

Fixes the two silent-data-loss paths in `/update` (17 August Business OS audit, finding 6).

### Fixed

- **`/update` no longer discards client settings.** `.claude/settings.json` is classified `critical` and was replaced wholesale on every update — losing the permissions Claude Code itself records when the user approves tools, and any hooks the client had added, with no warning. It now gets a structured merge: engine entries and client additions are combined (union per `permissions.*` and `hooks.*` array, client values win on other keys), so engine updates ship new hooks and permissions without destroying client state. If either side is invalid JSON the file is overwritten with a loud warning, and the client's copy is in the per-update backup.
- **First update on a customised workspace no longer overwrites silently.** With no backup directory there is no merge base, and locally modified files fell through to the clean-copy branch — overwritten unmerged, unreported. They are now classified and displayed as their own category ("no merge base"), listed in the preview and again after apply with the backup path for recovery. Fixed in both the engine phase and the PRIMA phase.

### Changed

- `.claude/rules/engine-protection.md` — documents the `settings.json` structured-merge exception to Tier 1 and the first-update no-merge-base behaviour.
- `README.md` — the "edits are preserved across engine updates" claim now states the first-update exception instead of overpromising.
- `.claude/engine-manifest.json` — `engineVersion` bumped to 2.4.1; `.claude/suite-registry.json` `host.version` updated.

---

## [2.4.0] — 2026-08-17

### Added

- `AGENTS.md` (workspace root) — universal entry point for non-Claude agents (Codex, Cursor, Gemini CLI, Copilot coding agent), which auto-load `AGENTS.md` rather than `CLAUDE.md`. Carries the agent-agnostic doctrine, mandatory pre-action reads, state-write discipline, and a location table. Pointers only — `CLAUDE.md` remains canonical.
- `.claude/docs/agent-agnostic-design.md` — the five design rules that keep workspaces vendor-independent (plain-JSON state via bash + jq, runnable markdown procedures, rules in text not only in hooks, no vendor-specific copies, no vendor-specific formats), the two-door entry-point architecture, and the per-project stub template.
- `Infrastructure/Scripts/backfill-project-agents-stubs.sh` — writes an `AGENTS.md` pointer stub into every project/client folder that has a `CLAUDE.md` but no stub. Supports `--dry-run`. Skips `.claude/`, `.git/`, and `Archive/`.
- `PHILOSOPHY.md` — new "Agent-agnostic by design" entry under Part Five, Design Rationale.

### Changed

- `.claude/engine-manifest.json` — the three new files added to `engineFiles` so they propagate to existing workspaces via `/update`. `engineVersion` bumped to 2.4.0; `.claude/suite-registry.json` `host.version` and `README.md` reference updated.

---

## [2.3.1] — 2026-07-17

### Fixed

- Windows Git Bash support in `Infrastructure/Scripts/update-engine.sh` — three defects found and verified on a Windows 10 client workspace (native WinGet jq, Git Bash):
  - **CRLF-safe jq output.** Native Windows jq builds terminate every output line with `\r\n`; the trailing `\r` survives bash's `read` and contaminates every filename, so `git show upstream/main:<file>` fails silently and the dry run under-reports the delta (e.g. "1 file to update" when the true delta is ~81 files). A `--force` apply in that state would write to `\r`-suffixed filenames, which are illegal on Windows — a no-op disguised as a successful update. Fixed with a single shadow function (`jq() { command jq "$@" | tr -d '\r'; }`) covering all current and future jq call sites.
  - **MSYS path-conversion opt-out.** Git Bash rewrites `remote/branch:path` arguments into Windows path syntax before git sees them, crashing the script (exit 128) at "Fetching upstream...". Fixed by exporting `MSYS_NO_PATHCONV=1` and `MSYS2_ARG_CONV_EXCL='*'` at the top of the script. Both are no-ops on macOS/Linux.
  - **HTTPS remotes.** Missing `upstream` / `prima-upstream` remotes were added as `git@github.com:` SSH URLs, which fail on client machines without SSH keys (`Permission denied (publickey)`). New remotes are now added over HTTPS, and an existing SSH URL for either remote is switched to HTTPS automatically.

### Changed

- `.claude/engine-manifest.json` — `engineVersion` bumped to 2.3.1.
- `.claude/suite-registry.json` — `host.version` bumped to 2.3.1.
- `README.md` — version reference updated to v2.3.1.

**Note for existing Windows workspaces:** the broken script cannot fetch its own fix. Run once from the workspace root:
`git fetch upstream && MSYS_NO_PATHCONV=1 git show upstream/main:Infrastructure/Scripts/update-engine.sh > Infrastructure/Scripts/update-engine.sh`
then run `/update` normally.

---

## [2.3.0] — 2026-06-09

### Added

- `.claude/rules/decomposition.md` — new auto-loaded rule giving a four-way decision framework (tool inline / script / skill / subagent) for deciding what *kind* of thing a reusable capability or non-trivial task should be. Includes smell tests (loop over 3+ items → script; "always do X before Y" → skill; independent context-bloating work → subagent; one-fact output → inline) so Claude picks the cheapest shape that fits before building. Adapted from Anthropic's "Code with Claude" agent-decomposition workshop, generalised for non-developer business workspaces.

### Changed

- `.claude/engine-manifest.json` — `engineVersion` bumped to 2.3.0; `decomposition.md` added to `engineFiles` so it propagates to existing workspaces via `/update`.
- `.claude/suite-registry.json` — `host.version` bumped to 2.3.0.
- `README.md` — version reference updated to v2.3.0.

---

## [2.2.0] — 2026-05-21

### Added

- `.claude/commands/migrate-company.md` — slash command that converts the legacy monolithic `CLIENT_PROFILE.md` into the six modular files under `.claude/company/`. Auto-splits content using a canonical section-to-file mapping, then walks the user through any thin areas (typically `voice.md` and `brand.md`).
- `Infrastructure/Scripts/migrate-company.sh` — bash helper that handles the mechanical part of the migration: detects state, archives the legacy file to `.claude/engine-backups/company-migration/`, scaffolds empty target files, and writes a migration manifest. Supports `--check` and `--rollback` modes. Idempotent and safe to re-run.

### Changed

- `Infrastructure/Scripts/update-engine.sh` — after a successful engine update, detects orphan `CLIENT_PROFILE.md` (at workspace root or under `.claude/`) and prints the two-step instruction to run the migration. Existing v1.x workspaces upgrading via `/update` are nudged toward `/migrate-company` rather than left with a stale monolithic profile.
- `.claude/engine-manifest.json` — `engineVersion` bumped to 2.2.0; new files added to `engineFiles` so they propagate to existing workspaces via `/update`.
- `.claude/suite-registry.json` — `host.version` bumped to 2.2.0 (previously 2.0.0, had not been kept in sync with engine-manifest).
- `README.md` — version reference updated to v2.2.0.

---

## [2.1.0] — 2026-05-21

### Added

- `.claude/rules/no-permission-prompts.md` — rule clarifying that explicit user instructions are pre-authorised; no further confirmation needed for internal workspace actions

### Changed

- `.claude/commands/resume.md` — updated to support optional HH:MM time argument for checkpoint refinement (mirrors PRIMA Plugin v1.3.0)
- `.claude/commands/save.md` — updated to align with task-enforcement reconciliation flow
- `.claude/suite-registry.json` — PRIMA Plugin bumped 1.2.1 → 1.3.0; PRIMA Dashboard rewritten from prototype/standalone-app to released/file-copy (HTML-based, version 1.1.0)
- `README.md` — version badge updated to v2.1.0

---

## [2.0.0] — 2026-04-10

### Added

- **7 new skills:** copywriting (with 12 reference files), creating-presentations, processing-spreadsheets, processing-documents, documenting-workflows, search-engine-optimisation (with technical SEO checklist), email-drafting
- **Suite registry:** `.claude/suite-registry.json` — authoritative JSON registry of all PRIMA ecosystem components with versions, dependencies, and install methods
- **Engine guard hook:** `Infrastructure/Scripts/engine-guard.sh` — PreToolUse hook blocking edits to critical engine files at the tool level
- **Safety guard hook:** `Infrastructure/Scripts/safety-guard.sh` — PreToolUse hook blocking dangerous operations (rm -rf, force push, sudo, remote code execution, global package installs, global git config)
- **Modular company knowledge:** `.claude/company/` directory with 6 files (overview, team, audiences, voice, brand, industry) replacing the monolithic CLIENT_PROFILE.md
- **userCustomisable manifest tier:** new array in engine-manifest.json listing files users can edit freely with three-way merge on update
- **PRIMA Ecosystem table** in README.md listing all 5 PRIMA components
- Hooks registered in `.claude/settings.json` (PreToolUse for Edit/Write/MultiEdit and Bash)

### Changed

- **BREAKING:** `CLIENT_PROFILE.md` removed — replaced by `.claude/company/` directory. Existing users must migrate their company context to the new modular files.
- **BREAKING:** CLAUDE.md placeholders changed from `[CLIENT_NAME]` to `[COMPANY_NAME]`, `[clientname]` to `[companyname]`, `[CLIENT_CLOUD_PATH]` to `[CLOUD_STORAGE_PATH]`
- `engine-protection.md` rewritten with three-tier classification (critical, customisable, standard)
- `FRAMEWORK.md` updated for company directory structure
- `ROADMAP.md` expanded to cover full PRIMA ecosystem with status column on cross-product dependencies
- `README.md` PRIMA sections consolidated into single ecosystem table
- All skill context source tables updated to reference `.claude/company/` files
- `getting-started.md` and `update.md` — "Client files" renamed to "Your files"
- `integrations.json` comments updated from deployer language to self-setup language
- `on-page-seo.md` moved from copywriting references to search-engine-optimisation references
- `setup.md` updated to walk through modular company files during initial setup

### Fixed

- Duplicate `.claude/skills/processing-pdfs/SKILL.md` entry in engineFiles array
- False tool references in ROADMAP.md cross-product table now marked as "Planned"

### Removed

- `.claude/CLIENT_PROFILE.md` (replaced by `.claude/company/` directory)

## [1.9.3] — 2026-03-17

### Changed

- Updated `.claude/commands/newclient.md`

## [1.9.2] — 2026-03-17

### Changed

- Updated `.gitignore`

## [1.9.1] — 2026-03-13

### Fixed

- `update-engine.sh`: empty bash arrays crash under `set -u` strict mode — guarded all 16 array expansions with `${arr[@]+"${arr[@]}"}` idiom

## [1.9.0] — 2026-03-11

### Added

- `.claude/docs/cloud-sync-warning.md`

### Changed

- Updated `.claude/docs/getting-started.md`

## [1.8.0] — 2026-03-11

### Added

- `.claude/commands/save.md`

## [1.7.1] — 2026-02-28

### Changed

- Updated `.claude/docs/getting-started.md`
- Updated `README.md`

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
