## ADDED Requirements

### Requirement: Read-it-later capture creates canonical source notes
The system SHALL capture each saved link as a Markdown note in the vault’s `_Sources/` directory so the vault retains a searchable local copy of the source.

#### Scenario: Save a new link for later reading
- **WHEN** an agent is asked to save a URL for read-it-later processing
- **THEN** the system creates one `_Sources` note for that URL with the source link and capture metadata

### Requirement: Source notes preserve fetched content status
The system SHALL record whether content extraction succeeded, partially succeeded, or failed, and SHALL preserve any fetched article content in the `_Sources` note.

#### Scenario: Successful content capture
- **WHEN** the system can retrieve article metadata and body content from the URL
- **THEN** the `_Sources` note includes normalized metadata and the captured content body

#### Scenario: Content fetch fails
- **WHEN** the system cannot retrieve article content from the URL
- **THEN** the `_Sources` note is still created with the original URL and an explicit failed-capture status

### Requirement: Read-it-later capture maintains a review queue
The system SHALL maintain a dedicated read-it-later queue in Markdown that tracks unread and in-progress items by linking to their `_Sources` notes.

#### Scenario: Register a new unread item
- **WHEN** a new read-it-later source note is created
- **THEN** the system adds a corresponding unread queue entry that links to the `_Sources` note

#### Scenario: Update reading state
- **WHEN** an agent reviews or finishes a queued read-it-later item
- **THEN** the system updates the queue entry to reflect the new reading state without duplicating article content outside `_Sources`

### Requirement: Read-it-later capture records same-day intake in the daily inbox
The system SHALL add a daily-note inbox entry for each newly captured read-it-later item so same-day review includes the intake event.

#### Scenario: Link captured on the current day
- **WHEN** a read-it-later URL is captured successfully or partially successfully
- **THEN** the system appends an inbox item to the current daily note that references the queued reading item
