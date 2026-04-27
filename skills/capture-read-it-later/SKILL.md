---
name: readlater
description: Save a URL into Lifewiki as a read-it-later source note plus queue entry. Use when the user wants to keep an article, webpage, or document for later reading inside the vault.
user-invocable: true
---

# Capture Read It Later

Create a canonical source note in `$LIFEWIKI_VAULT/_Sources/` and register it in the read-it-later queue.

## When to use

Use this skill when the user wants to:
- save a webpage or article to read later
- preserve the contents of a link inside the vault
- build a durable queue of unread reading items

## Vault contract

- Vault root: `$LIFEWIKI_VAULT`
- Canonical source-note folder: `_Sources/`
- Queue note: `Read It Later.md` at the vault root

## Required outputs

For each captured URL, produce all of the following:
- one source note in `_Sources/`
- one queue entry in `Read It Later.md`

## Source note requirements

The source note should include:
- title
- original URL
- capture timestamp
- capture status: `captured`, `partial`, or `failed`
- any extracted metadata that is reliably available
- fetched content, if available

Use a filename derived from the source title when practical. If the title is unavailable, use a slug based on the URL.

## Workflow

1. Fetch the URL content using available tooling that can return Markdown or clean text.
2. Normalize a title and metadata from the fetched result.
3. Create the `_Sources` note with metadata and captured content.
4. Add an unread queue task to `Read It Later.md` linking to the source note.
5. If a same-day daily note mention is useful, add only a non-task note or link to the source note. Do not add a todo item in the daily note.

## Failure handling

- If content fetch fails, still create the `_Sources` note with the original URL and `failed` status.
- If content fetch is partial, record `partial` status and preserve whatever content was captured.
- If the queue note is missing, stop and report the missing path after creating the source note.

## Formatting rules

- Treat the `_Sources` note as the canonical record. Do not duplicate full article content anywhere else.
- Keep queue entries short and link back to the source note.
- Do not create a daily-note todo item for read-it-later capture; the queue entry is already the task-like record.
- Do not silently discard a URL because the fetch was imperfect.
