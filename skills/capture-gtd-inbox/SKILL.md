---
name: inbox
description: Capture actionable inbox items into today's Lifewiki daily note. Use when the user wants to save a task, follow-up, reminder, or other GTD-style inbox item for later processing.
user-invocable: true
---

# Capture GTD Inbox

Write actionable items into today's daily note inbox at `$LIFEWIKI_VAULT/-Daily-Notes/YYYY-MM-DD.md` under `## Inbox 📥`.

## When to use

Use this skill when the user wants to:
- capture a task or next action quickly
- save a reminder for later triage
- collect inbox items during the day without deciding the final project or area yet

Do not use this skill for narrative journaling. Use `capture-daily-note` for note-style entries.

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Daily note path: `-Daily-Notes/YYYY-MM-DD.md`
- Required target heading: `## Inbox 📥`
- Inbox entries are authored content, not dashboard query results

## Workflow

1. Resolve today's daily note path in `$LIFEWIKI_VAULT/-Daily-Notes/`.
2. Confirm the file exists. If not, stop and report the missing note.
3. Confirm the `## Inbox 📥` heading exists. If not, stop and report the missing heading.
4. Convert the captured item into a concise inbox entry.
5. Append the entry under `## Inbox 📥`.

## Formatting rules

- Default to a task checkbox: `- [ ] ...`
- Keep the text short and actionable.
- Preserve user-provided dates, links, and project wikilinks when present.
- Do not assign projects, tags, or due dates unless the user explicitly provides them.
- Avoid duplicates when the exact same inbox item is already present nearby.

## Failure handling

- If the daily note is missing, stop and report the expected path.
- If the inbox heading is missing, stop and report the required heading.
- If the content is not actionable, either convert it into a neutral inbox item or suggest `capture-daily-note` instead.
