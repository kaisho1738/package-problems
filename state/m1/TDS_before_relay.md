# Package Problems — M1 Technical Design v0.1

**Implemented:** 2026-10-30. **Target:** Place1, unpublished (`PlaceId=0`), Studio/MCP.
**Scope:** The approved M1 carry slice. GDD v0.4 remains the product baseline; no HP, deadlines, strikes, economy, persistence, rain, or monetization is implemented here.

## Ownership and recovery

Studio owns the live objects/scripts. `state/m1/` contains the implemented source snapshots, one-time authoring script, and executable test fixtures for recovery and review. There is no Rojo sync; update snapshots deliberately after subsequent Studio edits.

Before changes, original Baseplate and SpawnLocation were cloned into `ServerStorage.M1BaselineCheckpoint`. Originals, world gravity (196.2), streaming setting, and default player movement settings were preserved. ChangeHistory waypoints mark the pre-M1 and authored-M1 states. Baseline manifest and rollback steps are in [the evidence log](Evidence.md).

**Local place save:** The native Save As attempt could not complete because computer-use app approval timed out. No `.rbxl` file or cloud publication is claimed. Save the open place through Studio's Save to File action before closing it. The repository snapshots can rebuild M1 from a fresh baseplate if necessary.

## Authored objects and scripts

| Studio location | Contents / responsibility |
|---|---|
| Workspace.PackageProblemsM1 | Persistent-streaming model containing greybox Geometry, Markers, Gate, Switch, and one runtime LivePackage. |
| ServerStorage.PackageProblemsM1.StandardPackage | 3×3×3 parcel template with one CarryAttachment, density 0.7, friction 0.5, elasticity 0. |
| ReplicatedStorage.PackageProblemsM1 | Config ModuleScript; Request, Response, State RemoteEvents under Remotes. |
| ServerScriptService.PackageProblemsM1 | Server ModuleScript and Bootstrap Script. |
| StarterPlayer.StarterPlayerScripts.PackageProblemsM1Client | LocalScript: input, context selection, snapshot rendering, and feedback. |
| StarterGui.PackageProblemsM1 | Editable persistent ScreenGui: Header, Actions, Feedback, Handoff, Result, Inspect. |

The direct route runs from pickup `(20, -10)` through the gate at `z=-60`, past the merge checkpoint at `z=-92`, to destination `(20,-130)`. The free blue bypass goes through `x=66` around the barrier. These pairs are X/Z coordinates. Switch requires a free hand and latches the gate open for the cycle. Signs are noncolliding. Gate resets on the next cycle.

## Server state and protocol

Cycle phases: Active → Result → next Active; Preparing is the initialization state. Package: Available → Carried ↔ Dropped, with Recovering and Delivered. One server Heartbeat owns follow updates, handoff expiry, bounds checks, and result restart. No per-cycle heartbeat/listener accumulation.

Request payload: `{action, cycleId, requestId, token?}`. Actions: Sync, Pickup, Drop, RequestHandoff, AcceptHandoff, Switch, Recover, Deliver. Targets are derived from the sole package/switch/destination; no arbitrary client CFrames or instance paths are accepted.

Response: `{requestId, ok, message}` to requester. Snapshot: `{cycleId, version, phase, packageState, carrier, gateOpen, checkpoint, completed, pending?}`. Pending handoff contains recipient user ID, server expiry, and request token. Client renders only newer/equal snapshots and requests a sync after load/respawn.

Connected Players are the prototype team. Mutations revalidate current cycle, phase, living character, ownership, proximity, line of sight, and consent. Deduplication retains the last 64 request IDs per player; a token bucket allows a 12-request burst and replenishes 8/second. Player-specific caches and connections are removed on departure. Commands mutate without yielding; delivery switches phase before later callbacks can resolve it again.

Server-only API: Server module exposes Start, Handle, Inspect. In Studio only, `ServerStorage.M1StudioTests` is a BindableFunction that calls the live module's Request/Inspect boundary. This avoids test execution requiring a separate module instance. It is not a client remote, is created only at runtime in Studio, and is absent outside Studio. Temporary multiplayer harness Scripts were removed after testing.

## Physics and lifecycle

The package is an independent server-owned assembly. One-attachment AlignPosition/AlignOrientation goals follow the carrier's root; the package is not welded or force-connected to the character. Carry constraints are destroyed on release. Movement changes to 13.6 while carrying and restores the previous humanoid speed afterward.

Initial tuning: four-stud forward offset, position responsiveness 22, maximum velocity 24, maximum force mass × gravity × 6; angular responsiveness 15, velocity cap 8, torque mass × 3000. A boxcast shortens obstructed carry targets. Follow error over 10 studs for 1.5 seconds recovers rather than adding unbounded force.

Collision groups disable player/player and player/package pushing; package/world remains collidable. Grounded placement tries front offsets 4, 5, then 3 studs, requires a surface normal above 0.8 Y and clear parcel volume, and releases with zero velocity. Failed placement retains the carrier. Template objects and HUD are authored in edit mode; only live parcels, carry constraints, and Studio diagnostics are dynamic.

Handoff: request within 8 studs, explicit carrier acceptance within 5 seconds, revalidation, then one ownership transition. Request/drop/departure/expiry clears pending consent as appropriate. Carrier death or character replacement recovers the parcel; a respawn at checkpoint 2 returns to that reached checkpoint. The default Roblox respawn system remains responsible for character creation.

Checkpoint 2 requires the carried package and its carrier near the authored merge marker, with at least two seconds since pickup. Bounds and stuck-state recovery return to the last reached marker and clear velocity. Manual recovery has a 10-second cooldown and rejects reachable parcels or valid teammate possession. Prototype unreachable detection uses obstruction/overlap/bounds checks rather than general navigation solving.

Delivery requires explicit intent, player/package proximity, reached merge checkpoint, and a carried placement or resting parcel fully inside the pad. Success anchors the package, restores carry speed, shows the result for five seconds, then cleans the parcel, resets gate/checkpoints, relocates players to the depot, and starts a fresh cycle.

## UI and verification limits

E/context button interacts; Q/Place places; I/Info toggles package help; Recover has a dedicated button. Context priority is delivery, carrier consent, nearby handoff request, gate switch, then available parcel. Processed keyboard input cannot trigger a world action. GUI Activated handles on-screen buttons. Context proximity refreshes at 10 Hz; snapshots drive the underlying state.

Desktop and iPhone 14 landscape emulation were inspected. Source/test evidence is in [Evidence.md](Evidence.md). Ten-cycle tests and two-real-client tests passed; the delay runs exercised the server request boundary under configured network delays, not end-to-end client input latency or subjective smoothness. Physical-device performance, scaled-avatar compatibility beyond the observed R15 rig, comprehensive movement anti-cheat, and fresh-player enjoyment remain unverified. This is a practice prototype, not a production security or performance certification.

## Rebuild procedure

On a fresh baseplate, first capture a baseline. Execute `state/m1/BuildEdit.luau` once in Edit mode; it refuses to overwrite an existing M1 world. Install source snapshots at the locations above: Config.luau → Config, Server.luau → Server, Bootstrap.server.luau → Bootstrap, Client.client.luau → PackageProblemsM1Client. Keep test fixtures outside the normal runtime hierarchy. Start Test to run the prototype. This procedure reconstructs authored assets and UI; it is not an automatic source synchronization system.
