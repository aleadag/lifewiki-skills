## ADDED Requirements

### Requirement: Daily note capture targets authored sections
The system SHALL provide a daily-note capture capability that locates the current daily note in the lifewiki vault and appends new content only to authored sections of that note.

#### Scenario: Capture a note entry into today’s daily note
- **WHEN** an agent is asked to record a daily note entry without a section override
- **THEN** the system appends the entry under the `## Notes 📝` section of the current daily note

#### Scenario: Avoid query-driven log sections
- **WHEN** an agent records a daily note entry
- **THEN** the system MUST NOT write into the `Logs` section or any other query-generated section of the daily note

### Requirement: Daily note capture resolves the active note by vault date convention
The system SHALL resolve the current daily note using the vault’s `-Daily-Notes/YYYY-MM-DD.md` naming convention.

#### Scenario: Daily note exists for today
- **WHEN** the expected file for the current date already exists
- **THEN** the system writes to that file instead of creating another dated note

#### Scenario: Daily note is missing for today
- **WHEN** the expected file for the current date does not exist
- **THEN** the system MUST fail with an explicit message that identifies the missing path and required template contract

### Requirement: Daily note capture supports explicit inbox targeting
The system SHALL allow callers to direct captured content to the `## Inbox 📥` section when the user intends the content to be processed as inbox material rather than as a journal note.

#### Scenario: Capture with inbox target
- **WHEN** an agent invokes daily-note capture with an inbox section target
- **THEN** the system appends the content under `## Inbox 📥` in the current daily note
