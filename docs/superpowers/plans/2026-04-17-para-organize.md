# PARA Organize Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a local `para-organize` Lifewiki skill that reorganizes user-selected vault folders into PARA buckets with preview-first behavior and clear safety constraints.

**Architecture:** The implementation is documentation-driven because this repo packages local skills by discovering `skills/*/SKILL.md`. Add one new skill directory with operational instructions aligned to the approved design, then update the repo README so the packaged plugin and slash-command surface stay accurate. Verification is limited to file-level review and flake evaluation because there is no executable test suite for skill prose.

**Tech Stack:** Markdown skill docs, Nix flake packaging, OpenClaw local skill discovery

---

### Task 1: Add the PARA skill doc

**Files:**
- Create: `skills/para-organize/SKILL.md`
- Reference: `docs/superpowers/specs/2026-04-17-para-organize-design.md`

- [ ] **Step 1: Write the skill document**

```md
---
name: para-organize
description: Reorganize selected Lifewiki vault folders into Projects, Areas, Resources, and Archives. Use when the user wants a PARA-based cleanup for one or more specific folders instead of the whole vault.
user-invocable: true
---

# PARA Organize

Reorganize one or more user-specified folders inside `$LIFEWIKI_VAULT` into a PARA layout:

- `Projects/`
- `Areas/`
- `Resources/`
- `Archives/`

## When to use

Use this skill when the user wants to:
- clean up one or more bounded folders using PARA
- preview a PARA move plan before applying it
- move notes and files into action-oriented buckets instead of topic sprawl

Do not use this skill to sweep the whole vault by default.

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- PARA roots:
  - `$LIFEWIKI_VAULT/Projects/`
  - `$LIFEWIKI_VAULT/Areas/`
  - `$LIFEWIKI_VAULT/Resources/`
  - `$LIFEWIKI_VAULT/Archives/`

Protected paths that must never be modified:

- `$LIFEWIKI_VAULT/-Daily-Notes/`
- `$LIFEWIKI_VAULT/.obsidian/`

Avoid queue and workflow notes unless the user explicitly includes them:

- `$LIFEWIKI_VAULT/Read It Later.md`
- `$LIFEWIKI_VAULT/_Sources/`

## PARA rules

- `Projects`: active efforts with a concrete end state
- `Areas`: ongoing responsibilities without a natural finish
- `Resources`: reference material, topic notes, reusable knowledge
- `Archives`: inactive material from any of the other buckets

Organize by actionability rather than broad subject.

## Workflow

1. Resolve the requested source folders under `$LIFEWIKI_VAULT`.
2. Refuse any path outside the vault.
3. Recursively inspect candidate notes and files inside those folders.
4. Skip protected paths and explicitly excluded paths.
5. Classify each item using path, filename, frontmatter, headings, and note content.
6. Produce a move plan grouped by destination bucket.
7. Flag ambiguous items instead of forcing a low-confidence move.
8. Preview the move plan by default.
9. Apply the moves only after user approval, unless the user explicitly asks to apply immediately.
10. Report moved items and unresolved items.

## Move rules

- Preserve filenames unless a conflict requires disambiguation.
- Prefer moving whole notes as units.
- Keep PARA roots as the main boundary.
- Avoid deep subfolder hierarchies unless they already exist or clearly help.
- Never delete notes during PARA cleanup.

## Ambiguity handling

- Prefer `Projects` over `Resources` when a note clearly supports active delivery.
- Prefer `Areas` over `Projects` when the note describes steady responsibility rather than a finishable outcome.
- Prefer `Resources` over `Archives` when the material still appears in active use.
- Otherwise leave the item in place and surface it as ambiguous.

## Failure handling

- If a requested folder does not exist, stop and report the expected path.
- If a requested path is outside `$LIFEWIKI_VAULT`, refuse.
- If classification is too uncertain, do not move the item.
- If a protected path is included by accident, skip it and report that it was protected.
```

- [ ] **Step 2: Review the new skill text against the design**

Run: `sed -n '1,240p' skills/para-organize/SKILL.md`
Expected: The file includes bounded-folder scope, preview-first behavior, protected paths, PARA rules, ambiguity handling, and failure handling with no placeholder text.

- [ ] **Step 3: Commit**

```bash
git add skills/para-organize/SKILL.md
git commit -m "feat: add PARA organize skill"
```

### Task 2: Update packaged documentation and verify discovery

**Files:**
- Modify: `README.md`
- Verify: `flake.nix`

- [ ] **Step 1: Update the README skill list and examples**

```md
## Included Skills

This plugin packages five local skills:

- `/note` writes authored content into today's daily note
- `/inbox` captures GTD-style inbox items into today's daily note
- `/readlater` saves a URL into `_Sources`, adds it to the reading queue, and records intake in today's inbox
- `/reading` reviews and updates the read-it-later queue
- `/para-organize` reorganizes selected folders into `Projects`, `Areas`, `Resources`, and `Archives`

## Slash Commands

/para-organize Preview a PARA cleanup for `Inbox Imports/`.

## Skill Behavior

### `/para-organize`

- Reorganizes only user-specified folders, not the entire vault by default
- Classifies content into `Projects`, `Areas`, `Resources`, and `Archives`
- Previews planned moves before applying them unless the user explicitly requests immediate apply
- Skips protected paths such as daily notes and `.obsidian`
```

- [ ] **Step 2: Run file review to confirm README consistency**

Run: `sed -n '1,260p' README.md`
Expected: The README mentions five local skills, includes `/para-organize`, and describes the bounded preview-first behavior without claiming any unsupported automation.

- [ ] **Step 3: Verify the flake still discovers local skills**

Run: `nix eval --json .#openclawPlugin --apply 'f: f "x86_64-linux"'`
Expected: JSON output includes a `skills` array with a path ending in `skills/para-organize` alongside the existing local skills.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: document PARA organize skill"
```

### Task 3: Final verification and cleanup

**Files:**
- Verify: `skills/para-organize/SKILL.md`
- Verify: `README.md`
- Verify: `docs/superpowers/specs/2026-04-17-para-organize-design.md`

- [ ] **Step 1: Diff the final change**

Run: `git diff -- skills/para-organize/SKILL.md README.md docs/superpowers/specs/2026-04-17-para-organize-design.md`
Expected: The diff is limited to the new skill, README updates, and the already-approved design doc.

- [ ] **Step 2: Re-run discovery verification**

Run: `nix eval --json .#openclawPlugin --apply 'f: f "x86_64-linux"'`
Expected: Output still includes `skills/para-organize` in the `skills` array and returns successfully.

- [ ] **Step 3: Summarize verification status**

Run: `jj st`
Expected: The working copy shows only the intended files changed for the PARA skill work.

- [ ] **Step 4: Commit**

```bash
git add skills/para-organize/SKILL.md README.md
git commit -m "chore: verify PARA organize packaging"
```
