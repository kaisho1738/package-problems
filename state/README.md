# Session handoff — start here

**Last updated:** 2026-10-31 (Asia/Manila).  
**Active milestone:** M1 — Cooperative relay slice. **Status:** Verify — relay implementation present; acceptance incomplete.  
**Read next:** [M1 summary](m1/Summary.md).

The original carry slice was implemented in unpublished Place1; the current named place is `139622891678280` and now contains the relay extension. Solo, multiplayer, repeated-cycle, route, and phone-layout checks have evidence. Fresh-player testing and human latency/touch assessment remain open. The native pre-extension backup is verified; the final relay native save remains pending.

**Next session:** Read [relay evidence](m1/RelayEvidence.md) and the active summary. Complete human fresh-player/latency and touch/aimed-catch checks, remaining edge cases, and final checkpoint verification. The native pre-extension backup is at repository-root `M1-before-relay.rbxl`; relay code is implemented in place `139622891678280`. M1 remains Verify; do not start M2.

| Milestone | Summary | Last recorded status |
|---|---|---|
| M1 — Cooperative relay slice | [M1 summary](m1/Summary.md) | Verify — relay implementation present; human/input/edge-case acceptance incomplete. |
| M2 — Run and station flow | [M2 summary](m2/Summary.md) | Not started. |
| M3 — Connected world and environmental delivery | [M3 summary](m3/Summary.md) | Not started. |
| M4 — Equipment economy | [M4 summary](m4/Summary.md) | Not started. |
| M5 — Persistent progress | [M5 summary](m5/Summary.md) | Not started. |
| M6 — Lobby and team sessions | [M6 summary](m6/Summary.md) | Not started. |
| M7 — Public release readiness | [M7 summary](m7/Summary.md) | Not started. |
| M8 — Cosmetic monetization | [M8 summary](m8/Summary.md) | Future after M7; scope boundary recorded, detailed product design pending. |

The user agreed to leave cosmetic monetization after M7 as M8. The revised v0.1 roadmap retains M1–M8 IDs, splits M3 into four gated stages, and records an M8 scope boundary; no M8 implementation or product/pricing design has begun.

## Milestone revision

M1 proves the full relay loop; M2 proves run/station state using placeholders; M3A builds the connected two-district world and tests streaming early; M3B adds measured HP/deadlines; M3C adds biome obstacles/weather; M3D adds one major event. M4–M6 integrate economy, persistence, and real team sessions; M7 completes/certifies the existing world. M8 remains future. No milestone has passed a new gate through this planning update.

## Latest design amendment

The GDD now specifies a connected warehouse/biome world with satellite pickups, a two-district initial MVP, and major events after every five successful deliveries. Four districts are the long-term goal. Existing M1 depot-reset evidence describes a test harness; world integration is pending, with no milestone status change. See the [review amendment](../Package_Problems_GDD_v0.4_Review.md#7-interconnected-world-and-environmental-layers--2026-10-30).

## Recordkeeping

Maintain one summary per milestone, including a current-state snapshot and dated session log. Update it after meaningful work even if the milestone remains unfinished. On completion, retain the summary as the handoff into the next milestone. Use [the template](Summary_TEMPLATE.md) for new milestones.

Read the [roadmap](../Package_Problems_Roadmap_v0.1.md) for scope and gates, the [GDD](../Package_Problems_GDD_v0.4_Development_Refinement.md) for gameplay rules, and each summary's evidence links for verification. An old summary never overrides newer user instructions or a freshly inspected Studio state.
