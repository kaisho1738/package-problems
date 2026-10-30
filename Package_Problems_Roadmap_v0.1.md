# Package Problems — Milestone Roadmap v0.1

**Date:** 2026-10-30  
**Design baseline:** [GDD v0.4](Package_Problems_GDD_v0.4_Development_Refinement.md)  
**Team:** One developer + Codex  
**Workflow:** Milestones with short development iterations and a small task board  
**Planning status:** All milestones Not started. M1 is next. No implementation, live Studio inspection, or gameplay validation is claimed by this roadmap.

## 1. How to use this roadmap

A **milestone** delivers a playable capability and ends with an evidence-based acceptance gate. An **iteration** is a short work period toward that milestone; start with one week, adjusting to actual availability. A milestone may take several iterations. M1–M7 are not promises to finish the game in seven weeks.

At each iteration start, select one outcome and only enough tasks to fit the available time. Build, verify, playtest, and record the result. Unfinished work returns to the backlog; do not remove acceptance checks to make the iteration appear complete. Estimate later milestones after learning from the current one rather than assigning speculative release dates.

Use this task flow: **Backlog → Ready → In progress → Verify → Done**, with **Blocked** available when an external dependency prevents progress. Keep one main implementation task in progress. A task is Done only when its acceptance check passes and evidence is recorded. A milestone is Done only when its full exit gate passes, including required human playtesting.

The GDD owns gameplay rules and their CONFIRMED/PROPOSED status. The technical design owns implementation decisions. This roadmap owns sequencing, deliverables, and readiness. Adding a proposed feature to a milestone does not make it owner-confirmed. Use reversible isolated experiments for proposed mechanics; record consequential design selections before treating them as production behavior. Routine implementation choices do not need a new approval ceremony.

### Confirmed rules that every milestone must preserve

- Team-instanced, on-foot delivery with endless progression; no automatic finale at delivery 10 or 20.
- Crises occur during deliveries 5, 10, 15, 20, and onward.
- Each run starts with **3 shared Company Strikes**; each legitimate failed attempt costs exactly one; the third failure ends the team run.
- Every real mission has a **package HP bar and delivery time limit**. Either 0 HP or deadline expiry fails it; both occurring together still cost only one strike.

M1 may deliberately omit mission-failure systems to isolate carry feel. M2 may simulate HP and expiry. Those are internal prototype limitations, not changes to the confirmed final game.

### Workspace and development boundary

Follow the repository's [Studio/MCP workflow](README.md): keep design, task records, and test notes here; work with game objects and scripts in the intended Roblox Studio place. Rojo is not required. Before the first game edit, inspect the existing place and scripts, identify a recoverable checkpoint/version, and record the intended test place. Do not assume the place is empty or overwrite existing work.

Maintain a lightweight technical design document as implementation begins. Detail the current milestone and its immediate interfaces; expand it before each later system. Keep a change record that identifies which Studio scripts/objects changed and how to reproduce the tests, even when source is not mirrored locally. This roadmap does not publish a game or authorize paid services.

## 2. Milestone overview

| Milestone | Player-visible outcome | Depends on | Current status |
|---|---|---|---|
| M1 — Carry slice | A player can pick up, carry, hand off, recover, and deliver a parcel repeatedly. | Intended Studio test place and a minimal technical plan. | Not started — next |
| M2 — Endless run state | The delivery loop continues, schedules crises, and ends correctly after three failures. | M1 gate. | Not started |
| M3 — HP, deadlines, and rain | Players understand and can overcome the real failure conditions and first crisis. | M2 gate; measured M1 handling. | Not started |
| M4 — Equipment economy | Delivery earnings fund useful, understandable preparation choices. | M3 gate. | Not started |
| M5 — Persistent progress | Earned Reputation and records survive normal exits; save problems are handled honestly. | M4 gate and a persistence design. | Not started |
| M6 — Lobby and team sessions | Solo players and friend parties can enter, play, and leave private team runs reliably. | M5 gate and a published test experience for transfer tests. | Not started |
| M7 — Public release readiness | Players can find teammates and play the validated MVP on supported desktop/mobile devices. | M6 gate and the release test matrix. | Not started |

**Main sequence:** M1 → M2 → M3 → M4 → M5 → M6 → M7. Preparing later design notes is fine; building optional later systems must not displace unresolved current-gate work. Mobile usability, cleanup, server validation, and readability start in M1 and are checked throughout.

## 3. M1 — Reliable, enjoyable carry slice

**Question:** Is pickup/carry/place satisfying without rewards, weather, or progression?  
**Demo:** One solo player, then two players, complete repeated deliveries in a small greybox area.

**Entry:** Inspect the intended Studio place, existing structure, and available test controls. Write the minimal technical plan for package state, server-authorized interactions, client feedback, cleanup, and recovery. Choose the initial supported avatar collision envelope and available desktop/mobile test surfaces; record any unavailable physical device.

**Deliverables:** One depot, one Standard parcel, one destination, a readable route catch and free alternative; pickup/carry/drop, consensual handoff, explicit delivery, recovery, disconnect/respawn handling, and a result-to-depot loop. Include provisional desktop/touch controls and the measurements needed to size later routes. Use placeholder art.

### M1 task backlog

All tasks start in **Backlog**. Move a task to Ready after its dependencies and acceptance checks are clear. Dependency IDs describe build order, not separate sprints.

| ID | Task / deliverable | Depends on | Acceptance check |
|---|---|---|---|
| M1-01 | Inspect Studio, record the test place and recoverable checkpoint, and draft the carry-slice technical design. | None | Existing work is documented; package state, request ownership, cleanup, and test approach are explicit; disposable experiments are identified. |
| M1-02 | Build the greybox depot/destination, small route catch, free solo alternative, and safe checkpoint locations. | M1-01 | A player can traverse both routes; switches remain usable after dropping a parcel; intended parcel/player clearance is measured. |
| M1-03 | Implement authorized pickup, carry, and safe drop. | M1-01, M1-02 | Two simultaneous pickup requests yield one carrier; blocked drops preserve possession; ordinary placement is controllable. |
| M1-04 | Implement consensual handoff. | M1-03 | Nearby accepted handoff transfers once; unaccepted, stale, or distant requests leave ownership unchanged. |
| M1-05 | Implement recovery, carrier departure, and respawn behavior. | M1-03 | Parcel returns to a valid reached checkpoint without a forward shortcut; one remaining player can continue; reset does not duplicate the parcel. |
| M1-06 | Implement explicit delivery, result, depot return, and cleanup. | M1-03, M1-05 | Correct destination resolves once; wrong destination has clear feedback; repeated loops leave no old live parcel, timer, or interaction callback. |
| M1-07 | Integrate keyboard/touch prompts and contextual targeting across the loop. | M1-03–M1-06 | Every included action works through desktop and mobile-emulation controls; buttons do not obscure movement/camera controls. UI feedback is added alongside earlier tasks, then verified here. |
| M1-08 | Run solo and two-client handling/race/lifecycle checks; record measurements and defects. | M1-04–M1-07 | Tests include simultaneous pickup, invalid requests, handoff, recovery, carrier disconnect, respawn, wrong destination, and at least 10 complete loops. Measurements include carry speed, clearance, and safe placement impact speeds. |
| M1-09 | Conduct an uncoached fresh-player test and decide keep/refactor/rethink. | M1-08 | Record action discovery, completion, confusion, and voluntary repeat play. Fix blocking handling issues and repeat the affected check before closing M1. |

**Exit gate:** A fresh tester discovers the core action within a target ~30 seconds and completes the loop without verbal coaching; the parcel remains recoverable; two-player interaction and repeat-loop checks pass. Record observations rather than claiming fun from technical correctness alone. Use the GDD's broader five-tester evidence target before release; one early tester is useful M1 evidence, not a retention forecast.

**Excluded:** Real HP/deadline failure, strike progression, economy, persistence, weather, teleports, matchmaking, monetization, and final art. M1's package visuals and route layout are enough to test handling.

**GDD traceability:** §§4, 6, 12, 14; GDD-005–009, 022, 024, 027, 041–042. Later milestones extend the mobile, cleanup, and respawn checks as their systems arrive.

## 4. M2 — Endless progression and reliable resolution

**Outcome:** A stable run can continue past delivery 20, retry correctly, and terminate exactly once at the third failure.  
**Entry:** M1 gate passed. Extend the technical design for run/attempt IDs, outcome ordering, director selection, and finite history/cleanup. Record the selected prototype defaults for no refills, same-contract retry, neutral exit, capped tiers, and simultaneous-outcome ordering (OPEN-001/002/005/014/023).

**Deliverables:** Server-owned depth and shared strikes; one active attempt; deterministic success/failure/technical-cancellation transitions; crisis tags; a small set of valid test templates; same-number retry; basic voluntary exit and run summary. Use test-only HP/expiry triggers and placeholder crisis labels. No requirement for rain art or the full ten-template content set yet.

**Suggested iteration order:** M2-A run state and success loop → M2-B failures/retries/exits → M2-C director and transition stress tests.

**Exit gate:**

- Complete 21 simulated successful deliveries; crises appear at 5/10/15/20 and neither 10 nor 20 ends the run.
- Three distinct failed attempts consume 3→2→1→0; terminal state rejects all further attempts/interactions.
- Failed crisis 5 keeps depth 4 and retries crisis 5 with a new attempt ID.
- Duplicate, simultaneous HP/expiry, and stale callbacks cannot double-resolve or double-deduct.
- Neutral technical cancellation and individual exit do not consume a strike or award success; earlier earned depth remains intact.
- Run at least 50 simulated transitions with cleanup checks. Capture live resource counts at repeatable boundaries, not just “no visible error.”

**Excluded:** Live impact tuning, real rain, shops, durable rewards, and production lobby transfers. Simulated triggers must not be accessible as normal player controls in released builds.

**GDD traceability:** §§0.2, 3, 11, 14; GDD-002–004, 011–018, 023, 027–029, 044.

## 5. M3 — Real HP, deadlines, and first rain crisis

**Outcome:** Players can understand both failure causes and complete an actual rain crisis without equipment.  
**Entry:** M2 gate passed; carry measurements available. Select safe impact thresholds, initial HP/damage, and deadline tuning through tests (OPEN-018). HP depletion and deadline failure are already confirmed; do not reopen that product decision. Team-abandon details remain proposed (OPEN-006).

**Deliverables:** Standard and Fragile HP bars; validated impact damage; visible hard countdowns; readable warnings; coaching for both constraints; measured free-route deadlines; same-contract retry reset; verified-fault pause/cancellation. Implement rain and wet terrain only after the basic failure model passes. Add one dry alternate route, forecast-before-start, and at least one complete crisis template. Include unanimous abandon if selected, with nonresponse/roster-change cancellation.

**Suggested iteration order:** M3-A HP and deadline behavior → M3-B coaching and fair solo/mobile tuning → M3-C forecast/rain/crisis combination.

**Exit gate:**

- Either parcel at 0 HP fails once; positive-HP cargo fails when time expires. Simultaneous causes lose one strike.
- Check delivery just before, exactly at, and just after expiry; a success accepted before expiry remains successful through result/save delay.
- Pickup, handoff, placement, respawn, and recovery do not generate phantom damage. Normal player actions do not reset clocks or heal parcels.
- Server-fault recovery freezes gameplay and clocks as designed; stale timers cannot fail a replacement attempt.
- A fresh solo/mobile tester completes the free route within its deadline and explains HP, time, and the strike cause.
- Wet terrain has a measurable effect and readable dry alternative. Crisis 5 adds no untaught failure mechanic. Test solo and 2/4 clients, including the GDD's provisional 100/200 ms latency scenarios.
- If abandon is included, absent consent never becomes approval and changed rosters invalidate the vote.

**Excluded:** Equipment assistance, water exposure/Rain Cover, Inflatable, additional weather, and final visual polish. A crisis that needs purchased equipment fails this gate.

**GDD traceability:** §§3.3, 5–7, 9, 11–12; GDD-008, 010, 017–018, 024, 030–031, 033, 041, 043–047.

## 6. M4 — Rewards and equipment choices

**Outcome:** Successful deliveries pay correctly, and players can make understandable preparation choices.  
**Entry:** M3 gate passed. Select prototype defaults for temporary wallets, equal eligibility, equipment slots/durations, rating/payout formula, and prices (OPEN-007/008/009/017/020). These are balance hypotheses, not measured truths.

**Deliverables:** Individual Run Coins; one shared rating and per-eligible-player awards; depot-only shop; Grip Boots and Packing Foam; charges and expiry; nonstacking parcel protection; preparation/loadout confirmation sufficient for this loop; exact technical-cancellation gear restoration. Show payout and equipment effects clearly. Persistent Reputation writes arrive in M5.

**Suggested iteration order:** M4-A award calculations and eligibility → M4-B shop/equipment behavior → M4-C repeated-run balance tests.

**Exit gate:**

- Using the current GDD balance, five perfect successes pay 120/130/140/150/175 coins; the fifth is a crisis. Failure/cancellation never pays success rewards.
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
- Pending becomes Saved only after acknowledgement; delayed saves follow the selected depot-hold policy and never consume a strike.
- Leaving or a third failure does not intentionally confiscate earlier permanent earnings; the incomplete current attempt earns nothing.
- Test throttling/failure, departure during load/save, competing sessions, shutdown, and a profile migration. Record the unavoidable limitation that unsaved data may be lost in an abrupt outage.
- Verify deduplication/history bounds and cleanup over repeated attempts; avoid an ever-growing award-ID list.

**Excluded:** Global leaderboards, resumable active runs, trading, paid purchases, and extensive unlock trees.

**GDD traceability:** §§8.1–8.2, 10; GDD-015, 020–021, 025, 037, 040.

## 8. M6 — Lobby, parties, and private run sessions

**Outcome:** A solo player or friend party can launch a private run, handle missing arrivals, and leave safely.  
**Entry:** M5 gate passed. Identify lobby/run test places and published-client testing access. Select party-size, departure/rejoin limits, and readiness/Away timing defaults (OPEN-005/011/016/019). Verify current transfer APIs when implementing them; do not copy an old API assumption blindly.

**Deliverables:** Public lobby; Solo/Friends launch; party ready roster; server-validated admission; loading/profile handoff; partial-arrival Wait/Continue/Return; depot Ready/Away/Leave; carrier/leader departure; return-to-lobby retry; empty-run cleanup. Integrate the earlier core loop rather than creating a second independent run system.

**Suggested iteration order:** M6-A lobby and readiness → M6-B run admission/transfer → M6-C partial-arrival/departure/recovery tests.

**Exit gate:**

- Published-client tests launch solo and 2/4-player friend runs with no unrelated members admitted.
- Partial arrival cannot silently start a contract; closed rosters reject late admission safely; failed outbound/return transfers have usable retry/return feedback.
- An unready member is not forcibly deployed; Away members cannot interact with or earn for the current attempt; no ready participant means no start.
- Carrier and party-leader departure do not strand remaining members or reset strikes. All-exit cleanup leaves no active session resources.
- Profiles transfer without conflicting ownership or duplicated rewards. Save/load errors remain understandable in the lobby/run flow.
- Normal character respawn remains distinct from disconnect/rejoin. No promised active-run resumption is implied.

**Excluded:** Cross-server queues, mid-run newcomers, disconnected-player rejoin, and complex public social systems. A friends/solo closed test can follow this milestone; it is not the full public MVP yet.

**GDD traceability:** §§2, 9–10, 15; GDD-001, 011, 022, 032, 038, 040–041.

## 9. M7 — Content, matching, and release readiness

**Outcome:** The MVP is ready for an explicitly authorized public release, with evidence for its supported devices and core behavior.  
**Entry:** M6 gate passed; all earlier critical defects addressed. Name minimum test devices, finalize the avatar envelope, and define production analytics retention/access. Confirm same-lobby matching scope (OPEN-012), content/package deferrals, and final balance selections.

**Deliverables:** Same-lobby Find Team with Solo/wait fallback; one cohesive neighborhood, approximately five destinations and ten validated templates; onboarding; readable art/audio; accessible desktop/mobile UI; minimal instrumentation; release test record and known limitations. These are content targets, not permission to ship unvalidated combinations.

**Suggested iteration order:** M7-A matching and authored content completion → M7-B presentation/accessibility/performance → M7-C external playtest and release candidate fixes. Do not treat all of M7 as one sprint.

**Exit gate:**

- Audit every GDD-001–047 criterion and each shipped contract, with evidence attached. Prior results remain usable only if the relevant behavior has not changed.
- Public team finding works without an indefinite forced wait; solo remains available.
- Every shipped template is solo/mobile-completable with zero gear, positive HP, and a reachable deadline. Confirm the first-four teaching sequence and crisis rotation beyond depth 20.
- Meet or explicitly revise the GDD's provisional playtest gates: at least 4 of 5 fresh testers complete onboarding/explain failure, and at least 3 of 5 voluntarily continue after three deliveries. Record qualitative reasons as well as counts.
- Complete physical mobile-device checks, safe-area/aspect checks, accessibility checks, latency scenarios, 50-attempt cleanup checks, and published-session failure tests. Emulation alone cannot establish device performance.
- On named target devices, evaluate the provisional 95%-of-frames mobile 33.3 ms / desktop 16.7 ms targets in representative four-player rain play; report actual results and unresolved limitations.
- No known blocker remains involving progression loss, duplicate awards, incorrect strikes, impossible required routes, inaccessible mandatory controls, or unauthorized run membership. Lower-impact issues have an explicit disposition.

**Release boundary:** Passing M7 means the release candidate is ready for a release decision. Public publishing is a separate action, not performed or implied by this planning document. Record the intended build/version and rollback path before a later authorized release.

**GDD traceability:** All §16 acceptance criteria and §17 release gates; especially GDD-008–010, 024, 026–027, 047. Do not count the documentation or a simulated run as evidence of live release readiness.

## 10. Iteration planning and evidence templates

### First iteration proposal

**Goal:** Prove authorized solo pickup, carrying, safe placement, and a basic destination interaction in the greybox test area.

**Initial selection:** M1-01 → M1-02 → M1-03. Add the delivery portion of M1-06 only if capacity remains, with its dependency on recovery/cleanup made explicit; do not mark M1-06 complete until all of its checks pass. Plan M1-04/05 and the complete loop for the following iteration if needed. Do not begin HP, shops, or rain to fill spare time while handling is unresolved.

**Review:** Demonstrate what works, record the current build/place checkpoint and measured handling issues, and select the next small batch. This is a proposed first-week scope, not a calendar commitment. Re-plan after M1-01 if the Studio inventory reveals existing implementation or setup work.

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

Keep future work in a parking lot until the base loop and release evidence justify it. Do not turn this section into committed sprints.

| Future area | Revisit when | Existing boundary |
|---|---|---|
| Monetization | The core game is enjoyable, repeat play is observed, and the team explicitly schedules commercial work. | Cosmetic direction only; no planned paid strike refill, premium continue, or required paid counterplay. Products, prices, and purchase flows remain undesigned. |
| Inflatable / more package types | Standard/Fragile handling is reliable and players need variety. | A focused physics/route prototype must pass before entering the contract pool. |
| More weather / water sensitivity | Rain is useful and understandable; authored route variety no longer addresses the observed need. | Rain Cover arrives only with a validated water mechanic. |
| Rejoin / active-run recovery | Session ownership and persistence are proven, with evidence that interruptions materially harm longer sessions. | No current MVP promise of resumption. |
| Cross-server matching / global records | Same-lobby grouping or local records demonstrably limit the product. | Security, fairness, operating complexity, and performance need a separate design. |

When scope changes, record the player problem, evidence, cost to the active milestone, and selected decision. Update the GDD if behavior changes; update the roadmap if order or scope changes. Preserve the confirmed endless/crisis/three-strike/HP/deadline rules unless the owner explicitly revises them. Cut optional content before weakening reliability or quietly removing those core rules.

## 12. Local skills and handoff

This plan applies the previously reviewed local `router`, `prototype-fast`, and `level-design` skills: route by actual task, prove the core verb before expanding, measure player/package geometry, and teach mechanics before testing them under pressure. UI, persistence, and server validation gates also carry forward the GDD's application of `game-ui-ux`, `save-systems`, `roblox-datastores`, and `roblox-networking`.

At implementation time, read the focused local skills for the assigned milestone. For direct Studio work, include `roblox-studio-workflow`; add physics, UI, networking, or data-store guidance only as relevant. Inspect the current project before changing it. No skill instruction replaces the owner's confirmed gameplay choices.

**Next actionable task:** M1-01 — inspect the intended Studio test project and prepare the minimal carry-slice technical design. The technical design and implementation remain future work; this deliverable is the milestone roadmap.
