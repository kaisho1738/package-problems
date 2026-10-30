# Package Problems — GDD v0.4 review

**Date:** 2026-10-30  
**Current draft:** [GDD v0.4](Package_Problems_GDD_v0.4_Development_Refinement.md)  
**Historical source:** [GDD v0.3](Package_Problems_GDD_v0.3_Three_Strikes.md), preserved unchanged.

The core concept is intact: team instances, on-foot delivery, endless progression, fifth-delivery crises, and three shared strikes. During this review, the owner confirmed that each mission has both a package HP bar and a time limit: either 0 HP or deadline expiry fails it. The largest remaining development risks are fair damage/time tuning and behavior around retries, recovery, equipment, rewards, and team state. v0.4 supplies concrete proposed defaults and identifies what still needs a decision or measured evidence.

## 1. Ambiguities and omissions addressed

| Priority | v0.3 issue | v0.4 resolution | Location |
|---|---|---|---|
| P0 | Fragile cargo can reach zero integrity and still deliver, while zero also triggers destruction; deadlines are optional/unclear. | Owner confirmed BOTH failure conditions for every mission: 0 package HP OR time expiry. Add HP to Standard and Fragile, a hard countdown, and one-strike handling for simultaneous causes. | §§5, 11; DEC-013; OPEN-003/004 resolved |
| P0 | “Every fifth successful delivery” can mean an event during #5 or after it. | Crisis runs during the attempt numbered 5/10/15/etc.; it is prepared before that success. Define depth, delivery, contract, and attempt separately. | §0.2 |
| P0 | Exact retry content and state resets are unclear. | Same number/template/weather/targets, fresh attempt ID/package/timer; retained wallet and unused gear; no easier reroll. | §§3.1, 11.4 |
| P0 | “All players ready” can stall forever; “active players” is undefined. | Separate run members, deployed participants, and Away members. Specify readiness prompts, opt-out, and no forced start. | §§0.2, 2.2 |
| P0 | AFK exclusion could let a single player force a shared-strike abandon. | All connected deployed participants must consent; nonresponse cancels; roster changes reset voting. | §9 |
| P0 | “Place in a drop zone” does not specify automatic or explicit delivery, handoff consent, or conflict behavior. | Explicit context delivery; precise carried/dropped acceptance; request-and-accept handoff; clear invalid-action feedback. | §4.2 |
| P0 | Recovery penalty, checkpoint, respawn, and bug rollback are vague. | No healing/shortcut; prior validated checkpoint; defined fallback/cancellation; exact gear restoration on full cancellation only. | §§4.3–4.4, 8.4 |
| P0 | A technical cancellation and recovery share a terminal/nonterminal description. | Recovery continues the same attempt; cancellation closes it and creates a new attempt after preparation. | §§0.2, 11.2 |
| P0 | “First callback wins” makes simultaneous destruction/delivery dependent on scheduling. | Proposed server event ordering and same-step priority, with a single terminal guard. | §11.3; OPEN-023 |
| P0 | Persistence promises can imply guaranteed progress even during service failure. | Separate earned, pending, and acknowledged saves; failed-load protection; pending-save depot hold; no lossless-outage promise. | §10 |
| P1 | Rain Cover is a required shop item but its only useful mechanic is optional. | Defer water exposure and Rain Cover together; retain Boots and Foam in the base MVP. | §§5.2, 8.4, 14 |
| P1 | Equipment slots, ownership, stacking, charge use, expiry, and refunds are not exact. | Two slots, no stockpile/duplicate type, wearer-only Boots, parcel-wide nonstacking Foam, exact rollback snapshot. | §8.4 |
| P1 | Reward/rating/streak formulas and participation are missing. | One bounded team formula, worked payouts, explicit roster-based eligibility, acknowledged AFK risk. | §§8.2–8.3 |
| P1 | Permanent equipment/contract unlocks conflict with shared access for new friends. | Cosmetic-only Reputation in base MVP; core packages/tools available through onboarding. | §8.1 |
| P1 | Economy text assumes finite gear prevents long-run inflation. | Show that proposed income exceeds full replenishment cost; treat surplus as an open balance issue. | §8.5 |
| P1 | “8–12 templates” does not explain what the team will build or teach. | Ten concrete candidates, first-four ordering, crisis sequence, free solo solutions, and explicit validation status. | §3.3 |
| P1 | Difficulty uses “depth / next delivery” interchangeably. | Tier selection uses next delivery number; all raw severity capped at tier 4. | §3.2 |
| P1 | Partly hidden next route conflicts with informed preparation. | Reveal the full current contract before buying; later contracts remain unknown. | §§2.2, 3 |
| P1 | “Mobile playable” lacks input, readability, and test coverage. | Proposed input map, context priority, landscape/safe-area coverage, reduced motion and text/audio requirements. | §§4.1, 12, 17 |
| P1 | Teleport failures, partial arrivals, leader departure, and save loading have no player flow. | Explicit wait/continue/return, frozen admission, no leader dependency, and safe error states. | §§2.1, 10 |
| P1 | Standard parcels with no deadline may never naturally fail. | Every mission now has HP and a hard deadline; Standard is more durable, and introductory routes get generous measured time limits. | §§3.3, 5 |
| P1 | Public matching is intended but optional in the release candidate. | Allow solo/friends closed tests; require same-lobby matching before unrestricted public release. | §14 |
| P2 | Acceptance checks mix owner decisions, technical invariants, and proposals. | Separate those categories; preserve DEC-001–012, GDD-001–029, OPEN-001–017; add DEC-013 and missing tests/decisions. | §§0, 16, 20 |

## 2. Proposed scope changes requiring attention

**Confirmed during this review:** Every mission fails at 0 package HP or when its delivery time limit expires. Both conditions are recorded in DEC-013. The original zero-HP-but-deliverable rule and the initial rating-only timer recommendation are superseded. Proposed default HP is 100 for both parcel types, with lower impact damage for Standard; exact values and deadlines need playtesting.

The following remain recommendations, not silently approved changes:

- **Deadline tuning and recovery:** Use measured solo/mobile route times, a separate optional bonus target, and neutral pauses only for verified server faults. These details implement the confirmed failure model but still need testing.
- **Two useful base tools:** Rain Cover moves with water sensitivity to deferred scope.
- **Inflatable deferred:** Removes its ambiguous “MVP YES*” position. A later focused prototype can justify adding it.
- **Cosmetic-only permanent unlocks:** Avoids party compatibility and necessity-gating problems during the first release.
- **Predictable prepared contract:** Full current briefing before spending; no player-selected contract rerolls.
- **Public-release matchmaking gate:** Same-lobby fill fulfills the existing access intent; cross-server queues remain deferred.
- **Transparent participation:** Ready/deployed roster eligibility replaces undefined “reasonably participating.” This knowingly tolerates some AFK farming risk.
- **Save-delay hold:** Finish the active attempt, then hold further starts at the depot while remaining members' awards are pending. Review the reliability/usability tradeoff at M5.

## 3. Decisions to make next

1. **Tune the confirmed failure model (OPEN-018).** OPEN-003/004 are resolved: both HP depletion and deadline expiry fail. Measure fair damage thresholds and time limits; verify simultaneous failure costs one strike, exact-expiry deliveries fail, and stale timers cannot affect retries.
2. **Select run-resolution defaults (OPEN-001/002/005/006/023).** No refill, same-contract retry, neutral personal exit, unanimous abandon, and deterministic simultaneous-outcome ordering.
3. **Measure handling (OPEN-018/021).** Safe impact thresholds, carry clearance, avatar envelope, and rating times depend on the prototype. Pick actual test devices before declaring minimum-device support.
4. **Validate loadout economics (OPEN-009/020).** Two slots can make buying both tools automatic; test one versus two slots before adding more equipment.
5. **Review session/save behavior (OPEN-019/022).** Test Away prompts and pending-save holds with real players and simulated service failures.

The dual failure conditions are confirmed; the remaining new defaults are proposals. Production milestones must explicitly select their consequential unresolved rules; prices and visual polish can remain tunable.

## 4. Improvements worth testing

| Order | Experiment | Evidence to collect |
|---|---|---|
| First | Carry/place with no progression, using the prototype-fast one-question brief. | Uncoached action discovery, repeated voluntary play, and the exact sources of handling frustration. |
| Next | HP/deadline coaching before a crisis. | Whether players understand both failure causes, predict damage, and finish within a free-route deadline; normal handling must not produce false damage. |
| Next | Full forecast and free-route preview before purchases. | Whether players can explain a tool choice and finish with no equipment. |
| After the loop works | One-slot versus two-slot loadouts. | Purchase diversity, unspent coins, and whether choice feels useful rather than restrictive. |
| Later | A simple route/handoff ping. | Whether mobile/non-voice teams cooperate better without added menu burden. |
| Later | New route catches using existing mechanics. | Repetition complaints at depth 11–20 before spending effort on new weather or package physics. |

## 5. Review method and limits

Applied local skills: `router`, `level-design`, `prototype-fast`, `game-ui-ux`, `save-systems`, `roblox-datastores`, and `roblox-networking`. Their guidance informed measured geometry, teach-before-test pacing, small prototype gates, accessible UI, clear server ownership, and resilient progress handling.

Checked the revised document for ID continuity, section references, local links, table shape, and worked reward calculations. The v0.3 source remains unchanged. Official Roblox references are linked beside the relevant constraints in v0.4 and were inspected on 2026-10-30. No game code, live Studio state, or gameplay tests were created or run; all fun, balance, device-performance, and reliability gates still require implementation and testing.
