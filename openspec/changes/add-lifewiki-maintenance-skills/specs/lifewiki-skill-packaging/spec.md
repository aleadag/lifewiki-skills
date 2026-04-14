## ADDED Requirements

### Requirement: Flake packaging exposes local lifewiki skills
The system SHALL package the repository’s local lifewiki skills through `flake.nix` so they can be consumed as part of the plugin output.

#### Scenario: Evaluate the local flake output
- **WHEN** a consumer evaluates the flake-defined plugin package
- **THEN** the package includes the local skill paths required for lifewiki maintenance workflows

### Requirement: Flake packaging includes upstream Obsidian skills
The system SHALL fetch and package skills from `kepano/obsidian-skills` as part of the same flake-defined plugin output.

#### Scenario: Evaluate the plugin with upstream skills enabled
- **WHEN** a consumer inspects the packaged skill list from the flake output
- **THEN** the output includes both local lifewiki skills and the selected upstream Obsidian skills

### Requirement: Upstream skill source is pinned and explicit
The system SHALL declare the upstream Obsidian skills repository as a pinned flake input so packaged skill provenance is reproducible.

#### Scenario: Review flake inputs
- **WHEN** a maintainer inspects `flake.nix` and the lockfile
- **THEN** the upstream Obsidian skills source is identifiable as a pinned dependency rather than an implicit runtime fetch
