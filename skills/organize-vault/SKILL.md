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
2. Find items already marked done or grouped under `## Done`.
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
6. Treat GTD control lists such as `Someday Maybe`, `Wishlist`, `Backlog`, or `Incubation` as `Areas` or ambiguous by default, not `Archives`, unless the user explicitly asks to archive them.

## Failure handling

- If a required file or folder is missing, stop and report the expected path.
- If the PARA layout is ambiguous, stop and report it.
- If a workflow name is unsupported, stop and list the supported workflows.
- If a completed queue item has no matching `_Sources` note, report it and continue.
- If `## Archived` is missing, create it only when the queue structure already uses state headings; otherwise stop and report the expected heading model.
- Never modify protected paths unless a supported workflow explicitly targets them.

## Reporting

After each run, return a short summary with:

- workflow used
- PARA layout used
- items changed
- items skipped
- unresolved items
