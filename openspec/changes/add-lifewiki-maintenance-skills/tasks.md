## 1. Skill scaffolding

- [x] 1.1 Create local skill directories and `SKILL.md` files for `capture-daily-note`, `capture-gtd-inbox`, `capture-read-it-later`, and `review-read-it-later`
- [x] 1.2 Document the shared vault assumptions for `~/Lifewiki`, daily note naming, required headings, `_Sources/`, and the read-it-later queue note
- [x] 1.3 Add any supporting templates or helper scripts needed to keep Markdown output consistent across the lifewiki skills

## 2. Daily note capture workflows

- [x] 2.1 Implement the daily-note capture skill so it resolves today’s note at `-Daily-Notes/YYYY-MM-DD.md`
- [x] 2.2 Implement section-targeted append behavior that writes to `## Notes 📝` by default and supports explicit `## Inbox 📥` targeting
- [x] 2.3 Add clear failure handling when the expected daily note or required section headings are missing

## 3. Read-it-later workflows

- [x] 3.1 Implement read-it-later capture instructions for creating canonical `_Sources/` notes with normalized metadata and source URLs
- [x] 3.2 Implement queue-maintenance instructions for adding and updating Markdown task entries that track unread and in-progress reading items
- [x] 3.3 Define same-day read-it-later capture without duplicating queue entries as daily-note todo items

## 4. Packaging and verification

- [x] 4.1 Update `flake.nix` to package the local lifewiki skills in the plugin output
- [x] 4.2 Add a pinned upstream input for `kepano/obsidian-skills` and include the selected upstream skills in the packaged output
- [x] 4.3 Validate the packaged output and review the skill docs against the OpenSpec requirements before marking the change ready for apply
