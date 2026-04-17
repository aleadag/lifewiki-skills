# Organize Vault Skill Design

## Goal

Add a Lifewiki skill named `organize-vault` that serves as a high-level entry point for scheduled or manual vault maintenance.

The skill should dispatch a small set of named workflows and apply changes automatically by default. It is intended for unattended runs such as a nightly OpenClaw automation job.

## Scope

The skill accepts a named workflow and executes that workflow's bounded rules directly.

Initial workflows:

- `read-it-later`
- `para-cleanup`

The skill does not accept arbitrary cleanup goals or open-ended vault reorganization requests.

## Non-Goals

- Sweeping the entire vault by default
- Inferring new workflows from vague user requests
- Acting as a generic planner-only skill
- Replacing the lower-level `para-organize` or `reading` skills

## Design Principles

- Deterministic enough for unattended execution
- Narrow workflow boundaries
- Automatic apply by default
- Explicit refusal for unsupported workflows
- Clear summary reporting after each run

## Vault Contract

- Vault root: `$LIFEWIKI_VAULT`
- Queue note: `$LIFEWIKI_VAULT/Read It Later.md`
- Source notes: `$LIFEWIKI_VAULT/_Sources/`

Supported PARA layouts:

- Unnumbered:
  - `$LIFEWIKI_VAULT/Projects/`
  - `$LIFEWIKI_VAULT/Areas/`
  - `$LIFEWIKI_VAULT/Resources/`
  - `$LIFEWIKI_VAULT/Archives/`
- Numbered:
  - `$LIFEWIKI_VAULT/1-Projects/`
  - `$LIFEWIKI_VAULT/2-Areas/`
  - `$LIFEWIKI_VAULT/3-Resources/`
  - `$LIFEWIKI_VAULT/4-Archives/`

Protected paths must never be modified unless a supported workflow explicitly targets them:

- `$LIFEWIKI_VAULT/-Daily-Notes/`
- `$LIFEWIKI_VAULT/.obsidian/`

## Workflow Resolution

The skill requires a supported workflow name.

If the user or automation prompt does not specify a supported workflow:

- stop
- list the supported workflows
- refuse to guess

If a workflow requires additional scope, such as source folders for `para-cleanup`, the request must include that scope explicitly.

## PARA Layout Detection

The skill should resolve the active PARA layout in this order:

1. explicit user instruction
2. existing root folders in the vault
3. otherwise stop and report that the PARA layout is ambiguous

Within one run, the skill must use one layout consistently.

## Workflow: `read-it-later`

This workflow performs read-it-later maintenance directly.

### Inputs

- workflow name: `read-it-later`
- optional explicit PARA layout override

### Behavior

1. Open `Read It Later.md`.
2. Find items already marked done or placed in a done/completed section.
3. Move those items into `## Archived`.
4. Resolve the corresponding source notes in `_Sources/`.
5. Move those source notes into the active PARA resources root:
   - `Resources/` for unnumbered layout
   - `3-Resources/` for numbered layout
6. Preserve note filenames unless disambiguation is required.
7. Report which queue items were archived and which source notes were moved.

### Failure handling

- If `Read It Later.md` is missing, stop and report the expected path.
- If a completed queue item has no matching source note, report it and continue with the rest.
- If the PARA layout cannot be resolved, stop and report that explicitly.
- If `## Archived` is missing, create it only if the queue structure clearly supports state headings; otherwise stop and report the expected heading model.

## Workflow: `para-cleanup`

This workflow performs generic PARA refiling on user-specified folders.

### Inputs

- workflow name: `para-cleanup`
- one or more source folders
- optional explicit PARA layout override

### Behavior

1. Resolve the requested source folders under `$LIFEWIKI_VAULT`.
2. Refuse any path outside the vault.
3. Skip protected paths and unsupported operational notes.
4. Classify candidate files into the active PARA layout using the `para-organize` rules.
5. Move files into the matching PARA roots.
6. Leave ambiguous items untouched and report them.
7. Summarize what moved.

### Failure handling

- If any requested folder is missing, stop and report it.
- If the PARA layout cannot be resolved, stop and report that explicitly.
- If classification is too uncertain, do not move the item.

## Automatic Apply Model

The skill applies changes automatically by default.

This is intentional because the primary use case is unattended scheduled maintenance. The skill should not require a preview step unless the user explicitly asks for dry-run or preview behavior.

## Summary Reporting

After a run, the skill should provide a concise report that includes:

- workflow used
- detected PARA layout
- files or queue items changed
- items skipped
- items left unresolved

The summary should be short enough for automation logs.

## Safety Constraints

- Never run without a supported workflow name.
- Never broaden the scope beyond the workflow's defined inputs.
- Never guess unsupported workflow behavior.
- Never modify protected paths outside supported workflow rules.
- Never delete notes as part of maintenance.

## User Interface

The skill should be user-invocable.

Expected requests:

- "Use `organize-vault` with `read-it-later`."
- "Run `organize-vault` for `para-cleanup` on `Inbox Imports/`."
- "Use `organize-vault` with `read-it-later` and numbered PARA roots."

Scheduled automation prompt example:

```text
Use organize-vault with the read-it-later workflow. Apply changes automatically. Archive done items in Read It Later.md and move the corresponding _Sources notes into the active PARA resources root. Report a short summary.
```

## Verification

Success means:

- the skill refuses unsupported workflows
- `read-it-later` updates the queue and moves matching source notes into the correct resources root
- `para-cleanup` only operates on explicit source folders
- numbered and unnumbered PARA layouts are both supported
- unattended runs produce a concise summary instead of interactive back-and-forth

## Implementation Notes

Keep this skill as a dispatcher and policy layer. Detailed classification logic should stay aligned with the lower-level skills rather than being reinvented here.
