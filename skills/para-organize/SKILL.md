---
name: para-organize
description: Reorganize selected Lifewiki vault folders into Projects, Areas, Resources, and Archives. Use when the user wants a PARA-based cleanup for one or more specific folders instead of the whole vault.
user-invocable: true
---

# PARA Organize

Reorganize one or more user-specified folders inside `$LIFEWIKI_VAULT` into the active PARA layout.

## When to use

Use this skill when the user wants to:
- clean up one or more bounded folders using PARA
- preview a PARA move plan before applying it
- move notes and files into action-oriented buckets instead of topic sprawl

Do not use this skill to sweep the whole vault by default.

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Supported PARA layouts:
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
3. Resolve the active PARA layout in this order:
   1. explicit user instruction
   2. existing PARA roots in the vault
   3. otherwise stop and report ambiguous layout
4. Use one layout consistently for the run.
5. Recursively inspect candidate notes and files inside those folders.
6. Skip protected paths and explicitly excluded paths.
7. Classify each item using path, filename, frontmatter, headings, and note content.
8. Produce a move plan grouped by destination bucket.
9. Flag ambiguous items instead of forcing a low-confidence move.
10. Preview the move plan by default.
11. Apply the moves only after user approval, unless the user explicitly asks to apply immediately.
12. Report moved items and unresolved items.

## Move rules

- Move items into the matching roots for the active layout:
  - unnumbered: `Projects/`, `Areas/`, `Resources/`, `Archives/`
  - numbered: `1-Projects/`, `2-Areas/`, `3-Resources/`, `4-Archives/`
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
- If the PARA layout is ambiguous, stop and report it.
- If classification is too uncertain, do not move the item.
- If a protected path is included by accident, skip it and report that it was protected.
