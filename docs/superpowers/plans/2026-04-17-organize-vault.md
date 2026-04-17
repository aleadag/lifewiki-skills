# Organize Vault Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a high-level `organize-vault` Lifewiki skill for unattended named-workflow maintenance and update `para-organize` to support both numbered and unnumbered PARA roots.

**Architecture:** This is a documentation-driven feature because local skills are packaged by discovering `skills/*/SKILL.md`. Add a new `organize-vault` dispatcher skill, revise `para-organize` so its vault contract matches the new numbered-or-unnumbered PARA model, then update the README so the documented behavior matches the packaged skills. Verification is by reviewing the generated Markdown and evaluating the flake output.

**Tech Stack:** Markdown skill docs, Nix flake packaging, OpenClaw local skill discovery

---

### Task 1: Add the high-level organize-vault skill

**Files:**
- Create: `skills/organize-vault/SKILL.md`
- Reference: `docs/superpowers/specs/2026-04-17-organize-vault-design.md`

- [ ] **Step 1: Write the new skill document**

```md
---
name: organize-vault
description: Run named Lifewiki maintenance workflows such as read-it-later cleanup or PARA cleanup. Use when the user wants one high-level command for scheduled or manual vault organization.
user-invocable: true
---

# Organize Vault

Run a supported maintenance workflow inside `$LIFEWIKI_VAULT`.

Supported workflows:

- `read-it-later`
- `para-cleanup`

This skill applies changes automatically by default. Use dry-run or preview only when the user explicitly asks for it.

## When to use

Use this skill when the user wants to:
- run a named vault-maintenance workflow directly
- automate nightly or scheduled organization work
- use one top-level entry point instead of invoking lower-level skills separately

Do not use this skill for open-ended vault cleanup without a supported workflow name.

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Read-it-later queue: `$LIFEWIKI_VAULT/Read It Later.md`
- Source notes: `$LIFEWIKI_VAULT/_Sources/`

Supported PARA layouts:

- unnumbered:
  - `Projects/`
  - `Areas/`
  - `Resources/`
  - `Archives/`
- numbered:
  - `1-Projects/`
  - `2-Areas/`
  - `3-Resources/`
  - `4-Archives/`

Protected paths:

- `$LIFEWIKI_VAULT/-Daily-Notes/`
- `$LIFEWIKI_VAULT/.obsidian/`

## Workflow resolution

- Require one supported workflow name.
- If no supported workflow is provided, stop and list the supported workflows.
- If the workflow requires more scope, such as source folders for `para-cleanup`, require that scope explicitly.

## PARA layout resolution

Resolve the PARA layout in this order:

1. explicit user instruction
2. existing PARA roots in the vault
3. otherwise stop and report ambiguous layout

Use one layout consistently for the entire run.

## Workflow: `read-it-later`

1. Open `Read It Later.md`.
2. Find done items or items already grouped under a done/completed section.
3. Move those queue items into `## Archived`.
4. Resolve the matching notes in `_Sources/`.
5. Move those notes into the active resources root:
   - `Resources/` when using the unnumbered layout
   - `3-Resources/` when using the numbered layout
6. Report archived queue items, moved notes, missing matches, and skipped items.

## Workflow: `para-cleanup`

1. Resolve the requested source folders inside the vault.
2. Refuse any path outside `$LIFEWIKI_VAULT`.
3. Classify candidate files using the `para-organize` rules.
4. Move files into the active PARA roots.
5. Leave ambiguous items in place and report them.

## Failure handling

- If a required file or folder is missing, stop and report the expected path.
- If the PARA layout is ambiguous, stop and report it.
- If a workflow name is unsupported, stop and list the supported workflows.
- If a completed queue item has no matching `_Sources` note, report it and continue.
- Never modify protected paths unless a supported workflow explicitly targets them.

## Reporting

After each run, return a short summary with:

- workflow used
- PARA layout used
- items changed
- items skipped
- unresolved items
```

- [ ] **Step 2: Review the new skill text**

Run: `sed -n '1,260p' skills/organize-vault/SKILL.md`
Expected: The file contains the two supported workflows, automatic apply by default, PARA layout detection, and bounded failure handling with no placeholder text.

- [ ] **Step 3: Commit**

```bash
git add skills/organize-vault/SKILL.md
git commit -m "feat: add organize-vault skill"
```

### Task 2: Update para-organize for dual-layout PARA roots

**Files:**
- Modify: `skills/para-organize/SKILL.md`
- Reference: `docs/superpowers/specs/2026-04-17-para-organize-design.md`
- Reference: `docs/superpowers/specs/2026-04-17-organize-vault-design.md`

- [ ] **Step 1: Revise the PARA root contract**

```md
Supported PARA layouts:

- unnumbered:
  - `$LIFEWIKI_VAULT/Projects/`
  - `$LIFEWIKI_VAULT/Areas/`
  - `$LIFEWIKI_VAULT/Resources/`
  - `$LIFEWIKI_VAULT/Archives/`
- numbered:
  - `$LIFEWIKI_VAULT/1-Projects/`
  - `$LIFEWIKI_VAULT/2-Areas/`
  - `$LIFEWIKI_VAULT/3-Resources/`
  - `$LIFEWIKI_VAULT/4-Archives/`
```

- [ ] **Step 2: Add layout resolution rules to the workflow**

```md
Before classifying items, resolve the active PARA layout in this order:

1. explicit user instruction
2. existing PARA roots in the vault
3. otherwise stop and report ambiguous layout

Use one layout consistently for the run.
```

- [ ] **Step 3: Update move targets and examples to avoid assuming only unnumbered roots**

```md
Move items into the matching roots for the active layout:

- unnumbered: `Projects/`, `Areas/`, `Resources/`, `Archives/`
- numbered: `1-Projects/`, `2-Areas/`, `3-Resources/`, `4-Archives/`
```

- [ ] **Step 4: Review the revised skill text**

Run: `sed -n '1,280p' skills/para-organize/SKILL.md`
Expected: The skill supports both PARA layouts, explains layout resolution, and still keeps preview-first behavior for direct `para-organize` use.

- [ ] **Step 5: Commit**

```bash
git add skills/para-organize/SKILL.md
git commit -m "feat: support numbered PARA roots"
```

### Task 3: Update README and verify packaged discovery

**Files:**
- Modify: `README.md`
- Verify: `flake.nix`

- [ ] **Step 1: Update the local skill list and behavior descriptions**

```md
This plugin packages six local skills:

- `/para-organize` reorganizes selected folders into the active PARA layout
- `/organize-vault` runs named maintenance workflows such as `read-it-later` and `para-cleanup`

### `/para-organize`

- Supports numbered and unnumbered PARA roots
- Uses preview-first behavior unless the user explicitly asks to apply immediately

### `/organize-vault`

- Runs supported named workflows only
- Applies changes automatically by default
- Fits scheduled automation such as a nightly cleanup job
```

- [ ] **Step 2: Add one slash-command example for organize-vault**

```text
/organize-vault Use the read-it-later workflow and apply changes automatically.
```

- [ ] **Step 3: Review the README for consistency**

Run: `sed -n '1,320p' README.md`
Expected: The README mentions six local skills, includes `organize-vault`, and describes the distinction between preview-first `para-organize` and auto-apply `organize-vault`.

- [ ] **Step 4: Verify flake discovery**

Run: `nix eval --json .#openclawPlugin --apply 'f: f "x86_64-linux"'`
Expected: The `skills` array includes paths ending in `skills/para-organize` and `skills/organize-vault`.

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: document organize-vault workflows"
```

### Task 4: Final verification and change review

**Files:**
- Verify: `skills/organize-vault/SKILL.md`
- Verify: `skills/para-organize/SKILL.md`
- Verify: `README.md`
- Verify: `docs/superpowers/specs/2026-04-17-organize-vault-design.md`

- [ ] **Step 1: Review the final diff for scope**

Run: `git diff -- skills/organize-vault/SKILL.md skills/para-organize/SKILL.md README.md docs/superpowers/specs/2026-04-17-organize-vault-design.md`
Expected: The diff is limited to the new high-level skill, the dual-layout PARA update, README documentation, and the approved design doc.

- [ ] **Step 2: Re-run flake verification**

Run: `nix eval --json .#openclawPlugin --apply 'f: f "x86_64-linux"'`
Expected: The plugin output still evaluates successfully and includes the new skill paths.

- [ ] **Step 3: Review repository status**

Run: `jj st`
Expected: The working copy shows only the intended files for the organize-vault work.

- [ ] **Step 4: Commit**

```bash
git add skills/organize-vault/SKILL.md skills/para-organize/SKILL.md README.md
git commit -m "chore: verify organize-vault packaging"
```
