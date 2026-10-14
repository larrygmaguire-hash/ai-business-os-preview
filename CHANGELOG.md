# Changelog

All notable changes to AI Business OS engine files are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [3.0.1] — 2026-10-14

Documentation and command fixes. Nothing changes in how an existing workspace is laid out.

### Added

- **`LICENSE` file.** The GenAI Skills Academy Software Licence now ships at the repository root and in the engine manifest, so `/update` delivers it; `package.json`-style pointers in the PRIMA products reference the same text. The README Licence section links it.
- **Platforms and Support section in the README.** macOS is the tested platform; Windows may work through WSL or Git Bash but is not directly supported; no outcome is guaranteed on any operating system; support is purchased separately; contact larry@genaiskills.io.

### Fixed

- **Command tables complete.** `README.md`, `getting-started.md`, `available-automations.md` and the `FRAMEWORK.md` command table now list every command that ships in `.claude/commands/`, adding `/resume`, `/dashboard` and `/migrate-company` (and, in `FRAMEWORK.md`, `/save`, `/status`, `/update` and `/install-pack`).
- **Dangling rule references.** `/migrate-company` cited `.claude/rules/communication.md` and the `creating-skills` skill cited `.claude/rules/plugin-development.md`; neither file exists. `/migrate-company` now states the one-question-at-a-time instruction in full, and `creating-skills` points to its own `references/skills-standard.md`.
- **Project numbering.** `getting-started.md` said `/setup` lets you choose a numbering format and `folder-structure.md` said the format can be customised. `/setup` states the format is fixed at `P001` and the state schema enforces `^P\d{3}$`, so both documents now say the format is fixed in the base engine and custom formats come with PRIMA Project Management. `/newproject` still built the ID from `projectNumbering` in `integrations.json`, whose comment invited the user to change the format, and the schema had rejected custom formats since March although `/setup` had offered them before then.
- **Project numbering comes from the project register.** `/newproject` now reads the IDs already in `state.json` before generating one. A new workspace starts at `P001`; a workspace that already uses another format (for example `PRJ-0001`) continues that format. Existing IDs are never changed, a second format is never introduced, and if the register already holds two formats `/newproject` stops and asks which one to use. The next number is the highest existing number plus one, and IDs are never reused. The state schema accepts the custom formats it accepted before March again, so an existing custom register cannot fail validation after an update. Both validators warn (without failing) when a register mixes formats. A re-run of `/setup` keeps existing numbering. `integrations.json`, `getting-started.md` and `folder-structure.md` describe this.
- **Windows and Git Bash.** `getting-started.md` said Git Bash is not supported, while `update-engine.sh` carries the Git Bash fixes from 2.3.1. The page now says WSL is the supported environment, that the update script also runs under Git Bash, and that the other scripts have not been tested there.
- **Engine health in `/status`.** `getting-started.md` and `engine-protection.md` say `/status` reports engine health, but `status.md` printed only the engine version. `/status` now runs the Engine Health Check and adds an Engine Health section to the report.
- **Engine Health Check baseline.** The check as documented compared critical files with the latest `.claude/engine-backups/` folder, which holds the pre-update copies, so after a normal update it would flag every critical file the update changed. A new read-only mode, `update-engine.sh --health`, compares each critical file with the upstream copy at the version the workspace runs, accepting any upstream commit that carries that version. `settings.json` passes while it holds every engine permission and hook, since `/update` merges it. Line-ending differences are ignored. `/status`, the `status-report` skill and `engine-protection.md` now call the script.
- **No warning before editing engine files.** `engine-protection.md` said users should know what happens to their edits on update but gave Claude no instruction to tell them. Claude now says, before editing any engine file, whether the change is blocked or merged on update with possible conflicts. The Tier 2 merge description names the upstream copy as the base.
- **Base workspaces now receive fixes to the PRIMA-managed commands.** `/day`, `/night`, `/setup`, `/status`, `/sync`, `/newproject`, `/resume`, `/dashboard`, `state-validation.md`, `state.schema.json`, `Scripts/backup-state.sh` and `Scripts/validate-state.sh` ship in the base engine but were listed only as PRIMA-managed, so `/update` never changed them in a workspace without PRIMA Project Management: fixes reached new installs only. They are now engine files, delivered by three-way merge so user edits are kept. With PRIMA Project Management installed they are still skipped and PRIMA's update manages them. The pre-update backup now also covers files the new version adds to the engine list.
- **Install instructions point to the purchase email.** The README Quick Start told buyers to use the GitHub template, and the README and `getting-started.md` told them to clone PRIMA Memory from GitHub into the workspace, a method retired on 17 August 2026. Buyers install from the install prompt in their purchase email, which has Claude clone from `git.genaiskills.io` with their key; the README, `getting-started.md` and the suite registry now say so. The registry no longer names `/install-pack` for PRIMA Project Management, which has no `PACK.md`. "Prima Memory" corrected to "PRIMA Memory".
- **One migration result for `CLIENT_PROFILE.md`.** `/setup` renamed the old profile to `CLIENT_PROFILE.backup.md` and left it beside the company files, while `/migrate-company` archived it. The company folder takes precedence, so both routes now archive the old profile, and any company file the migration overwrites, to `.claude/engine-backups/company-migration/`.
- **Undoing an update.** `/update` told the user to "run /update with --rollback flag", but the command had no rollback step. `/update rollback` (or asking Claude to undo the update) now runs the rollback, reports what was restored and commits it; users working in a terminal are also given the script command, and the script's closing message names both. The rollback now restores every file in the backup rather than the files listed in the old version's manifest, which would have missed files a newer version added to the engine list.
- **False merge conflicts on files the user never edited.** The merge base was the upstream commit that bumped the version, but a workspace may hold a copy from a later commit at the same version, so unedited lines looked like user edits and could conflict (seen on `CHANGELOG.md`). The base is now chosen per file from every upstream commit carrying the workspace's version: an exact match counts as unedited, otherwise the closest copy is used. Takes effect from the update after this one, since an update runs the workspace's existing script.
- **`/save` cited a PRIMA-only rule.** `/save` said to follow the format in `context-checkpoint.md`, a rule that ships with PRIMA Project Management and is absent from a base workspace. It now follows that rule when present and otherwise uses the list of checkpoint contents in the command.
- **Merge base described wrongly.** `README.md` and `engine-protection.md` said the three-way merge uses the backup from a previous update, so the first update had no merge base. `update-engine.sh` uses the upstream copy of the workspace's current version, falling back to the latest backup. Both documents now describe that order.
- **Permission behaviour.** `capabilities-reference.md` said Claude asks permission before every action. `settings.json` pre-approves the core tools, so the page now describes the pre-approved tools, the two safety hooks and when Claude still stops to ask.
- **README rules and documentation lists.** The rules list adds Decomposition, No Permission Prompts and State Validation, and the documentation list adds Cloud Sync Warning and Agent-Agnostic Design, matching the files that ship.
- **`/dashboard` output ignored by git.** `dashboard.md` says the generated `Documentation/Reports/prima-dashboard.html` should be gitignored. `.gitignore` now ignores it.
- **`drafting-documents` trigger.** The skill description named a `/draft` command that does not exist. It now names `/drafting-documents`, the skill's own slash name.
- **`/setup` calendar entries.** `/setup` wrote calendar names into `selectedCalendars` as plain strings, while the state schema expects objects. It now writes `{"name": ...}` objects, with `id` added when known.
- **`ROADMAP.md` brought up to date.** The header showed v1.5.1, and the body still listed v1.6 to v2.0 releases although the engine is at 3.0. Items that have shipped (pack catalogue browsing, example packs, engine compatibility checks, stale project flags, the industry question in `/setup`) now sit under Shipped; the rest are listed as planned with no version assigned. References to the maintainer's internal workspace removed.

### Changed

- `.claude/suite-registry.json`: PRIMA Project Management 1.5.0, which ships the HTML dashboard and the `/day` Today view (13 October 2026). The engine keeps its base `/day` and `/dashboard`; a workspace with PRIMA Project Management installed receives the fuller versions through the PRIMA update path in `update-engine.sh`.
- `.claude/engine-manifest.json`: `engineVersion` 3.0.1, `released` 2026-10-14.
- `.claude/suite-registry.json`: `host.version` 3.0.1.
- `README.md`: version reference updated to v3.0.1.

---

## [3.0.0] — 2026-09-15

The default workspace layout changes shape. Nothing changes for a workspace that already exists.

### Added

- **Domain layout for new installations.** The template now ships `Domains/` with seventeen numbered domain folders (`01 Clients` to `16 Legal & Compliance`, plus `99 Cross-Domain`), each with its own `CLAUDE.md` and numbered reference subfolders (65 in total). Tracked projects live inside the domain they belong to; client folders live under `Domains/01 Clients/`. The domain `CLAUDE.md` files are `neverTouch`, so `/update` never overwrites a customised one and never recreates a domain a workspace has removed.
- **`/newproject` and `/newclient` detect the layout.** Both open with a shell test, `[ -d Domains ]`. Where `Domains/` exists, `/newproject` asks which domain the project belongs to, writes `Domains/NN Name/{ID} {Project Name}` and records a `domain` field in state; `/newclient` writes `Domains/01 Clients/[Client-Name]`. Where `Domains/` is absent, both run exactly as in 2.x. PRIMA Project Management 1.4.0 carries the same gate in its `/newproject`.
- `.vscode/extensions.json` recommends three more extensions alongside Claude Code and Bearded Icons: OpenAI Codex (`openai.chatgpt`), Ollama (`ollama.ollama`) and Live Preview (`ms-vscode.live-server`). VS Code offers them once when the workspace is first opened.
- `folder-structure.md`, `file-conventions.md`, `FRAMEWORK.md`, `getting-started.md` and the README describe both layouts, with an "Installed Before 3.0" section for the `Projects/`, `Clients/` and department-folder layout. `available-automations.md`, `capabilities-reference.md` and `glossary.md` brought current: the seven remaining skills listed in full, the command tables complete, a "Skill Packs" section, and glossary entries for Domain, Reference Subfolder, Skill Pack and Tracked Project.
- **`AGENTS.md` stubs in every domain folder and sample project**, written by `Infrastructure/Scripts/backfill-project-agents-stubs.sh`, and `/newproject` now writes the stub alongside each new project's `CLAUDE.md`. Non-Claude agents (Codex, Cursor, Gemini CLI, Copilot) load `AGENTS.md`, so without the stubs they never saw the domain or project rules. Stubs live outside `engineFiles` so `/update` cannot inject them into an existing workspace.
- **Community block** at the top of the README linking to the GenAI Skills Academy learning community, and a "Skills Removed in 3.0" note in the skills section.
- `agent-agnostic-design.md` records that only Claude Code discovers `.claude/commands/`, that Agent Skills adopters discover `.claude/skills/` automatically, and that `SOUL.md` is an OpenClaw bootstrap file the workspace does not ship. `ROADMAP.md` records the decision to convert commands to skills suite-wide in the next release.

### Changed

- **Sample content relocated.** `P001 Website Redesign` to `Domains/04 Information Technology/`, `P002 Q2 Marketing Campaign` to `Domains/07 Marketing/`, `P003 Staff Training Programme` to `Domains/03 Human Resources/`, the three sample clients and `_Templates/` to `Domains/01 Clients/`. Template `state.json` paths updated and `domain` recorded.
- **`/day` and `/status` read projects from `state.json`** instead of listing `Projects/` and `Clients/` on disk, so a project filed anywhere (a domain, a client folder, a custom top-level folder) is reported. These two files are PRIMA-managed and reach only workspaces without PRIMA Project Management installed.
- `suite-registry.json`: the PRIMA CRM entry no longer claims the CRM reads `tasks/P###.json`; it reads `taskCount` and `tasksDone` from project entries.

### Fixed

- **`/update` three-way merge base.** `update-engine.sh` used the most recent per-update backup as the merge base. That backup is a snapshot of the client's own files, so a client edit made before the previous update sat inside the base and was dropped silently whenever upstream rewrote that region; and a workspace whose backup was older than its installed version saw unedited files reported as conflicts. The base is now the pristine upstream file at the version the workspace last received, located by walking upstream history for the manifest commit carrying that `engineVersion` (and `version` for PRIMA Project Management). The backup remains the fallback when no such commit exists, and the preview names which base is in use. Verified against copies of both client workspaces: the client edit now appears in a conflict block, and spurious conflicts on unedited files disappear.
- **`/update` no longer overwrites itself mid-run.** The script is an engine file and was replaced on disk while bash was still reading it, ending every update with a syntax or unbound-variable error at a line past the end of the old file. It now re-executes from a temporary copy first.

### Removed

- **Six skills leave the template:** `copywriting`, `search-engine-optimisation`, `email-drafting`, `creating-presentations`, `processing-spreadsheets` and `processing-documents`, with their manifest entries. Skills are now widely published by Anthropic, skills.sh and other providers, and these six are available as skill packs in the GenAI Skills Academy community. Seven skills remain: `client-setup`, `creating-skills`, `documenting-workflows`, `drafting-documents`, `meeting-notes`, `processing-pdfs` and `status-report`. Existing workspaces keep the six, because `/update` never deletes a local file that upstream no longer lists.
- From the template only: the seven department folders (`01 Finance/` to `07 Legal/`), `Projects/` (including the empty `Projects/Workflows/`) and `Clients/`. Their content moved under `Domains/`. No path under any of them was ever listed in `engineFiles`, so `/update` does not touch these folders in an existing workspace.

### Not Included

- No migration. An existing workspace keeps its layout without exception. `Infrastructure/Scripts/migrate-folder-naming.sh` (the 2.0.0 department renaming script) is unchanged and unrelated.

## [2.5.0] — 2026-09-02

### Changed

- Updated `.gitignore`

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
