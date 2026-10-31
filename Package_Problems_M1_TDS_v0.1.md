# Package Problems — M1 Technical Design v0.1

**Updated:** 2026-10-31. **Target:** Studio place `139622891678280`, inspected at version 2 before extension. **Status:** Implemented; acceptance Verify.

The owner-approved relay plan selects OPEN-024–026/028 for this prototype; OPEN-027 has a fixed test-count interface, with real launch-roster integration deferred to M2/M6. Numerical values remain provisional. See [relay evidence](state/m1/RelayEvidence.md), [original evidence](state/m1/Evidence.md), and [historical TDS](state/m1/TDS_before_relay.md).

## Ownership, checkpoint, and rebuild

Studio owns the live game. Local sources are deliberate snapshots, without automatic synchronization. The user saved `M1-before-relay.rbxl` at the repository root (116,457 bytes, verified); it is the pre-extension build. `ServerStorage.M1BeforeRelay` stores additional in-place clones; original `M1BaselineCheckpoint` remains. Final relay native checkpoint status is recorded in RelayEvidence and Summary.

Fresh rebuild: run `state/m1/BuildEdit.luau` only on a fresh baseplate; then run `ExtendEdit.luau` in Edit mode. Install Config, Server, Bootstrap, Stamina, Transfer, and Client snapshots at the locations below. Do not run the original builder over an existing place. ExtendEdit is an edit-time authoring script, not a runtime generator. Test fixtures stay outside normal runtime hierarchy.

## Structure and interfaces

| Location | Responsibility |
|---|---|
| Workspace.PackageProblemsM1 | Persistent greybox world, original gate/bypass, RelayCourse, ordered Markers, one runtime parcel |
| ServerStorage.PackageProblemsM1.StandardPackage | Independent 3×3×3 physical parcel template |
| ReplicatedStorage.PackageProblemsM1 | Shared Config and existing Request/Response/State RemoteEvents |
| ServerScriptService.PackageProblemsM1 | Server coordinator, Bootstrap, Stamina per-player model, Transfer geometry/arbitration |
| StarterPlayer.StarterPlayerScripts.PackageProblemsM1Client | Context selection, keyboard/touch intent, highlights, interpolated stamina/charge feedback |
| StarterGui.PackageProblemsM1 | Authored HUD; Context/Place/Throw/Run/Recover/Info controls, stamina and charge labels |

Request envelope remains `{action, cycleId, requestId, token?}`. Added actions: `SetRunning {running}`, `BeginThrow`, `ReleaseThrow {aim}`, `CancelThrow`, `Catch {aim, flightId}`. Client sends intent only; server derives origins, strength, stamina, range, eligibility, and ownership. Snapshots add fixed `enduranceCount`, current `flightId`, and `players[userIdString] = {stamina, running, chargeAt?, catchUntil?}`. Response remains `{requestId, ok, message}`. Existing version ordering, 64-ID deduplication, 12-burst/8-per-second limiting, living/proximity/consent checks remain.

Cycle phases are Active → Result → Active. Parcel states include Available, Carried, Thrown, Dropped, Recovering, Delivered. Mutations do not yield. One Heartbeat updates vitals, carry targets, flight arbitration, checkpoints and resets; snapshots are bounded to 10 Hz plus immediate transitions. Server module retains Start/Handle/Inspect. Runtime Studio-only `ServerStorage.M1StudioTests` supports Inspect, Request, and explicit NewPracticeRun(count); it is absent outside Studio.

## Stamina, movement, and release

Capacity 100; walking endurance 45/25/20/18 seconds for fixed 1/2/3/4 players; carrying speed 13.6; run speed ×1.25; moving run drain ×1.5. Stationary carrying drains normally. Unburdened regeneration is 10/second without delay; no general movement exhaustion. Running movement is detected from root horizontal velocity or Humanoid intent. Pickup, handoff reception, and catch require at least 10 stamina. Warning starts at 25.

Stamina belongs to player identity, persists across character replacement/recovery/result resets, and regenerates while not carrying. Only an explicit NewPracticeRun starts everyone full. PracticePlayerCount is a Studio-only server-folder Attribute, frozen on startup (default 1); the Studio test bridge can explicitly start another run with count 1–4. Departures never recalculate it. Production run launch is not implemented here.

Centralized speed application uses the original speed of each character; release restores unburdened walking/running speed. Death/respawn cancels running, catch intent and charge. Transfers never refill either player's stamina.

At zero, attempt safe placement; if none, release in the current clear parcel position with velocity zeroed. Embedded/out-of-bounds release recovers to the last checkpoint. Normal blocked Q placement retains possession while stamina remains, cancels charge, and reports the problem. No exhaustion strike/damage exists. A pending request cannot auto-transfer; only validated acceptance before exhaustion succeeds.

## Physics, throw, and catch

Keep the original independent server-owned AlignPosition/AlignOrientation carry assembly, boxcast-obstructed goals, force limits, collision groups, and follow-error recovery. Package/world collision remains enabled; players cannot push each other or the parcel.

Hold F or touch Throw to charge; release launches. Server charge caps at one second, with no automatic launch. Speed interpolates 55–95 studs/second. Finite camera direction determines horizontal aim, elevation clamped to 15–60°. Launch is ballistic, without homing. Ownership/phase changes, death, recovery, Q, and focus loss cancel charging. The originating touch is tracked so another finger ending cannot release a throw.

Look at a highlighted flight parcel and press E / Catch. Initial target range 16, aiming cone 15°, catch window 0.5 seconds, interception radius 6 around upper body. Server verifies flight ID, minimum stamina, character, aiming intent and sight. Swept parcel-box obstruction and segment/sphere interception resolve each update. Earliest interception wins; equal interception uses distance then user ID. World impact wins exact ties and ends this flight's catch eligibility. Catch clears velocity and assigns one carrier. Pickup/delivery are denied during flight; throwing onto the pad never auto-delivers. Flight outcome counters prepare later M3 damage work; no damage is applied.

## Route, recovery, and UI

Depot/gate/bypass retained. The main course runs from pickup z=-10 to destination z=-730, with merge checkpoint z=-92 then checkpoints at -242/-392/-542/-692. A 24-stud-wide corridor and rest areas support solo placement/rest. A low barrier at z=-370 offers throwing or a free eastern walk-around; the east rail opens between -355 and -395. Recovery bounds cover the extension.

Checkpoints advance sequentially only when the parcel is not Thrown and both parcel and a living participant reach the next marker. Throw passage alone does not advance progress. Delivery requires checkpoint 6 plus explicit valid interaction and pad placement. Results last five seconds, reset the gate/parcel/checkpoints, return players to depot, and preserve stamina. Existing out-of-bounds, disconnect and respawn recovery foundations remain; deeper recovery-fault cancellation is future hardening.

E/context interacts or catches, Q places, hold F throws, hold Shift runs, I opens help. Touch has Throw hold/release and Run toggle. Catch targeting has E priority; handoff remains recipient-request/carrier-consent. Editable two-column actions respect screen insets. Studio-only GUI response Attributes measure matching request acknowledgement time; timing storage is bounded to 64 IDs.

## Verification boundary

See RelayEvidence for exact runs and limits: 142 initial solo assertions; real 2/3/4-client relay tests; actual desktop E/Q/F inputs at 0/100/200 ms delay per direction; extended solo route traversal. Passing scripted timers does not establish enjoyment. Fresh-player usability, human latency feel, physical-device performance, and reliable touch/catch input verification remain M1 exit work. M1 omits HP, deadlines, strikes, economy, persistence, stations, weather, teleports and final art.
