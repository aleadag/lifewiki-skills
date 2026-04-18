---
name: daystart
description: Bootstrap a new day in Lifewiki by creating today's daily note if needed, summarizing tasks and reading, and writing a short startup summary into the note. Use when the user asks to start the day or create today's note and tell them what to do.
user-invocable: true
---

# Daystart

Bootstrap the current day in `$LIFEWIKI_VAULT` and write a short authored summary into today's daily note.

## When to use

Use this skill when the user wants to:
- create today's daily note if it does not exist yet
- get a short startup summary for the day
- see what tasks are ready to do, what to read, and whether Kongfu should be practiced today

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Daily note template: `$LIFEWIKI_VAULT/5-Templates/Daily-Notes.md`
- Daily note path: `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`
- Read-it-later queue: `$LIFEWIKI_VAULT/Read It Later.md`
- Authored note section: `## Notes 📝`
- Query-driven sections that must not be edited directly:
  - `## Today 🔆`
  - `## Dashboard 🗺️`
  - `## Logs 🪵`

## Non-goals

- do not depend on Obsidian runtime APIs or plugin-rendered output
- do not rewrite or re-group the query-driven sections in the daily note
- do not implement the full Obsidian Tasks query engine
- do not reorganize tasks or articles during bootstrap
- do not modify yesterday's note or any other historical note

## Design principles

- work before today's note exists
- stay Markdown-first, like the other Lifewiki skills
- keep file reads and writes deterministic
- preserve the existing daily-note template structure
- keep the authored summary short and readable

## Workflow

1. Resolve today's and yesterday's dates from the local clock.
2. Confirm `$LIFEWIKI_VAULT` is set and readable. If it is not, stop and report it.
3. Resolve today's note path at `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`.
4. If today's note is missing:
   - read `$LIFEWIKI_VAULT/5-Templates/Daily-Notes.md`
   - materialize the template for today's actual date
   - write the result to today's note path
   - preserve the template's headings and query blocks
   - do not create the note if the required substitutions are unclear
5. Read the vault directly for task-bearing Markdown files and build a short startup task snapshot.
6. Read `$LIFEWIKI_VAULT/Read It Later.md` and build a short unread-reading snapshot.
7. Read yesterday's daily note and inspect its `Kongfu::` field.
8. Write a short authored summary block into today's note under `## Notes 📝`.
9. Return the same summary in chat and state whether today's note was created during the run or already existed.

## Daily note creation

When creating today's note from the template:
- replace date placeholders with today's actual date values
- keep the existing daily-note structure intact
- preserve query-driven sections exactly as authored in the template
- do not partially synthesize a note from an ambiguous template

## Task summary model

Because the daily note's task query blocks may not have rendered yet, derive the summary from raw Markdown files instead of Obsidian output.

Task source scope:
- scan Markdown files under `$LIFEWIKI_VAULT`, but exclude `$LIFEWIKI_VAULT/5-Templates/`, `$LIFEWIKI_VAULT/-Daily-Notes/`, `$LIFEWIKI_VAULT/_Sources/`, and `$LIFEWIKI_VAULT/Read It Later.md`
- treat task-bearing files as any remaining Markdown file that contains open tasks or explicit in-progress task state in raw Markdown
- do not inspect attachments, rendered output, or non-Markdown files

Primary task set:
- open tasks whose explicit task metadata says they happen on or before today
- tasks already in progress when that state is visible in raw Markdown

Fallback task set:
- if no primary tasks match, include a small list of open unscheduled tasks
- keep the fallback intentionally short

## Read-it-later summary model

Summarize unread items from `Read It Later.md`:
- prefer unread items over completed or archived items
- keep the summary short
- preserve note links exactly as written in the queue file
- do not change queue state during daystart
- use only `$LIFEWIKI_VAULT/Read It Later.md` as the reading source during bootstrap

## Kongfu reminder

Inspect yesterday's daily note for `Kongfu::`.

- If yesterday's note is missing, or `Kongfu::` is missing, empty, or `0`, include a reminder to practice Kongfu today.
- If `Kongfu::` has a non-zero value, omit the reminder.

## Writeback rules

Write an authored summary block under `## Notes 📝`.

- use a short heading such as `### Daystart`
- if a `### Daystart` block already exists in `## Notes 📝`, replace that block in place; otherwise append a new `### Daystart` block at the end of `## Notes 📝`
- include the task snapshot
- include the unread reading snapshot
- include the Kongfu reminder when triggered
- preserve surrounding Markdown and all other sections
- do not write into query-driven sections or alter their code blocks

## Failure handling

- If `$LIFEWIKI_VAULT` is unset or unreadable, stop and report it.
- If the daily-note template is missing when today's note must be created, stop and report the expected template path.
- If `Read It Later.md` is missing, stop and report the expected path.
- If yesterday's note is missing, treat that as a reminder condition rather than a hard failure.
- If `## Notes 📝` is missing from today's note after creation or load, stop and report the required heading.
- If task parsing is incomplete or uncertain, prefer a smaller trustworthy summary over a broad speculative list.

## Formatting rules

- Keep the startup summary concise and readable.
- Preserve Markdown links and file references.
- Do not reorganize tasks, articles, or historical notes.
- Do not depend on Obsidian runtime APIs or plugin-rendered output.
