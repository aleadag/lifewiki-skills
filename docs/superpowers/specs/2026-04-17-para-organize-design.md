# PARA Organize Skill Design

## Goal

Add a Lifewiki skill named `para-organize` that reorganizes selected vault folders into a PARA layout under `$LIFEWIKI_VAULT`, using the PARA categories:

- Projects
- Areas
- Resources
- Archives

The skill should be operational, not advisory-only. It may move notes and files when the user approves the plan.

## Scope

The skill reorganizes one or more user-specified source folders inside the vault. It does not sweep the whole vault by default.

The skill is intended for broader cleanup within bounded areas of the vault, such as an imports folder, a notes holding area, or a topic collection that has outgrown its current structure.

## Non-Goals

- Reorganizing the entire vault without explicit source-folder boundaries
- Editing daily notes or operational Obsidian metadata
- Rewriting note bodies just to make them match PARA
- Inventing new note taxonomy beyond the four PARA roots

## Vault Contract

- Vault root: `$LIFEWIKI_VAULT`
- PARA target roots:
  - `$LIFEWIKI_VAULT/Projects/`
  - `$LIFEWIKI_VAULT/Areas/`
  - `$LIFEWIKI_VAULT/Resources/`
  - `$LIFEWIKI_VAULT/Archives/`

Protected paths must never be changed:

- `$LIFEWIKI_VAULT/-Daily-Notes/`
- `$LIFEWIKI_VAULT/.obsidian/`

The skill should also avoid changing queue or workflow notes unless the user explicitly includes them:

- `$LIFEWIKI_VAULT/Read It Later.md`
- `$LIFEWIKI_VAULT/_Sources/`

## PARA Classification Rules

The skill organizes by actionability rather than by broad subject.

### Projects

Use `Projects` for active efforts with a concrete end state. A note belongs here when it supports work that can be finished and crossed off.

Examples:

- trip planning
- launch checklist
- paper draft
- renovation plan

### Areas

Use `Areas` for ongoing responsibilities that need maintenance over time and do not naturally complete.

Examples:

- health
- finances
- home
- team management

### Resources

Use `Resources` for reference material, learning notes, topic collections, and reusable material that is not tied to an active outcome.

Examples:

- reading notes
- topic research
- templates
- reference docs

### Archives

Use `Archives` for inactive material from any of the other three categories.

Examples:

- completed projects
- paused initiatives
- retired areas
- stale references

## Execution Workflow

1. Resolve the user-specified source folders under `$LIFEWIKI_VAULT`.
2. Refuse to run if any requested folder is outside the vault.
3. Recursively inspect candidate notes and files in those folders.
4. Skip protected paths and any explicitly excluded paths.
5. Classify each item into a PARA bucket using file path, filename, frontmatter, headings, and note content.
6. Produce a move plan grouped by destination bucket.
7. Flag ambiguous items separately instead of guessing when confidence is low.
8. By default, show the move plan first.
9. Apply the moves only when the user approves, or immediately if the user explicitly asks to apply without preview.
10. Report what moved and what was left unresolved.

## Move Rules

- Preserve filenames unless a naming conflict forces disambiguation.
- Prefer moving whole notes as units rather than splitting content.
- Preserve relative folder structure only when it remains useful inside the target PARA bucket.
- Do not create deep subfolder hierarchies unless they already exist in the source material or clearly improve findability.
- Keep the PARA roots as the primary organizational boundary.

## Ambiguity Handling

The skill should stop short of low-confidence churn.

When an item plausibly fits more than one bucket:

- prefer `Projects` over `Resources` when the note is clearly tied to active delivery
- prefer `Areas` over `Projects` when the note describes enduring responsibility rather than a finishable outcome
- prefer `Resources` over `Archives` when the material still appears actively referenced
- otherwise mark the item as ambiguous and leave it in place until the user decides

## Safety Constraints

- Never move files outside the requested source folders.
- Never touch protected paths.
- Never delete notes as part of PARA reorganization.
- Never rewrite large portions of content to force a classification.
- Do not make speculative archive decisions without evidence that the material is inactive.

## User Interface

The skill should be user-invocable.

Expected requests:

- "Reorganize `Inbox Imports/` using PARA."
- "Sort `Work Notes/` and `Personal Notes/` into PARA buckets."
- "Preview a PARA cleanup for `Research Dump/`."

## Verification

Success means:

- every moved item came from a user-specified folder
- no protected path was modified
- the move plan is understandable before apply
- ambiguous items remain visible to the user instead of being silently forced into a bucket

## Implementation Notes

Keep the skill narrow and practical. It should describe how to classify and move notes in this vault, not teach the full PARA philosophy.
