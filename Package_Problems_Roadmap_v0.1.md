# Package Problems — Milestone Roadmap v0.1

**Date:** 2026-10-30  
**Design baseline:** [GDD v0.4](Package_Problems_GDD_v0.4_Development_Refinement.md)  
**Team:** One developer + Codex  
**Workflow:** Milestones with short development iterations and a small task board  
**Revision:** Milestones reconciled on 2026-10-30 with cooperative handling and interconnected-world decisions; stable IDs and filename retained.

**Current status (2026-10-31):** M1 is Verify: relay extension implemented with automated solo/multiplayer and client latency evidence. Human/touch/edge-case acceptance and final checkpoint verification remain open; see [relay evidence](state/m1/RelayEvidence.md). M2–M7 remain Not started; M8 Future. No new gate is closed.

## 1. How to use this roadmap

A **milestone** delivers a playable capability and ends with an evidence-based acceptance gate. An **iteration** is a short work period toward that milestone; start with one week, adjusting to actual availability. A milestone may take several iterations. M1–M7 are not promises to finish the game in seven weeks.

At each iteration start, select one outcome and only enough tasks to fit the available time. Build, verify, playtest, and record the result. Unfinished work returns to the backlog; do not remove acceptance checks to make the iteration appear complete. Estimate later milestones after learning from the current one rather than assigning speculative release dates.

Use this task flow: **Backlog → Ready → In progress → Verify → Done**, with **Blocked** available when an external dependency prevents progress. Keep one main implementation task in progress. A task is Done only when its acceptance check passes and evidence is recorded. A milestone is Done only when its full exit gate passes, including required human playtesting.

The GDD owns gameplay rules and their CONFIRMED/PROPOSED status. The technical design owns implementation decisions. This roadmap owns sequencing, deliverables, and readiness. Adding a proposed feature to a milestone does not make it owner-confirmed. Use reversible isolated experiments for proposed mechanics; record consequential design selections before treating them as production behavior. Routine implementation choices do not need a new approval ceremony.

### Confirmed rules that every milestone must preserve

- Team-instanced, on-foot delivery with endless progression; no automatic finale at delivery 10 or 20.
- Major environmental events trigger after successes 5, 10, 15, 20, and onward; failures/retries never advance that schedule. This replaces the older during-delivery crisis timing.
- Each run starts with **3 shared Company Strikes**; each legitimate failed attempt costs exactly one; the third failure ends the team run.
- Every real mission has a **package HP bar and delivery time limit**. Either 0 HP or deadline expiry fails it; both occurring together still cost only one strike.

M1 may deliberately omit mission-failure systems to isolate carry feel. M2 may simulate HP and expiry. Those are internal prototype limitations, not changes to the confirmed final game.

**2026-10-30 handling amendment:** DEC-014–018 confirm one-carrier relays, carrying stamina/regeneration, fixed run-start player-count endurance, physics throws, assisted catches, and no direct strike for exhaustion or missed catches. Proposed sequencing extends M1 handling and adds missed-catch durability validation in M3. Existing evidence covers the earlier slice only; no new feature is implemented by this roadmap. Resolve GDD OPEN-024–028 and extend the TDS before that work.

**2026-10-30 world amendment:** GDD DEC-019–023 confirm one connected island/city per team run, a central warehouse, local satellite pickups, and three environmental layers. Initial environment MVP is two districts with multiple destinations and at least one station each, basic biome obstacles, simple weather, and one major event; all four districts come after loop validation. Names/effects and OPEN-029–033 remain unselected. M1’s depot reset remains a test harness; proposed M2/M3 integration and M7 content gates below reflect the final-world change without claiming implementation.

### Workspace and development boundary

Follow the repository's [Studio/MCP workflow](README.md): keep design, task records, and test notes here; work with game objects and scripts in the intended Roblox Studio place. Rojo is not required. Before the first game edit, inspect the existing place and scripts, identify a recoverable checkpoint/version, and record the intended test place. Do not assume the place is empty or overwrite existing work.

Maintain a lightweight technical design document as implementation begins. Detail the current milestone and its immediate interfaces; expand it before each later system. Keep a change record that identifies which Studio scripts/objects changed and how to reproduce the tests, even when source is not mirrored locally. This roadmap does not publish a game or authorize paid services.

## 2. Milestone overview

| Milestone | Player-visible outcome | Depends on | Current status |
|---|---|---|---|
| M1 — Cooperative relay slice | A player can manage carrying stamina, hand off/throw/catch, recover, and deliver repeatedly. | Intended Studio test place and a minimal technical plan. | Verify — relay implemented; acceptance incomplete |
| M2 — Run and station flow | Contracts continue through warehouse/satellite pickups; events trigger after each five successes; three failures end the run. | M1 gate. | Not started |
| M3 — Connected world and environmental delivery | Two connected districts support real HP/deadlines, biome obstacles, simple weather, and one major event. | M2 gate; measured M1 handling. | Not started |
| M4 — Equipment economy | Delivery earnings fund useful, understandable preparation choices. | M3 gate. | Not started |
| M5 — Persistent progress | Earned Reputation and records survive normal exits; save problems are handled honestly. | M4 gate and a persistence design. | Not started |
| M6 — Lobby and team sessions | Solo players and friend parties can enter, play, and leave private team runs reliably. | M5 gate and a published test experience for transfer tests. | Not started |
| M7 — Public release readiness | Players can find teammates and play the validated MVP on supported desktop/mobile devices. | M6 gate and the release test matrix. | Not started |
| M8 — Cosmetic monetization | Optional cosmetic purchases, only after release readiness and a separately scoped design. | M7 gate and explicit scheduling. | Future — not started |

**Main sequence:** M1 → M2 → M3A → M3B → M3C → M3D → M4 → M5 → M6 → M7; M8 follows only when scheduled. M3A–D are internal acceptance gates of M3, not renumbered milestones. Preparing later design notes is fine; building optional later systems must not displace unresolved current-gate work. Mobile usability, cleanup, server validation, and readability start in M1 and are checked throughout.

## 3. M1 — Cooperative relay slice

**Question:** Are carrying, stamina management, and relays satisfying without rewards, weather, or progression?
**Demo:** Solo placement/rest/resume and multiplayer handoff/throw/catch relays in a small greybox area; verify the 1/2/3/4-player endurance presets.

**Entry:** Inspect the intended Studio place, existing structure, and available test controls. Write the minimal technical plan for package state, server-authorized interactions, client feedback, cleanup, and recovery. Choose the initial supported avatar collision envelope and available desktop/mobile test surfaces; record any unavailable physical device.

**Deliverables:** One depot, one Standard parcel, one destination, a readable route catch and free alternative; pickup/carry/drop, stamina/regeneration with 1/2/3/4-player endurance presets, consensual handoff, physics throw/assisted catch, explicit delivery, recovery, disconnect/respawn handling, and a result-to-depot loop. Include provisional desktop/touch controls and the measurements needed to size later routes. Use placeholder art.

### M1 task backlog

New tasks start in **Backlog**. Preserve the existing implementation/evidence for M1-01–08; do not reset them or claim the revised scope has passed. Move a new task to Ready after its dependencies and acceptance checks are clear. Dependency IDs describe build order, not separate sprints.

| ID | Task / deliverable | Depends on | Acceptance check |
|---|---|---|---|
| M1-01 | Inspect Studio, record the test place and recoverable checkpoint, and draft the carry-slice technical design. | None | Existing work is documented; package state, request ownership, cleanup, and test approach are explicit; disposable experiments are identified. |
| M1-02 | Build the greybox depot/destination, small route catch, free solo alternative, and safe checkpoint locations. | M1-01 | A player can traverse both routes; switches remain usable after dropping a parcel; intended parcel/player clearance is measured. |
| M1-03 | Implement authorized pickup, carry, and safe drop. | M1-01, M1-02 | Two simultaneous pickup requests yield one carrier; blocked voluntary drops preserve possession while stamina remains; exhaustion uses the selected release/recovery fallback; ordinary placement is controllable. |
| M1-04 | Implement consensual handoff. | M1-03 | Nearby accepted handoff transfers once; unaccepted, stale, or distant requests leave ownership unchanged. |
| M1-05 | Implement recovery, carrier departure, and respawn behavior. | M1-03 | Parcel returns to a valid reached checkpoint without a forward shortcut; one remaining player can continue; reset does not duplicate the parcel. |
| M1-06 | Implement explicit delivery, result, depot return, and cleanup. | M1-03, M1-05 | Correct destination resolves once; wrong destination has clear feedback; repeated loops leave no old live parcel, timer, or interaction callback. |
| M1-07 | Integrate keyboard/touch prompts and contextual targeting across the loop. | M1-03–M1-06 | Every included action works through desktop and mobile-emulation controls; buttons do not obscure movement/camera controls. UI feedback is added alongside earlier tasks, then verified here. |
| M1-08 | Run solo and two-client handling/race/lifecycle checks; record measurements and defects. | M1-04–M1-07 | Tests include simultaneous pickup, invalid requests, handoff, recovery, carrier disconnect, respawn, wrong destination, and at least 10 complete loops. Measurements include carry speed, clearance, and safe placement impact speeds. |
| M1-09 | Conduct an uncoached fresh-player test and decide keep/refactor/rethink. | M1-08 | Record action discovery, completion, confusion, and voluntary repeat play. Fix blocking handling issues and repeat the affected check before closing M1. |

**Recorded task state (2026-10-31):** M1-10 prototype decisions recorded in the revised TDS. M1-11/12 implemented and in Verify. M1-13 has solo, real 2/3/4-client, route, and client acknowledgement evidence; human/touch/edge cases remain open. M1-09 uncoached testing remains pending. Native pre-change checkpoint verified; final checkpoint status is in RelayEvidence. Historical original-slice evidence remains valid only within its stated limits.

**Relay tasks — specification retained; current task state is recorded above:**

| ID | Task / deliverable | Depends on | Acceptance check |
|---|---|---|---|
| M1-10 | Reconcile live slice/TDS with GDD OPEN-024–028; record selected prototype controls, exhaustion fallback, stamina lifecycle, and run-start count interface. | M1-01; current-place inspection | Decisions distinguish confirmed mechanics from provisional parameters; original evidence retained. |
| M1-11 | Add carrying stamina/regeneration and player-count presets; walking/running drain and safe zero-stamina release. | M1-03, M1-05, M1-10 | GDD-049/050; solo can place/rest/resume; no direct strike or general-movement exhaustion. Use fixed test run count until M2/M6 integration. |
| M1-12 | Add physics throw, assisted catch, and desktop/mobile controls. | M1-04, M1-07, M1-10, M1-11 | GDD-048/051 handling subset: single carrier, safe handoff/catch, recoverable misses, contested transfer checks. Live damage remains M3B. |
| M1-13 | Recheck revised handling and uncoached relay pacing for 1/2/3/4 players, including latency and mobile controls. | M1-11, M1-12 | GDD-052; record rest/transfer frequency, useful non-carrier actions, repeat-loop stability, and affected earlier checks. No claim of fun from timers alone. |

**Exit gate:** Confirm a native saved place/build checkpoint and record its location/version, then complete the applicable human and latency/input checks. Revised stamina/relay handling passes M1-10–13 before expansion; earlier evidence is reused only for unchanged behavior. A fresh tester discovers the core action within a target ~30 seconds and completes the loop without verbal coaching; the parcel remains recoverable; two-player interaction and repeat-loop checks pass. Record observations rather than claiming fun from technical correctness alone. Use the GDD's broader five-tester evidence target before release; one early tester is useful M1 evidence, not a retention forecast.

**Excluded:** Real HP/deadline failure, strike progression, economy, persistence, weather, teleports, matchmaking, monetization, and final art. M1's package visuals and route layout are enough to test handling.

**GDD traceability:** §§4, 6, 12, 14; GDD-005–009, 022, 024, 027, 041–042, 048–052 (handling subset). Later milestones extend the mobile, cleanup, and respawn checks as their systems arrive.

## 4. M2 — Run and station flow

**Outcome:** A stable run can continue past delivery 20, retry correctly, and terminate exactly once at the third failure.  
**Entry:** M1 gate passed. Extend the technical design for run/attempt IDs, outcome ordering, director selection, and finite history/cleanup. Record the selected prototype defaults for no refills, same-contract retry, neutral exit, capped tiers, and simultaneous-outcome ordering (OPEN-001/002/005/014/023).

**Deliverables:** Server-owned depth, shared strikes, and a fixed run-start stamina-count snapshot (OPEN-027); one active attempt; deterministic success/failure/technical-cancellation transitions; deduplicated post-success event milestones/exposure state and warehouse/satellite preparation flow (OPEN-030/031); a small set of valid local/cross-district test templates; same-number retry; basic voluntary exit and run summary. Use test-only HP/expiry triggers and placeholder crisis labels. No requirement for rain art or the full ten-template content set yet.

**Before M2 event/station work:** Select OPEN-030/031. Demonstrate successive local and cross-district contract selections from satellites without compulsory central returns; placeholder districts are sufficient at this stage.

**Work packages — all Not started:**

| ID | Scope | Depends on | Evidence required |
|---|---|---|---|
| M2-01 | Run/attempt IDs, depth, fixed run-start stamina count, and single-resolution guard. | M1 gate; selected OPEN-027 | Attempt reset does not recalculate endurance; old callbacks cannot mutate the new attempt. |
| M2-02 | Failures, retries, neutral cancellation, individual exit, and terminal summary. | M2-01 | Three distinct failures end once; simulated simultaneous HP/expiry costs one strike. |
| M2-03 | Warehouse/satellite contract flow with placeholder station/district IDs and readiness. | M2-01; OPEN-030 | Consecutive local/cross-district selections work without compulsory warehouse teleport; one active contract remains. |
| M2-04 | Post-success event schedule and event-exposure interface. | M2-01, M2-02; OPEN-031 | Trigger once after successes 5/10/15/20; no replay on failure, retry, or duplicate success. No live hazard needed. |
| M2-05 | Director integration and repeated-transition checks. | M2-02–04 | 21 successes and 50 mixed transitions with recorded cleanup/resource counts. |

**Boundary:** M2 proves state and station flow with placeholders; the authored two-district world belongs to M3A. It does not require implementing the entire map to test the director.

**Exit gate:**

- Complete 21 simulated successful deliveries; major events trigger once after successes 5/10/15/20, not at those attempts’ start, and neither 10 nor 20 ends the run.
- Three distinct failed attempts consume 3→2→1→0; terminal state rejects all further attempts/interactions.
- Failed delivery 5 keeps depth 4 and triggers no event; failed delivery 6 keeps depth 5 without retriggering the first event. Retry uses a new attempt ID and the selected contract/event-exposure policy.
- Duplicate, simultaneous HP/expiry, and stale callbacks cannot double-resolve or double-deduct.
- Neutral technical cancellation and individual exit do not consume a strike or award success; earlier earned depth remains intact.
- Run at least 50 simulated transitions with cleanup checks. Capture live resource counts at repeatable boundaries, not just “no visible error.”

**Excluded:** Live impact tuning, real rain, shops, durable rewards, and production lobby transfers. Simulated triggers must not be accessible as normal player controls in released builds.

**GDD traceability:** §§0.2, 3, 11, 14; GDD-002–004, 011–018, 023, 027–029, 044, 050, 054 (station-flow subset).

## 5. M3 — Connected world and environmental delivery

**Outcome:** A team can continue local and cross-district deliveries in one connected two-biome world, managing real parcel HP/deadlines and a readable major event without equipment.

**Entry:** Expanded M1 and M2 gates passed, saved checkpoints recorded, measured relay behavior available. The first two biome names/effects are still provisional. Select OPEN-029/030 and a preliminary OPEN-033 streaming test plan before world construction; select OPEN-018/031/032 before their dependent stages. HP depletion and deadline failure are confirmed, not reopened decisions.

M3 has four sequential gates. Finish and record each before expanding; passing one does not complete M3. Use the M3 summary to retain the selected configuration, build checkpoint, and evidence for every gate.

| Gate / work packages | Deliverable | Exit evidence before the next gate |
|---|---|---|
| M3A — Connected world (M3-01–03) | M3-01: select/layout the two districts and measure routes; M3-02: greybox central warehouse and connected districts with multiple destinations each; M3-03: add at least one satellite per district and integrate M2 flow. | A real player completes local and cross-district deliveries, continues from satellites without compulsory central returns, and can reach pickups/destinations solo. Record rest/travel times and readable navigation. Establish instance streaming and test district crossings/carry/throw/catch early; record device/budget gaps before art expansion. |
| M3B — Parcel risk and deadlines (M3-04–05) | M3-04: Standard/Fragile HP, measured impact/missed-catch damage and safe transfers; M3-05: deadlines, warnings, retry/fault handling, and coaching on the actual routes. | 0 HP or expiry fails once; simultaneous causes lose one strike. Test just-before/at/after expiry and stale timers. Ordinary placement/handoff/successful catch/recovery cause no phantom damage. Misses/exhaustion alone cost no strike. Fresh solo/mobile completion fits the free-route deadline including rest time; fixed endurance after departures remains viable. |
| M3C — Biome obstacles and simple weather (M3-06–07) | M3-06: selected basic biome obstacles; M3-07: simple weather, forecast, warnings, and validated combined effects. Rain remains proposed first weather. | Teach each effect separately, then combine it. Effects are readable and measurable; every required route has solo/no-gear counterplay. Test 1/2/4 clients and provisional 100/200 ms latency scenarios; record modifier combinations rather than blindly stacking them. Remeasure affected deadlines and catch behavior. |
| M3D — First major event (M3-08–09) | M3-08: implement one selected event and its onset, footprint, lifetime, retry/exposure policy; M3-09: integrate repeated milestones and validate the full loop. Storm-driven route closure is a candidate, not a locked design. | After success 5, a disruption meaningfully changes route choice/conditions; it does not occur merely at delivery 5 start. Verify milestones 10/15/20 with the same validated event/configurations where appropriate, no duplicate triggering, no unfair effect accumulation, and reachable stations/destinations. Preserve one-strike resolution and fair solo/mobile counterplay. |

**Cross-stage checks:** Server-fault recovery follows the selected neutral pause/cancellation policy; normal recovery neither heals nor resets the clock. If unanimous abandon is selected (OPEN-006), absent consent and changed rosters invalidate the vote. Recheck only affected earlier evidence after changes. Every stage uses placeholder art until its gameplay passes.

**Overall exit gate:** M3A–D each have a saved checkpoint, executed evidence, and unresolved-issue disposition. Complete an integrated no-gear local/cross-district run through the first event and a failure/retry; players can explain HP, time, event changes, and next pickup. No known mandatory route is inaccessible. Full device/content certification remains M7, but known streaming or transfer blockers cannot be deferred while claiming M3 complete.

**Excluded:** Third/fourth districts, advanced unselected biome interactions, additional major-event types, equipment assistance, water exposure/Rain Cover, Inflatable, final art, and monetization. One validated major event satisfies initial scope; neither four biomes nor a new event type every five successes is required.

**GDD traceability:** §§3–7, 9, 11–12, 15; GDD-003–004, 008–010, 017–018, 024, 030–031, 033, 041, 043–056. Numerical damage, timing, catch, environment, and performance settings remain provisional until measured.

## 6. M4 — Rewards and equipment choices

**Outcome:** Successful deliveries pay correctly, and players can make understandable preparation choices.  
**Entry:** All M3A–D gates passed. Select prototype defaults for temporary wallets, equal eligibility, equipment slots/durations, rating/payout formula, and prices (OPEN-007/008/009/017/020). These are balance hypotheses, not measured truths.

**Deliverables:** Individual Run Coins; one shared rating and per-eligible-player awards; central-warehouse shop (satellite services OPEN-030); Grip Boots and Packing Foam; charges and expiry; nonstacking parcel protection; preparation/loadout confirmation sufficient for this loop; exact technical-cancellation gear restoration. Show payout and equipment effects clearly. Persistent Reputation writes arrive in M5.

**Station integration check:** Apply the selected OPEN-030 service policy; do not introduce satellite shops implicitly. A team can continue deliveries without a mandatory shop trip. Verify the selected OPEN-031 exposure tag before calculating crisis bonuses.

**Suggested iteration order:** M4-A award calculations and eligibility → M4-B shop/equipment behavior → M4-C repeated-run balance tests.

**Exit gate:**

- Using the current GDD balance, the first five perfect ordinary successes pay 120/130/140/150/150 coins (690 total), then the first event triggers; a later perfect crisis-affected success pays 175 under OPEN-031. Bonus amounts are unchanged. Failure/cancellation never pays success rewards.
- Duplicate purchases, uses, and award requests cannot double-spend or double-grant; simultaneous Foam application consumes only one charge across the team.
- Boots affect their wearer; Foam follows the parcel through handoff; neither extends time or restores strikes.
- Legitimate failure retains spent charges; cancellation restores the starting gear snapshot once; normal recovery refunds nothing.
- Departure expires that player's temporary resources without altering teammates' balances. Unused gear behaves as specified across non-terminal failure.
- Run no-gear and equipped trials. Record balances/spending at depth 5/10/20 and whether players always buy both tools. If there is no meaningful choice, test the GDD's one-slot alternative or retune, then document the selected design.

**Excluded:** Real-money purchases, trading, extra currencies, shared banking, Rain Cover, and permanent gameplay upgrades.

**GDD traceability:** §8; GDD-019, 021, 026, 029, 034–036, 039.

## 7. M5 — Persistent Reputation and records

**Outcome:** Players retain earned progress across normal sessions and receive accurate feedback when saving is delayed.  
**Entry:** M4 gate passed. Define profile schema, migrations, session ownership, ordered writes, bounded award deduplication, and pending-save behavior (OPEN-022). Identify an isolated test data environment before persistence tests; never test against real player profiles casually.

**Deliverables:** Reputation, best team depth, lifetime eligible deliveries, minimal cosmetic unlock records, tutorial/settings persistence, per-success award checkpoints, Saved/Pending/error UI, failed-load protection, shutdown/leave save handling, and safe migration behavior. Specify how the later lobby-to-run transfer hands over profile ownership. Any cosmetic artwork can remain minimal; do not build a large cosmetic catalog.

**Suggested iteration order:** M5-A profile lifecycle and failure-safe loading → M5-B persistent awards/idempotency → M5-C interruption, migration, and competing-session tests.

**Exit gate:**

- Rejoin sees committed Reputation/records; bestDepth and totalDeliveries have distinct correct meanings.
- A failed load never saves defaults over an existing profile. Retried or unknown-result writes do not duplicate progress or overwrite newer state.
- Pending becomes Saved only after acknowledgement; delayed saves follow the selected warehouse/satellite preparation hold policy and never consume a strike.
- Leaving or a third failure does not intentionally confiscate earlier permanent earnings; the incomplete current attempt earns nothing.
- Test throttling/failure, departure during load/save, competing sessions, shutdown, and a profile migration. Record the unavoidable limitation that unsaved data may be lost in an abrupt outage.
- Verify deduplication/history bounds and cleanup over repeated attempts; avoid an ever-growing award-ID list.

**Excluded:** Global leaderboards, resumable active runs, trading, paid purchases, and extensive unlock trees.

**GDD traceability:** §§8.1–8.2, 10; GDD-015, 020–021, 025, 037, 040.

## 8. M6 — Lobby, parties, and private run sessions

**Outcome:** A solo player or friend party can launch a private run, handle missing arrivals, and leave safely.  
**Entry:** M5 gate passed. Identify lobby/run test places and published-client testing access. Select party-size, departure/rejoin limits, and readiness/Away timing defaults (OPEN-005/011/016/019). Verify current transfer APIs when implementing them; do not copy an old API assumption blindly.

**Deliverables:** Public lobby; Solo/Friends launch; party ready roster; server-validated admission; loading/profile handoff; partial-arrival Wait/Continue/Return; warehouse/satellite Ready/Away/Leave; carrier/leader departure; return-to-lobby retry; empty-run cleanup. Integrate the earlier core loop rather than creating a second independent run system.

**Suggested iteration order:** M6-A lobby and readiness → M6-B run admission/transfer → M6-C partial-arrival/departure/recovery tests.

**Exit gate:**

- Published-client tests launch solo and 2/4-player friend runs with no unrelated members admitted.
- Partial arrival cannot silently start a contract; closed rosters reject late admission safely; failed outbound/return transfers have usable retry/return feedback.
- An unready member is not forcibly deployed; Away members cannot interact with or earn for the current attempt; no ready participant means no start.
- Carrier and party-leader departure do not strand remaining members or reset strikes. All-exit cleanup leaves no active session resources.
- Profiles transfer without conflicting ownership or duplicated rewards. Save/load errors remain understandable in the lobby/run flow.
- Run-start stamina count is captured at the selected partial-arrival boundary (OPEN-027), then stays fixed through departures, Away changes, and station preparation. Verify gathering/readiness with members spread across districts (OPEN-030).
- Normal character respawn remains distinct from disconnect/rejoin. No promised active-run resumption is implied.

**Excluded:** Cross-server queues, mid-run newcomers, disconnected-player rejoin, and complex public social systems. A friends/solo closed test can follow this milestone; it is not the full public MVP yet.

**GDD traceability:** §§2, 9–10, 15; GDD-001, 011, 022, 032, 038, 040–041.

## 9. M7 — Content, matching, and release readiness

**Outcome:** The MVP is ready for an explicitly authorized public release, with evidence for its supported devices and core behavior.  
**Entry:** M6 gate passed; all earlier critical defects addressed. Name minimum test devices, finalize the avatar envelope, and define production analytics retention/access. Confirm same-lobby matching scope (OPEN-012), content/package deferrals, and final balance selections.

**Deliverables:** Same-lobby Find Team with Solo/wait fallback; one streamed interconnected world with a central warehouse and two districts, multiple destinations and at least one satellite per district, roughly ten validated local/cross-district templates, basic biome obstacles, simple weather, and one major event; onboarding; readable art/audio; accessible desktop/mobile UI; minimal instrumentation; release test record and known limitations. These are content targets, not permission to ship unvalidated combinations.

**Suggested iteration order:** M7-A matching and completion of the existing two-district content → M7-B presentation/accessibility and final streaming/device certification → M7-C external playtest and release candidate fixes. M7 validates and polishes the M3 world; it is not the first implementation of connected districts or streaming. Do not treat all of M7 as one sprint.

**Exit gate:**

- Audit every GDD-001–056 criterion and each shipped contract, with evidence attached. Prior results remain usable only if the relevant behavior has not changed.
- Public team finding works without an indefinite forced wait; solo remains available.
- Every shipped template is solo/mobile-completable with zero gear, positive HP, and a reachable deadline. Confirm the first-four teaching sequence and post-success event milestones beyond depth 20; validate combined environmental layers and station flow without per-delivery level loading.
- Meet or explicitly revise the GDD's provisional playtest gates: at least 4 of 5 fresh testers complete onboarding/explain failure, and at least 3 of 5 voluntarily continue after three deliveries. Record qualitative reasons as well as counts.
- Validate instance-streamed district boundaries, parcel throws/catches, critical stations/routes, and event changes on named devices; measure asset/memory budgets as well as frame time (OPEN-033).
- Complete physical mobile-device checks, safe-area/aspect checks, accessibility checks, latency scenarios, 50-attempt cleanup checks, and published-session failure tests. Emulation alone cannot establish device performance.
- On named target devices, evaluate the provisional 95%-of-frames mobile 33.3 ms / desktop 16.7 ms targets in representative four-player rain play; report actual results and unresolved limitations.
- No known blocker remains involving progression loss, duplicate awards, incorrect strikes, impossible required routes, inaccessible mandatory controls, or unauthorized run membership. Lower-impact issues have an explicit disposition.

**Release boundary:** Passing M7 means the release candidate is ready for a release decision. Public publishing is a separate action, not performed or implied by this planning document. Record the intended build/version and rollback path before a later authorized release.

**GDD traceability:** All §16 acceptance criteria and §17 release gates; especially GDD-008–010, 024, 026–027, 047. Do not count the documentation or a simulated run as evidence of live release readiness.

## 10. Iteration planning and evidence templates

### Next iteration — finish the relay foundation

**Goal:** Resume the existing slice and establish stamina behavior before expanding the world.

1. Inspect the live Studio place and native save status; reconcile it with the TDS/snapshots. Retain user work and recover only if the place is actually missing.
2. M1-10: select the prototype defaults in OPEN-024–028 and update the TDS. Fix the test run count now; M2/M6 own production roster integration.
3. M1-11: implement stamina/regeneration, walking/running drain, and the selected safe exhaustion behavior; verify solo placement/rest/resume and all four endurance presets.
4. Next batch: M1-12 throws/catches and accessible inputs, then M1-13 revised-loop checks plus pending M1-09 human evidence. Do not reopen already-passed unrelated checks unless the change affects them.

**Not in this iteration:** Rebuilding M1-02–07 from scratch, world construction, HP/deadline implementation, weather, shops, or persistence. The old depot reset remains a test harness until M2/M3 station integration.

**Review:** Record the native build/checkpoint, selected parameters, actual results and limitations, then choose the next batch. No calendar deadline or milestone completion is implied by this plan.

### Task record

Copy this small record into the chosen Markdown backlog or task board when scheduling work:

```text
ID / title:
Milestone:
Status: Backlog | Ready | In progress | Verify | Blocked | Done
Owner:
Player-visible outcome:
GDD section / requirement IDs:
Dependencies and selected design assumptions:
Included / excluded work:
Acceptance checks:
Verification environment and build/place checkpoint:
Evidence / result / remaining defects:
```

### Milestone completion record

```text
Milestone / completed date:
Build or Studio place checkpoint:
Delivered outcome:
Acceptance results and evidence links:
Human playtest observations:
Decisions made and corresponding GDD changes:
Known limitations / deferred issues:
Next milestone entry conditions met or still missing:
```

A missing tester, physical device, or published test setup should be recorded as **not verified**, not silently marked passed. Continue independent work when useful, but do not close a gate with missing evidence. Repeat checks when a change invalidates their result; otherwise use the recorded evidence rather than repeatedly running unrelated tests.

## 11. Future scope and change control

### M8 — Cosmetic monetization (Future, not started)

Keep M8 after M7 as previously agreed; it is not part of the initial gameplay MVP. Entry requires M7 readiness evidence and explicit scheduling. Before implementation, scope cosmetic products and presentation, purchase/entitlement handling, and validation in a separate design. Products, prices, and purchase flows are not selected here. Its eventual gate must demonstrate correct entitlements/retry behavior, readable cosmetics, and no gameplay advantage; detailed checks belong to that later design. No paid strike refill, premium continue, or required paid counterplay.

### Expansion parking lot

Keep future work in a parking lot until the base loop and release evidence justify it. Do not turn this section into committed sprints.

| Future area | Revisit when | Existing boundary |
|---|---|---|
| Monetization | The core game is enjoyable, repeat play is observed, and the team explicitly schedules commercial work. | Cosmetic direction only; no planned paid strike refill, premium continue, or required paid counterplay. Products, prices, and purchase flows remain undesigned. |
| Inflatable / more package types | Standard/Fragile handling is reliable and players need variety. | A focused physics/route prototype must pass before entering the contract pool. |
| Third/fourth biome districts | The two-district connected-world loop and environmental combinations are validated. | Full four-district structure is intended; names/effects remain provisional; each added district needs multiple destinations and a satellite. |
| More weather / water sensitivity | Rain is useful and understandable; authored route variety no longer addresses the observed need. | Rain Cover arrives only with a validated water mechanic. |
| Rejoin / active-run recovery | Session ownership and persistence are proven, with evidence that interruptions materially harm longer sessions. | No current MVP promise of resumption. |
| Cross-server matching / global records | Same-lobby grouping or local records demonstrably limit the product. | Security, fairness, operating complexity, and performance need a separate design. |

When scope changes, record the player problem, evidence, cost to the active milestone, and selected decision. Update the GDD if behavior changes; update the roadmap if order or scope changes. Preserve the confirmed endless/crisis/three-strike/HP/deadline rules unless the owner explicitly revises them. Cut optional content before weakening reliability or quietly removing those core rules.

## 12. Local skills and handoff

This plan applies the previously reviewed local `router`, `prototype-fast`, and `level-design` skills: route by actual task, prove the core verb before expanding, measure player/package geometry, and teach mechanics before testing them under pressure. UI, persistence, and server validation gates also carry forward the GDD's application of `game-ui-ux`, `save-systems`, `roblox-datastores`, and `roblox-networking`.

At implementation time, read the focused local skills for the assigned milestone. For direct Studio work, include `roblox-studio-workflow`; add physics, UI, networking, or data-store guidance only as relevant. Inspect the current project before changing it. No skill instruction replaces the owner's confirmed gameplay choices.

### Decision ownership and sequencing

| Open decisions | Resolve by | Why |
|---|---|---|
| OPEN-024–026/028; test interface for OPEN-027 | M1-10 before stamina/throw/catch implementation | Controls, stamina lifecycle, exhaustion and transfer conflicts must be explicit. |
| OPEN-001/002/005/014/023/027; OPEN-030/031 flow/state contracts | M2 entry and dependent work packages | Correct resolution, fixed endurance, stations, and event deduplication. |
| OPEN-029; physical layout/gathering details of OPEN-030; initial OPEN-033 | M3A | Select two biomes and prove connected-world/streaming feasibility before polishing assets. |
| OPEN-018; OPEN-006 if included | M3B | Measure damage/deadlines and optional abandon semantics. |
| OPEN-010/032 and concrete OPEN-031 event configuration | M3C/D | Readable effect combinations and a meaningful event with defined lifetime. |
| OPEN-007–009/017/020 and selected service/exposure policy | M4 | Correct rewards, equipment and station integration. |
| OPEN-022 | M5 | Safe persistent awards and station preparation holds. |
| OPEN-005/011/016/019 plus real launch binding of OPEN-027/030 | M6 | Admission, partial arrivals, readiness and fixed stamina scaling. |
| OPEN-012/021/033 final certification | M7 | Matching and measured device/streaming release evidence. |

Closing a planning dependency means recording a selected prototype rule or measured parameter; it does not automatically confirm all proposed GDD behavior or require a new permission ceremony.

**Next actionable task:** Complete the outstanding M1 human/input/edge-case checks and final checkpoint verification in [RelayEvidence](state/m1/RelayEvidence.md). Keep M1 Verify until its full exit gate passes; M2 remains closed.
