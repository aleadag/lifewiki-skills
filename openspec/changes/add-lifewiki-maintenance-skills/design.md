## Context

This repository is currently an OpenSpec workspace with a minimal `flake.nix` stub and no lifewiki-specific skills. The target Obsidian vault at `~/Lifewiki` follows the obsidian-workflow-template structure: daily notes live in `-Daily-Notes/`, project and area notes follow PARA folders, and read-it-later content is stored as Markdown in `_Sources/`. The new skill set must be Markdown-first, meaning skills operate by reading and editing vault files directly rather than depending on Obsidian plugins or runtime APIs.

The requested workflows span three areas: writing notes into the current daily note, capturing GTD inbox items into the daily note’s authored inbox section, and preserving read-it-later links as source notes plus a maintainable queue. In addition, the repository must package curated upstream Obsidian skills from `kepano/obsidian-skills` through `flake.nix` so those skills can be distributed alongside the new local skills.

## Goals / Non-Goals

**Goals:**
- Define a stable set of lifewiki skills that map directly onto the existing vault structure.
- Ensure daily-note capture targets authored sections such as `## Notes 📝` and `## Inbox 📥`, never query-generated log sections.
- Define read-it-later behavior around `_Sources/` as the canonical store for fetched content while also keeping a reviewable backlog.
- Package local and upstream Obsidian skills together in the flake output so downstream users get one installable bundle.

**Non-Goals:**
- Reproducing Omnivore or plugin-driven sync behavior inside Obsidian.
- Changing the vault’s existing templates, folder layout, or task query conventions.
- Implementing browser automation, authenticated web clipping, or rich article parsing beyond what local tooling can support.
- Designing general-purpose Obsidian skills unrelated to the lifewiki maintenance workflows.

## Decisions

### Use vault-aware, Markdown-first skills

The new skills will treat the vault as the system of record and will edit Markdown files directly. This matches the user’s preference to avoid plugin coupling and keeps the workflows executable in a terminal-only environment.

Alternative considered: a hybrid skill set that triggers Obsidian plugins or existing `_Scripts/*.js` helpers. This was rejected because it would make the skills depend on interactive Obsidian state and drift away from the requested Markdown-first constraint.

### Model daily note capture as section-targeted append operations

`capture-daily-note` and `capture-gtd-inbox` will share a common understanding of the daily note structure but remain distinct skills. The daily note skill writes note content to `## Notes 📝` by default and may target `## Inbox 📥` when explicitly asked. The inbox skill always writes actionable entries into `## Inbox 📥`.

Alternative considered: a single generic “capture” skill. This was rejected because the operational distinction between authored notes and GTD inbox items matters to the user and should remain explicit in the skill surface.

### Treat `_Sources/` notes as the canonical read-it-later record

Each captured link will produce one Markdown note in `_Sources/` containing normalized metadata, the source URL, capture timestamp, and fetched article content or a documented fetch failure. The backlog itself will be maintained separately as a queue of tasks linking to those source notes so review and processing do not depend on browsing the `_Sources/` folder manually.

Alternative considered: storing only a task or only a queue note. This was rejected because it loses the template’s core advantage of searchable saved content in the vault.

### Maintain the read-it-later queue in a dedicated Markdown index

The queue will live in a stable Markdown note rather than daily-note inbox entries. A same-day daily note may include a non-task note or link when useful, but the dedicated queue is the durable review surface for unread, in-progress, and completed items.

Alternative considered: using daily-note inbox tasks as the queue or as a duplicate intake record. This was rejected because items would become fragmented across dates, harder to review systematically, and duplicated in task queries.

### Package upstream Obsidian skills as a flake input

`flake.nix` will fetch `kepano/obsidian-skills` as a pinned input and expose its relevant skill paths alongside local skills in the plugin output. This keeps upstream provenance explicit and makes updates auditable.

Alternative considered: copying upstream skills into the repository. This was rejected because vendoring would create avoidable drift and maintenance overhead.

## Risks / Trade-offs

- [Section matching in daily notes may be brittle if template headings change] → Mitigation: define exact heading contracts in the specs and fail clearly when a required section is missing.
- [Fetched link content may be incomplete or unavailable for some URLs] → Mitigation: require source-note creation even on partial failure, with metadata and an explicit capture status recorded.
- [A dedicated read-it-later queue introduces a second record alongside the `_Sources/` note set] → Mitigation: treat the queue as an index that links to canonical source notes rather than storing duplicate article content.
- [Upstream skill packaging can break if the external repository structure changes] → Mitigation: pin the upstream revision in the flake and isolate mapping logic to a small packaging surface.
