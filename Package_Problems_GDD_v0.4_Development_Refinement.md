# PACKAGE PROBLEMS
## Game Design Document — Draft v0.4 — Development Refinement

**Date:** 2026-10-30  
**Platform:** Roblox; desktop and mobile first  
**Audience:** Designer, developer, Codex implementation assistant, QA/playtesters  
**Owner:** Project team, primarily one developer + Codex  
**Status:** Design review. Endless progression and three shared strikes remain confirmed. Major environmental events now trigger after each five successful deliveries. The interconnected world, central warehouse, satellite stations, and two-biome initial MVP are confirmed; the four district names/effects remain provisional. The owner additionally confirmed package HP and a delivery time limit: either 0 HP or expiry fails the mission. One-carrier cooperative relays, carrying stamina with fixed run-start player-count scaling, physics-based throwing, and assisted catching are now confirmed. Numerical balance and other unselected behavioral defaults remain proposals.
**Source:** Refines v0.3; preserves its confirmed decisions. This is a design document, not a complete technical design specification (TDS).

## 0. Decision policy and revision history

| Status | Meaning |
|---|---|
| CONFIRMED | An owner-confirmed decision carried forward from v0.3 or explicitly selected during this review; do not silently change it. |
| INVARIANT | A consistency or security requirement necessary to implement the selected design; not a newly approved product preference. |
| PROPOSED | A concrete recommendation for a bounded prototype or owner review. Every new gameplay rule and balance value in this revision has this status unless stated otherwise. |
| OPEN | A decision or measurement still needed before the affected production milestone. An explicit recommended default is provided where possible. |
| DEFERRED | Excluded from the base MVP. A later scope revision is required to add it. |

**Precedence:** Confirmed decisions below → the detailed rule in its owning section → examples. Examples cannot override rules. A proposal is not promoted to CONFIRMED by appearing in a table, acceptance test, implementation brief, or code. Resolve contradictions in the document before implementation.

**Revision history:** v0.2 replaced a fixed ten-delivery ending with endless runs and fifth-delivery crises. v0.3 confirmed three shared strikes and termination on the third legitimate failure. v0.4 resolves conflicting failure descriptions, separates logical deliveries from attempts, specifies missing interaction/economy/session behavior, narrows base MVP scope, and adds acceptance criteria and review gates. During this review, the owner confirmed BOTH failure conditions: the package reaches 0 HP OR the delivery time limit expires. This replaces the initial rating-only timer recommendation. v0.3 is retained unchanged for comparison. The 2026-10-30 cooperative-handling amendment incorporates the finalized task and [Parcel Teamwork Mechanics](https://chatgpt.com/c/6ae49ba5-ec74-83ec-812b-ead4cec17c67): universal carrying stamina and carry–handoff–throw–catch replace the earlier no-stamina/no-throw MVP scope. Earlier chat alternatives (special-only fatigue, multiplayer-required contracts, and extra player-count contract difficulty) are not adopted. The 45/25/20/18-second values are provisional, not validated balance.

**World amendment — 2026-10-30:** The owner’s world/biome task replaces mandatory central-depot returns with local satellite pickups in one interconnected island/city per team run. It explicitly places major events after successes 5/10/15/20, superseding the earlier during-delivery crisis timing. Four districts are the intended full world; two districts are the initial MVP. Cooperative handling and failure mechanics remain unchanged.

### 0.1 Confirmed decisions

| ID | Decision |
|---|---|
| DEC-001 | Primarily one developer + Codex. |
| DEC-002 | Balanced comedic physics and skillful cooperation. |
| DEC-003 | Separate instance for the team, not one large persistent public delivery world. |
| DEC-004 | Continuous run consisting of short, structured deliveries in one shared interconnected delivery island/city for the entire run. |
| DEC-005 | On-foot pickup, carry, drop, handoff, throw, and catch; no delivery vehicles initially. |
| DEC-006 | Long-term variety comes from harder contracts, package behaviors, and adaptation. |
| DEC-007 | Flexible schedule; validate gameplay quality before feature expansion. |
| DEC-008 | Successful deliveries award in-run coins used to purchase adaptation equipment. |
| DEC-009 | A major environmental event triggers after each five successfully completed deliveries, at completed depth 5, 10, 15, 20, and onward. This supersedes the earlier during-delivery timing; failures/retries do not advance the event schedule. |
| DEC-010 | Solo, friend teams, and players grouped through matchmaking are intended access paths. |
| DEC-011 | No fixed final delivery; continue until the run ends by choice or failure. |
| DEC-012 | Each run begins with 3 shared Company Strikes. Each legitimate failed attempt consumes exactly one team strike; the third failure ends the run. |
| DEC-013 | Every mission has a package HP bar and a delivery time limit. Reaching 0 HP OR failing to deliver within the limit fails the mission. Either cause consumes one shared strike; simultaneous causes still consume only one. Confirmed by the owner during v0.4 review. |
| DEC-014 | Only one player physically carries a given parcel at a time. Safe direct handoffs and physics-based throws with forgiving catch assist enable cooperative relays; a successful catch avoids catch impact damage. |
| DEC-015 | Carrying continuously drains stamina; running while carrying drains faster. Not carrying regenerates stamina. At zero, release or transfer is required; stamina governs carrying, not general movement. |
| DEC-016 | Fix stamina scaling from participating player count at run start for the entire run. Solo gets greater endurance; 45/25/20/18 seconds for 1/2/3/4 players are initial playtest values. Regeneration rates and modifiers remain open. |
| DEC-017 | Standard deliveries remain solo-achievable through placement, recovery of stamina, and route planning. Teams gain efficiency through relays, catch positioning, route preparation, and obstacle interaction; no mandatory classes or fixed roles. |
| DEC-018 | Exhaustion and missed catches do not directly consume Company Strikes. Actual contract failure still does; basic durability and missed-catch consequences are MVP scope. Advanced package-specific handling and complex stamina modifiers remain later work. |
| DEC-019 | One interconnected island/city per team run, centered on the company warehouse; stay in that world throughout the run rather than loading a new course per delivery. Use instance streaming and optimized assets. |
| DEC-020 | Intended full world: four connected biome districts, each with multiple destinations and at least one satellite parcel station. District names and effects are provisional. |
| DEC-021 | Satellite stations provide subsequent pickups without requiring return to the central warehouse after each delivery. Contracts can stay within a district or cross districts. |
| DEC-022 | Environmental difficulty combines persistent location effects, temporary weather, and major events after every five successes. Escalate through readable, validated changes to routes/conditions, not just numerical increases. |
| DEC-023 | Initial environment MVP: central warehouse, two districts with multiple destinations and satellite stations, basic biome obstacles, simple weather, and one major event. Expand to four districts after validating the loop. |

### 0.2 Vocabulary and counting

| Term | Exact meaning |
|---|---|
| Run | One team session with a unique `runId`, depth, and shared strike budget. |
| Depth / completedContracts | Number of successfully resolved deliveries in this run; starts at 0. |
| Delivery number | `completedContracts + 1`; retries keep this number. |
| Contract | The chosen package, destination, route rules, weather, rating targets, and failure conditions for one delivery number. |
| Attempt | One execution of that contract; each start or retry receives a new `attemptId`. |
| Major event / crisis | An environmental disruption triggered once when a success advances completed depth to a positive multiple of 5. Duration, footprint, and contract exposure are OPEN-031. |
| Crisis-affected contract | A contract exposed to a major event; its tag comes from the selected event lifecycle, never `deliveryNumber % 5 == 0`. |
| Warehouse / depot | Central company hub and initial run pickup. The old M1 depot is a prototype representation. |
| Satellite station | Local parcel pickup/preparation point in a biome; each district has at least one. |
| Persistent world | The same traversable world across deliveries within a run; not a promise of saved world state across sessions or a shared public world. |
| Recovery | Repositioning/restoring a valid active attempt; not a terminal outcome and not a retry. |
| Technical cancellation | Terminal neutral outcome for an invalid attempt; no strike, success award, or depth increase. A replacement has a new attempt ID. |
| Run member | An admitted player who has not exited or disconnected. |
| Deployed participant | A ready run member included when the current attempt starts. |
| Route catch | An authored obstacle or complication; distinct from catching a thrown parcel. |
| Parcel catch | Intercepting a thrown parcel and becoming its sole carrier without grounding it. |
| Away member | A run member waiting safely at a preparation location, excluded from the current attempt and its rewards. |

**Example:** At depth 4, the next attempt is delivery 5. Failure leaves depth 4 and triggers no milestone event. Success sets depth 5 and triggers the first major event once; delivery 6 is next. Its exposure depends on the selected event lifecycle. A failed delivery 6 keeps depth 5 and does not retrigger that event. The same rule applies after successes 10/15/20.

### 0.3 Scope and approval boundary

Use only the active milestone (§14). Configure proposed prices, timing, damage, capacities, and modifiers centrally; the confirmed initial strike count is 3. Unapproved failure mechanics may be tested in an isolated prototype with simulated rewards. They must not silently become production rules. This revision authorizes no game implementation or publishing by itself.

## 1. High concept and player promise

**Working title:** Package Problems. **Tagline:** Deliver the undeliverable.  
**Genre:** Cooperative physics comedy with short delivery challenges and an endless run structure.

A proposed team of 1–4 delivery workers enters its own interconnected delivery island/city, relays unusual packages through readable obstacles using carry, handoff, throw, and catch, and buys temporary equipment with delivery earnings. A major environmental disruption follows every five successful deliveries; the warehouse and satellite stations sustain the run across connected districts. The goal is to complete as many deliveries as the team wants before losing three shared strikes. Permanent progress is earned along the way; departure is not a forfeiture mechanic.

The five pillars are package handling, controlled chaos, simple cooperation, preparation, and respect for player time. Every mandatory route must work solo and without purchased equipment. Comedy comes from recoverable mishaps and readable reactions; unfair physics failures undermine the premise.

**Session targets — PROPOSED:** First delivery 1–3 minutes; ordinary deliveries 2–4 minutes; crises 3–5 minutes; preparation usually 20–45 seconds. Three to five deliveries should feel worthwhile. These are pacing targets, not countdowns or forced session lengths.

**Non-goals:** Vehicles, combat/PvP theft, mandatory dual carrying, procedural city generation, permanent power grind, trading, global leaderboards, paid gameplay boosts, or a final boss at delivery 10. Broad content expansion and monetization are not prototype prerequisites.

## 2. Session structure and readiness — PROPOSED details

### 2.1 Formation, admission, and departures

The public lobby offers Solo and Friends/Party; a simple same-lobby Find Team path is required before unrestricted public release (§14). Every party member readies before launch. A party leader manages invitations but cannot override readiness, spend others' coins, or impose a strike.

Freeze the launch roster before transfer to a team-only run. Start at the central warehouse only after arrival and profile loading complete. Use a provisional 60-second arrival timeout. If a member fails to arrive, show the missing member and offer the arrived members **Wait again**, **Continue with arrived players** (unanimous), or individual **Return to Lobby**. No attempt, gear charge, or strike starts during loading. Continuing closes admission for that launch; a late arrival returns safely to the lobby. Returning/failed teleports must not trap players in a loading screen.

No new members or disconnected-player rejoin in the base MVP. Roblox character respawn is not a disconnect and does not remove run membership. Departure by the party leader does not end the run; station readiness works without a leader. When everyone has left, clean up the run as `TeamEmpty` with no strike.

### 2.2 Warehouse and satellite preparation

1. Reveal the complete next contract: pickup station, destination and biome, connecting route, route catch, package, biome/weather/event effects, free alternative, failure conditions, and rating targets. The briefing cannot change after purchases without a clear correction and fresh readiness.
2. Keep players in the same world after a result; subsequent pickups may use a satellite station instead of a mandatory warehouse return. Disable package damage during preparation. Preserve persistent biome characteristics; reset only attempt-owned mechanisms as appropriate, and apply the selected weather/event lifecycle rather than resetting the whole environment. Station selection, travel, and gathering details are OPEN-030.
3. Let each player purchase where a shop is available, equip, and select **Ready**, **Away**, or **Leave Run**. Purchases or loadout changes clear that player's Ready status.
4. All non-Away members must be Ready. Show a cancellable 3-second start countdown; anyone becoming unready cancels it. No majority-start mechanic.
5. A member who has neither readied nor explicitly selected Away after 90 seconds receives a 15-second prompt. If unanswered, mark that member Away at the preparation location; do not eject them or consume a strike. Explicitly choosing Keep Preparing restarts their timer. These thresholds are tunable.
6. Require at least one Ready player. Freeze deployed participants and loadouts at attempt start. Away members cannot interact with the live package or receive that attempt's awards; they can ready for the following attempt.

The 20–45-second pacing target is not an automatic start deadline. An intentionally unready teammate can still delay the group; individual exit remains available. A host-force-start or vote-kick is excluded from this MVP.

### 2.3 Lifecycle

```text
Lobby → Loading → StationPreparation → ContractActive → Result → StationPreparation
                                                └→ third failure → RunSummary
TechnicalCancellation → StationPreparation (same delivery, new attempt ID)
IndividualExit → personal summary / lobby; other members continue
No members → TeamEmpty / cleanup
Service shutdown → ServerInterruption / best-effort save and cleanup
```

Result presentation lasts a proposed 5 seconds or until all deployed members dismiss it. It cannot hold the team indefinitely. Preparation, results, and loading never count toward a delivery timer. Opening a personal menu does not pause a multiplayer attempt; display that behavior.

## 3. Core loop and contract selection

**Loop:** Preview → prepare → pick up → carry / manage stamina / hand off or throw and catch / navigate / assist / recover → deliver → receive result and rewards → move to the next warehouse/satellite pickup and prepare again, or leave.

One active package, one destination, and one active attempt per run in the base MVP. The director selects the contract; players choose routes and equipment, not a contract reroll. A future contract-choice board is deferred.

### 3.1 Required authored contract data — INVARIANT structure

| Field | Required contents |
|---|---|
| Identity | Stable template ID, version, run configuration version, delivery number, attempt ID. |
| Eligibility | Tier, compatible biome/weather/event states and crisis-affected tag, package ID, allowed player counts, taught prerequisites. |
| World | Warehouse/satellite station ID, source and destination biome IDs, destination zone, connecting route links, ordered safe recovery checkpoints, primary and free alternate routes. |
| Challenge | One introductory catch or a tested set of compatible catches; the compatible biome, weather, and major-event modifiers with readable counterplay. |
| Failure | Both `PACKAGE_DESTROYED` at 0 HP and `DEADLINE_EXPIRED` at the time limit; configured starting HP, impact thresholds, and hardDeadline; any proposed abandon rule stated separately. |
| Rating | Good and slow time targets, quality metric, one optional objective or none. |
| Presentation | Briefing text, objective marker, hazard signs, equipment suggestions, accessible cues. |
| Validation | Solo/mobile route test record, package-clearance results, version of measured carry metrics. |

Reject invalid combinations before briefing. A deterministic run seed plus template/configuration versions and selection history must reproduce a test run; a seed by itself is insufficient. Keep the current contract fixed across legitimate retries, including its target times and modifiers. A technical cancellation may replace an invalid template with a validated fallback at the same delivery number and with the same agreed event exposure; explain the change and repeat preparation.

### 3.2 Variety and difficulty — PROPOSED

| Next delivery number | Tier | Permitted complexity |
|---|---:|---|
| 1–4 | 1 | One catch; teach each required mechanic before combining it. |
| 5–9 | 2 | Up to two compatible catches; first event triggers after success 5, not at delivery 5 start. |
| 10–14 | 3 | Two familiar mechanics with a route choice. |
| 15 onward | 4, capped | Up to three tested interactions; no unlimited increases in force, damage, or timing pressure. |

Use **next delivery number**, not completed depth, to select the tier. Player count does not multiply package health, damage, required tasks, or deadlines in the base MVP. Stamina endurance does scale with run-start player count (§4.5); this does not add player-count scaling to contract difficulty. Cooperative advantages come from coordinated relays, catches, and supporting actions. A change in deployed player count never requires a new mandatory route mid-attempt.

Maintain the last three successful template IDs. Avoid recent repeats when an eligible alternative exists; relax the oldest exclusion first, then permit repetition. Retry attempts do not update this history. Select only authored compatible combinations. Select pickup/destination pairs within or across districts to encourage movement through the existing world. Variety combines destination, parcel behavior, biome, weather, and major events; never generate a new course for each delivery. Validate the combined effect load, not only each modifier in isolation. If no tested contract is compatible with an active event, block start and report a content error rather than silently skipping that event.

### 3.3 Initial content matrix — PROPOSED, not validated content

Initial content uses two selected biome districts, each with multiple destinations and at least one satellite station, connected to the central warehouse. The former five neighborhood destination names and the candidates below are reusable route concepts, not separate levels or one fixed destination per biome. Assign actual station/district/destination pairs after selecting the first two biomes (OPEN-029). Roughly ten templates remain a provisional content target; validate local and cross-biome combinations and event exposure before release.

| ID | Earliest use | Parcel / weather | Catch and solo solution |
|---|---|---|---|
| CT-01 Corner Practice | Delivery 1, then ordinary rotation | Standard / dry | Low barrier requires a drop and side-switch interaction; gate latches open so one player can retrieve parcel. |
| CT-02 Careful Corner | Delivery 2, then ordinary | Fragile / dry | Marked rough shortcut versus wide paved detour; coach gentle placement before the risky section. |
| CT-03 Shop Gate | Delivery 3, then ordinary | Standard / dry | Gate opens from a reachable switch and remains open for a solo traverse; bypass always available. |
| CT-04 Hall Steps | Delivery 4, then ordinary | Fragile / dry | Direct steps versus longer ramp; telegraph impact risk. Teach simple weather before the first major event. |
| CT-05 Rain Crossing | First event exposure after success 5; timing OPEN-031 | Fragile / rain | One wet bend and wider dry detour; no new gate mechanic. |
| CT-06 Garden Detour | Tier 2 ordinary | Standard / dry | Visible roadwork blocks the direct path; route signs lead around it without a paid tool. |
| CT-07 Apartment Turn | Tier 2 ordinary | Fragile / dry | Tight corner versus broad ramp; no mandatory precise jump. |
| CT-08 Rain Hall | Later event exposure after success 10 | Fragile / rain | Wet approach and familiar steps/ramp choice. |
| CT-09 Rain Gate | Later event exposure after success 15 | Fragile / rain | Familiar gate and wet approach; latching gate plus dry bypass stay solo-valid. |
| CT-10 Rain Workshop | Later event exposure after success 20+ | Fragile / rain | Route detour and wet bend; visible rest/checkpoint before final approach. |

Deliveries 1–4 provisionally use CT-01 through CT-04 as teaching patterns within the connected world. Delivery 5 completes before the first major event triggers. CT-05/08/09/10 are candidate event-affected route patterns for the first and later milestones, not fixed event durations or separate maps. CT-06/07 and the taught patterns provide ordinary rotation and breathing room. Keep capped tier-4 parameters and anti-repetition rules; no major event introduces an unpracticed lethal mechanic. The new biome/event assignments are unvalidated, and ordinary rain alone does not satisfy the major-event scope.

## 4. Player interactions — CONFIRMED core / PROPOSED controls and tuning

### 4.1 Movement and controls

Use a third-person camera and familiar Roblox walk/jump controls. Carrying stamina, running with higher carrying drain, physics-based throwing, and assisted catching are core MVP mechanics. Walking/running speeds and input bindings remain open; no dash or ragdoll requirement is added. Carrying reduces base walk speed to an initial 85%; tune through a measured test course before building final routes. A required route must not need a precision jump. Standardize the gameplay collision envelope across supported avatar appearances so cosmetic body size cannot break clearance.

| Action | Desktop prototype | Mobile behavior |
|---|---|---|
| Context action | E | Large contextual button with verb and target. |
| Drop | Q while carrying | Separate Drop button, spaced from interaction. |
| Throw | Binding/aim control OPEN; distinct from safe Drop. | Distinct Throw action; aim interaction OPEN. |
| Catch | Activation mode/binding OPEN; forgiving assist radius required. | Accessible assisted catch; activation mode OPEN. |
| Walk / run | Binding/mode OPEN; running raises carrying drain. | Accessible walk/run control; mode OPEN. |
| Inspect | I / package-info button | Persistent package-info button. |
| Equipment | 1 / 2 | Two slot buttons, with passive/active state. |
| Menu | Escape / on-screen menu | On-screen menu; leave confirmation separate from abandon. |

Keybinds are provisional UI defaults. Context selection highlights one target and displays its action before activation; prefer delivery at the correct zone, then a valid handoff, then an aimed object. Menu input must not also trigger a world action. No essential action requires chat, voice, rapid tapping, or a long precision hold.

### 4.2 Pickup, carry, handoff, and delivery

- Pickup requires the deployed player to be within a proposed 8 studs with an unobstructed reach and an available package. Validate on the server. First valid request wins; another player sees **Already carried**.
- A recipient requests a handoff within 8 studs; the carrier explicitly accepts within 5 seconds. Recheck range and membership at acceptance. The transfer is atomic; neither player can steal or force the parcel onto the other. Clear the request on drop, departure, or resolution.
- Drop places the parcel into the nearest valid ground position in front of the carrier, with no added throwing impulse. If blocked while stamina remains, keep carrying and show **No room to place**. At zero stamina, carrying cannot continue; the safe release/recovery fallback must be selected before implementation (OPEN-026). A low-speed placement is damage-free.
- **CONFIRMED:** Only one player physically carries the parcel at a time. Direct handoff is safe and damage-free. Preserve integrity, condition, equipment effects, and timer through handoff or catch; transfer does not refill either player’s stamina. The range/consent timings above remain proposed interaction details.
- Delivery requires an explicit context action at the correct zone; walking over or throwing a parcel into it cannot silently complete. The server validates parcel identity, destination, objectives, player reach, and credible package position. Accept either a carried package whose placement preview fits inside the zone or a dropped package resting inside it. On acceptance, snap safely to the marked pad, resolve once, and freeze further handling.
- Wrong destination or blocked placement gives feedback without a strike. An already failed or destroyed package cannot deliver. The TDS must validate movement history/route legitimacy as well as final proximity.

### 4.3 Package lifecycle and recovery

```text
AtPickupStation → Available → Carried ↔ Dropped → Delivered
                        ↓  ↑
                     Thrown (catch → Carried; landing → Dropped)
Active parcel states ↔ Recovering
Any active state → Failed / Cancelled → cleanup
```

Recovery uses the last **server-validated safe checkpoint already reached**, with the pickup point as fallback. Checkpoints are authored, on reachable routes, and never advance from an untrusted position update alone. Do not heal damage, reset the clock, replenish gear, increment depth, or award currency through recovery. Clear velocity and prevent the relocation itself from dealing damage.

Automatic recovery handles out-of-bounds parcels, invalid geometry, or a departed carrier. A deployed member can request Recover when the server finds the parcel unreachable or not moving despite attempted handling. Use a provisional 10-second request cooldown; manual requests cannot recall a valid parcel held by an active teammate. A suspected exploit is rejected or recovered safely, not converted into an invented strike cause.

Repeated recovery at the same bad location falls back to the prior checkpoint. Two failed recoveries there cancel the invalid attempt neutrally; retain the last valid integrity/gear state until cancellation rollback. Never loop recovery forever. Manual recovery has no separate score deduction in the base MVP; ordinary elapsed time continues toward bonuses and the hard deadline. Verified server-fault recovery freezes gameplay and excludes recorded downtime from both clocks (§5.2). This replaces v0.3's unspecified recovery penalty.

Throwing removes the carrier; catching assigns exactly one new carrier. Dropped/Available parcels can be picked up again. Exhaustion releases or transfers the parcel without resolving the attempt. A parcel in flight remains subject to damage, deadlines, and existing recovery rules; it cannot auto-deliver.

### 4.4 Respawn, idle carriers, and collision grief

Character reset/death returns the player to the most recent safe player checkpoint and releases/recovers the parcel there. Preserve membership, gear, coins, and existing integrity; no direct strike, no healing, and no forward shortcut. A zero-integrity failure already accepted by the server cannot be undone by respawning or leaving.

Disable player-to-player pushing and damage. Non-carriers cannot impart damaging impulses to the active parcel. If a carrier has shown no server-observed movement or valid interaction for 60 seconds, show a 15-second resume warning; if unanswered, release the parcel safely for teammates. Do not deduct a strike or remove the player from a team-abandon vote. These timers are prototype defaults, not a complete anti-cheat system. Stamina drains even while holding still; zero-stamina release takes precedence over the idle-carrier timer. Respawn/reset stamina behavior remains OPEN-025; it must not bypass the carrying constraint.

### 4.5 Carrying stamina and relay endurance

**CONFIRMED:** Every carried parcel continuously drains the carrier’s stamina, including while stationary. Running while carrying consumes more than walking. Players regenerate whenever they are not carrying, including while moving freely. Heavy or special parcels may increase consumption later. At zero stamina, the player must release or transfer the parcel; exhaustion itself is neither damage nor contract failure. Do not impose general movement exhaustion on unburdened players.

Choose endurance using the number participating when the run begins and keep that scaling fixed for the whole run, including later attempts, departures, or Away changes. Do not recalculate from the current carrier or each attempt’s deployed roster. The precise run-start snapshot point around partial arrivals is OPEN-027.

| Players at run start | Standard parcel carrying endurance — PROVISIONAL |
|---|---|
| 1 | 45 seconds |
| 2 | 25 seconds |
| 3 | 20 seconds |
| 4 | 18 seconds |

These are initial playtesting values, not permanent balance decisions. Proposed measurement baseline: full stamina, Standard parcel, walking continuously; confirm that baseline in OPEN-024 before comparing tests. Exact regeneration rate/delay, running consumption multiplier, and capacity-versus-drain implementation remain open. Faster solo regeneration is a possibility to test, not a confirmed requirement. Complex modifiers remain deferred.

Solo players place parcels down to recover, then continue using route planning and obstacle navigation. Teams relay the parcel as stamina declines; non-carriers recover while running ahead, positioning for catches, preparing routes, or operating obstacles. Responsibilities emerge from actions without classes. Tune endurance and recovery to make cooperation useful without forcing tedious transfers every few seconds; test solo rest time and team handoff frequency together.

### 4.6 Throwing and catching

**CONFIRMED:** Throw launches the parcel toward a teammate or location along a physics-based trajectory. It offers more range than direct handoff and can cross obstacles or enable strategic positioning. Catch intercepts the in-flight parcel without placing it on the ground, using a forgiving catch-assist radius. A successful catch causes no impact damage; it does not heal damage from earlier collisions. Handoff remains the safest, most reliable transfer, especially for Fragile cargo.

A missed catch may cause displacement, impact damage, or later package-specific consequences. A miss alone is not a damage event or strike: apply the actual validated impact and contract-failure rules in §§5 and 11. Catching preserves parcel HP, effects, and the running deadline. Each player retains their own stamina; a transfer ends the previous carrier’s drain and starts the receiver’s drain.

**OPEN implementation details (OPEN-026/028):** Throw strength/range/aim, catch radius and timing, automatic versus explicit catch input, eligibility at low/zero stamina, contested-catch ordering, and exhausted-release fallback. Validate transfers on the server and preserve single ownership when catches, handoffs, impacts, and exhaustion compete. Existing no-theft and collision-grief protections still apply. Special parcels may later modify throw range, trajectory, handling, or stamina use; those interactions are not new MVP requirements.

## 5. Package HP and time limits — CONFIRMED failure conditions / PROPOSED tuning

### 5.1 Base MVP

| Archetype | Rules | Natural failure |
|---|---|---|
| Standard | Starts at a proposed 100 HP; durable, predictable carrying with lower impact damage. | 0 HP or the delivery deadline expires: mission fails, one shared strike. |
| Fragile | Starts at a proposed 100 HP; takes greater damage from meaningful validated impacts. | 0 HP or the delivery deadline expires: mission fails, one shared strike. |

**Owner-confirmed v0.3 conflict resolution:** Every mission has BOTH a package HP bar and a hard delivery deadline. A package at 0 HP cannot be delivered; a healthy package delivered too late also fails. One attempt still loses at most one strike, even if HP reaches zero when time expires. “Integrity” in internal data means package HP; display **Package HP: current / maximum** and **Time remaining** to players. Warn at a proposed 25% HP and at 30/10 seconds remaining using text/icons as well as sound. Exact HP, damage, and time values are tunable.

Package damage must be discrete and readable. One collision episode applies damage once, not once per contact callback. Initial test values are 5/10 HP for moderate/severe impacts on Standard and 10/25 HP on Fragile, with a 0.5-second same-contact cooldown. Foam halves these values. Track fractional HP internally; if the UI uses whole numbers, round positive HP upward so it never displays 0 before failure. Never infer a new impact solely because the cooldown expired while resting against a wall.

**Required measurement before enabling damage:** Record package normal-impact speed during deliberate placement and safe walking on the approved route. Set the moderate threshold above that measured safe envelope; set severe initially at twice the moderate threshold, then test. Log speed, surface, damage, and source per impact. Thresholds in studs/second remain OPEN until the carry prototype establishes a scale; do not guess production values or use visual client impulses as proof.

Exclude successful catch, spawn, pickup, handoff, recovery, teleport, respawn, and server-correction impulses from damage. A single ordinary severe impact cannot destroy a fresh parcel. Show a short visual/audio impact cue and the numerical loss. If the implementation cannot distinguish normal handling from damage reliably under latency, keep damage disabled and block failure-model release validation.

### 5.2 Delivery clock — CONFIRMED expiry failure / PROPOSED timing details

Each contract declares a finite `hardDeadline` before preparation purchases. Start its server-authoritative elapsed clock when the attempt becomes Active and the parcel is available, not when a player eventually picks it up. Delivery is valid only while `elapsed < hardDeadline` and HP is above zero. At `elapsed >= hardDeadline`, resolve `DEADLINE_EXPIRED` once; the UI shows zero and no late delivery can rescue the attempt. Round displayed positive remaining seconds upward so 0:00 means actual expiry. Do not trust a client timestamp or grant an undisclosed latency grace period.

Use the measured free solo/mobile route time to set a generous initial limit (§8.3), including interaction, learning, and solo stamina-rest time; also verify remaining-player completion with the original run-start endurance after departures. Shorter optional bonus targets are separate from this failure deadline. Ordinary and crisis contracts both have limits, but deadlines do not shrink automatically forever with run depth. Preparation/results/loading do not count. Stamina rests, throwing, catching, dropping, handoff, ordinary recovery, respawn, personal menus, and a teammate's departure do not restart or pause the clock. Verified server-fault recovery freezes gameplay and both clocks during the recorded interruption; if safe continuation is impossible, cancel neutrally. The client must show **Delivery paused — recovering package** during that verified pause.

A retry gets the same full deadline with a new attempt ID, fresh package, and fresh elapsed clock. A stale timer from a resolved attempt cannot fail its replacement. A valid success accepted before expiry stays successful even if its result animation or save finishes later.

### 5.3 Deferred packages and properties

Inflatable is deferred from the base MVP, with a later Small → Medium → Large prototype and explicit compression cooldown. Every stage requires a wide free route and safe scaling. Heavy/special stamina modifiers and package-specific throw/trajectory interactions are later scope. Magnetic, Shape-shifting, water exposure, and their dedicated tools are deferred. No shop offers a tool whose associated mechanic is disabled.

## 6. Interconnected world, biome districts, and route design

### 6.1 World structure — CONFIRMED

One interconnected delivery island/city remains the team’s world for the entire endless run. The central delivery company warehouse is the primary hub and initial pickup. Four distinct districts connected by traversable routes are the long-term structure; each has multiple potential destinations and at least one satellite parcel station. The initial MVP includes two districts, not all four.

Players travel through the same authored environment rather than entering a separate course or loading a new level for each contract. Separate multiplayer lobbies/team instances remain unchanged. “Persistent” here means continuity within the run, not cross-session world saving. Use Roblox instance streaming and optimized asset management to support the larger world without unnecessary loading screens; technical budgets and settings require measurement (§15, OPEN-033).

### 6.2 Biome candidates — PROVISIONAL names and effects

| Biome | Environmental characteristics | Effects on the existing delivery mechanics |
|---|---|---|
| Forest | Dense vegetation, fallen trees, narrow paths. | Navigation obstacles and restricted throwing routes; careful carrying and nearby handoffs remain useful. |
| Drylands | Sand patches, open terrain, strong winds. | Reduced mobility in marked areas and wind-influenced parcel throws; plan positioning and catch trajectories. |
| Harbor | Wet docks, moving platforms, water crossings. | Slippery terrain and coordinated crossings; solo-valid crossings must remain possible. |
| Highlands | Slopes, icy paths, elevated routes. | Momentum management and challenging parcel transfers; safe routes/rest positions support carrying stamina. |

The four-district structure is confirmed; these names, specific effects, and the first two districts to build are not locked. Validate effects against carrying, stamina, handoff, throw, and assisted catch rather than creating separate gameplay systems. Harbor water is a route-design candidate, not approval for swimming, parcel water damage, or new failure conditions. Environmental wind affecting throws is distinct from deferred package-specific throw modifiers. No extra biome stamina multiplier is approved by this amendment.

### 6.3 Satellite stations and delivery flow — CONFIRMED direction

Each biome has at least one satellite station supplying subsequent contracts. Players need not return to the warehouse after every delivery. A local station may send a parcel to another destination in its own district or across a connecting route to another district. The director should encourage movement through the world while avoiding repetitive compulsory backtracking.

The warehouse remains the main hub. Station selection/activation, travel between delivery and pickup, readiness for spread-out teammates, and which preparation services satellites offer remain OPEN-030. Existing readiness, individual exit, one-active-contract, and reward rules remain; no fast travel, additional shop, or parallel-contract system is implied. Do not silently turn the old M1 result-to-depot reset into a final-world requirement.

### 6.4 Route blockout and validation — PROPOSED measurements

Measure empty/walking/running carry speed, endurance/rest intervals, throw reach and catch-assist space, stopping distance, jump reach, interaction reach, camera clearance, and largest approved package/character collider before sizing routes. Size safe corridors for package plus player clearance with at least 25% margin over the measured sweep; validate corners, not just straight widths. Required switches remain reachable after dropping the parcel. Gates latch long enough for the slowest supported solo traverse and have a free bypass.

Treat warehouse, satellites, destinations, and district connections as one traversable route graph. Validate local and cross-district routes for no gear, Fragile carrying, solo stamina rests, and every shipped combination of biome/weather/event effects. Shortcuts advertise risk and are never the only viable path. Use signs, landmarks, and objective arrows without requiring chat. Safe placement/rest opportunities support solo recovery and relay preparation; calm sections separate difficult interactions. Throws may enable shortcuts, but no standard route requires a second player to catch. Event closures must leave reachable pickups, destinations, and counterplay.

## 7. Layered environmental difficulty

### 7.1 Three layers — CONFIRMED structure / PROVISIONAL effects

| Layer | Behavior | Examples and delivery role |
|---|---|---|
| 1 — Biome effects | Persistent characteristics of the current location. | Narrow paths, sand, slopes, slippery surfaces, local wind, and physical obstacles influence movement and transfers. |
| 2 — Weather conditions | Temporary modifiers that may vary between deliveries. | Rain, fog, wind, or other weather can interact with the biome; validate each combination before use. |
| 3 — Major environmental events | Significant disruptions after every five successful deliveries. | Severe storms, flooding, or blocked routes meaningfully change access, route choice, or handling conditions rather than only raising numbers. |

Biome properties persist across attempts. Weather is temporary; a storm event is not merely the ordinary rain label. Event intensity and complexity may grow with run depth through tested combinations, while the existing provisional severity cap and solo/no-gear viability remain. Limit simultaneous effects so hazards and counterplay remain understandable. Specific stacking rules and limits are OPEN-032; do not blindly multiply overlapping slippery/wind modifiers.

### 7.2 Event timing and lifetime

After a successful resolution advances `completedContracts` to 5, 10, 15, 20, and onward, trigger that milestone’s event exactly once. Failed attempts, retries, technical cancellation, and duplicate success callbacks cannot trigger it again or advance the schedule. This replaces `deliveryNumber % 5 == 0` as the event trigger: delivery 5 is not automatically a crisis contract before it succeeds.

Announce the disruption and affected routes clearly before players commit to the affected contract. Preserve the existing full-briefing/readiness rule. Exact onset presentation, affected districts, duration, expiry/replacement, retry exposure, and the crisis-affected contract tag are OPEN-031. Do not assume one event per active attempt, an automatic reset at every result, or endlessly accumulating events. Later events must make a meaningful environmental change without requiring an entirely new event type at every milestone. Event occurrence itself never consumes a strike; actual HP/deadline failure rules still apply.

### 7.3 First environment prototype — PROPOSED selection

Simple rain remains the proposed first weather modifier. On clearly marked wet surfaces, start with 25% longer stopping distance at the same initial carry speed; Grip Boots reduce that extra distance to 10%. These are playtest targets, not fixed friction settings. If physical slipping is unreliable, test a labeled movement modifier and revise tool text before release. Dry alternatives remain usable without gear; rain does not itself damage parcels or obscure essential signs, markers, or package readability. Decorative density can scale down independently.

Proposed first major event: a storm blocks one previously usable route and makes a signed alternate necessary, combining only taught obstacles and validated wet handling. This is a candidate for the required single MVP event, not a confirmed storm/flooding implementation. First teach the selected biome obstacle and simple weather separately, then test their combination. Additional weather, moving platforms, ice, and flooding are provisional candidates rather than automatic MVP commitments. Water exposure damage/Rain Cover remains deferred.

## 8. Coins, ratings, equipment, and Reputation — PROPOSED

### 8.1 Temporary versus permanent state

Start each run with 0 Run Coins, no gear, zero streak, depth 0, and the confirmed 3 strikes. Coins and gear are individual and temporary; retain them through a non-terminal failure but expire them when that player exits, disconnects, or the run ends. No trading, bank, inventory stockpile, or strike purchase/refill.

Reputation is persistent, non-spendable XP. In the base MVP it unlocks cosmetics only; all implemented packages and equipment are available through onboarding regardless of a teammate's Reputation. This removes mixed-unlock contract-pool ambiguity. Suggested cosmetic milestones are a title at 100 XP, uniform variant at 500, and badge at 1,000; assets and thresholds require scope review. Cosmetics cannot alter handling or mask package condition.

Store `bestDepth` (highest team depth reached on an eligible success) separately from `totalDeliveries` (count of that player's eligible successes). A member Away for a delivery does not receive its rewards or a retroactive credit later. Clearly label the record as **Best team depth reached**, not a claim that the player personally completed every delivery.

### 8.2 Participation and rewards

Eligible means included in the attempt's deployed roster and still a run member at its successful resolution. Carrier, gate operator, navigator, and observer/support all receive the same award. No hidden action-count scoring or carrier-only payout. Returning from Away mid-attempt is not supported; participate next preparation. If departure resolves before success, no current-attempt award; if success was already accepted, preserve the earned award even if saving is pending.

This broad rule accepts some AFK reward risk. Readiness must be renewed every attempt; idle preparation goes Away. More invasive contribution scoring is deferred until measured abuse justifies it. No automatic strike or forfeiture of prior earnings for inactivity.

### 8.3 Rating and reward formula

Use one team rating, shared by eligible players. All values below are a starting balance model.

```text
q = remainingHP / startingHP for either package type
t = 1 if elapsed <= goodTime
    0 if elapsed >= slowTime
    linearly interpolate from 1 to 0 between those targets
o = 1 if the listed optional objective is met; 0 if missed
    1 if the template has no optional objective
rating = 0.5*q + 0.3*t + 0.2*o
qualityBonus = 0.20 * rating
streakBonus = 0.10 * min(previousConsecutiveSuccesses, 3)
crisisBonus = 0.25 if crisis else 0  # crisis = contract exposure tag; OPEN-031
coinsPerPlayer = floor(100 * (1 + qualityBonus + streakBonus + crisisBonus))
reputationPerPlayer = 10 + (5 if crisis else 0)
```

Time targets are authored per template: measure three uncoached solo/mobile completions on the free safe route in an untimed calibration test. Provisionally set `goodTime` to the slowest observed completion time, `slowTime` to twice that, and `hardDeadline = max(180 seconds, ceil(slowTime + 60 seconds))`. Require `0 < goodTime < slowTime < hardDeadline`; confirm the final limit with fresh timed playtests, including tutorial reading and network conditions. These are initial tuning rules, not guaranteed fair times. Example: observed slowest time 90 seconds gives bonus targets 90/180 seconds and a 240-second failure deadline. Completing after slowTime but before hardDeadline still succeeds with no time bonus; reaching hardDeadline fails regardless of HP. Optional objectives never cause a strike, never require paid gear, and never require two players.

Increment streak after calculating the success award. Legitimate failure grants 0 new coins/XP and resets streak; technical cancellation neither pays nor resets streak. Earlier earnings are retained. Round coins once after summing bonuses. Display the breakdown and a simple quality label: Excellent at rating ≥0.85, Good at ≥0.60, Delivered below 0.60; the label never changes success into failure.

**Worked checks:** A perfect first Standard delivery pays 120 coins and 10 XP. Four perfect ordinary successes pay 120 + 130 + 140 + 150 = 540 coins. With no earlier major event, perfect delivery 5 is ordinary and pays 150 coins/10 XP, then triggers the event; total at depth 5 is 690 coins and 50 XP before spending. A subsequent perfect crisis-affected success pays 175 coins/15 XP under the existing formula. Which contracts receive that tag depends on OPEN-031; the bonus amounts are unchanged. A perfect ordinary success immediately after a legitimate failure pays 120 coins. Ordinary payout is capped at 150 and crisis payout at 175 per eligible player; raw depth does not multiply earnings.

### 8.4 Equipment lifecycle

Two shared-purpose equipment slots per player; passive and active items both occupy slots. No backpack stockpile and no duplicate item type. Shop only at the central warehouse for now; satellite shop/service availability is OPEN-030, not an added feature; show effect, remaining uses, price, and relevant next-contract condition. Empty slots cost nothing.

| Tool | Base MVP effect | Capacity and use | Price |
|---|---|---|---:|
| Grip Boots | Wearer gets the wet-surface handling improvement in §7; affects no teammate or parcel directly. | 5 started attempts while equipped, including dry attempts and legitimate failures. One use reserved at start; effect lasts to resolution even when this was the last use. | 180 coins for a fresh pair. |
| Packing Foam | Halves validated impact damage to the current Standard or Fragile parcel for the rest of this attempt. | One charge. Active use within interaction reach applies once to the parcel, persists through handoff/departure, and frees that slot. | 100 coins. |

Rain Cover is deferred with water exposure; the base MVP has **two useful tools**, not three tools with one ineffective purchase. Two-slot capacity remains tunable after mobile UI testing.

Buying requires sufficient funds and a free slot. Replacing existing gear is explicit and discards its remaining uses without a refund; show that before confirmation. No mid-attempt buying, gear swapping, or restocking. Purchases are atomic and retry-safe. There is no selling or free repair. Invalid active use never consumes a charge.

Only one Foam effect can be active on a parcel. If two users apply simultaneously, accept the first valid application and preserve the other's charge; no stacking or refresh. Foam cannot heal damage, prevent destruction at zero, or extend the deadline. Unused Foam survives a legitimate failure; used Foam stays consumed. Boots do not become a parcel effect when their wearer hands off. Boots with zero uses remaining are removed at the next preparation after their final attempt's effect ends.

At attempt start, snapshot each deployed player's gear after purchases. Full technical cancellation restores that snapshot once for members still present; leave coins and depot purchases unchanged. In-place recovery does not refund gear. This exact rollback replaces “refund where feasible.” Departed players' temporary gear remains expired. Repeated cancellation cannot create additional copies.

### 8.5 Economy risk and tuning

At high streak, 150 coins per ordinary success exceeds the 136-coin average cost of Foam every attempt plus Boots every fifth attempt. The proposed economy therefore allows balances to grow; it does not guarantee persistent scarcity. Track spend, balances, and purchase regret at depth 5/10/20. If buying both tools becomes automatic, test a one-slot loadout or retune costs/rewards before adding another currency or a surprise tax. Always retain free viable routes.

## 9. Cooperation — CONFIRMED direction; exits and votes — PROPOSED

Confirmed cooperation centers on stamina-driven parcel relays: safe handoffs or longer-range throws and assisted catches, with solo-operable gates, route guidance, and choosing who applies Foam as supporting actions. Solo has greater endurance and can rest by placing the parcel down; teams gain efficiency from non-carriers recovering while preparing routes and catch positions. No mandatory classes or fixed roles are introduced. Optional shortcuts can reward coordination without making the safe route dependent on multiple players. A teammate cannot take a held parcel, drain another wallet, cause friendly damage, or force a strike by clicking Retry alone.

**Leave Run** affects only the requesting player. Confirmation explains that temporary coins/gear expire and completed permanent earnings remain, subject to save status. Departure never directly consumes a strike. Recover the carrier's parcel and allow remaining deployed members to continue. If no deployed members remain but Away members are still present, neutrally cancel and return to preparation; if no run members remain, close as `TeamEmpty`.

**Team Abandon** is a separate action available only during an active attempt. It explicitly states **Costs the team 1 strike; retry this delivery**. All currently connected deployed participants must approve within 15 seconds; solo requires its player's confirmation. No response or rejection cancels the vote. Away members are not voters. A departure, respawn, or participant-state change invalidates the vote and requires a fresh one; never shrink an existing vote into unanimity. A resolved attempt invalidates its vote. Rate-limit initiation to once per player per 30 seconds.

No AFK timeout may count as consent or remove an idle deployed participant just to pass a vote. This can block a voluntary retry; players can still recover a stuck parcel or leave individually. Do not hide this limitation behind an undefined “active player” rule.

## 10. Persistence and interrupted sessions

### 10.1 Data contract — PROPOSED behavior, INVARIANT integrity

| Persistent per player | Temporary per run/player |
|---|---|
| Schema version, Reputation, bestDepth, totalDeliveries, cosmetic unlock IDs, tutorial completion, accessibility preferences, bounded award-deduplication state. | Run/attempt IDs, depth, strikes, selected contract and seed/config version, recent templates, coins, gear, readiness, membership, package state, votes, success streak. |

On success, determine the eligible roster and award amounts once, advance depth once, and enqueue an immutable award record per eligible user. Grant temporary coins once independently of a save retry. Save persistent deltas with the award identity; do not re-run gameplay rewards when a save is retried. Preserve ordering across writes and prevent stale sessions from overwriting newer profiles. Deduplication storage must be bounded without making an old award eligible again; the TDS must define session ownership and replay limits.

**Player-facing states:** Saving → Saved; if a write fails, **Saving delayed — recent progress is not yet confirmed**. Show Saved only after acknowledgement. Per-success persistence means a save attempt/checkpoint, not a promise of lossless storage during outages. Never gate earlier earned progress behind a final cash-out.

### 10.2 Failure behavior — PROPOSED

- Profile load failure: remain in lobby with Retry / leave options; do not start a rewarded run or overwrite existing data with defaults. A separately labeled unsaved internal practice mode may exist for testing.
- Save delay during an attempt: finish the current attempt and retain pending awards. At the next warehouse/satellite preparation, hold new starts until the pending persistent awards for remaining members are acknowledged. Explain the hold and allow exit; no strike or loss of temporary gear solely from waiting.
- Retrying saves uses bounded backoff and ordered writes. Keep failed records pending rather than silently dropping them. Retry/exit remains available; no claim that closing a crashed server can recover an award that never reached durable storage.
- Individual exit/shutdown: attempt pending saves within the available shutdown window; expiry of the run wallet does not erase pending permanent awards.
- Server interruption ends the session neutrally; no active-run resume in MVP. Summary distinguishes saved versus unconfirmed progress. Do not display a guessed final result after a disconnected client loses authority.

These requirements follow the principles of keeping related profile fields together, ordered retry handling, and avoiding stale overwrites in [Roblox's data-store best practices](https://create.roblox.com/docs/cloud-services/data-stores/best-practices). Exact service budgets and session-lock implementation belong in the TDS.

## 11. Resolution and shared strikes

### 11.1 Confirmed contract

Initialize 3 shared strikes once. Each legitimate failed attempt deducts exactly one. The third failure terminates the team run immediately: no new attempt, interaction, shop transaction, or delayed success can revive it. Already earned persistent progress is not intentionally forfeited. The proposed MVP has no refill, revive, extra-strike reward, or paid continuation.

### 11.2 Outcome table

| Outcome | Depth | Strikes | Streak / new reward | Next action |
|---|---|---|---|---|
| Success | +1 once | Unchanged | Award once, then streak +1 | Next-number preparation. |
| PACKAGE_DESTROYED | Unchanged | −1 once | Reset streak; 0 new reward | Same-contract retry preparation, or terminal summary. |
| DEADLINE_EXPIRED | Unchanged | −1 once | Reset streak; 0 new reward | Same-contract retry preparation, or terminal summary. |
| TEAM_ABANDONED | Unchanged | −1 once | Reset streak; 0 new reward | Same as destruction. |
| TechnicalCancellation | Unchanged | Unchanged | Preserve streak; 0 reward | Gear rollback; valid same-number preparation. |
| Recovery in place | Unchanged | Unchanged | Not a resolution | Continue same attempt with preserved state. |
| Individual exit | Unchanged by exit | Unchanged | No award for an incomplete attempt | Others continue; personal temporary state expires. |

Package destruction at 0 HP and delivery-deadline expiry are CONFIRMED failure conditions. Unanimous abandon remains a PROPOSED additional failure action. `SPECIAL_CONDITION_FAILED` is deferred. Exhaustion, missed catches, missing a bonus-time target, wrong destination, low rating, player reset, disconnect, unauthorized requests, physics recovery, and platform faults are not themselves strike causes. However, ordinary player recovery or a departure does not stop an otherwise valid clock: subsequent expiry still fails the mission. Confirmed server faults use the neutral pause/cancellation rules in §5.2.

### 11.3 Arbitration — INVARIANT, with PROPOSED tie policy

All terminal candidates reference the current run and attempt, pass server validation, and compete under one non-yielding resolution guard. Reject stale IDs and duplicate callbacks. Validate the deadline as part of delivery acceptance, not only in a periodic timer callback. Assign a server simulation-step/sequence to accepted gameplay events. For candidates in different steps, the earlier valid event wins. For otherwise simultaneous candidates within one step, proposed order is: a verified fault that invalidates the result → validated destruction → deadline expiry → valid delivery → unanimous abandon. A delivery at or after its exact deadline is invalid regardless of callback ordering. HP and expiry together produce one failure/strike; destruction is the proposed displayed primary reason and expiry may be recorded as secondary. Document and test this ordering; do not let callback scheduling randomly decide the winner.

A DataStore error after a valid success does not invalidate the success; it affects save status. A fault discovered after an already committed outcome must not silently resolve the same attempt a second time. Record it for diagnosis and any separate compensation policy. Client-reported timestamps or fault claims cannot establish priority.

### 11.4 Retry and ending examples

At depth 9 and 3 strikes, failed delivery 10 yields depth 9 / 2 strikes. Retry delivery 10 with the same contract, fresh package at 100 integrity, reset attempt timer, fresh attempt ID, and remaining purchased gear. A successful retry yields depth 10 / 2 strikes and offers 11. Three failures on 10 yield depth 9 / 0 strikes and end the run.

Normalize run-ending reasons to `StrikesExhausted`, `TeamEmpty`, or `ServerInterruption`; `VoluntaryExit` is a personal departure reason, not the remaining team's run status. Final/personal summaries show depth, best team depth, crisis milestones, cumulative earned XP/coins, spent/expired temporary coins, save status, and the reason. Never label delivery 10 Final Delivery. A Return to Lobby failure leaves a readable summary and Retry Return option.

## 12. UI, accessibility, and onboarding — PROPOSED

| Surface | Required information/actions |
|---|---|
| Lobby | Solo, Party, Find Team when released, ready roster, loading/error state. |
| Warehouse / satellite preparation | Pickup station, source/destination biome, active environmental layers; completed depth and next number separately; full contract card; forecast; strikes; coins; gear; Ready/Away/Leave; save status. |
| In-world HUD | Destination and next pickup guidance, current biome and readable weather/event warnings, carrier, player carrying stamina and drain/recovery state, handoff/throw/catch prompts, always-visible package HP bar and Time remaining countdown, strikes, tools/uses, current contextual action. Optional bonus targets are secondary and clearly distinct from the failure countdown. |
| Result | Success or specific failure reason, time/quality/optional-objective breakdown, each personal award, strikes and depth. |
| Run/personal summary | End/exit reason, records, confirmed/pending earnings, expired run resources, lobby-return action. |

The normal strike label is **Company Strikes remaining: 3 / 3**, supported by icons and text. A loss message is **Package destroyed — 1 team strike lost. 2 remaining.** Do not name a teammate as the cause or publish a blame board.

First-time onboarding is embedded in delivery 1. Explain **0 HP or time runs out = failed delivery and 1 team strike** before Ready starts its clock. Teach pickup, drop/rest, carrying drain and regeneration, safe handoff, throw, assisted catch, recover, interact, and deliver with durable Standard cargo. Keep initial action discovery quick; remeasure the prior one-minute onboarding target for this expanded sequence, with solo prompts not requiring a teammate; use a generous measured deadline that includes reading time. Allow prompts to be replayed or skipped. A completed tutorial flag suppresses extended instructions in later runs without skipping delivery numbers. Delivery 2 coaches Fragile's higher damage sensitivity with a safe placement area before any dangerous shortcut. Show a risk preview before its first impact challenge. Never make the first rain crisis the first explanation of HP or the deadline. An isolated untimed practice/calibration area may exist outside the rewarded mission loop; real delivery 1 still has both confirmed failure conditions.

Desktop keyboard/mouse and mobile landscape are required release targets; console/gamepad release is deferred. Verify mobile at 16:9, tall-phone landscape, and tablet 4:3 with real safe-area insets. Keep action buttons outside movement/camera areas. Scale text, retain readable contrast, pair color with labels/icons, and support reduced motion, shake off, and separate music/SFX levels. Critical cues cannot be sound-only. Externalize player-facing strings; initial language is English, with other localization deferred. Do not expose implementation IDs or technical error traces in normal player UI.

## 13. Visual and audio direction — PROPOSED

Friendly colorful delivery-workplace comedy across distinct connected districts; low-poly shapes, oversized readable parcels, distinctive silhouettes, and restrained effects. Give wet pavement a persistent readable material cue even with rain particles reduced. Keep carry sway cosmetic where possible so the player can predict clearance.

Audio communicates pickup weight, throw/catch, low stamina and recovery, gentle placement, damaging impact, low integrity, forecast, success, and strike loss. Pair each critical sound with a visual cue. Keep failure feedback short and explanatory; humor must not obscure the cause. Final art production follows successful greybox handling and route tests.

## 14. Build scope and milestone gates — revised development plan

This amendment is documentation only. Existing M1 carry-slice implementation/evidence is recorded in state/m1/Summary.md; stamina/throw/catch are pending and unverified. The revised roadmap extends M1 handling, proves run/station state in M2, and splits M3 into connected-world, damage/deadline, biome/weather, and major-event gates. Live durability consequences arrive in M3B. This sequencing does not mark any gate complete or finalize provisional biome/balance choices. Create a TDS and acceptance-testable tickets before production code. Implement only the current milestone.

| Milestone | Included | Gate before expansion |
|---|---|---|
| M1: Cooperative relay slice | One Standard parcel, depot, destination, alternative path, pickup/drop/handoff/throw/assisted catch, carrying stamina/regeneration and player-count presets, recovery/delivery, result loop; solo and multiplayer Studio tests. | Fresh tester uses the core action within ~30 seconds and completes a loop without coaching; repeated loops and disconnect do not strand parcel; stamina and relays work without tedious transfer frequency. |
| M2: Run and station flow | Depth, post-success event milestones and exposure state, placeholder station-to-station contract flow, retry IDs, three shared strikes with simulated 0-HP/deadline failures, cleanup, safe exit/summary. | 21 successful simulated contracts; events trigger once after successes 5/10/15/20, never from failure/retry; three failures end once; simultaneous HP/expiry and stale timers harmless. |
| M3: Connected world and environmental delivery | M3A: warehouse, two connected districts, multiple destinations and satellites, early streaming checks; M3B: Standard/Fragile damage and deadlines; M3C: biome obstacles/simple weather; M3D: one major event. | Pass each sequential stage with evidence/checkpoint; integrated local/cross-district no-gear loop, fair damage/deadlines, readable event after success 5, and no streaming/route blocker. |
| M4: Economy | Coins, team ratings, two tools/two slots, charge/stack/rollback rules. | Worked reward values reproduced; no double purchase/use/refund; spending remains a meaningful choice. |
| M5: Progress | Profiles, Reputation/cosmetics, bestDepth/totalDeliveries, pending save UI and fault behavior. | Failed loads cannot erase data; repeated/unknown-result writes do not duplicate awards; multi-session conflicts handled. |
| M6: Sessions | Public lobby, Solo/Friends, run admission, readiness/Away, departures, published-client teleport tests. | No unrelated joins, partial arrival handled, leader departure safe, no loading or return trap. |
| M7: External release | Complete/polish the existing two-district world, certify streamed-world behavior and devices, same-lobby Find Team, content matrix, accessibility, mobile/performance, instrumentation and release QA. | All release gates in §§16–17 pass; unmet content goals are reported honestly. |
| M8: Cosmetic monetization — Future | Separately scope optional cosmetics and purchase/entitlement handling after M7 and explicit scheduling; products/prices unselected. | Later design must define entitlement/retry validation and preserve cosmetic-only effects; not an initial MVP prerequisite. |

Friends/solo-only closed tests may precede M7. Calling them the complete public MVP would hide DEC-010's matchmaking access path. Cross-server matching remains deferred; an empty same-lobby queue offers Solo or continued waiting instead of indefinite forced waiting.

For M1, use the prototype-fast skill's one-question brief: **Are carrying, stamina management, and cooperative relays satisfying without rewards?** A throwaway handling experiment can use a 60–90 minute timebox; this is not the deadline for the full milestone. Keep if testers intentionally repeat the loop; refactor if one movement variable dominates frustration; cut/rethink the handling approach if explanation or added progression is the only reason to continue. Record whether code is disposable before writing it.

**Confirmed handling MVP priorities:** (1) pickup/carry/drop; (2) carrying stamina and regeneration; (3) player-count-based endurance fixed at run start; (4) direct handoff; (5) physics-based throw; (6) catch with forgiving assist radius; (7) basic durability and missed-catch consequences. Advanced package interactions and complex stamina modifiers remain later scope.

**Environment build order — CONFIRMED incremental scope:** (1) central warehouse hub; (2) two initial connected districts with multiple destinations each; (3) satellite stations, at least one per included district; (4) basic biome obstacles; (5) simple weather modifiers; (6) one major environmental event; (7) expand toward all four districts after validating the loop. This does not require building the full world during M1.

**Base MVP:** These handling priorities plus the two-district environment scope above, Standard + Fragile with HP bars and hard delivery deadlines, roughly ten validated local/cross-district templates, simple weather (rain proposed) and one major event, two useful tools, endless depth/three strikes, personal wallets, persistent cosmetics/records, solo/friend/same-lobby grouping, desktop/mobile UI. Reduce content quantity before reliability. Deferred: third/fourth district until loop validation, advanced unselected biome/weather/event effects, Inflatable, water exposure/Rain Cover, vehicles, procedural map generation, trade/banking, global leaderboards, active-run resume, late joins, complex anti-AFK scoring, console release, and monetization systems.

## 15. Technical handoff constraints

The server owns membership, readiness, active attempt, carrier, per-player stamina, run-start stamina scaling, throw/catch transitions, condition, outcomes, depth, strikes, purchases, awards, and persistent progress. Clients request actions and present feedback. Validate identity, current state, distance/reach, permissions, rates, and credible geometry; client physics is not proof of legal delivery or damage. Roblox documents the risks of client-owned physics in its [network ownership security guidance](https://create.roblox.com/docs/scripting/security/network-ownership). The TDS must select and test the carry/authority approach; this GDD does not assume an engine authority mode.

Partition responsibilities into Party/Admission, Run, ContractDirector, Package/Interactions, Weather, Equipment, Economy/Awards, Persistence, UI, and instrumentation. Tear down attempt timers, effects, physics objects, requests, and connections on every terminal transition. Use finite recent-template/award histories and bounded queues. “Endless” does not mean unlimited memory or guaranteed infinite server uptime; technical shutdown is neutral, not a designed delivery cap.

Use separate lobby/run places for production team sessions. At this review date, the [official reserved-server documentation](https://create.roblox.com/docs/projects/teleport-private-servers) shows `TeleportOptions.ReservedServerId` with a server-generated GUID. Verify the supported API again at M6 and enforce the admission roster on the destination server. Never trust client-supplied teleport membership. Test transfer failures with published clients; M1 requires no production teleport setup.

**Required TDS outputs:** Module ownership and typed state schemas; run/package FSM; remote request/response/error contracts; deterministic resolution arbitration; contract/config schema; physical validation and damage measurements; profile migration/session ownership/award deduplication; finite resource limits; telemetry schema; teardown strategy; admission and save failure behavior; and tests corresponding to §16. The existing M1 TDS and snapshots describe the earlier carry slice; extend them for stamina and throw/catch before implementation. The roadmap records pending integration; this document is not evidence of live feature completion.

**World streaming handoff:** Use Roblox instance streaming and optimized asset reuse/detail management within the run world. Define measured device memory/frame-time budgets, streaming behavior around carriers, thrown parcels, catches, district crossings, and critical route/station interactions before release. Missing client-streamed content must not be mistaken for a failed contract. Verify implementation settings/APIs when building; no new loading-screen or fast-travel system is specified here.

## 16. Acceptance criteria

The following are specifications for future validation, not claims that a game has passed tests. Status applies to the behavior under test; proposed acceptance tests do not approve the design.

| ID | Requirement and observable check | Status |
|---|---|---|
| GDD-001 | Only the admitted team can enter its run; unrelated admission is denied. | CONFIRMED |
| GDD-002 | Complete deliveries 11 and 21; neither 10 nor 20 ends a successful run. | CONFIRMED |
| GDD-003 | Success crossing completed depth 5/10/15/20 triggers one major event; no event fires merely because delivery 5/10/15/20 starts, and duplicate success callbacks cannot repeat it. | CONFIRMED |
| GDD-004 | Failing delivery 5 leaves depth 4 and triggers no milestone event; failing delivery 6 at depth 5 does not retrigger the event. Retry preserves the selected contract/exposure policy. | PROPOSED retry policy |
| GDD-005 | Two simultaneous pickups produce exactly one authorized carrier. | INVARIANT |
| GDD-006 | Consensual nearby handoff succeeds once; stale/distant/unaccepted handoff fails harmlessly. | PROPOSED interaction; INVARIANT ownership |
| GDD-007 | Stuck/out-of-bounds parcel recovers to a reached checkpoint, without healing or forward shortcut. | PROPOSED |
| GDD-008 | Every shipped template is completable solo, with zero gear, on mobile. | Carried-forward design requirement |
| GDD-009 | Every template has a visible catch and tested counterplay, including Standard deliveries. | Carried-forward design requirement |
| GDD-010 | Rain measurably changes marked wet handling; dry alternative works without gear. | PROPOSED parameters |
| GDD-011 | Individual exit causes no strike and does not end remaining members' run. | PROPOSED |
| GDD-012 | Run initializes exactly 3 shared strikes, independent of player count. | CONFIRMED |
| GDD-013 | Duplicate failure callbacks change 3→2 only once for the attempt. | INVARIANT |
| GDD-014 | Third distinct legitimate failure changes 1→0, shows summary, and permits no next attempt. | CONFIRMED |
| GDD-015 | Failure does not subtract previously earned depth or permanent awards. | Carried-forward design requirement |
| GDD-016 | Retry uses a fresh ID with the same delivery/template, forecast, and rating targets. | PROPOSED |
| GDD-017 | Recovery/cancellation/exit never deduct a strike; prior committed failure remains committed. | PROPOSED protective rule |
| GDD-018 | Competing same-step destruction/delivery/abandon/fault events have the documented single result. | INVARIANT single result; PROPOSED ordering |
| GDD-019 | Wallet/gear survive non-terminal failure and expire only for departing player or ended run. | PROPOSED |
| GDD-020 | Each success queues persistent progress; save delay is visible and holds subsequent starts. | PROPOSED |
| GDD-021 | Duplicate award/save/purchase requests never grant or spend twice. | INVARIANT |
| GDD-022 | Carrier disconnect leaves a recoverable parcel; one survivor can finish. | Carried-forward design requirement |
| GDD-023 | Tier never exceeds 4; no raw modifier grows automatically with depth after the cap. | PROPOSED |
| GDD-024 | All mandatory actions work on keyboard/mouse and landscape mobile with safe-area HUD. | Carried-forward platform requirement |
| GDD-025 | bestDepth is the maximum eligible team depth; totalDeliveries increases only on eligible successes. | PROPOSED |
| GDD-026 | Zero coins never makes a mandatory route inaccessible. | Carried-forward design requirement |
| GDD-027 | After 50 simulated attempts, live attempt resources return to baseline after each cleanup. | INVARIANT cleanup |
| GDD-028 | Cancellation/abandon cannot pay a success award or increase depth. | INVARIANT |
| GDD-029 | No shop, event, or retry resets/increases strikes in the base MVP. | PROPOSED |
| GDD-030 | Either parcel type reaches 0 HP, fails once, and cannot deliver; gentle placement never damages. | CONFIRMED failure; PROPOSED damage tuning |
| GDD-031 | Same impact episode is charged once; handoff/recovery cannot generate phantom damage. | PROPOSED |
| GDD-032 | Away/readiness timeout does not force deployment; no ready player means no start. | PROPOSED |
| GDD-033 | Missing vote response or changed roster cancels abandon; never infer consent. | PROPOSED |
| GDD-034 | Simultaneous Foam use applies one effect and consumes one charge total; handoff preserves it. | PROPOSED |
| GDD-035 | Cancellation restores starting gear once; recovery does not refund; failure retains used-charge cost. | PROPOSED |
| GDD-036 | Rewards match 120/130/140/150/150 for the first five perfect ordinary successes (690 total); a later perfect crisis-affected success pays 175 under the selected exposure policy. | PROPOSED |
| GDD-037 | Failed profile load cannot overwrite data; unknown write outcome cannot duplicate an award. | INVARIANT |
| GDD-038 | Partial arrival offers wait/continue/return; delayed admission after roster closure is rejected safely. | PROPOSED |
| GDD-039 | Skipped optional objective or exceeded bonus-time target lowers bonus; success still requires positive HP and elapsed time below the hard deadline. | PROPOSED rating; CONFIRMED failure conditions |
| GDD-040 | Save acknowledgement changes Pending to Saved; reconnect sees committed records without duplicate XP. | INVARIANT persistence |
| GDD-041 | Reset/respawn preserves membership and gear; recovery never advances checkpoint or restores integrity. | PROPOSED |
| GDD-042 | Wrong destination and blocked voluntary placement show feedback without losing parcel or strike; zero stamina uses the selected release/recovery fallback (§4.5). | PROPOSED |
| GDD-043 | With positive HP, reaching the hard deadline fails once; delivery at/after expiry cannot succeed. | CONFIRMED failure; PROPOSED exact boundary |
| GDD-044 | 0 HP and expiry in the same step deduct only one shared strike and award nothing. | INVARIANT |
| GDD-045 | Clock begins at Active, continues through stamina rests/throw/catch/handoff/drop/respawn/recovery, and resets only for a new attempt; stale expiry cannot affect it. | PROPOSED timing; INVARIANT attempt isolation |
| GDD-046 | Verified fault recovery freezes gameplay and clocks; valid completion before expiry remains success through result/save delay. | PROPOSED recovery; INVARIANT single result |
| GDD-047 | Every template has a finite measured deadline and visible HP/countdown; no-gear solo/mobile completion fits within it. | CONFIRMED dual constraints; PROPOSED tuning |
| GDD-048 | Each parcel has at most one carrier through pickup, handoff, throw, and contested catch; direct handoff and successful catch cause no impact damage. | CONFIRMED / INVARIANT ownership |
| GDD-049 | Carrying drains continuously; running drains faster; not carrying regenerates; zero forces release/transfer without restricting general unburdened movement. | CONFIRMED; rates OPEN |
| GDD-050 | Endurance uses run-start participant count and stays fixed through attempts, Away changes, and departures; test 45/25/20/18-second presets for 1/2/3/4 players under the selected baseline. | CONFIRMED scaling; PROVISIONAL values |
| GDD-051 | Throws follow physics, exceed handoff range, and permit assisted interception; a miss can displace/damage on impact but neither a miss nor exhaustion alone consumes a strike. | CONFIRMED; throw/catch parameters OPEN |
| GDD-052 | Solo can place/rest/resume and finish standard routes; teams gain useful relay/route-preparation opportunities without fixed roles or tedious passing. Validate desktop/mobile and 1/2/3/4-player cases. | CONFIRMED intent; playtest evidence pending |
| GDD-053 | The team stays in one connected run world; warehouse, two MVP districts, and their multiple destinations are reachable without per-contract level loading. | CONFIRMED; full four-district expansion later |
| GDD-054 | Each included district has a satellite station; subsequent local and cross-district contracts can proceed without compulsory warehouse return after every delivery. | CONFIRMED; gathering/services OPEN |
| GDD-055 | Biome, weather, and major-event layers are readable together; the shipped event meaningfully changes delivery conditions and preserves solo/no-gear counterplay. | CONFIRMED direction; effects/limits PROPOSED |
| GDD-056 | Instance-streamed district travel, carrying/throw/catch, station interaction, and event route changes work on named desktop/mobile devices without lost parcels or inaccessible mandatory routes. | CONFIRMED streaming direction; measurements OPEN |

## 17. Playtest evidence and release gates — PROPOSED

Run tests in this order: carry feel and stamina → handoff/throw/catch relays → Fragile readability → solo/no-gear routes → rain preparation → cooperation → first event after success 5 → sustained depth 20+ → interrupted sessions. Test each mechanic independently before combinations. Use observed evidence rather than declaring a system fun because it meets a numerical rule.

| Gate | Provisional pass signal |
|---|---|
| Comprehension | At least 4 of 5 fresh testers finish the first delivery without verbal coaching and explain why a later strike occurred. Small sample is an iteration gate, not a retention forecast. |
| Agency | A solo mobile tester completes each template on the free route and can leave/recover without assistance. |
| Desire to repeat | At least 3 of 5 testers voluntarily attempt another delivery after the first three; record why others stop. |
| Relay pacing | Record carrying/rest duration, transfer frequency, missed catches, and non-carrier actions for 1/2/3/4 players; compare walking/running and the provisional endurance values. Ask whether relays feel useful or repetitive. Test remaining players with fixed original scaling after departures. |
| Fair damage | No repeatable damage from ordinary placement/handoff/successful catch/recovery in solo and 2/4-client sessions, including 100/200 ms simulated latency tests. |
| Fair deadlines | Each template can be completed on its free solo/mobile route before expiry by fresh testers; verify just-before, exactly-at, and just-after deadline results plus simultaneous 0-HP/expiry. |
| Rain/tool value | Testers identify the wet risk and free route; Boots produce a measurable improvement without making all wet handling trivial. |
| Long-run stability | 50 alternating success/failure/cancel cycles show no monotonic growth in attempt connections, packages, timers, or effects; production idempotency history also remains bounded. |
| Performance | Provisional mobile target: at least 95% of frames within 33.3 ms during a representative 10-minute four-player rain test. Desktop target: 16.7 ms. Select named minimum test devices before claiming support. |
| Connected-world flow | Complete consecutive local and cross-district contracts using satellites without forced warehouse resets; record navigation confusion, pickup travel time, and solo rest pacing. Verify event changes and streaming at district boundaries. |
| Session reliability | Published-client tests cover partial launch, departure, leader loss, profile-load failure, delayed save, shutdown, and lobby-return retry. |

Log configuration/template versions, attempt outcomes, depth, strikes, failure reason, time, integrity damage sources, recoveries, gear usage, coin balance, save delay, disconnect/exit reason, and aggregate performance. Separate technical cancellations from player failures and voluntary exits. Do not log chat or publish player blame. Set data retention/access rules before production analytics integration.

Content expansion depends on findings: measure boredom at deliveries 11–20 before adding more weather; measure coin surpluses before adding economy complexity. Establish retention targets from real external tests, not speculative concurrent-player projections.

## 18. Improvements and product risks

| Priority | Improvement / decision | Benefit and validation |
|---|---|---|
| P0 | Both confirmed failure conditions visible: package HP and delivery countdown, with coached practice before rain. | Makes the three-strike budget understandable; test cause recall, fair damage, and achievable deadlines. |
| P0 | Complete forecast/contract card before shop and readiness. | Gear purchases can be informed; ask testers why they bought or skipped a tool. |
| P0 | Keep two useful tools; defer unused Rain Cover and complex Inflatable physics. | Reduces implementation risk without weakening endless/crisis identity. |
| P0 | Exact recovery, rollback, and save feedback. | Prevents soft locks, duplicate rewards, and misleading progress promises. |
| P1 | Test one-slot versus two-slot loadouts if everyone always buys both tools. | Creates equipment tradeoffs without new currencies; compare choice diversity and frustration. |
| P1 | Add a contextual “This way / Need handoff” ping after basic cooperation works. | Helps mobile/non-voice teams; test usefulness before adding wheel menus or role systems. |
| P1 | Short humorous result stamps, without blaming the carrier. | Strengthens comedy; ensure players still understand the mechanical result. |
| P2 | Additional authored destinations/catches before additional weather systems. | Adds variety with existing validated mechanics. |
| P2 | Rejoin/recovery across network disconnects after session ownership is proven. | Valuable for longer runs, but deferred rather than promised in MVP. |

Remaining risks include intentional carrier sabotage, an unready player delaying preparation, AFK payouts under broad participation rules, repeated crisis content, and economy surplus. Shared strikes inherently expose teammates to one another's mistakes; disabling theft and collision grief reduces but does not eliminate that risk. Address observed problems with small tests before adding punitive systems.

Monetization is deferred. Future direct-purchase uniforms, badges, and effects must preserve visibility, package identity, and free counterplay. No paid random rewards, gameplay boosts, strike refills, or premium continues are part of this proposed MVP. Review relevant platform requirements when monetization actually enters scope.

## 19. Skill use and sources

This world amendment additionally applies the local `level-design` skill to route connectivity, measured geometry, and teach-before-test environmental layering. Applied repository skills under `.agents/skills/`: `router` for scope, `level-design` for measured routes and teach-before-test pacing, `prototype-fast` for carry validation, `game-ui-ux` for screen states/mobile readability, `save-systems` and `roblox-datastores` for versioned progress and failure behavior, and `roblox-networking` for server authority and race/lifecycle requirements. No live Studio changes or game tests were performed during this document review.

Official references inspected on 2026-10-30: [reserved-server routing](https://create.roblox.com/docs/projects/teleport-private-servers), [data-store best practices](https://create.roblox.com/docs/cloud-services/data-stores/best-practices), and [network ownership security](https://create.roblox.com/docs/scripting/security/network-ownership). These support technical constraints, not the proposed balance or fun claims. Reverify platform APIs at implementation time; local skills are guidance, not a substitute for checking the selected API.

## 20. Owner decisions and measurements still needed

The previous OPEN-001–017 identifiers are preserved below for traceability. OPEN-003/004 are now resolved by the owner's explicit dual-failure instruction, as recorded in DEC-013; their balance values still require testing. Other recommendations do not close their approval status.

| ID | Recommended v0.4 default | Required by / disposition |
|---|---|---|
| OPEN-001 | No strike refill, purchase, or revive. | M2 design lock; still PROPOSED. |
| OPEN-002 | Failed crisis retries same number and exact contract. | M2; PROPOSED. |
| OPEN-003 | Every mission fails at package 0 HP OR delivery-time expiry. Unanimous abandon is a separate proposal. | **RESOLVED / CONFIRMED: DEC-013.** Damage thresholds remain M3 measurements. |
| OPEN-004 | Every mission has a hard deadline; bonus targets may be shorter. | **RESOLVED / CONFIRMED: DEC-013.** Exact times and pause/boundary details proposed in §5.2. |
| OPEN-005 | Individual exit anytime, with no direct strike. | M2/M6; PROPOSED. |
| OPEN-006 | Unanimous deployed-player abandon; nonresponse cancels, no AFK exclusion. | M3; PROPOSED. |
| OPEN-007 | Coins/gear expire on personal departure or run end. | M4; PROPOSED. |
| OPEN-008 | Individual wallets, equal eligible rewards, no trading. | M4; PROPOSED. |
| OPEN-009 | Two shared equipment slots; Boots 5 started attempts, Foam one active charge. | M4 UI/playtest gate; PROPOSED. |
| OPEN-010 | Simple rain as first weather; storm with a blocked route as first major-event candidate. No longer rain-only crises tied to every fifth active delivery. | M3/content review; PROPOSED effects, confirmed layered structure. |
| OPEN-011 | 1–4 member release cap remains proposed; solo validity confirmed. Contract HP/damage/tasks/deadlines do not scale numerically with party size; stamina scales separately under DEC-016. | M6; PROPOSED. |
| OPEN-012 | Same-lobby Find Team before unrestricted public release; cross-server queue deferred. | M7; PROPOSED phasing of confirmed access intent. |
| OPEN-013 | No intentional loss of already earned Reputation from failure. | Retained design direction; persistence details at M5. |
| OPEN-014 | Four capped tiers; later variety from validated rotation. | M2/M3; PROPOSED. |
| OPEN-015 | Inflatable excluded from base MVP. | Scope review; PROPOSED deferral. |
| OPEN-016 | No disconnected-player rejoin or active-run resume in base MVP. | M6; PROPOSED deferral. |
| OPEN-017 | Deployed and still present at success qualifies; no hidden participation score. | M4; PROPOSED, acknowledged AFK tradeoff. |
| OPEN-018 | Measured safe impact threshold, starting HP/damage, movement/clearance, and template bonus/deadline times. | M1/M3 measurements; **cannot invent production values**. |
| OPEN-019 | Readiness/Away/idle-carrier timing and non-forcing vote policy. | M6 usability/grief test; PROPOSED. |
| OPEN-020 | Rating/payout formula and prices in §8; accept surplus or retune from tests. | M4 economy test; PROPOSED. |
| OPEN-021 | Named minimum desktop/mobile devices and supported avatar envelope. | M1 blockout assumptions, M7 release certification. |
| OPEN-022 | Hold new attempts at warehouse/satellite preparation while remaining members have pending persistent awards. | M5 failure/recovery review; PROPOSED. |
| OPEN-023 | Exact tie priority for valid simultaneous terminal candidates in §11.3. | M2 state tests, before M3 live failure rules. |
| OPEN-024 | Endurance measurement baseline (proposed full stamina, Standard, walking), running speed/drain multiplier, regeneration rate/delay, and whether solo recovers faster. | Before stamina implementation; 45/25/20/18 seconds remain provisional. |
| OPEN-025 | Initial stamina and reset/preservation through preparation, retries, respawn, recovery, Away, and verified-fault pauses. | Before stamina lifecycle implementation; prevent reset exploits without inventing penalties. |
| OPEN-026 | Zero-stamina release when placement is blocked, transfer timing at exhaustion, and pickup/catch eligibility with low/zero stamina. | Before exhaustion/transfer implementation; cannot allow indefinite carrying or create a direct strike. |
| OPEN-027 | Exact run-start roster snapshot after partial arrivals/Continue and before Away/deployment changes. | Specify in run/session integration; once chosen, endurance stays fixed for the run. |
| OPEN-028 | Throw aim/strength/range, catch activation/radius/window, contested catches and impact ordering, desktop/mobile bindings. | Before throw/catch implementation; physics and forgiving assist are confirmed. |
| OPEN-029 | Select the first two districts, final names/effects, destination and satellite layout, and local/cross-district routes. | Before world blockout; four-district goal, two-district MVP confirmed. |
| OPEN-030 | Next-station selection, between-contract travel/gathering and Away behavior, satellite services versus central warehouse shop, and retry pickup location. | Before station-flow implementation; no compulsory central return each success. |
| OPEN-031 | Major-event onset presentation, footprint, duration/expiry/replacement, retry exposure, and crisis-affected reward tag. | Before M2/M3 event implementation; post-success multiples-of-five trigger confirmed. |
| OPEN-032 | Valid biome/weather/event combinations, simultaneous-effect limits, readable warnings, and capped escalation. | Before environmental combinations enter the contract pool. |
| OPEN-033 | Streaming configuration, critical-object behavior, asset budgets, and named-device crossing/throw/catch performance evidence. | Before streamed-world release validation; no guessed production settings. |

**Next design lock:** Select OPEN-024–028 for the handling extension, then playtest relay frequency and solo rest pacing. The two failure conditions are selected; measure fair HP damage and achievable deadlines in M1/M3 before production tuning is locked. OPEN-001/002/005/006 and OPEN-023 define remaining run/attempt resolution details. Prices, FX, and cosmetic thresholds can remain tunable. No approval is needed merely to review or refine this document.

## 21. Codex-facing implementation brief

> Build only the explicitly assigned milestone. Preserve endless progression, `nextDelivery = completedContracts + 1`, major environmental events after every five successful deliveries, 3 shared initial strikes, and the confirmed dual failure conditions: package HP reaches zero OR the delivery deadline expires. Either failure costs exactly one strike per attempt; simultaneous causes never cost two. The third failure ends the run. Preserve DEC-014–018: one carrier, stamina relays, physics throws, assisted catches, solo viability, and no direct strike for exhaustion/misses. Use the status policy in §0: other v0.4 defaults remain proposed until selected or validated for the assigned prototype. Preserve DEC-019–023: connected run world, warehouse/satellite flow, two-district MVP, four-district long-term goal, and layered environment effects. Do not silently implement deferred systems or convert this entire GDD into one build request.

**Next implementation task, when requested:** Inspect the live M1 place and native save status; reconcile the existing TDS with OPEN-024–028, then extend the Studio-testable greybox carry loop with one Standard parcel, depot, destination, solo alternative, explicit pickup/drop/deliver, consensual handoff, stamina/regeneration with player-count presets, physics throwing and assisted catching, recovery, disconnect handling, and result-to-depot cleanup. No teleports, production persistence, economy, weather, or monetization. Record the handling measurements and fresh-tester evidence before expanding. The current M1 depot reset is a test harness, not the final station flow; resolve OPEN-029–033 before the relevant later world/event implementation.

**End of v0.4.** For a concise audit and priorities, see `Package_Problems_GDD_v0.4_Review.md`.
