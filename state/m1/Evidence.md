# M1 implementation and verification evidence

**Date:** 2026-10-30 (Asia/Manila). **Status:** Implementation ready for human playtest; M1 acceptance gate remains open.

## Baseline checkpoint

- Place1: PlaceId 0, PlaceVersion 0; original Workspace contained Camera, Terrain, Baseplate, SpawnLocation. No game scripts existed.
- Original Baseplate: size `(2048,16,2048)`, position `(0,-8,0)`, anchored. Original spawn: size `(12,1,12)`, position `(0,0.5,0)`, anchored.
- Default walk speed 16; gravity approximately 196.2; streaming enabled. The observed playtest character was R15.
- Before edits, original Baseplate and SpawnLocation were cloned into ServerStorage.M1BaselineCheckpoint. Originals were retained untouched. Baseline folder records original gravity, streaming, PlaceId, and date.
- Recovery checkpoint is inside the open place; source snapshots and the edit-mode rebuild script are saved in this repository. Native local Save As was attempted but computer-use approval timed out. No saved `.rbxl` or published place is claimed.

Rollback to the original baseplate: stop play, then remove only the namespaced M1 world, scripts, shared folder, template folder, client script, and GUI listed in the TDS. Originals remain present. The baseline copies can restore Baseplate/SpawnLocation if later changed. Never remove originals or unrelated user work. Keep the checkpoint until a native place file is saved.

## Executed tests

| Test | Evidence / observed result |
|---|---|
| Startup and client | Server bootstrap ran; HUD showed Practice delivery 1 and no carrier; observed R15 character. Live package reported server network ownership. |
| Ordinary direct-route delivery | Actual E/Q input picked up, dropped to free hands, opened the gate, retrieved, and delivered. Humanoid MoveTo exercised walking segments through the open gate and merge. Result transitioned to next cycle. |
| Solo request tests | TestSolo.luau passed 16 assertions: out-of-range pickup, valid/duplicate pickup, speed, ownership, stale request, held-parcel recovery denial, blocked placement retaining possession, wrong-position delivery, safe drop/speed restoration, bounds recovery/no checkpoint advance, pickup after recovery, death releasing carrier, and one live parcel. |
| Ten completed cycles | One ordinary direct-route success plus nine server-fixture cycles. Completions 2–10 passed reset, duplicate delivery, stale request, and next-cycle assertions. Fixtures relocate both character and package; they do not prove route navigation or anti-teleport security. |
| Stable resources | Across the nine fixture cycles: 4 shared server listeners; fresh parcel had exactly 1 child (CarryAttachment), with no leftover carry constraints. One live package remained. This is a resource-count check, not a full memory profiler soak test. |
| Two actual Studio clients | StudioTestService.ExecuteMultiplayerTestAsync(2, 'PackageProblemsM1') passed 17 assertions. Exactly one concurrent pickup winner; unauthorized acceptance denied; consent transfers once; original speed restored; ownership remains server; replay/expired/distant handoffs denied; actual kicked-client departure clears carrier; survivor can pick up. |
| Simulated delay, 100 ms each direction | Same 17 two-client assertions passed with NetworkSettings inbound/outbound minimum delay each set to 100 ms, then restored. Requests are injected at the server Handle boundary; this does not measure client-button round-trip time. |
| Simulated delay, 200 ms each direction | Same 17 assertions passed at 200 ms inbound/outbound; original delay settings restored afterward (0/0). Subjective carry smoothness at those delays still needs human assessment. |
| Phone landscape layout | StudioDeviceSimulatorService selected iPhone 14, LandscapeRight. Client reported touch enabled and viewport 749×388. Visible action buttons were approximately 210×45, separated from movement/jump controls in the captured layout. |
| On-screen button activation | In phone simulation, clicks on Context and Drop produced authoritative Carried/Dropped transitions; Info toggled the help panel. This uses virtual mouse activation in a touch-enabled viewport, not a physical finger/device test. |
| Free alternate route | In phone simulation, walked the real carried assembly around `(20,-35) → (66,-35) → (66,-84) → (20,-92) → (20,-126)` using Humanoid MoveTo. All nodes reached within 1.5 studs. Gate remained closed; on-screen context delivery succeeded. Peak sampled target-follow error was approximately 4.18 studs, including turns. |
| Closed-gate collision | Six-second approach toward the closed gate: parcel center never went past approximately z=-57.55 (gate front z=-59); peak sampled package speed 14.49 studs/s. No fling or gate penetration observed in that case. |
| Final hierarchy | Only four implemented game scripts remain: shared Config, server Server/Bootstrap, client controller. Temporary multiplayer harness removed. Device simulation stopped; network delay settings restored. Studio returned to Edit mode. |

## Findings and corrections

- Signs initially interfered with the automation navigation helper. Signs were made noncolliding. The helper still reported Path Blocked, so route tests used actual Humanoid movement rather than treating helper failure as a game pass/fail. Both direct and alternate routes were traversed that way.
- The initial prototype texture generated an asset warning; it was removed from the package template. The console tool continued returning historical warning text; final live texture inspection showed only original baseplate/spawn textures and their checkpoint copies. No new game-script exception was observed during the successful scenarios.
- First cycle fixture teleported the character alone and triggered the deliberate follow-distance recovery. Corrected the fixture to relocate the parcel with the character; fixture results are explicitly scoped to cycle/state testing.
- First disconnect test checked before the kicked client actually left. Corrected it to wait for departure, then re-ran baseline, 100 ms, and 200 ms tests successfully.
- No HP/deadline/reward mechanics were added to fill prototype gaps. They remain assigned to later milestones.

## Prepared or unverified

- Fresh uncoached tester: action discovery within approximately 30 seconds, complete loop, voluntary repeat play, and qualitative enjoyment. **Not run; M1-09 remains open.**
- Physical mobile device, finger input, device performance, tablet layouts, and broader avatar body scales: **not verified**.
- End-to-end client input and subjective carry feel under 100/200 ms delay, especially fast turns/corners: **not verified**. Automated ownership invariants passing do not close this gate.
- A full multi-client route completion via each client's touch controls, exhaustive corner/wedge cases, and a production movement-validation system: **not verified**.
- Native saved `.rbxl`: **not completed** because computer-use approval timed out. Save the open place locally before closing; code and authoring snapshots are available here.

## Human playtest recipe

Start Test. Follow the signs without a verbal explanation. Pick up with E or the context button; Q or Place sets the package down. Try opening the gate while carrying, then solve it with free hands or take the blue bypass. Carry to the yellow pad and explicitly deliver. Let the result return you to the depot. With two clients, approach the carrier, request a handoff, and accept on the carrier's screen. Record where prompts or movement are confusing and whether another delivery is appealing. Assess latency feel with the documented delay settings, then restore them.

## Verification references

API choices were checked against official [mover constraints](https://create.roblox.com/docs/physics/mover-constraints), [network ownership](https://create.roblox.com/docs/physics/network-ownership), [StudioTestService](https://create.roblox.com/docs/reference/engine/classes/StudioTestService), [device simulation](https://create.roblox.com/docs/reference/engine/classes/StudioDeviceSimulatorService), and [network delay settings](https://create.roblox.com/docs/reference/engine/classes/NetworkSettings). These references support the APIs, not claims of fun or physical-device performance.
