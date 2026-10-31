# Session continuity

At the start of project work:

1. Read `README.md`, `state/README.md`, and the active milestone's `Summary.md`.
2. Read the relevant GDD, roadmap section, and local `.agents/skills/` instructions for the task.
3. Before game edits, inspect the current Studio place. Summary entries describe the last observed state, not guaranteed live state. Studio is the game source of truth; local source snapshots do not synchronize automatically.

Before ending a session that changes project work:

- Update the active milestone's `Summary.md`: current status, changes, decisions, executed checks, unresolved issues, and the precise next action.
- Append a dated session entry; preserve earlier entries and distinguish implemented, tested, pending, and unverified work. Link detailed evidence rather than duplicating it.
- Update `state/README.md` if the active milestone or its status changes. Keep roadmap status consistent with actual acceptance evidence.
- On milestone completion, record the exit-gate evidence, saved build/place checkpoint, and next milestone entry conditions. Never mark a milestone Done solely because its code exists.

Use `state/Summary_TEMPLATE.md` for new milestones. Update these records for the work actually completed; do not invent tests, native place saves, approvals, or future progress.
