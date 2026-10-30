# PACKAGE PROBLEMS
## Game Design Document — Draft v0.4 — Development Refinement

**Date:** 2026-10-30  
**Platform:** Roblox; desktop and mobile first  
**Audience:** Designer, developer, Codex implementation assistant, QA/playtesters  
**Owner:** Project team, primarily one developer + Codex  
**Status:** Design review. Endless progression, fifth-delivery crises, and three shared strikes remain confirmed. The owner additionally confirmed package HP and a delivery time limit: either 0 HP or expiry fails the mission. Other new behavioral defaults remain proposals.  
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

**Revision history:** v0.2 replaced a fixed ten-delivery ending with endless runs and fifth-delivery crises. v0.3 confirmed three shared strikes and termination on the third legitimate failure. v0.4 resolves conflicting failure descriptions, separates logical deliveries from attempts, specifies missing interaction/economy/session behavior, narrows base MVP scope, and adds acceptance criteria and review gates. During this review, the owner confirmed BOTH failure conditions: the package reaches 0 HP OR the delivery time limit expires. This replaces the initial rating-only timer recommendation. v0.3 is retained unchanged for comparison.

### 0.1 Confirmed decisions

| ID | Decision |
|---|---|
| DEC-001 | Primarily one developer + Codex. |
| DEC-002 | Balanced comedic physics and skillful cooperation. |
| DEC-003 | Separate instance for the team, not one large persistent public delivery world. |
| DEC-004 | Continuous run consisting of short, structured deliveries in a shared neighborhood. |
| DEC-005 | On-foot pickup, carry, drop, and handoff; no delivery vehicles initially. |
| DEC-006 | Long-term variety comes from harder contracts, package behaviors, and adaptation. |
| DEC-007 | Flexible schedule; validate gameplay quality before feature expansion. |
| DEC-008 | Successful deliveries award in-run coins used to purchase adaptation equipment. |
| DEC-009 | A major challenge/event occurs at each fifth successful delivery: 5, 10, 15, 20, and onward. |
| DEC-010 | Solo, friend teams, and players grouped through matchmaking are intended access paths. |
| DEC-011 | No fixed final delivery; continue until the run ends by choice or failure. |
| DEC-012 | Each run begins with 3 shared Company Strikes. Each legitimate failed attempt consumes exactly one team strike; the third failure ends the run. |
| DEC-013 | Every mission has a package HP bar and a delivery time limit. Reaching 0 HP OR failing to deliver within the limit fails the mission. Either cause consumes one shared strike; simultaneous causes still consume only one. Confirmed by the owner during v0.4 review. |

### 0.2 Vocabulary and counting

| Term | Exact meaning |
|---|---|
| Run | One team session with a unique `runId`, depth, and shared strike budget. |
| Depth / completedContracts | Number of successfully resolved deliveries in this run; starts at 0. |
| Delivery number | `completedContracts + 1`; retries keep this number. |
| Contract | The chosen package, destination, route rules, weather, rating targets, and failure conditions for one delivery number. |
| Attempt | One execution of that contract; each start or retry receives a new `attemptId`. |
| Crisis | A contract for which `deliveryNumber % 5 == 0`; the event runs DURING that delivery, before its success. |
| Recovery | Repositioning/restoring a valid active attempt; not a terminal outcome and not a retry. |
| Technical cancellation | Terminal neutral outcome for an invalid attempt; no strike, success award, or depth increase. A replacement has a new attempt ID. |
| Run member | An admitted player who has not exited or disconnected. |
| Deployed participant | A ready run member included when the current attempt starts. |
| Away member | A run member waiting safely at the depot, excluded from the current attempt and its rewards. |

**Example:** At depth 4, the next attempt is delivery 5 with rain already forecast. A failure leaves depth 4. A successful retry sets depth 5 and next delivery 6. There is no additional event after delivery 5 succeeds.

### 0.3 Scope and approval boundary

Use only the active milestone (§14). Configure proposed prices, timing, damage, capacities, and modifiers centrally; the confirmed initial strike count is 3. Unapproved failure mechanics may be tested in an isolated prototype with simulated rewards. They must not silently become production rules. This revision authorizes no game implementation or publishing by itself.

## 1. High concept and player promise

**Working title:** Package Problems. **Tagline:** Deliver the undeliverable.  
**Genre:** Cooperative physics comedy with short delivery challenges and an endless run structure.

A proposed team of 1–4 delivery workers enters its own neighborhood, carries unusual packages through readable obstacles, and buys temporary equipment with delivery earnings. Every fifth delivery is a forecasted crisis. The goal is to complete as many deliveries as the team wants before losing three shared strikes. Permanent progress is earned along the way; departure is not a forfeiture mechanic.

The five pillars are package handling, controlled chaos, simple cooperation, preparation, and respect for player time. Every mandatory route must work solo and without purchased equipment. Comedy comes from recoverable mishaps and readable reactions; unfair physics failures undermine the premise.

**Session targets — PROPOSED:** First delivery 1–3 minutes; ordinary deliveries 2–4 minutes; crises 3–5 minutes; preparation usually 20–45 seconds. Three to five deliveries should feel worthwhile. These are pacing targets, not countdowns or forced session lengths.

**Non-goals:** Vehicles, combat/PvP theft, mandatory dual carrying, procedural city generation, permanent power grind, trading, global leaderboards, paid gameplay boosts, or a final boss at delivery 10. Broad content expansion and monetization are not prototype prerequisites.

## 2. Session structure and readiness — PROPOSED details

### 2.1 Formation, admission, and departures

The public lobby offers Solo and Friends/Party; a simple same-lobby Find Team path is required before unrestricted public release (§14). Every party member readies before launch. A party leader manages invitations but cannot override readiness, spend others' coins, or impose a strike.

Freeze the launch roster before transfer to a team-only run. Start at the depot only after arrival and profile loading complete. Use a provisional 60-second arrival timeout. If a member fails to arrive, show the missing member and offer the arrived members **Wait again**, **Continue with arrived players** (unanimous), or individual **Return to Lobby**. No attempt, gear charge, or strike starts during loading. Continuing closes admission for that launch; a late arrival returns safely to the lobby. Returning/failed teleports must not trap players in a loading screen.

No new members or disconnected-player rejoin in the base MVP. Roblox character respawn is not a disconnect and does not remove run membership. Departure by the party leader does not end the run; depot readiness works without a leader. When everyone has left, clean up the run as `TeamEmpty` with no strike.

### 2.2 Depot preparation

1. Reveal the complete next contract: destination, route catch, package, weather, free alternative, failure conditions, and rating targets. The briefing cannot change after purchases without a clear correction and fresh readiness.
2. Return all deployed players to the depot after a result; this advertised between-attempt relocation is part of the loop. Reset route mechanisms and weather. Disable package damage during preparation.
3. Let each player purchase/equip and select **Ready**, **Away**, or **Leave Run**. Purchases or loadout changes clear that player's Ready status.
4. All non-Away members must be Ready. Show a cancellable 3-second start countdown; anyone becoming unready cancels it. No majority-start mechanic.
5. A member who has neither readied nor explicitly selected Away after 90 seconds receives a 15-second prompt. If unanswered, mark that member Away at the depot; do not eject them or consume a strike. Explicitly choosing Keep Preparing restarts their timer. These thresholds are tunable.
6. Require at least one Ready player. Freeze deployed participants and loadouts at attempt start. Away members cannot interact with the live package or receive that attempt's awards; they can ready for the following attempt.

The 20–45-second pacing target is not an automatic start deadline. An intentionally unready teammate can still delay the group; individual exit remains available. A host-force-start or vote-kick is excluded from this MVP.

### 2.3 Lifecycle

```text
Lobby → Loading → DepotPreparation → ContractActive → Result → DepotPreparation
                                                └→ third failure → RunSummary
TechnicalCancellation → DepotPreparation (same delivery, new attempt ID)
IndividualExit → personal summary / lobby; other members continue
No members → TeamEmpty / cleanup
Service shutdown → ServerInterruption / best-effort save and cleanup
```

Result presentation lasts a proposed 5 seconds or until all deployed members dismiss it. It cannot hold the team indefinitely. Preparation, results, and loading never count toward a delivery timer. Opening a personal menu does not pause a multiplayer attempt; display that behavior.

## 3. Core loop and contract selection

**Loop:** Preview → prepare → pick up → navigate / assist / recover → deliver → receive result and rewards → prepare again or leave.

One active package, one destination, and one active attempt per run in the base MVP. The director selects the contract; players choose routes and equipment, not a contract reroll. A future contract-choice board is deferred.

### 3.1 Required authored contract data — INVARIANT structure

| Field | Required contents |
|---|---|
| Identity | Stable template ID, version, run configuration version, delivery number, attempt ID. |
| Eligibility | Tier, ordinary/crisis tag, package ID, allowed player counts, taught prerequisites. |
| World | Pickup point, destination zone, ordered safe recovery checkpoints, primary and free alternate routes. |
| Challenge | One introductory catch or a tested set of compatible catches; all active weather and route modifiers. |
| Failure | Both `PACKAGE_DESTROYED` at 0 HP and `DEADLINE_EXPIRED` at the time limit; configured starting HP, impact thresholds, and hardDeadline; any proposed abandon rule stated separately. |
| Rating | Good and slow time targets, quality metric, one optional objective or none. |
| Presentation | Briefing text, objective marker, hazard signs, equipment suggestions, accessible cues. |
| Validation | Solo/mobile route test record, package-clearance results, version of measured carry metrics. |

Reject invalid combinations before briefing. A deterministic run seed plus template/configuration versions and selection history must reproduce a test run; a seed by itself is insufficient. Keep the current contract fixed across legitimate retries, including its target times and modifiers. A technical cancellation may replace an invalid template with a validated fallback at the same delivery number and with the same crisis tag; explain the change and repeat preparation.

### 3.2 Variety and difficulty — PROPOSED

| Next delivery number | Tier | Permitted complexity |
|---|---:|---|
| 1–4 | 1 | One catch; teach each required mechanic before combining it. |
| 5–9 | 2 | Up to two compatible catches; first rain crisis at 5. |
| 10–14 | 3 | Two familiar mechanics with a route choice. |
| 15 onward | 4, capped | Up to three tested interactions; no unlimited increases in force, damage, or timing pressure. |

Use **next delivery number**, not completed depth, to select the tier. Player count does not multiply package health, damage, required tasks, or deadlines in the base MVP. Cooperative advantages come from supporting actions and handoffs. A change in deployed player count never requires a new mandatory route mid-attempt.

Maintain the last three successful template IDs. Avoid recent repeats when an eligible alternative exists; relax the oldest exclusion first, then permit repetition. Retry attempts do not update this history. Select only authored compatible combinations. If no tested crisis template is available, block start and report a content error; never substitute an ordinary delivery to skip the crisis.

### 3.3 Initial content matrix — PROPOSED, not validated content

Five working destinations: Corner House, Mini Mart, Community Hall, Apartment Lobby, Garden Workshop. Ten templates are a target; ship fewer only if they cover teaching, crises, and sustained replay in tests.

| ID | Earliest use | Parcel / weather | Catch and solo solution |
|---|---|---|---|
| CT-01 Corner Practice | Delivery 1, then ordinary rotation | Standard / dry | Low barrier requires a drop and side-switch interaction; gate latches open so one player can retrieve parcel. |
| CT-02 Careful Corner | Delivery 2, then ordinary | Fragile / dry | Marked rough shortcut versus wide paved detour; coach gentle placement before the risky section. |
| CT-03 Shop Gate | Delivery 3, then ordinary | Standard / dry | Gate opens from a reachable switch and remains open for a solo traverse; bypass always available. |
| CT-04 Hall Steps | Delivery 4, then ordinary | Fragile / dry | Direct steps versus longer ramp; telegraph impact risk. Forecast rain before next preparation. |
| CT-05 Rain Crossing | Crisis 5 | Fragile / rain | One wet bend and wider dry detour; no new gate mechanic. |
| CT-06 Garden Detour | Tier 2 ordinary | Standard / dry | Visible roadwork blocks the direct path; route signs lead around it without a paid tool. |
| CT-07 Apartment Turn | Tier 2 ordinary | Fragile / dry | Tight corner versus broad ramp; no mandatory precise jump. |
| CT-08 Rain Hall | Crisis 10 | Fragile / rain | Wet approach and familiar steps/ramp choice. |
| CT-09 Rain Gate | Crisis 15 | Fragile / rain | Familiar gate and wet approach; latching gate plus dry bypass stay solo-valid. |
| CT-10 Rain Workshop | Crisis 20+ | Fragile / rain | Route detour and wet bend; visible rest/checkpoint before final approach. |

Deliveries 1–4 use CT-01 through CT-04 in order. Crises 5/10/15 use CT-05/08/09. At 20+ rotate CT-05/08/09/10 with capped tier-4 parameters and anti-repetition rules. Ordinary deliveries 6+ select eligible non-crisis templates. Familiar simple deliveries are intentional breathing room. No fifth-delivery crisis introduces an unpracticed lethal mechanic.

## 4. Player interactions — PROPOSED

### 4.1 Movement and controls

Use a third-person camera and familiar Roblox walk/jump controls. No sprint, throw, dash, stamina, or ragdoll requirement in the base MVP. Carrying reduces base walk speed to an initial 85%; tune through a measured test course before building final routes. A required route must not need a precision jump. Standardize the gameplay collision envelope across supported avatar appearances so cosmetic body size cannot break clearance.

| Action | Desktop prototype | Mobile behavior |
|---|---|---|
| Context action | E | Large contextual button with verb and target. |
| Drop | Q while carrying | Separate Drop button, spaced from interaction. |
| Inspect | I / package-info button | Persistent package-info button. |
| Equipment | 1 / 2 | Two slot buttons, with passive/active state. |
| Menu | Escape / on-screen menu | On-screen menu; leave confirmation separate from abandon. |

Keybinds are provisional UI defaults. Context selection highlights one target and displays its action before activation; prefer delivery at the correct zone, then a valid handoff, then an aimed object. Menu input must not also trigger a world action. No essential action requires chat, voice, rapid tapping, or a long precision hold.

### 4.2 Pickup, carry, handoff, and delivery

- Pickup requires the deployed player to be within a proposed 8 studs with an unobstructed reach and an available package. Validate on the server. First valid request wins; another player sees **Already carried**.
- A recipient requests a handoff within 8 studs; the carrier explicitly accepts within 5 seconds. Recheck range and membership at acceptance. The transfer is atomic; neither player can steal or force the parcel onto the other. Clear the request on drop, departure, or resolution.
- Drop places the parcel into the nearest valid ground position in front of the carrier, with no added throwing impulse. If blocked, keep carrying and show **No room to place**. A low-speed placement is damage-free.
- One carrier remains authoritative despite visual sway. Preserve integrity, condition, equipment effects, and timer through a handoff.
- Delivery requires an explicit context action at the correct zone; walking over or throwing a parcel into it cannot silently complete. The server validates parcel identity, destination, objectives, player reach, and credible package position. Accept either a carried package whose placement preview fits inside the zone or a dropped package resting inside it. On acceptance, snap safely to the marked pad, resolve once, and freeze further handling.
- Wrong destination or blocked placement gives feedback without a strike. An already failed or destroyed package cannot deliver. The TDS must validate movement history/route legitimacy as well as final proximity.

### 4.3 Package lifecycle and recovery

```text
AtDepot → Available → Carried ↔ Dropped → Delivered
                         ↕
                     Recovering
Any active state → Failed / Cancelled → cleanup
```

Recovery uses the last **server-validated safe checkpoint already reached**, with the pickup point as fallback. Checkpoints are authored, on reachable routes, and never advance from an untrusted position update alone. Do not heal damage, reset the clock, replenish gear, increment depth, or award currency through recovery. Clear velocity and prevent the relocation itself from dealing damage.

Automatic recovery handles out-of-bounds parcels, invalid geometry, or a departed carrier. A deployed member can request Recover when the server finds the parcel unreachable or not moving despite attempted handling. Use a provisional 10-second request cooldown; manual requests cannot recall a valid parcel held by an active teammate. A suspected exploit is rejected or recovered safely, not converted into an invented strike cause.

Repeated recovery at the same bad location falls back to the prior checkpoint. Two failed recoveries there cancel the invalid attempt neutrally; retain the last valid integrity/gear state until cancellation rollback. Never loop recovery forever. Manual recovery has no separate score deduction in the base MVP; ordinary elapsed time continues toward bonuses and the hard deadline. Verified server-fault recovery freezes gameplay and excludes recorded downtime from both clocks (§5.2). This replaces v0.3's unspecified recovery penalty.

### 4.4 Respawn, idle carriers, and collision grief

Character reset/death returns the player to the most recent safe player checkpoint and releases/recovers the parcel there. Preserve membership, gear, coins, and existing integrity; no direct strike, no healing, and no forward shortcut. A zero-integrity failure already accepted by the server cannot be undone by respawning or leaving.

Disable player-to-player pushing and damage. Non-carriers cannot impart damaging impulses to the active parcel. If a carrier has shown no server-observed movement or valid interaction for 60 seconds, show a 15-second resume warning; if unanswered, release the parcel safely for teammates. Do not deduct a strike or remove the player from a team-abandon vote. These timers are prototype defaults, not a complete anti-cheat system.

## 5. Package HP and time limits — CONFIRMED failure conditions / PROPOSED tuning

### 5.1 Base MVP

| Archetype | Rules | Natural failure |
|---|---|---|
| Standard | Starts at a proposed 100 HP; durable, predictable carrying with lower impact damage. | 0 HP or the delivery deadline expires: mission fails, one shared strike. |
| Fragile | Starts at a proposed 100 HP; takes greater damage from meaningful validated impacts. | 0 HP or the delivery deadline expires: mission fails, one shared strike. |

**Owner-confirmed v0.3 conflict resolution:** Every mission has BOTH a package HP bar and a hard delivery deadline. A package at 0 HP cannot be delivered; a healthy package delivered too late also fails. One attempt still loses at most one strike, even if HP reaches zero when time expires. “Integrity” in internal data means package HP; display **Package HP: current / maximum** and **Time remaining** to players. Warn at a proposed 25% HP and at 30/10 seconds remaining using text/icons as well as sound. Exact HP, damage, and time values are tunable.

Package damage must be discrete and readable. One collision episode applies damage once, not once per contact callback. Initial test values are 5/10 HP for moderate/severe impacts on Standard and 10/25 HP on Fragile, with a 0.5-second same-contact cooldown. Foam halves these values. Track fractional HP internally; if the UI uses whole numbers, round positive HP upward so it never displays 0 before failure. Never infer a new impact solely because the cooldown expired while resting against a wall.

**Required measurement before enabling damage:** Record package normal-impact speed during deliberate placement and safe walking on the approved route. Set the moderate threshold above that measured safe envelope; set severe initially at twice the moderate threshold, then test. Log speed, surface, damage, and source per impact. Thresholds in studs/second remain OPEN until the carry prototype establishes a scale; do not guess production values or use visual client impulses as proof.

Exclude spawn, pickup, handoff, recovery, teleport, respawn, and server-correction impulses from damage. A single ordinary severe impact cannot destroy a fresh parcel. Show a short visual/audio impact cue and the numerical loss. If the implementation cannot distinguish normal handling from damage reliably under latency, keep damage disabled and block failure-model release validation.

### 5.2 Delivery clock — CONFIRMED expiry failure / PROPOSED timing details

Each contract declares a finite `hardDeadline` before preparation purchases. Start its server-authoritative elapsed clock when the attempt becomes Active and the parcel is available, not when a player eventually picks it up. Delivery is valid only while `elapsed < hardDeadline` and HP is above zero. At `elapsed >= hardDeadline`, resolve `DEADLINE_EXPIRED` once; the UI shows zero and no late delivery can rescue the attempt. Round displayed positive remaining seconds upward so 0:00 means actual expiry. Do not trust a client timestamp or grant an undisclosed latency grace period.

Use the measured free solo/mobile route time to set a generous initial limit (§8.3), including interaction and learning time. Shorter optional bonus targets are separate from this failure deadline. Ordinary and crisis contracts both have limits, but deadlines do not shrink automatically forever with run depth. Preparation/results/loading do not count. Dropping, handoff, ordinary recovery, respawn, personal menus, and a teammate's departure do not restart or pause the clock. Verified server-fault recovery freezes gameplay and both clocks during the recorded interruption; if safe continuation is impossible, cancel neutrally. The client must show **Delivery paused — recovering package** during that verified pause.

A retry gets the same full deadline with a new attempt ID, fresh package, and fresh elapsed clock. A stale timer from a resolved attempt cannot fail its replacement. A valid success accepted before expiry stays successful even if its result animation or save finishes later.

### 5.3 Deferred packages and properties

Inflatable is deferred from the base MVP, with a later Small → Medium → Large prototype and explicit compression cooldown. Every stage requires a wide free route and safe scaling. Magnetic, Shape-shifting, water exposure, and their dedicated tools are deferred. No shop offers a tool whose associated mechanic is disabled.

## 6. Neighborhood and route design

One consistent low-poly neighborhood contains a safe central depot, five destinations, connected paths, gate/steps/rough-surface catches, and marked wet surfaces. Mission changes affect authored obstacles and conditions, not unexplained city regeneration.

**PROPOSED blockout rules:** Measure empty/carry speed, stopping distance, jump reach, interaction reach, camera clearance, and largest approved package/character collider before sizing routes. Size safe corridors for package plus player clearance with at least 25% margin over the measured sweep; validate corners, not just straight widths. Required switches must remain reachable after dropping the parcel. Gates latch long enough for the slowest supported solo traverse and have a free bypass.

Each route has a short graph from pickup through recoverable checkpoints to destination. Validate it for no gear, Fragile carrying, rain where applicable, and one player. Shortcuts must advertise their risk and not be the only viable path. Use signs, landmarks, and objective arrows without requiring players to read chat. A scenic calm section after a difficult interaction supports both recovery and pacing.

## 7. Weather and crises — PROPOSED implementation

Heavy Rain is the only base MVP weather. It lasts for one active crisis attempt and resets before depot preparation. The forecast appears after delivery 3 and again before 5; every later crisis is announced in its immediately preceding preparation, including retries.

Rain changes control only on clearly marked wet surfaces. Start with 25% longer stopping distance on those surfaces at the same initial carry speed; Grip Boots reduce that extra distance to 10%. These are measurable playtest targets, not instructions to set raw physics friction to a particular value. If physical slipping is unreliable, test a clearly labeled wet-surface movement modifier and revise the tool description before release.

Dry detours are slower but remain fully usable with no gear. Wet routes do not hide mandatory instant-fail pits. Rain does not damage parcels or globally reduce visibility. Preserve signs, markers, and package readability; decorative rain density can scale down independently of gameplay.

The first rain crisis combines previously taught Fragile handling with one wet bend. Later crises add familiar route catches (§3.3). Always teach a new mechanic safely before a crisis tests it. Wind, fog, water sensitivity, and unique weather every fifth delivery are deferred.

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
crisisBonus = 0.25 if crisis else 0
coinsPerPlayer = floor(100 * (1 + qualityBonus + streakBonus + crisisBonus))
reputationPerPlayer = 10 + (5 if crisis else 0)
```

Time targets are authored per template: measure three uncoached solo/mobile completions on the free safe route in an untimed calibration test. Provisionally set `goodTime` to the slowest observed completion time, `slowTime` to twice that, and `hardDeadline = max(180 seconds, ceil(slowTime + 60 seconds))`. Require `0 < goodTime < slowTime < hardDeadline`; confirm the final limit with fresh timed playtests, including tutorial reading and network conditions. These are initial tuning rules, not guaranteed fair times. Example: observed slowest time 90 seconds gives bonus targets 90/180 seconds and a 240-second failure deadline. Completing after slowTime but before hardDeadline still succeeds with no time bonus; reaching hardDeadline fails regardless of HP. Optional objectives never cause a strike, never require paid gear, and never require two players.

Increment streak after calculating the success award. Legitimate failure grants 0 new coins/XP and resets streak; technical cancellation neither pays nor resets streak. Earlier earnings are retained. Round coins once after summing bonuses. Display the breakdown and a simple quality label: Excellent at rating ≥0.85, Good at ≥0.60, Delivered below 0.60; the label never changes success into failure.

**Worked checks:** A perfect first Standard delivery pays 120 coins and 10 XP. Four perfect ordinary successes pay 120 + 130 + 140 + 150 = 540 coins. Perfect crisis 5 pays 175 coins and 15 XP; total at depth 5 is 715 coins and 55 XP before spending. A perfect ordinary success immediately after a legitimate failure pays 120 coins. Ordinary payout is capped at 150 and crisis payout at 175 per eligible player; raw depth does not multiply earnings.

### 8.4 Equipment lifecycle

Two shared-purpose equipment slots per player; passive and active items both occupy slots. No backpack stockpile and no duplicate item type. Shop only at depot; show effect, remaining uses, price, and relevant next-contract condition. Empty slots cost nothing.

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

## 9. Cooperation, exits, and votes — PROPOSED

Cooperation comes from consensual handoffs, solo-operable gates, route guidance, and choosing who applies Foam. Optional shortcuts can reward coordination without making the safe route dependent on multiple players. A teammate cannot take a held parcel, drain another wallet, cause friendly damage, or force a strike by clicking Retry alone.

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
- Save delay during an attempt: finish the current attempt and retain pending awards. At the next depot, hold new starts until the pending persistent awards for remaining members are acknowledged. Explain the hold and allow exit; no strike or loss of temporary gear solely from waiting.
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

Package destruction at 0 HP and delivery-deadline expiry are CONFIRMED failure conditions. Unanimous abandon remains a PROPOSED additional failure action. `SPECIAL_CONDITION_FAILED` is deferred. Missing a bonus-time target, wrong destination, low rating, player reset, disconnect, unauthorized requests, physics recovery, and platform faults are not themselves strike causes. However, ordinary player recovery or a departure does not stop an otherwise valid clock: subsequent expiry still fails the mission. Confirmed server faults use the neutral pause/cancellation rules in §5.2.

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
| Depot | Completed depth and next number separately; full contract card; forecast; strikes; coins; gear; Ready/Away/Leave; save status. |
| In-world HUD | Destination, carrier, always-visible package HP bar and Time remaining countdown, strikes, tools/uses, current contextual action. Optional bonus targets are secondary and clearly distinct from the failure countdown. |
| Result | Success or specific failure reason, time/quality/optional-objective breakdown, each personal award, strikes and depth. |
| Run/personal summary | End/exit reason, records, confirmed/pending earnings, expired run resources, lobby-return action. |

The normal strike label is **Company Strikes remaining: 3 / 3**, supported by icons and text. A loss message is **Package destroyed — 1 team strike lost. 2 remaining.** Do not name a teammate as the cause or publish a blame board.

First-time onboarding is embedded in delivery 1. Explain **0 HP or time runs out = failed delivery and 1 team strike** before Ready starts its clock. Within a target minute, teach pickup, drop, recover, interact, and deliver with durable Standard cargo; use a generous measured deadline that includes reading time. Allow prompts to be replayed or skipped. A completed tutorial flag suppresses extended instructions in later runs without skipping delivery numbers. Delivery 2 coaches Fragile's higher damage sensitivity with a safe placement area before any dangerous shortcut. Show a risk preview before its first impact challenge. Never make the first rain crisis the first explanation of HP or the deadline. An isolated untimed practice/calibration area may exist outside the rewarded mission loop; real delivery 1 still has both confirmed failure conditions.

Desktop keyboard/mouse and mobile landscape are required release targets; console/gamepad release is deferred. Verify mobile at 16:9, tall-phone landscape, and tablet 4:3 with real safe-area insets. Keep action buttons outside movement/camera areas. Scale text, retain readable contrast, pair color with labels/icons, and support reduced motion, shake off, and separate music/SFX levels. Critical cues cannot be sound-only. Externalize player-facing strings; initial language is English, with other localization deferred. Do not expose implementation IDs or technical error traces in normal player UI.

## 13. Visual and audio direction — PROPOSED

Friendly colorful suburban workplace comedy; low-poly shapes, oversized readable parcels, distinctive silhouettes, and restrained effects. Give wet pavement a persistent readable material cue even with rain particles reduced. Keep carry sway cosmetic where possible so the player can predict clearance.

Audio communicates pickup weight, gentle placement, damaging impact, low integrity, forecast, success, and strike loss. Pair each critical sound with a visual cue. Keep failure feedback short and explanatory; humor must not obscure the cause. Final art production follows successful greybox handling and route tests.

## 14. Build scope and milestone gates — PROPOSED plan

No implementation has been completed by this document. Create a TDS and acceptance-testable tickets before production code. Implement only the current milestone.

| Milestone | Included | Gate before expansion |
|---|---|---|
| M1: Carry slice | One Standard parcel, depot, destination, alternative path, pickup/drop/handoff/recovery/delivery, result loop; solo and two-client Studio tests. | Fresh tester uses the core action within ~30 seconds and completes a loop without coaching; repeated loops and disconnect do not strand parcel. |
| M2: Endless state | Depth, crisis flags, retry IDs, three shared strikes with simulated 0-HP/deadline failures, cleanup, safe exit/summary. | 21 successful simulated contracts; correct 5/10/15/20 crisis flags; three failures end once; simultaneous HP/expiry and stale timers harmless. |
| M3: Failure and rain | Standard/Fragile HP bars and measured damage, hard deadlines, coached warning cues, rain/free route, exact retry, proposed team-abandon semantics. | Both confirmed failure causes work; deadlines and impacts fair under solo/mobile/latency tests; causes understood; crisis needs no purchased tool. |
| M4: Economy | Coins, team ratings, two tools/two slots, charge/stack/rollback rules. | Worked reward values reproduced; no double purchase/use/refund; spending remains a meaningful choice. |
| M5: Progress | Profiles, Reputation/cosmetics, bestDepth/totalDeliveries, pending save UI and fault behavior. | Failed loads cannot erase data; repeated/unknown-result writes do not duplicate awards; multi-session conflicts handled. |
| M6: Sessions | Public lobby, Solo/Friends, run admission, readiness/Away, departures, published-client teleport tests. | No unrelated joins, partial arrival handled, leader departure safe, no loading or return trap. |
| M7: External release | Same-lobby Find Team, content matrix, accessibility, mobile/performance, instrumentation and release QA. | All release gates in §§16–17 pass; unmet content goals are reported honestly. |

Friends/solo-only closed tests may precede M7. Calling them the complete public MVP would hide DEC-010's matchmaking access path. Cross-server matching remains deferred; an empty same-lobby queue offers Solo or continued waiting instead of indefinite forced waiting.

For M1, use the prototype-fast skill's one-question brief: **Is pickup/carry/place satisfying without rewards?** A throwaway handling experiment can use a 60–90 minute timebox; this is not the deadline for the full milestone. Keep if testers intentionally repeat the loop; refactor if one movement variable dominates frustration; cut/rethink the handling approach if explanation or added progression is the only reason to continue. Record whether code is disposable before writing it.

**Base MVP:** One neighborhood/five destinations target, Standard + Fragile with HP bars and hard delivery deadlines, roughly ten validated templates, rain, two useful tools, endless depth/three strikes, personal wallets, persistent cosmetics/records, solo/friend/same-lobby grouping, desktop/mobile UI. Reduce content quantity before reliability. Deferred: Inflatable, water exposure/Rain Cover, other weather, vehicles, procedural map generation, trade/banking, global leaderboards, active-run resume, late joins, complex anti-AFK scoring, console release, and monetization systems.

## 15. Technical handoff constraints

The server owns membership, readiness, active attempt, carrier, condition, outcomes, depth, strikes, purchases, awards, and persistent progress. Clients request actions and present feedback. Validate identity, current state, distance/reach, permissions, rates, and credible geometry; client physics is not proof of legal delivery or damage. Roblox documents the risks of client-owned physics in its [network ownership security guidance](https://create.roblox.com/docs/scripting/security/network-ownership). The TDS must select and test the carry/authority approach; this GDD does not assume an engine authority mode.

Partition responsibilities into Party/Admission, Run, ContractDirector, Package/Interactions, Weather, Equipment, Economy/Awards, Persistence, UI, and instrumentation. Tear down attempt timers, effects, physics objects, requests, and connections on every terminal transition. Use finite recent-template/award histories and bounded queues. “Endless” does not mean unlimited memory or guaranteed infinite server uptime; technical shutdown is neutral, not a designed delivery cap.

Use separate lobby/run places for production team sessions. At this review date, the [official reserved-server documentation](https://create.roblox.com/docs/projects/teleport-private-servers) shows `TeleportOptions.ReservedServerId` with a server-generated GUID. Verify the supported API again at M6 and enforce the admission roster on the destination server. Never trust client-supplied teleport membership. Test transfer failures with published clients; M1 requires no production teleport setup.

**Required TDS outputs:** Module ownership and typed state schemas; run/package FSM; remote request/response/error contracts; deterministic resolution arbitration; contract/config schema; physical validation and damage measurements; profile migration/session ownership/award deduplication; finite resource limits; telemetry schema; teardown strategy; admission and save failure behavior; and tests corresponding to §16. Companion TDS, roadmap, and guardrails files are future work, not present deliverables of this revision.

## 16. Acceptance criteria

The following are specifications for future validation, not claims that a game has passed tests. Status applies to the behavior under test; proposed acceptance tests do not approve the design.

| ID | Requirement and observable check | Status |
|---|---|---|
| GDD-001 | Only the admitted team can enter its run; unrelated admission is denied. | CONFIRMED |
| GDD-002 | Complete deliveries 11 and 21; neither 10 nor 20 ends a successful run. | CONFIRMED |
| GDD-003 | At depth 4/9/14/19, the next active contract is crisis 5/10/15/20. | CONFIRMED |
| GDD-004 | Failing crisis 5 leaves depth 4; retry remains crisis 5. | PROPOSED retry policy |
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
| GDD-036 | Rewards match 120/130/140/150/175 for five perfect successes, including crisis 5. | PROPOSED |
| GDD-037 | Failed profile load cannot overwrite data; unknown write outcome cannot duplicate an award. | INVARIANT |
| GDD-038 | Partial arrival offers wait/continue/return; delayed admission after roster closure is rejected safely. | PROPOSED |
| GDD-039 | Skipped optional objective or exceeded bonus-time target lowers bonus; success still requires positive HP and elapsed time below the hard deadline. | PROPOSED rating; CONFIRMED failure conditions |
| GDD-040 | Save acknowledgement changes Pending to Saved; reconnect sees committed records without duplicate XP. | INVARIANT persistence |
| GDD-041 | Reset/respawn preserves membership and gear; recovery never advances checkpoint or restores integrity. | PROPOSED |
| GDD-042 | Wrong destination and blocked placement show feedback without losing parcel or strike. | PROPOSED |
| GDD-043 | With positive HP, reaching the hard deadline fails once; delivery at/after expiry cannot succeed. | CONFIRMED failure; PROPOSED exact boundary |
| GDD-044 | 0 HP and expiry in the same step deduct only one shared strike and award nothing. | INVARIANT |
| GDD-045 | Clock begins at Active, continues through normal handoff/drop/respawn/recovery, and resets only for a new attempt; stale expiry cannot affect it. | PROPOSED timing; INVARIANT attempt isolation |
| GDD-046 | Verified fault recovery freezes gameplay and clocks; valid completion before expiry remains success through result/save delay. | PROPOSED recovery; INVARIANT single result |
| GDD-047 | Every template has a finite measured deadline and visible HP/countdown; no-gear solo/mobile completion fits within it. | CONFIRMED dual constraints; PROPOSED tuning |

## 17. Playtest evidence and release gates — PROPOSED

Run tests in this order: carry feel → Fragile readability → solo/no-gear routes → rain preparation → cooperation → crisis 5 → sustained depth 20+ → interrupted sessions. Test each mechanic independently before combinations. Use observed evidence rather than declaring a system fun because it meets a numerical rule.

| Gate | Provisional pass signal |
|---|---|
| Comprehension | At least 4 of 5 fresh testers finish the first delivery without verbal coaching and explain why a later strike occurred. Small sample is an iteration gate, not a retention forecast. |
| Agency | A solo mobile tester completes each template on the free route and can leave/recover without assistance. |
| Desire to repeat | At least 3 of 5 testers voluntarily attempt another delivery after the first three; record why others stop. |
| Fair damage | No repeatable damage from ordinary placement/handoff/recovery in solo and 2/4-client sessions, including 100/200 ms simulated latency tests. |
| Fair deadlines | Each template can be completed on its free solo/mobile route before expiry by fresh testers; verify just-before, exactly-at, and just-after deadline results plus simultaneous 0-HP/expiry. |
| Rain/tool value | Testers identify the wet risk and free route; Boots produce a measurable improvement without making all wet handling trivial. |
| Long-run stability | 50 alternating success/failure/cancel cycles show no monotonic growth in attempt connections, packages, timers, or effects; production idempotency history also remains bounded. |
| Performance | Provisional mobile target: at least 95% of frames within 33.3 ms during a representative 10-minute four-player rain test. Desktop target: 16.7 ms. Select named minimum test devices before claiming support. |
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

Applied repository skills under `.agents/skills/`: `router` for scope, `level-design` for measured routes and teach-before-test pacing, `prototype-fast` for carry validation, `game-ui-ux` for screen states/mobile readability, `save-systems` and `roblox-datastores` for versioned progress and failure behavior, and `roblox-networking` for server authority and race/lifecycle requirements. No live Studio changes or game tests were performed during this document review.

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
| OPEN-010 | Rain-only crises with authored route/package variations. | M3/content review; PROPOSED. |
| OPEN-011 | 1–4 members, always solo-valid; no numerical party-size difficulty scaling. | M6; PROPOSED. |
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
| OPEN-022 | Hold new attempts at depot while remaining members have pending persistent awards. | M5 failure/recovery review; PROPOSED. |
| OPEN-023 | Exact tie priority for valid simultaneous terminal candidates in §11.3. | M2 state tests, before M3 live failure rules. |

**Next design lock:** The two failure conditions are selected; measure fair HP damage and achievable deadlines in M1/M3 before production tuning is locked. OPEN-001/002/005/006 and OPEN-023 define remaining run/attempt resolution details. Prices, FX, and cosmetic thresholds can remain tunable. No approval is needed merely to review or refine this document.

## 21. Codex-facing implementation brief

> Build only the explicitly assigned milestone. Preserve endless progression, `nextDelivery = completedContracts + 1`, crisis contracts at every fifth delivery, 3 shared initial strikes, and the confirmed dual failure conditions: package HP reaches zero OR the delivery deadline expires. Either failure costs exactly one strike per attempt; simultaneous causes never cost two. The third failure ends the run. Use the status policy in §0: other v0.4 defaults remain proposed until selected or validated for the assigned prototype. Do not silently implement deferred systems or convert this entire GDD into one build request.

**First implementation task, when requested:** Create a Studio-testable greybox carry loop with one Standard parcel, depot, destination, solo alternative, explicit pickup/drop/deliver, consensual two-client handoff, recovery, disconnect handling, and result-to-depot cleanup. No teleports, production persistence, economy, weather, or monetization. Record the handling measurements and fresh-tester evidence before expanding.

**End of v0.4.** For a concise audit and priorities, see `Package_Problems_GDD_v0.4_Review.md`.
