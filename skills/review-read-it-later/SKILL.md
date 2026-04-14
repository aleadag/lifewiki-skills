---
name: reading
description: Maintain the Lifewiki read-it-later queue. Use when the user wants to review unread links, move items between reading states, or mark reading work complete.
user-invocable: true
---

# Review Read It Later

Maintain the queue note that tracks read-it-later items stored canonically in `$LIFEWIKI_VAULT/_Sources/`.

## When to use

Use this skill when the user wants to:
- review unread or in-progress reading items
- mark a saved item as reading, done, or archived
- clean up the read-it-later queue without touching source-note content

## Vault contract

- Queue note: `$LIFEWIKI_VAULT/Read It Later.md`
- Canonical article records live in `$LIFEWIKI_VAULT/_Sources/`
- Queue entries should link to `_Sources` notes rather than duplicating article content

## Workflow

1. Open `Read It Later.md`.
2. Locate the relevant queue entry or list the current unread items.
3. Update the task state or move the entry to the appropriate section.
4. Preserve links to the canonical `_Sources` note.
5. If needed, update the source note metadata to reflect the new reading state.

## Recommended queue structure

- `## Unread`
- `## Reading`
- `## Done`
- `## Archived`

Use task checkboxes only where they clarify status. Headings are the primary state boundary.

## Failure handling

- If the queue note is missing, stop and report the expected path.
- If the linked source note is missing, report the broken reference before changing queue state.
- Do not delete source notes when marking queue items complete or archived.
