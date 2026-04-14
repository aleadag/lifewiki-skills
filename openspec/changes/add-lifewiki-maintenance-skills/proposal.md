## Why

The current repository has no lifewiki-specific agent skills even though the target vault already follows a stable Obsidian workflow template with daily notes, PARA folders, and `_Sources`-based read-it-later capture. Defining those workflows as reusable skills now will let agents maintain the wiki consistently instead of improvising note locations, formats, and review flows on each task.

## What Changes

- Add a Markdown-first skill set for maintaining a lifewiki built on the Obsidian workflow template.
- Define capture behavior for daily-note entries so agents write only to authored sections such as `## Notes 📝` and `## Inbox 📥`.
- Define GTD inbox capture behavior that appends actionable items to the current daily note rather than creating ad hoc inbox files.
- Define read-it-later capture behavior that stores fetched article content as Markdown notes in `_Sources/`, tracks unread items in a maintained reading list, and records capture in the daily note inbox.
- Package the repository’s local skills together with curated upstream Obsidian skills from `kepano/obsidian-skills` through `flake.nix`.

## Capabilities

### New Capabilities
- `daily-note-capture`: Capture journal-style notes and inbox entries into the correct authored sections of the current daily note.
- `read-it-later-capture`: Save links for later reading by creating `_Sources` notes with extracted content and maintaining a reviewable reading queue.
- `lifewiki-skill-packaging`: Expose local lifewiki skills and imported upstream Obsidian skills as part of the flake-defined plugin package.

### Modified Capabilities

None.

## Impact

- Adds new skill documentation and supporting assets for lifewiki maintenance workflows.
- Adds new OpenSpec capability specs for daily note capture, read-it-later capture, and skill packaging.
- Updates `flake.nix` to fetch and package upstream Obsidian skills alongside local skills.
- Shapes future implementation around the existing vault structure in `~/Lifewiki` and the Obsidian workflow template.
