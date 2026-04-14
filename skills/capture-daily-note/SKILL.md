---
name: note
description: Capture authored note content into today's Lifewiki daily note. Use when the user wants to record a note, journal entry, summary, or other non-task content in the current daily note.
user-invocable: true
---

# Capture Daily Note

Write Markdown into today's daily note in `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`.

## When to use

Use this skill when the user wants to:
- record a journal-style note
- save a short summary from a conversation
- add authored content to today's daily note
- explicitly target the daily note inbox with non-task capture

Do not use this skill for read-it-later ingestion. Use `capture-read-it-later` instead.

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Daily notes live in `-Daily-Notes/`
- Daily notes are named `YYYY-MM-DD.md`
- Default authored section: `## Notes 📝`
- Optional alternate section: `## Inbox 📥`
- Never write into `## Logs 🪵` or query-driven dashboard sections

## Workflow

1. Resolve today's note path using the current local date and `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md`.
2. Confirm the note exists. If it does not, stop and report the missing path.
3. Find the target section:
   - default to `## Notes 📝`
   - allow explicit override to `## Inbox 📥`
4. Append the new content inside that section, preserving surrounding Markdown.
5. Report exactly where the content was written.

## Formatting rules

- Keep the user's wording unless a small cleanup is clearly helpful.
- Preserve existing heading structure and spacing.
- Use Markdown bullets only when the content is inherently list-shaped.
- For plain note capture, prefer a short paragraph or a dated bullet rather than a task checkbox.
- Do not create new daily note templates or alter unrelated sections.

## Failure handling

- If the daily note is missing, stop and report the expected path.
- If the target section heading is missing, stop and report the required heading text.
- If the user asks to write into the logs area, refuse and explain that logs are query-driven in this vault.
