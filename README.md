# Lifewiki Skills

General OpenClaw skills for maintaining a Lifewiki vault built on the Obsidian workflow template.

## Included Skills

This plugin packages five local skills:

- `/note` writes authored content into today's daily note
- `/inbox` captures GTD-style inbox items into today's daily note
- `/readlater` saves a URL into `_Sources`, adds it to the reading queue, and records intake in today's inbox
- `/reading` reviews and updates the read-it-later queue
- `/para-organize` reorganizes selected folders into `Projects`, `Areas`, `Resources`, and `Archives`

It also packages selected upstream skills from `kepano/obsidian-skills` through `flake.nix`.

## Required Environment

Set the vault root before using the skills:

```bash
export LIFEWIKI_VAULT=/home/alexander/Lifewiki
```

The skills assume this vault structure:

- daily notes at `-Daily-Notes/YYYY-MM-DD.md`
- source captures in `_Sources/`
- read-it-later queue in `Read It Later.md`

## Slash Commands

After installing the plugin in OpenClaw, invoke the skills with:

```text
/note Met with Dr. Wang, need to send the follow-up summary tomorrow.
/inbox Renew passport before June.
/readlater https://example.com/article
/reading Show unread items and move the BTC article to Reading.
/para-organize Preview a PARA cleanup for `Inbox Imports/`.
```

## Skill Behavior

### `/note`

- Writes to today's daily note
- Defaults to the `## Notes 📝` section
- Can target `## Inbox 📥` when explicitly requested
- Never writes into query-driven log/dashboard sections

### `/inbox`

- Writes actionable items into today's `## Inbox 📥`
- Defaults to task checkboxes
- Keeps entries short and easy to triage later

### `/readlater`

- Creates a canonical Markdown note in `_Sources/`
- Stores source URL, capture timestamp, status, and captured content when available
- Adds an unread entry to `Read It Later.md`
- Adds a same-day intake item to today's inbox

### `/reading`

- Reviews or updates `Read It Later.md`
- Moves items between states such as Unread, Reading, Done, and Archived
- Keeps `_Sources/` notes as the canonical content record

### `/para-organize`

- Reorganizes only user-specified folders, not the entire vault by default
- Classifies content into `Projects`, `Areas`, `Resources`, and `Archives`
- Previews planned moves before applying them unless the user explicitly requests immediate apply
- Skips protected paths such as daily notes and `.obsidian`

## Nix

The flake exports an `openclawPlugin` output that includes:

- local skills from `./skills`
- pinned upstream skills from `kepano/obsidian-skills`
- required environment variable metadata for `LIFEWIKI_VAULT`

Useful commands:

```bash
nix flake show --json
nix eval --json .#openclawPlugin
```
