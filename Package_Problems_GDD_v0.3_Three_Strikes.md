# PACKAGE PROBLEMS
## Game Design Document (GDD) — Draft v0.3 — Endless Runs + Three Shared Strikes

**Status:** PRE-PRODUCTION / ENDLESS-RUN + SHARED-STRIKE RULES CONFIRMED; OTHER DEFAULTS REQUIRE REVIEW  
**Date:** 2026-10-30  
**Audience:** Designer, Roblox developer, Codex implementation assistant, QA/playtesters  
**Document owner:** Project team (primarily one developer + Codex)  
**Implementation rule:** This GDD specifies *intended behavior*, not a complete technical architecture. CONFIRMED choices are requirements; PROPOSED defaults are test hypotheses, not authorization to implement all features. Codex MUST prioritize the vertical slice and must not invent unresolved gameplay behavior.

---

## 0. Decision policy and revision log

**Statuses**
- **CONFIRMED** — explicitly chosen by the owner. Changes require an explicit revision.
- **PROPOSED** — the designer's recommended testable default; not yet user-confirmed.
- **DEFERRED** — specifically excluded from the vertical slice / MVP.
- **OPEN** — owner decision or playtest evidence needed before a production implementation.

**Revision v0.2 (2026-10-30):** Supersedes the v0.1 **fixed ten-delivery ending**, **mandatory five-delivery cash-out checkpoint**, and **endless-mode deferral**. The confirmed structure is now an **endless escalating team run with a major challenge at every fifth successful delivery**. Delivery 10 is a milestone, **not a finale**. Any conflicting v0.1 statement is obsolete. The milestones and economy below remain tunable.

**Revision v0.3 (2026-10-30):** Confirms **three shared Company Strikes at run start** and **immediate run termination on the third legitimate failed contract**. Incorporates a single authoritative contract-resolution path, clear strike-eligible versus no-strike events, anti-duplication behavior, retry semantics, strike-facing UI and QA. Only the three-strike count and termination condition were explicitly approved by the owner in this revision; proposed failure triggers, voting rules and equipment behavior remain marked PROPOSED.

### 0.1 Confirmed decisions

| ID | Decision | Status |
|---|---|---|
| DEC-001 | Primarily one developer + Codex | CONFIRMED |
| DEC-002 | Balanced comedic physics and skillful cooperation | CONFIRMED |
| DEC-003 | Separate instance for the team; not one large persistent public delivery world | CONFIRMED |
| DEC-004 | Continuous run consisting of short, structured deliveries in a shared neighborhood | CONFIRMED |
| DEC-005 | On-foot pickup, carry, drop, and handoff; no delivery vehicles initially | CONFIRMED |
| DEC-006 | Long-term variety comes from harder contracts, package behaviors, and adaptation | CONFIRMED |
| DEC-007 | Flexible schedule; validate gameplay quality before feature expansion | CONFIRMED |
| DEC-008 | Successful deliveries award in-run coins used to purchase adaptation equipment | CONFIRMED |
| DEC-009 | A major challenge/event occurs at each fifth **successful** delivery (5, 10, 15, 20…) | CONFIRMED |
| DEC-010 | Solo, friend teams, or players grouped through matchmaking are intended access paths | CONFIRMED |
| DEC-011 | Run has **no fixed final delivery**; team can keep going until run ends by choice or failure | CONFIRMED |
| DEC-012 | Every run begins with **3 shared Company Strikes**. Each legitimate failed contract consumes exactly one team strike; the run ends when the third strike is lost. | CONFIRMED |

### 0.2 Recommended defaults to review

| ID | Proposed rule | Why |
|---|---|---|
| PROP-001 | One to four players per run; all critical routes solo-completable | Availability and practical scope |
| PROP-002 | No strike restoration, purchase, premium continues or extra-strike rewards in MVP | Preserves a clear failure budget and avoids pay-to-continue pressure |
| PROP-003 | After a non-terminal failed contract, return to depot and retry the same delivery number; the crisis designation remains | Event cannot be skipped by intentionally failing |
| PROP-004 | Individuals may exit freely; a deliberate **team retry/abandon** command during a contract requires unanimous active-player consent | Respects players' time and prevents unilateral strike grief |
| PROP-005 | Reputation and personal-best depth are saved per successful contract; Run Coins reset on exit | Long-run savings safety; fresh equipment choices |
| PROP-006 | Individual Run Coin wallets and individual equipment purchases, with equal baseline team rewards | Simpler than shared economy and fewer disputes |
| PROP-007 | Maximum two equipment slots; equipment expires/consumes charges rather than providing permanent invulnerability | Continuous adaptation throughout an endless run |
| PROP-008 | First MVP event is heavy rain; later fifth-delivery crises vary by tested route/package combinations | Feasible solo-developer content scope |
| PROP-009 | After the early tiers, difficulty **plateaus in raw penalties** and increases via fair combinations/rotation | Prevent impossible runs and cheap arbitrary inflation |
| PROP-010 | Basic public teammate matching is a release goal but not required for first internal prototype | Access without friends, phased networking complexity |
| PROP-011 | Legitimate failures can come only from explicitly disclosed, tested irreversible package damage, validated hard deadlines, or unanimous abandonment; technical mishaps are free recoveries | Strikes feel deserved rather than arbitrary |
| PROP-012 | No strike on an individual exit, player disconnect, server shutdown, parcel-stuck recovery, or server-error cancellation | Prevents unfair shared punishment |

### 0.3 Ownership and change-control rule

Codex should write code only for the active implementation milestone in the roadmap. Any PROPOSED value (e.g. strike count, reward price, max active modifiers) must appear in centralized configuration with documentation. If a PROPOSED decision is consequential and unapproved, implement a tiny isolated prototype or defer it; do not treat it as CONFIRMED. Keep a change log as the design evolves. The **3-strike cap and terminal third failure** are confirmed constants; the precise *strike-trigger rules* and restoration/abandonment policies are still proposed until reviewed.

## 1. High concept

**Working title:** Package Problems  
**Tagline:** *Deliver the undeliverable.*  
**Genre:** Cooperative, session-based physics comedy / light roguelite delivery challenge  
**Platform:** Roblox, desktop and mobile first  
**Target session:** Flexible, player-directed: complete a few deliveries or compete for extended high-depth runs. The run has no time-based hard endpoint.  
**Audience promise:** Straightforward tasks create memorable, solvable moments when unusual packages, obstructed routes, teamwork, and weather combine.

**Pitch:** A team of 1–4 delivery workers enters its own neighborhood and attempts to complete as many escalating deliveries as possible. Every delivery features a recognizable catch. Players earn Run Coins, buy tools to adapt, and tackle a major crisis every fifth successful delivery. Keep going to improve the team's delivery depth, or leave at the depot with permanent reputation already earned. A team gets three shared legitimate contract failures before the run ends.

### 1.1 Design pillars
1. **Packages are the puzzle:** Standard, Fragile, and later Inflatable packages have different handling behaviors.
2. **Controlled chaos:** Silly moments emerge from readable forces and obstacles, not unpreventable failure.
3. **Simple cooperation:** Handoff, route knowledge, complementary equipment and helpful actions make a team better, but nothing requires 2+ players.
4. **Prepare, adapt, improve:** Forecasts, run-based coins and short equipment decisions matter every few contracts.
5. **Respect player time:** No predetermined ending, no coercive lock-in; progress already earned survives departure or disconnection.

### 1.2 Differentiation

Not a vehicle simulator, a passive tycoon, a generic obby, or a copy of another survival game. Its distinctive challenge is how **delivery object properties × environmental obstacles × equipment choices** interact inside a growing cooperative run.

### 1.3 Explicit non-goals for MVP

No delivery vehicles; open-world public delivery city; combat/PvP theft; permanent power-stat grind; dozens of weather types; full procedural map generation; trading; elaborate shop tech tree; monetization-dependent items; cross-server global leaderboard; or a final boss at delivery 10. The *endless system itself* is in scope, but extensive deep-run content is not.

## 2. Session, lobby, and endless-run structure

### 2.1 Topology and team formation

1. Players appear in a **public lobby** and select **Solo**, **Friends / Party**, or (after basic integration) **Find Team**.
2. A ready party of **1–4 players (PROPOSED)** enters its own reserved run instance. No unrelated players can enter its neighborhood.
3. All team members arrive at a central **Depot**, the safe preparation area containing the briefing board, equipment shop, weather forecast and exit.
4. The run cycles between the depot and individual contracts until its members depart or the team loses all three shared Company Strikes.
5. If everybody leaves, the instance closes naturally; permanent personal progress already earned remains saved.

Reserved run servers are *developer-managed* instances, not purchasable Roblox VIP servers. Teleports and error handling are production features; the first Studio prototype does not use teleports.

### 2.2 Endless milestone structure (CONFIRMED core / PROPOSED examples)

| Successful delivery number | Stage | Contract example |
|---|---|---|
| 1–4 | Orientation | Basic pickup, safe routes, introduction to Fragile or optional Inflatable |
| **5** | **Crisis #1** | Forecasted heavy rain and slippery marked surfaces |
| 6–9 | Growing Problems | Longer routes, optional shortcuts, more deliberate equipment choices |
| **10** | **Crisis #2** | Rain plus a tested route complication; not a finale |
| 11–14 | Advanced Contracts | Familiar mechanics arranged in newer combinations |
| **15** | **Crisis #3** | More demanding but validated rain / package / route combination |
| 16–19 | Mastery Rotation | Author-approved variations and modest added pressure |
| **20, 25, 30, ...** | **Recurring Crises** | Every fifth success triggers a difficult event assembled from the approved pool |

- **Run depth** is the number of **successfully completed contracts**; display it prominently and use it for high-score tracking.
- The next mission is `deliveryNumber = completedContracts + 1`. A *failed* contract does not increment completedContracts or skip a fifth-delivery event.
- Every fifth contract is a distinct **major event**, but does **not** require new weather assets every time. MVP repeatedly uses rain with varying approved obstacles and package conditions.
- After a crisis, the depot and route conditions return to the normal state unless the next mission explicitly says otherwise.
- Offer **Leave Run** at each depot; it does not require waiting for another milestone. Mid-contract disconnects are handled separately.
- The run has no final stage, fixed maximum depth, or required completion time; engine limits/maintenance still require saving progress and graceful shutdown handling.

### 2.3 A concrete session example

1. A three-player team completes deliveries 1–4 and buys Grip Boots or Packing Foam.
2. At the depot before delivery 5, the forecast warns of rain. The team chooses its equipment.
3. Delivery 5 succeeds: team depth becomes 5, and its players' Reputation and personal-best records are eligible for persistence.
4. They complete deliveries 6–9. At delivery 10, rain intersects with a harder authored route.
5. If delivery 10 legitimately fails, **one of the three shared Company Strikes is lost (CONFIRMED)**. After returning to the depot, the team retries *delivery 10* with a preparation opportunity; the event is not skipped.
6. Players can freely end their own sessions at the depot. Those remaining continue with player-count-aware future missions.

### 2.4 State diagram / lifecycle

`PublicLobby -> TeamReady -> LoadingReservedRun -> DepotPreparation -> ContractActive -> ContractResolvedSuccess -> DepotPreparation -> ...`

Additional states: `ContractResolvedFailure -> ApplyStrikeOnce -> DepotPreparation` (1–2 strikes lost, retry same delivery number); `ContractResolvedFailure -> ApplyThirdStrike -> RunSummary -> Lobby` (3 strikes lost); `ContractCancelledTechnical -> RestoreSafeState/DepotPreparation` (no strike); `IndividualExit -> PersistEarnedProgress -> Lobby`; `RunEmpty -> Cleanup`; `TeleportFailed -> SafeLobbyFallback`. Only the server can change strike and contract resolution states.

An individual player's **earned Reputation** must never depend on reaching delivery 5, 10 or any checkpoint. All earned completed-contract rewards survive a team wipe. The in-run wallet and ephemeral gear do not.

### 2.5 Session length, pacing and time agency

- First contract targeted at ~1–3 minutes, later ordinary deliveries ~2–4 minutes, plus a brief ~20–45s depot preparation (all provisional playtest targets).
- A team should be able to enjoy **3–5 deliveries and exit** without feeling its time was wasted.
- Deeper runs can extend well beyond an hour. No infinite hard increase in speed penalties or unavoidable attrition; difficulty must remain mechanically fair.
- Avoid mandatory cutscenes, idle waiting, long intermission timers, or rewards that require staying for an unreasonable duration.

## 3. Core and contract loops

### 3.1 Macro loop

`Form party -> Join reserved run -> Preview next contract + forecast -> Buy/equip -> Deliver -> Get run coins + Reputation + record -> Prepare again -> Continue indefinitely / leave / run ends at 0 strikes`

### 3.2 Contract micro-loop

1. **Briefing:** Destination, visible package property, route catch, weather (if any), rating objectives and approximate difficulty.
2. **Preparation:** Equip up to two tools and decide whether to spend Run Coins; all players confirm ready.
3. **Pickup:** A teammate obtains server-authorized possession of the parcel.
4. **Navigation:** Move, place, recover, hand off, use tools, operate environmental obstacles and choose routes.
5. **Delivery:** Reach the marked destination and place package inside an authenticated drop zone. Server validates package, objective and state.
6. **Resolution:** Grade time, package integrity and objectives; award each eligible participant once; update run depth only on successful completion.
7. **Loop or stop:** Return to depot, see next warning and select next contract or leave.

### 3.3 Every mission has a readable catch

Each authored mission includes one or more **approved** interactions: package property, route geometry, route event, marked terrain or an optional delivery constraint. Combinations come from a validity matrix—not unconstrained randomness. Players must be told what their package does, and a solo-safe path exists without owning specific gear.

### 3.4 Retention through breadth, not punishment

- Different destination/package/route pairings, tool choices and crisis preparations sustain replayability.
- Personal best depth, event milestones and cosmetic unlocks provide milestones without putting teammates in direct competition.
- New contract options can be added as authored content without rewriting the core run system.
- No automatic difficulty scaling that simply shrinks deadlines forever or makes movement uncontrollable.

## 4. Player interaction and package handling

### 4.1 Controls (design intent)

| Action | Desktop concept | Mobile concept |
|---|---|---|
| Pick up / hand off / deliver | Context interaction | Large context interaction button |
| Drop | Dedicated action | Dedicated button while carrying |
| Inspect package | UI prompt / hotkey | Tap package-info button |
| Use active tool | Assigned equipment key | Equipment slot button |
| Interact with gates/switches | Context interaction | Context button |

Final keybinds and touch layout belong to the TDS / UI prototype, not this GDD.

### 4.2 Package state machine

`AtDepot -> Available -> Carried -> Dropped -> Carried ... -> Delivered`  
Exceptional states: `Recovering`, `Failed`, `Despawning`.

- At most **one carrier** at a time.
- A pickup or handoff is requested by the client but granted by the **server** after validating availability, range, mission state and cooldown.
- Drop releases the package into the simulated world; recovery is possible.
- Carry movement should have **weight and character** but must remain playable under imperfect network conditions.
- No permanently lost packages: out-of-bounds or irrecoverable stuck states present an explicit **Recover Package** action, with a modest rating/time penalty.
- Teammates can assist through switch activation, package handoff, navigation and complementary tools.

### 4.3 Desired physics feel

**Controlled chaos** rather than ragdoll randomness:

- A predictable normal carry baseline.
- Readable collisions with clear audiovisual response.
- Intentional package-specific forces (e.g., inflation stages).
- Reliable grabs and state transfer before extra physics complexity.
- No injury/gore/realistic dangerous content.

### 4.4 Visibility and accessibility

Players should always know: **current package, destination, condition, timer, weather, tool charges, and next action**. Feedback must include visual indicators rather than color-only or audio-only cues. Keep default camera effects and flashing minimal; offer camera shake toggle if effects are introduced.

## 5. Package archetypes

| ID | Archetype | MVP | Behavior | Main counterplay | Risk |
|---|---|---|---|---|---|
| PKG-STD | Standard | YES | Predictable basic carrying | Route planning | None beyond route |
| PKG-FRG | Fragile | YES | Loses integrity from impactful drops/collisions | Gentle carry, packing foam, safer path | Frustration if physics damage is noisy |
| PKG-INF | Inflatable | YES* | Grows through defined stages; may block tight passages | Compress briefly, change route, coordinate | Collision/replication complexity |
| PKG-MAG | Magnetic | NO | Attracted to compatible tagged surfaces | Separate/redirect | Requires extra interaction tech |
| PKG-SHP | Shape-shifting | NO | Alternates between authored package dimensions | Timing / alternate path | Risky physics state changes |

`*` Inflatable is an MVP **stretch feature**. If physics testing fails, release the first external playtest with Standard + Fragile and keep Inflatable behind a feature flag until reliable.

### 5.1 Fragile package rules (PROPOSED)

- Integrity displayed as `0–100`, initially 100.
- Damage caused by server-evaluated meaningful impact thresholds; low-speed placement does not damage.
- Padded handling decreases impact damage while equipped.
- At zero integrity, parcel is **severely damaged**, but can still be delivered for a low rating; this avoids erasing several minutes of progress due to one collision.
- Water sensitivity is an *explicit property* of some contracts, not automatically true for every Fragile package.

### 5.2 Inflatable package rules (PROPOSED)

- Package has clearly shown inflation **Small -> Medium -> Large** stages, not arbitrary scaling every frame.
- Stage progresses at telegraphed intervals while a contract is active.
- An interaction or equipped tool allows brief compression, with cooldown.
- Intended play: choose between a longer, wider route and timing a narrow shortcut.
- Any scaling must not wedge players, crash the physics assembly, or create impossible pathways.

## 6. Environment and world layout

### 6.1 MVP environment

One colorful, readable neighborhood with:

- **Central Depot:** contract desk, weather forecast, shop, loadout, result board, exit.
- **Five destinations:** e.g., Corner House, Mini Mart, Community Hall, Apartment Lobby, Garden Workshop. Names are working placeholders.
- **A few authored route hazards:** a slippery ramp, narrow gate, alternate steps/path, timed gate, shallow puddle zone.
- **Walkable connected paths** with visual route markers and solo-accessible alternates.

The neighborhood remains physically consistent during the run; increasing challenge comes mainly from contracts, package behaviors, limited route changes and periodic events. This substantially reduces content-production cost relative to generating a new level each round.

### 6.2 Route design rules

1. Each destination has at least one reliable solo-safe path.
2. Shortcuts create **optional risk/reward**, never mandatory frustration.
3. All required buttons/switches are reachable by a lone player while maintaining package recoverability.
4. Hazards clearly communicate their effect in advance.
5. Spawn/respawn and package recovery points cannot soft-lock the run.
6. Mobile touch controls must work with every mandatory interaction.

## 7. Endless difficulty director

### 7.1 Goals

Produce a run that feels harder over time while preserving (1) readable causes, (2) multiple possible solutions, (3) solo completable routes, (4) modest content requirements, and (5) stable network/physics performance.

### 7.2 Difficulty stages (PROPOSED)

| Depth / next delivery | Tier | Variety budget (illustrative) | Design rule |
|---|---:|---|---|
| 1–4 | 1 | One introductory catch | Avoid overload during onboarding |
| 5–9 | 2 | One or two **compatible** catches | First crisis at 5 |
| 10–14 | 3 | Two familiar mechanics | Crisis at 10 |
| 15–19 | 4 | Two to three validated interactions | Crisis at 15 |
| 20+ | 4 **capped** | Rotate authored high-tier challenges | Keep it hard, not impossible |

**Important:** A difficulty tier caps the *severity* of raw speed reductions, deadline pressure, physics forces and obstacle complexity. Beyond tier 4, variation comes primarily from mission order, route selection, player choices, and periodically refreshed content. It does **not** scale damage, traction loss or time limits exponentially forever. High-tier difficulty and cap values are design proposals.

### 7.3 Fifth-delivery crisis policy (CONFIRMED cadence)

A crisis occurs when `nextDeliveryNumber % 5 == 0`. A crisis is an authored mission tagged `MajorEvent`. For MVP, its core environment modifier is rain; later update candidates include wind and fog. Crisis loadouts must be *forecasted before purchasing gear* and must remain finishable without purchased gear. A failed crisis stays at that delivery number for the next attempt.

### 7.4 Contract director and anti-repetition

- MVP target: **8–12 authored contract templates**, reused only with tested route/package combinations and scaled expectations. For long-run replayability, we may need more variants after evaluating tester boredom.
- Track `recentTemplateIds` for at least the last 3 completed contracts (PROPOSED); avoid back-to-back repeats when alternatives exist.
- Use a server-generated run seed and a deterministic, data-driven selection strategy for reproducible QA. Seed alone is not a security boundary.
- Validate package compatibility, route accessibility, current event tag, minimum unlocks and player count before selecting a contract.
- If the high-tier pool cannot provide a novel challenge, choose a known valid template; **never generate an untested impossible combination**.
- Keep upcoming exact route partly unknown for variety, but *forecast the category of hazard* and give equipment information before the next mission.

### 7.5 Party-size rules

Difficulty can adjust **optional scoring, route choices or preparation requirements** based on active team count; it cannot add hard dependencies on a second player. When someone disconnects, finish the current contract with recovery safeguards and recalculate at the next depot phase. Recheck route validity when team size changes.

### 7.6 High-run score integrity

Run depth advances only through server-validated successful delivery, not elapsed time or client action claims. Persist personal bests and milestone awards idempotently. Public global high-score boards remain DEFERRED until exploit validation and production telemetry justify them.

## 8. Weather and major events

### 8.1 What qualifies as an event

A **major event** introduces a gameplay-relevant change to route and/or package interactions, distinct from decorative weather. **Every 5th successful delivery milestone requires a major event**, but not necessarily an entirely unique weather effect. Event conditions last for that one contract (PROPOSED) and reset at the depot afterward.

### 8.2 MVP: Heavy Rain

- **Forecast:** warning visible after completing contract 3, clearly confirmed before purchasing for contract 5. Subsequent crises are always forecast in the immediately preceding depot phase at minimum. Notifications are not required to interrupt ongoing missions.
- **Route effect:** clearly marked wet patches/slippery pavement alter perceived traction; dry alternate path is slower but safely navigable.
- **Package effect (optional stretch):** explicitly water-sensitive cargo accumulates exposure without a cover. Do not make all Fragile packages automatically water-sensitive.
- **Counterplay:** Grip Boots mitigate traction difficulty; Rain Cover helps water-sensitive cargo; optional Packing Foam helps Fragile impact protection. All effects have measurable, understandable limits.
- **Failure prevention:** no sudden weather start midway through an otherwise normal contract, no invisible loss of traction, and no insta-fail water exposure. No mandatory special equipment.

### 8.3 Crisis evolution using only rain (MVP proposal)

| Crisis | Type | Distinguishing catch |
|---|---|---|
| #5 | Rain I | Tutorial-level slippery crossing; long dry alternate route |
| #10 | Rain II | Slick surface plus package condition constraint |
| #15 | Rain III | Slick surface with a gate or route detour, telegraphed |
| #20+ | Rain Mastery pool | Rotate approved high-tier combinations; no exponential hazard growth |

If the MVP lacks enough tested templates for genuine deep-run variety, honest repetition is preferable to untested randomized hazards. Expand content based on playtest feedback.

### 8.4 Future events (DEFERRED)

Wind that pushes light/Inflatable parcels; fog that reduces long-range clarity while preserving objective cues; temporary roadwork/obstruction without new weather physics. Each must have distinct counterplay and route validity tests. Do not ship multiple weather systems at the cost of stability.

## 9. Economy, equipment and progression

### 9.1 Separate temporary equipment economy from permanent progression

**Run Coins — session-only, spendable:** Awarded after every successful delivery to each eligible participant. Used between contracts for gear and consumables. Current wallet, current run gear and consumable charges are **not saved across completed runs** (PROPOSED). They reset on departure, team failure or run shutdown. Deep runs therefore always need new choices; run spending does not create permanent character superiority.

**Reputation — persistent, non-spendable XP:** Saved per player as contracts are completed. Unlocks cosmetic milestones, harder optional contract pools, equipment *availability* and package discovery. It does **not** bypass the normal difficulty curve or prevent new friends from partying together.

**Personal best depth — persistent record:** Highest successfully completed delivery in one run. Separate from lifetime completed deliveries and earned Reputation. Track a few crisis milestones for recognition; MVP may store `bestDepth` and `totalCompleted`, not an elaborate leaderboard.

### 9.2 When money and progress are earned

- Success grants all **eligible team participants** a baseline equal award. No winner-takes-all payout or bonus solely for being the player who hands over the parcel; strike pressure is shared, so rewards should reinforce cooperation.
- **PROPOSED playtest values:** First Standard contract awards 100 Run Coins. A success-streak bonus of +10% per consecutive success caps at +30%. Crises can add a bounded bonus. All numbers live in balancing configuration; no unchecked earnings escalation.
- **On legitimate failure (CONFIRMED strike effect):** Exactly one shared strike is consumed; the failed attempt grants **zero new success coins or Reputation**, does not increase run depth, and resets the successful-delivery streak (streak policy PROPOSED). Already earned personal progress and coins from previous successes are not confiscated.
- **On technical recovery (PROPOSED):** No strike, no reward, no progression; restore the same contract to a valid state or safely return to preparation. Refund spent **attempt-specific** equipment charges when cancellation was caused by a confirmed server fault, where feasible.
- **On individual exit (PROPOSED):** No strike or penalty to teammates. The exiting player retains earned permanent Reputation and records; unspent Run Coins and temporary gear expire for that departing player. An active incomplete contract never pays out for that player.
- Success awards, Reputation, personal-best updates and milestone cosmetics must be idempotent. Server controls outcomes and can safely retry persistence without duplicating rewards.
- AFK reward eligibility needs a transparent and non-punitive policy. Supporting actions count; holding the parcel is not a prerequisite for getting paid.

### 9.3 Equipment: useful choices, not permanent dominance

**Recommended model:** Individual wallets; at most **two equipped tools**; buy/replenish at the depot; no trading and no shared team bank at MVP. Equipment is temporary, with a visible charge count or contract-limited duration so endless runs continue requiring adaptation. Whether passive items use one slot or a separate passive slot remains OPEN until UI testing—default to a simple shared two-slot rule.

| ID | Tool | Effect | Proposed limit | Example price (tunable) |
|---|---|---|---|---:|
| EQ-GRIP | Grip Boots | Improves movement control on wet marked terrain | 5 started contract attempts with boots equipped; no arbitrary mid-attempt expiration | 180 Run Coins |
| EQ-COVER | Rain Cover | Slows water exposure for explicit sensitive cargo | One crisis contract / one charge | 90 Run Coins |
| EQ-FOAM | Packing Foam | Reduces meaningful Fragile impact damage | One contract / one charge | 100 Run Coins |

**Pricing objective:** A team completing contracts 1–4 can meaningfully prepare for rain. A player with no coins or no gear always retains at least one solo-safe route. No tool provides complete immunity to weather; no upgrade must make standard carrying boring. Gear durations, prices and effects are PROPOSED. A *legitimately failed* attempt may consume equipment that was actually used; a technical rollback should not punish players for server faults. No coin purchases can restore shared strikes in the planned MVP (PROPOSED).

### 9.4 Permanent unlocks and friends

- **Early mastery:** Learn Standard and Fragile handling; earn a uniform/title and access to clearly explained tools.
- **Intermediate mastery:** Unlock optional advanced contract choices and the Inflatable package as soon as technically stable.
- **Late mastery:** Earn cosmetic certifications and challenge badges for crisis #10, #15, #20, etc.
- When party members have different Reputation levels, use a **shared accessible contract pool** and fixed basic unlocks; experienced players do not force new players into inaccessible mandatory content. Full tier-selection policy is OPEN for later.
- Do not unlock basic *survival necessity* behind dozens of runs. The MVP base tool trio is available early or after a brief introduction.

### 9.5 Run-economy inflation safeguards

In an endless run, coin balances can accumulate. Prevent gear decisions becoming meaningless by using consumable charges, bounded reward scaling and finite slots, not punitive surprise taxes or exponentially inflating prices. Show prices and forecasts up front. Measure unspent coins at depth 5/10/20 and adjust economy only from playtest results.

## 10. Multiplayer, parties and cooperation

### 10.1 Party types

- **Solo:** start with one participant; every required contract is solo-accessible.
- **Friends party:** invite players and ready up in public lobby; use a private team run.
- **Public team fill:** eventual streamlined queue for other players who want teammates. A small same-lobby matching implementation may be the first production step; cross-lobby matchmaking is DEFERRED until necessary.
- **Party size 1–4** is PROPOSED for MVP, based on readability, networking and development workload.

### 10.2 What teammates can do

- Hand off a parcel through an atomic, server-approved ownership transition.
- Hold a gate/trigger, scout the route, recover a dropped package, choose compatible tools, assist without hijacking carrying.
- Receive individual progress rewards regardless of which player physically places the parcel (subject to fair participation rules).
- Help new players without mandatory voice chat, purchase requirements or private social relationships.

### 10.3 Exit, absence and grief policy

- **Shared strikes (CONFIRMED):** Every team starts with 3. Each legitimate contract failure deducts exactly one strike regardless of which player was carrying. The third ends the entire team run and opens Run Summary. Players see the remaining count and the specific reason for any deduction.
- **Safe individual exit (PROPOSED):** Anyone can exit from the depot. To respect real-world interruptions, an individual may also leave a running session from the Roblox menu or an explicit confirmed Exit action; leaving alone does **not** consume a team strike. Any held parcel is released/recovered for those who remain.
- **Team abandon/retry (PROPOSED):** A voluntary early *contract failure* is a distinct action from an individual exit, and must be approved by every currently active teammate. With fewer than unanimous approvals, the active contract continues. AFK/nonresponsive-player handling must not permit one player to force a strike; implement a fair timeout or safe recovery in TDS.
- **Mid-contract disconnect (PROPOSED):** Disconnect does not deduct a strike. Server releases/repositions the carrier's parcel, and remaining team members can finish the route. Team-size-aware selection adjusts at next depot phase.
- **Technical failure (PROPOSED):** Lost/unrecoverable package due to simulation bug, server desync, reserved-server failure, or teleport shutdown cannot deduct a strike. Recover parcel/contract or cancel it neutrally without reward. A departing teammate must not trigger a shared wipe.
- **Party empty:** If everybody leaves, close/clean up the session without deducting strikes. Completed persistent earnings remain saved as reliably as the platform permits; incomplete contracts pay no completion rewards.
- **Anti-grief:** No package theft from a current carrier, push attacks, friendly player damage, forced teleports, vote-kicks, or teammate wallet theft in MVP. Do not publish a blame leaderboard; show the failure cause, not an accusation about a particular player.
- Clamp/rate-limit pickup, handoff, purchase, recovery and abandon-vote requests; server checks actual session membership and action eligibility.

### 10.4 Rejoining and partial sessions

- An in-run rejoin after network disconnect is a desirable quality-of-life feature but **DEFERRED** until reserved-server identity, persistence and security are robust. Do not promise automatic rejoin at MVP launch.
- MVP should at least explain disconnections, preserve completed persistent rewards and avoid deadlocking surviving members.
- New players do not join active mid-run missions in MVP; any later join-at-depot system must balance player readiness and matchmaking fairness.

## 11. Contract resolution, failure, and ending an endless run

### 11.1 Confirmed strike contract — what Codex must preserve

**SR-001 (CONFIRMED):** A new run initializes `strikesRemaining = 3` once, on the server. These strikes belong to the **run/team**, not individual users.

**SR-002 (CONFIRMED):** Each legitimate failed contract attempt decrements `strikesRemaining` **by exactly 1**. A single attempt must never deduct multiple strikes due to repeated client events, physics signals, timer callbacks or retry processing.

**SR-003 (CONFIRMED):** When the decrement takes strikes to 0, stop accepting new interactions for that run, issue a **Run Summary**, and end the entire team's run. Do not schedule the next delivery.

**SR-004 (CONFIRMED):** A success is not a failure and never consumes a strike; the server must select **exactly one terminal outcome** per attempt (`Success`, `LegitimateFailure`, or `TechnicalCancellation`).

**SR-005 (PROPOSED retry detail compatible with confirmed endless progression):** Failed attempts do not advance `completedContracts` or bypass a scheduled fifth-delivery crisis. A new attempt ID is used for each retry.

### 11.2 Successful contract resolution

1. Package reaches the correct destination during an active, authorized contract.
2. Server validates package identity, objective state and credible geometry/proximity. Client events are requests, never proof of completion.
3. Server atomically resolves this *attempt* to `Success` once.
4. `completedContracts += 1` exactly once; server grants eligible player rewards and persistent progress idempotently.
5. Strikes remain unchanged. Team returns to depot and is offered `nextDeliveryNumber = completedContracts + 1`.

**Rating (PROPOSED):** Completion time, package condition and optional handling goals can affect a bounded reward bonus. Light damage and missing optional goals reduce quality, not automatically cause a strike. A rating-only soft timer does not cause contract failure.

### 11.3 Legitimate strike triggers (PROPOSED; owner approval/playtesting required)

A strike should follow **an explicit, fair, player-influenced failure condition that was disclosed before the contract**. Recommended allowed causes:

| Outcome code (design name) | When it applies | MVP policy |
|---|---|---|
| `PACKAGE_DESTROYED` | A package with a disclosed integrity meter reaches zero from server-validated gameplay impacts | Test after Fragile damage has reliable thresholds and recovery safeguards |
| `DEADLINE_EXPIRED` | A contract **explicitly labeled Hard Deadline** reaches a generous, authoritative deadline | Include only in verified challenge templates; early introductory deliveries use soft scoring timers instead |
| `TEAM_ABANDONED` | **Every currently active player** confirms team retry/abandon during a contract | PROPOSED quality-of-life action; creates a real failure, distinct from leaving individually |
| `SPECIAL_CONDITION_FAILED` | An expressly explained later condition (e.g. water-sensitive cargo's exposure meter) reaches its documented failure threshold | DEFERRED until that package/hazard is validated; never silently enable |

A generic Standard package need not be destructible. An ordinary contract with no hard deadline may be repeatable until it succeeds or the team explicitly abandons; that is acceptable in early onboarding, but later **strike-worthy contracts must actually have meaningful, tested loss conditions** for the risk system to matter.

**No surprise failure rule:** Before starting, the briefing shows any hard deadline, integrity/exposure limit and relevant event. The HUD surfaces the live meter/countdown, and gear is not required for a viable route. Never generate a contract with an impossible target for solo/mobile players.

### 11.4 Events that NEVER cost a strike (PROPOSED protective rules)

| Cause | Correct resolution |
|---|---|
| Individual exits the run, including quitting mid-contract | Remove that player; server safely releases/repositions carried parcel; remaining team continues |
| Player disconnects, lags, or loses network ownership | Recover/reassign package or neutrally cancel an unfinishable attempt |
| Package becomes stuck, falls outside valid bounds, or clips through terrain | Unstuck to a safe checkpoint with feedback; do not treat a physics bug as package destruction |
| Server or data service fault, teleport interruption, server shutdown | Neutral cancellation or shutdown; try to save already earned progress; no punitive team failure |
| Soft timer expires or optional objective isn't met | Lower rating/bonus, not a strike |
| An unauthorized client submits a fake success/failure, stale timer fires, or duplicate remote event arrives | Reject or ignore; do not mutate shared strikes |

Players should not be able to exploit an unstuck/reset button to gain a free shortcut: recovery returns the parcel to a designated safe prior position with a small usage cooldown (PROPOSED), not directly to the destination. When the server cannot confidently determine whether an incident was player-caused, **prefer safe recovery over deducting a shared strike**.

### 11.5 Failure, retry, and crisis invariants

**On a legitimate failure with strikes remaining:**

1. Resolve the current attempt once and record a server-side failure reason.
2. Subtract **one** shared Company Strike.
3. Award no success coins or Reputation for that attempt. Existing Run Coin balances and permanent progress remain; the success streak resets (PROPOSED).
4. Despawn/clean up the failed attempt. Reopen depot preparation and allow remaining players to re-equip from their own wallets.
5. Retry the **same numbered delivery** with a **new attempt ID**. Preserve `isCrisis = (deliveryNumber % 5 == 0)`; a failed #5 or #10 must still be a crisis when retried. Keeping the exact package + hazard combination fixed on retry is the **PROPOSED default** to prevent easier reroll farming; allow a route change only when necessary to repair an invalid template.

**On the third legitimate failure:** Perform steps 1–3, then resolve the run to `FailedOut`, show Run Summary, and return players to the public lobby. No fourth attempt or paid continuation. No lost earned Reputation, cosmetic unlocks, prior successful deliveries or personal records.

**If an attempt is cancelled for technical reasons:** Do not decrement strikes or advance depth. Recover in place or return to preparation with the same delivery number and no failure payout; no repeatable rewards. Attempt-specific charges consumed solely because of a verified server bug should be restored when feasible (PROPOSED).

**Edge cases:** A completed #9 means next is crisis #10. Failing it at 3 → 2 strikes still leaves `completedContracts = 9` and the next attempt remains #10; if it fails again 2 → 1; third failure 1 → 0 ends the run at depth 9. Successful retry moves depth to 10 with the remaining strikes unchanged. Success/failure occurring in the same frame must resolve under a single server-side state guard; the first valid authoritative resolution wins and later callbacks are ignored.

### 11.6 Strikes and equipment (PROPOSED)

- Initial strikes are exactly 3. For MVP **do not sell, refill, trade, revive or award extra strikes**, including with Robux, Run Coins or reputation. Later experimentation can be discussed but must not be silently implemented.
- Gear affects the *chance of successful handling*, not strike totals directly. For example Grip Boots lower slip risk and Packing Foam buffers declared impact damage.
- Individual wallets are preferred over a shared team bank, because a shared loss should not enable a teammate to seize everyone's funds.
- Run gear is temporary. Consumable charges spent on a valid failed attempt stay spent; unused purchases remain available for retries under their normal limits. Refunds apply to server-fault cancellations, not legitimate failures.
- Pricing and free routes must be tuned so a player can attempt a crisis with zero remaining coins or equipment. Do not create a compulsory-pay trap after failure.

### 11.7 Individual departure, disconnects, and end-of-run results (PROPOSED details)

- Players may leave voluntarily from the depot. An optional mid-contract **Exit Run** action should likewise be an individual departure, not a team-abandon command, and must never deduct a team strike.
- Other players retain the shared current strike count; one player leaving doesn't reset or increase strikes. Any carried parcel is released safely. If only one player remains, mandatory future routes must remain solo-valid.
- Players joining mid-run are DEFERRED; party/roster changes at the depot do not regenerate spent strikes.
- If all players exit, end as `TeamEmpty` rather than `FailedOut`; no strike deduction is necessary.
- Final Run Summary identifies `reason = StrikesExhausted | VoluntaryExit | TeamEmpty | ServerInterruption`, current depth, crisis milestones, earned persistent rewards and each player's best depth. Present the shared strike count without a blame label.
- Completed progress should be buffered and persisted as successful contracts finish; end-of-run saving is a safety fallback, not the only save opportunity. Do not promise lossless persistence during outages: use retries, idempotency and graceful feedback.

### 11.8 Minimal server-authoritative resolution sketch (for the TDS)

This is behavioral pseudocode, **not** a complete Luau implementation:

```text
run.strikesRemaining = 3      // once at run creation
run.completedContracts = 0

startAttempt():
    number = run.completedContracts + 1
    isCrisis = (number % 5 == 0)
    create new attemptId and mark attempt Active

resolveAttempt(result, cause, attemptId):
    verify run Active, attemptId current, attempt Active, server validity
    atomically mark the attempt Resolved; ignore any repeat resolution
    if result == Success:
        run.completedContracts += 1
        grant success rewards once to eligible players
        return to DepotPreparation
    else if result == LegitimateFailure:
        run.strikesRemaining -= 1                 // exactly once, team-wide
        if run.strikesRemaining == 0:
            end run with reason StrikesExhausted
        else:
            return to DepotPreparation            // retry number unchanged
    else if result == TechnicalCancellation:
        recover or return to DepotPreparation      // no strike, no rewards
```

**State invariants:** `0 <= strikesRemaining <= 3` and never increases in MVP; `completedContracts` changes only on success; only one active attempt per run; no client-supplied result or arbitrary cause code directly decides a strike; terminal runs reject further actions. The TDS must specify synchronization and safe persistence around these transitions.

## 12. UI, accessibility and onboarding

### 12.1 Required views

| Surface | Required information |
|---|---|
| Lobby | Solo, team formation, ready states, play instructions |
| Depot | **Completed deliveries / next delivery**, forecast, package catch, remaining shared Company Strikes (always visible), Run Coins, gear shop, active slots, Leave Run |
| In-world | Delivery destination, parcel carrier, condition, event effects, remaining strikes, disclosed hard timer (if any), tool charges |
| Contract result | Success/failure, time/condition, success reward or exact failure reason, strikes remaining, current depth, next depot action |
| Run Summary | Successful-delivery depth, personal best, crisis milestones, earned progress, strikes lost, exact run-ending reason, return to lobby |

**Clarity rule:** Delivery 10 must never display **Final Delivery** or a campaign-completion screen. Label #5, #10, etc. as **Crisis Milestones**, and #11 as **Next Delivery**.

### 12.2 One-minute tutorial goal

First-time onboarding teaches pickup, carry, drop, recover and deliver on a safe Standard package. The first shop interaction introduces coins and slots; the first rain warning explains why forecasting matters. Teach the normal loop before event complexity. Short contextual prompts are preferable to an unskippable lecture.

### 12.3 Accessibility and platform coverage

Every mandatory interaction must work on desktop and mobile. HUD must not rely on color alone to convey condition/strikes. Touch buttons must stay comfortably separated from camera inputs. Events use visually legible terrain and audible cues (not sound-only communication). Minimize mandatory shaking and flashing and add toggles if these effects become prominent.

## 13. Visual/audio direction

- Stylized low-poly, colorful, friendly suburban workplace-comedy aesthetic.
- Oversized and visually readable packages; distinctive silhouettes and status indicators by archetype.
- Exaggerated but *legible* package movement; avoid excessive chaos on low-end devices.
- Recognizable rain forecast signs, wet pavement cues, route markers and depot signage.
- Sound emphasizes pickup weight, bounce/impact, inflation, successful delivery and approaching weather.
- Avoid visual clutter, extreme bloom or mandatory camera shake.

Art direction remains PROPOSED until greybox playtests show map readability and required assets are estimated.

## 14. MVP and scope boundaries

### 14.1 Vertical slice (Codex Milestone 1)

- Single greyboxed depot, one destination, one alternative route.
- One Standard parcel; add Fragile only after pickup/drop/recovery and server authorization work reliably.
- One short contract loop: brief -> pick up -> carry -> drop/recover -> deliver -> result -> depot.
- Basic one- and two-player Studio tests, including a valid handoff and disconnect behavior.
- No production teleports, persistent saves, weather, cash shop, monetization or advanced generation.

**Exit gate:** A new tester can complete the action loop, can recover a stuck package, and has fun doing it at least a few times. If not, iterate on handling before making an economy.

### 14.2 Endless-system prototype (Codex Milestone 2)

- Run state holds completed delivery count and advances without a fixed cap.
- One director that selects valid authored templates at each level.
- Test `nextDeliveryNumber % 5 == 0` for crisis behavior using placeholder warning labels, not necessarily rain art.
- Add **confirmed three shared Company Strikes** and simulate legitimate failures; prove three distinct failed attempts deduct exactly 3 strikes and the third ends the run. Keep specific triggers behind playtest/config flags until approved.
- Add **Leave Run** at the depot and a summary with depth; no persistence yet.

**Exit gate:** Automated/state tests support completing contract #11, #21, failed #5 retry, terminal failure at 0 strikes, one failure event with duplicate callbacks counting once, solo continuation after a teammate leaves and explicit voluntary exit without broken transitions.

### 14.3 MVP release candidate

- Public lobby, solo and party launch, private 1–4-player run instances; limited public fill if sufficiently stable.
- One compact neighborhood, central depot and approximately five destinations.
- Standard + Fragile packages. Inflatable only if physics performance and gameplay quality justify it.
- Roughly 8–12 curated templates with meaningful combination variants; enough to test delivery #20+.
- **Endless** deliveries with recurring event every fifth success, **three shared strikes**, server-validated legitimate failure, no-strike technical recovery, capped difficulty tiers and retry rules.
- Heavy Rain event, wet terrain counterplay, clear warnings. Additional package wetness optional stretch.
- Run Coins, shop, three equipment choices, short gear durations/charges and two slots (PROPOSED parameters); no strike refills in the recommended MVP model.
- Persistent Reputation and personal-best depth, per-contract grant safeguards, disconnect-safe completed progress.
- Desktop and mobile UI; recoverable packages; sufficient instrumentation and honest run summaries.

### 14.4 Deferred / post-MVP

- More weather types, Magnetic and Shape-shifting parcels, complex Inflatable behavior (if unstable), vehicles, procedural city generation, global leaderboards, real-time run resumption, sophisticated cross-lobby matchmaking, team banking/trading, paid gameplay boosts, extensive cosmetics, large-scale live events.

### 14.5 Explicit quality-first scope rule

When a feature threatens reliability, reduce **content quantity** before removing the core identity of endless escalation. If the rain simulation is unstable, use a simpler traction/route modifier. If an advanced package makes multiplayer unreliable, ship Standard + Fragile. Do **not** silently switch back to fixed-ten deliveries to meet a deadline.

## 15. Technical handoff guidance for Codex (not a full TDS)

**Do not implement the entire GDD as a single request.** Use the TDS and roadmap to control build order.

### 15.1 Architecture boundaries

1. **Authoritative server state:** `RunState`, `completedContracts`, `strikesRemaining`, active attempt ID and resolution lock, package carrier, purchase approval, completion, rewards and persistent XP are server-authoritative.
2. **Client requests only:** UI asks to pick up, drop, hand off, use a tool or buy; server validates state, distance, rate limits, ownership and currency. Client physics cannot alone prove valid delivery.
3. **Config-driven generation:** place tiers, per-fifth major event, weather variants, package parameters, gear duration/cost and award formulas in centralized versioned configuration.
4. **Idempotency:** reward once per `runId + successfulAttemptId + userId`; repeated events cannot double-grant. Deduct a strike at most once per `runId + failedAttemptId`, and never when a newer attempt has started.
5. **Finite resources:** Long-running reserved servers must clean up packages, connections, timers, events and spawned effects on **every** contract transition. Bound event/physics object counts. No per-delivery connection accumulation.
6. **Safe depth counters:** Keep depth within a validated practical integer range and avoid unbounded string/UI growth. Engine uptime is not a promise of unlimited actual session time.
7. **Roblox topology:** Separate `LobbyPlace` and `RunPlace` if using reserved team sessions; test Studio gameplay first. Production teleports require a published experience and real clients.
8. **Modern teleport method:** Current official Roblox documentation uses `TeleportOptions.ReservedServerId` with a server-generated GUID for developer-reserved sessions; older access-code fields are deprecated. Verify the exact API again in the TDS before coding.
9. **Persistence:** DataStoreService for durable per-player Reputation/unlocks/bestDepth; temporary in-memory run state for Run Coins and mission state; MemoryStore only if needed for cross-server queues. Use appropriate DataStore request budgeting and failure recovery.
10. **Network physics:** Choose a responsive carry technique that is validated under latency and cannot be exploited for proximity/mission payouts; ownership is a security consideration rather than a proof of legitimacy.
11. **Modularity:** Clear separation among Party, Run, ContractDirector, Package, Interactions, Weather, Equipment, Economy, Persistence, UI and Analytics.
12. **Device and solo tests:** No required feature should depend on two-player controls or a keyboard.

### 15.2 Required companion TDS outputs

- Experience places and reserved-run topology; Rojo + Studio/MCP collaboration boundaries.
- Module ownership and Luau types/interfaces; contract configuration schema, package FSM and run FSM.
- RemoteEvent/RemoteFunction protocol, validation errors, client/server state snapshots and disconnect recovery.
- Persistent profile schema with `reputation`, `bestDepth`, `totalDeliveries`, cosmetics and migration version.
- Session/run schema for `runId`, `completedContracts`, `strikesRemaining`, `activeAttemptId`, `deliveryNumber`, `attemptResolution`, `recentTemplates`, `wallets`, gear charges and forecast.
- Exact delivery completion and award idempotency; difficulty-generation validation; five-contract crisis edge cases.
- QA tests: completion #4 → crisis #5; failed crisis #5 remains #5; three failed attempts end run; technical cancellation leaves 3 strikes; #10 → #11; #20 → #21; no duplicate awards or duplicate strike deduction; two clients grab same package; carrier disconnect; all exit; teleport failure; DataStore throttling; mobile.

### 15.3 Milestone discipline

Create an acceptance-testable implementation ticket for each vertical-slice feature, not one giant build prompt. Keep one config surface for changeable values. Set strike count to the confirmed value **3**; use feature flags for *unapproved failure triggers*, Inflatable and weather wetness until owner-approved. Every new package type or event must be validated solo and with multiple clients before entering the generation pool.

## 16. Product requirements and acceptance criteria

| ID | Requirement | Acceptance test | Status |
|---|---|---|---|
| GDD-001 | Team-only run | Solo/friend party opens run place containing no unrelated players | CONFIRMED |
| GDD-002 | Endless depth | Contract #11 and #21 can be offered and completed; no end at #10 | CONFIRMED |
| GDD-003 | Every-fifth crisis | Successful #4 prepares crisis #5; successful #9 prepares crisis #10 | CONFIRMED |
| GDD-004 | Failed-crisis fairness | Failing #5 doesn't increment depth or permit skipping the crisis; retry #5 | PROPOSED retry detail |
| GDD-005 | Package ownership | Only one server-authorized carrier exists per package | CONFIRMED architecture |
| GDD-006 | Handoff | Nearby valid request transfers carrier once; distant/invalid request denied | CONFIRMED architecture |
| GDD-007 | Unstuck recovery | A stuck parcel has a deterministic rescue path, not a soft lock or strike | PROPOSED |
| GDD-008 | Solo routes | All required mission templates completable with one player | CONFIRMED design intent |
| GDD-009 | Meaningful catch | Every template has a visible gameplay consequence beyond walking to a marker | CONFIRMED design intent |
| GDD-010 | Weather counterplay | Rain changes route/handling; equipment helps partially; free safe path exists | CONFIRMED concept, PROPOSED parameters |
| GDD-011 | Personal safe exit | An individual exits without ending others' run or consuming a strike | PROPOSED |
| GDD-012 | Initial strikes | New run gets exactly 3 shared strikes, not 3 per user | **CONFIRMED** |
| GDD-013 | Deduct exactly once | One legitimately failed attempt decrements 3→2 or 2→1 or 1→0 exactly once despite duplicate signals | **CONFIRMED** |
| GDD-014 | Terminal third failure | On 1→0, run becomes terminal, no new contract, team sees summary | **CONFIRMED** |
| GDD-015 | Retained historical progress | A failure cannot revert previously completed depth or already earned permanent rewards | CONFIRMED design direction |
| GDD-016 | Retry unchanged number | At completed depth 9, failure on #10 keeps next attempt #10 and crisis tag true | PROPOSED |
| GDD-017 | No strike for bug | Unstuck, disconnect, service fault and canceled attempt preserve strikes | PROPOSED fairness rule |
| GDD-018 | One result per attempt | Success/failure/technical cancellation compete under one guard; stale callbacks do nothing | CONFIRMED technical invariant |
| GDD-019 | Temporary wallet | Run Coins and run gear reset when user exits or run ends | PROPOSED |
| GDD-020 | Reputation persistence | Successful contract progress saved without requiring a run finale | PROPOSED |
| GDD-021 | Duplicate prevention | Retries/duplicate request never award progress twice | CONFIRMED security |
| GDD-022 | Team-size change | Departed carrier cannot strand package; solo-completable next mission | CONFIRMED design intent |
| GDD-023 | No endless penalty inflation | Beyond tier cap, raw difficulty parameters do not increase without bound | PROPOSED |
| GDD-024 | Mobile playable | Every mandatory action can be done on mobile | CONFIRMED platform intent |
| GDD-025 | Honest records | Best depth counts only successful deliveries and persists across sessions | PROPOSED |
| GDD-026 | Free core gameplay | No Robux needed for mandatory routes or weather counterplay | CONFIRMED design direction |
| GDD-027 | Session clean-up | No leftover contract connections/parts accumulate across 20+ deliveries | CONFIRMED quality target |
| GDD-028 | Cancellation security | Canceled/abandoned contract cannot grant successful completion | CONFIRMED security |
| GDD-029 | No paid strike refill | No purchase grants strikes or averts a terminal run loss | PROPOSED MVP fairness rule |

**Numbers beyond the confirmed three-strike budget are not final balances.** Exact causes, deadlines, prices, tool durations and anti-AFK thresholds require owner review or controlled playtesting.

## 17. Validation and instrumentation

### 17.1 Playtest ladder

1. **Carry feel:** Is Standard fun to move, place and hand off before weather or rewards?
2. **Fragile readability:** Can players predict the consequence of a collision?
3. **Weather preparation:** Can players say why boots, cover or foam were appropriate?
4. **Cooperation:** Do two players cooperate efficiently without grief or mandatory dual carrying?
5. **Fifth crisis:** Do players understand why #5, #10, #15 are special and plan accordingly?
6. **Endless longevity:** Are contracts #11–20 still interesting, or is it merely repetition?
7. **Safe exit:** Do players leave from depot feeling a run was worthwhile even without a campaign ending?
8. **Long-run stability:** Does server memory and performance remain stable past 20 and 50 simulated missions?

### 17.2 Telemetry candidates

Track tutorial completion, first-delivery completion, time per contract, depth-at-exit, depth-at-team-failure, time-to-first-crisis, crisis completion rate, equipment purchase rate, equipment usage, reward balances at 5/10/20, recovered parcels, invalid interactions, **legitimate strike reason codes**, technical cancellations, duplicate resolution attempts, attempted team-abandon votes, early exits, disconnects, average FPS and lag complaints, daily returning players and multiplayer replays. Distinguish **voluntary exit** from a **team failure** and **disconnect**.

### 17.3 Release gates

Do not add weather #2 before Rain is mechanically useful. Do not add advanced parcels before network-safe handling and mobile interaction work. Do not claim sustainable CCU projections based only on this design; first demonstrate fun and genuine repeat play. Set quantitative retention targets from actual small playtests, not guesses.

## 18. Monetization (not a prototype prerequisite)

Consider direct-purchase cosmetic uniforms, humorous badges, package appearances and delivery effects that do not obstruct visibility or create team confusion. Keep gameplay-affecting advantages earnable through play and avoid cash-grab pressure to continue a run. Monetization systems require platform-policy and age-eligibility review before release. No paid random-reward systems in planned MVP.

## 19. Risks and mitigation

| Risk | Why it matters | Mitigation |
|---|---|---|
| Core carrying is awkward | Endless content can't fix unfun movement | Prototype pickup/handling before progression |
| Deep runs feel repetitive | Same neighborhood and few templates can fatigue players | Curated catch combinations, short sessions, expand only from playtest needs |
| Infinite stat inflation | Events eventually become impossible | Hard difficulty/force/deadline caps; scale combinations and patterns instead |
| Long session failure loses reward | Players resent time investment | Save earned Reputation/bestDepth during run; strikes only end current run |
| A strike is caused by a bug | Unfair team wipe | Server-controlled recoveries; distinguish valid failure reason from technical cancellation before a strike |
| Player leaves and team is stuck | Cooperative session breaks | Atomic carrier release; solo path; scaling at next contract |
| Players farm easy contracts or spoof depth | Reputation/records become meaningless | Server-generated state, no advancement without valid completion, idempotent awards |
| Economy becomes trivial at depth 20 | No reason to prepare | Finite equipment charges, limited slots, bounded payouts |
| Weather feels cosmetic or overpowered | Weak central identity | Visible traction consequence, partial counterplay, safer route |
| Team queue is empty at launch | Solo player gets stranded | Always allow solo; staged lobby-specific matching |
| Server session resources leak | Very long runs degrade performance | Lifetime cleanup, bounded templates/objects, simulated 50-delivery soak test |
| Teleport / DataStore service issues | Lost group or progress | Graceful fallback, buffered persistence, user-facing explanation |
| Scope grows beyond solo dev | Shipping stalls | One package + one route vertical slice; one weather in MVP |

## 20. Remaining decisions for owner review

**LOCKED (owner-confirmed in v0.3):** Three shared strikes per run. A legitimate failed contract deducts one team strike; the third failure ends the run. Endless contracts and fifth-delivery crises remain confirmed. The entries below are **recommended design defaults**, not yet owner-approved production rules.

| ID | Design question | Recommended v0.3 default | Why / consequence |
|---|---|---|---|
| OPEN-001 | Can players regain strikes? | **No** refill, purchase or revive for MVP | Simple stakes; avoids gear/Robux making failure meaningless |
| OPEN-002 | Does failing crisis #5 skip to #6? | **No; replay #5** | Prevents deliberate skipping; depth means actual success |
| OPEN-003 | What legitimately causes a strike? | Disclosed and validated package destruction, generous labeled hard deadline, or unanimous team abandon | Predictability is necessary for cooperative fairness |
| OPEN-004 | Should an ordinary contract have a hard timer? | No for tutorial; only explicitly marked challenge contracts after testing | Avoid false failures from latency/controls |
| OPEN-005 | Can a player leave at any time? | Yes, individual voluntary exit without strike; most naturally from depot | Preserves agency and avoids hostage situations |
| OPEN-006 | Can one teammate force a paid failure/retry? | No; unanimous active-team approval for abandon | Avoids griefing with shared strikes |
| OPEN-007 | Do Run Coins/gear persist? | No; persistent Reputation and best depth do | Run-based economy with meaningful starting conditions |
| OPEN-008 | Wallet model? | Individual Run Coin wallets and equal eligible rewards | Prevents ownership arguments and fund theft |
| OPEN-009 | Gear duration and capacity? | Two equipped slots; consumables and finite-contract durations | Meaningful repeated preparation |
| OPEN-010 | Must every crisis use different weather? | No; rain plus approved route/package combinations | Keeps scope achievable |
| OPEN-011 | Team population for MVP? | Solo through four players; all routes solo-completable | Better launch resilience, smaller tech workload |
| OPEN-012 | Public teammate finder? | Simple same-lobby fill after prototypes, full cross-server queue later | Staged networking complexity |
| OPEN-013 | Does failure erase already earned Reputation? | No; lose run opportunity and success streak only | Respect long sessions |
| OPEN-014 | Difficulty grow infinitely in raw penalties? | No; cap severity and rotate tested hard combinations | Prevent mathematical impossibility |
| OPEN-015 | Inflatable in MVP? | Only after Standard and Fragile are stable | Networking/physics risk |
| OPEN-016 | Mid-run rejoin? | Defer; save completed progress, support surviving teammates | Robust recovery is nontrivial |
| OPEN-017 | Reward eligibility? | Present and reasonably participating, including support roles | Prevents AFK farming without carrier bias |

**Suggested next approval batch:** (a) no strike refills, (b) three specifically disclosed legitimate failure causes, (c) neutral exit/disconnect rule, and (d) same-number retries. These decisions determine the TDS RunState and ContractResolution interfaces. Exact prices and modifier percentages can stay playtest-tunable.

## 21. Codex-facing implementation brief

### 21.1 Non-negotiable scope message to Codex

> Build **Package Problems** as a team-instanced **endless** run. Never end automatically at delivery #10. Track completed deliveries on the server; `nextDelivery = completed + 1`. Trigger a major-event contract at every fifth successful delivery. A failed fifth-delivery attempt must not skip the event. Initialize **3 shared Company Strikes** on each run; each legitimate failed attempt deducts 1 exactly once; the third ends the entire run and presents a summary. Technical recovery or player exit must not count as legitimate failure. Implement only the explicitly assigned milestone; do not build a full multiplayer lobby, shop, rain effect, persistence and procedural generation all at once. Make proposed parameters configurable and record assumptions.

### 21.2 First task to assign

> Create a Roblox Studio-testable greybox prototype: one parcel, one depot, one destination, pickup/carry/drop/recover, server-validated delivery, result UI, and solo + two-client handoff tests. The gameplay loop must restart for another delivery without accumulating objects or event connections. No teleports, monetization, weather, progression or production matchmaking yet.

### 21.3 Subsequent technical design and roadmap

1. `Package_Problems_TDS_v0.1.md`: Run FSM, ContractDirector, authored template schema, server/client validation, profile + session data, teleport strategy, robust package mechanics, teardown and tests.
2. `Package_Problems_Roadmap_v0.1.md`: Vertical slice -> Endless director -> first crisis -> equipment economy -> per-contract persistence -> lobby instances -> social matching/mobile polish -> release validation.
3. `Package_Problems_Codex_Guardrails.md`: Active milestone, acceptance tests, design statuses, config-only values, no scope creep, no hidden gameplay policy changes.

**Definition of done for endless-run logic:** Complete at least 21 simulated contracts; detect crises at 5/10/15/20; verify #10 and #20 do not end run on success; simulate 3 separate legitimate failed attempts and termination at zero; handle failed crisis without skipping it; ensure duplicate failure events do not double-deduct strikes; ensure neutral technical cancellations cost zero; preserve previously earned rewards when a player exits; prove no duplicate awards or resource leaks across repeated transitions.

## 22. Official Roblox documentation (checked 2026-10-30)

- Teleport to private/reserved servers: https://create.roblox.com/docs/projects/teleport-private-servers
- Teleport between places: https://create.roblox.com/docs/projects/teleport
- Network ownership and movement security: https://create.roblox.com/docs/scripting/security/network-ownership
- Network ownership and physics: https://create.roblox.com/docs/physics/network-ownership
- Data stores and persistent data: https://create.roblox.com/docs/cloud-services/data-stores
- Data store best practices: https://create.roblox.com/docs/cloud-services/data-stores/best-practices
- Memory store vs data stores: https://create.roblox.com/docs/cloud-services/data-stores-vs-memory-stores

---

**End of GDD v0.3 — Endless Runs + Three Shared Company Strikes.** Supersedes v0.2. Only explicitly CONFIRMED items are locked; PROPOSED defaults and numeric examples require owner review or empirical validation before production lock.

