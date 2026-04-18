# Daystart Skill Design

## Goal

Add a Lifewiki skill named `daystart` that bootstraps a new day by creating today's daily note from the vault template when needed, summarizing what to do, and writing that startup summary into the note as authored content.

The skill should work even when today's note does not exist yet and before Obsidian has rendered any Tasks-plugin query blocks.

## Scope

The skill accepts a day-start request and performs the following bounded workflow:

- resolve today's and yesterday's dates from the local clock
- create today's daily note from the daily-note template if the note is missing
- inspect the vault directly for tasks to do today
- inspect `Read It Later.md` for unread articles to read
- inspect yesterday's daily note for `Kongfu::`
- write a concise startup summary into today's daily note
- return the same summary in chat

## Non-Goals

- depending on Obsidian runtime APIs or plugin-rendered output
- rewriting or re-grouping the query-driven sections in the daily note
- implementing the full Obsidian Tasks query engine
- reorganizing tasks or articles as part of the bootstrap run
- modifying yesterday's note or any other historical note

## Design Principles

- work before today's note exists
- Markdown-first, like the existing Lifewiki skills
- deterministic file reads and writes
- preserve the existing daily-note template structure
- keep the authored summary short and readable

## Vault Contract

- Vault root: `$LIFEWIKI_VAULT`
- Daily note template: `$LIFEWIKI_VAULT/5-Templates/Daily-Notes.md`
- Daily note path: `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`
- Read-it-later queue: `$LIFEWIKI_VAULT/Read It Later.md`
- Authored note section: `## Notes 📝`
- Query-driven sections that must not be edited directly:
  - `## Today 🔆`
  - `## Dashboard 🗺️`
  - `## Logs 🪵`

The numbered PARA layout used elsewhere in the vault does not materially affect this skill.

## Daily Note Creation

If today's note is missing, the skill should create it from the daily-note template.

### Behavior

1. Read `$LIFEWIKI_VAULT/5-Templates/Daily-Notes.md`.
2. Materialize the template for today's date.
3. Write the result to `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`.
4. Preserve the template's existing headings and query blocks.

### Template materialization

The vault template contains date placeholders for the note title, navigation links, and Tasks-plugin query dates. The skill should replace those placeholders with today's actual date values so the created note matches the vault's existing daily-note format.

The skill should not partially create the note from a raw copy of the template if required substitutions cannot be made clearly.

## Task Summary Model

Because a newly created daily note contains only raw Tasks-plugin queries, the skill must derive the startup task summary from the vault's task-bearing Markdown files rather than from the note's rendered `## Today 🔆` section.

### Primary task set

The task summary should include:

- open tasks whose explicit task metadata indicates they happen on or before today
- tasks already in progress when that state is visible in raw Markdown

This is intended to approximate the meaning of the daily note's `## Today 🔆` query without depending on plugin rendering.

### Fallback task set

If no tasks match the primary task set, the skill should include a short fallback list of open unscheduled tasks so the day-start output remains useful.

The fallback should be intentionally short rather than dumping the entire vault backlog.

## Read-It-Later Summary Model

The skill should read `$LIFEWIKI_VAULT/Read It Later.md` and summarize unread reading items.

### Behavior

- prefer unread items over already completed or archived items
- keep the summary short
- preserve note links as written in the queue file

The skill does not change queue state during daystart.

## Kongfu Reminder Model

The skill should inspect yesterday's daily note for the `Kongfu::` field.

### Reminder rule

If yesterday's note is missing, or the `Kongfu::` field is missing, empty, or `0`, the skill should include a reminder to practice Kongfu today.

If yesterday's `Kongfu::` value is a non-zero value, the reminder should be omitted.

## Daily Note Writeback

After gathering the startup summary, the skill should write an authored summary block into today's note under `## Notes 📝`.

### Behavior

- add a short heading such as `### Daystart`
- include the task snapshot
- include the unread reading snapshot
- include the Kongfu reminder when triggered
- preserve the surrounding Markdown and all other sections

The skill must not write into the query-driven sections or alter their code blocks.

## Chat Reporting

The skill should return the same startup summary in chat after the note update completes.

The report should also state whether today's note was created during the run or already existed.

## Failure Handling

- If `$LIFEWIKI_VAULT` is unset or unreadable, stop and report it.
- If the daily-note template is missing when today's note must be created, stop and report the expected template path.
- If `Read It Later.md` is missing, stop and report the expected path.
- If yesterday's note is missing, treat that as a reminder condition rather than a hard failure.
- If `## Notes 📝` is missing from today's note after creation or load, stop and report the required heading.
- If task parsing is incomplete or uncertain, prefer a smaller trustworthy summary over a broad speculative list.

## User Interface

The skill should be user-invocable.

Expected requests:

- "Bootstrap a new day."
- "/daystart"
- "Create today's note and tell me what to do."

## Verification

Success means:

- the skill creates today's note from the template when it is missing
- the created note contains today's concrete date values rather than unresolved template placeholders
- the skill writes a short startup summary under `## Notes 📝`
- the skill returns the same summary in chat
- unread read-it-later items are summarized without changing queue state
- a Kongfu reminder appears only when yesterday's note is missing or has no positive `Kongfu::` value
- the skill does not modify query-driven sections directly

## Implementation Notes

Keep the implementation narrow and file-driven. The skill should approximate the daily Tasks query well enough for daystart without trying to become a full Tasks-plugin reimplementation.
