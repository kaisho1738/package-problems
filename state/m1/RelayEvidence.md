# Relay extension evidence — 2026-10-31

Status: implemented in Studio; M1 remains **Verify**, not accepted complete.

## Baseline and implementation

- Inspected place `139622891678280`, version 2, before editing. The original four live scripts matched the earlier carry implementation; no stamina/throw/catch existed.
- User saved the native baseline. Verified repository-root `M1-before-relay.rbxl`, 116,457 bytes. `ServerStorage.M1BeforeRelay` additionally contains in-place pre-extension clones; the earlier `M1BaselineCheckpoint` remains.
- Installed Stamina and Transfer ModuleScripts alongside Server/Bootstrap; updated Config and the existing client. Existing Request/Response/State remotes retained.
- Authored `Workspace.PackageProblemsM1.RelayCourse`, checkpoints 3–6, destination at z=-730, rest areas, a low throw barrier with a walk-around route, and authored stamina/charge/Run/Throw controls. Gate/bypass/depot remain.
- All numerical tuning is provisional and centralized in Config. No live ConfigService, HP/damage/deadline/strike/economy/world-flow work was added.

## Executed automated checks

`TestRelay.luau` returned **142 passing assertions**; see [raw result](RelaySoloResult.json). This ran before the later movement-detection and death-cleanup refinements; subsequent multiplayer tests exercised death cleanup. Covered all four endurance presets/regeneration/running-drain calculations, low-stamina reception, finite aim/charge bounds, swept intersection and tie arbitration, live stationary exhaustion, speed restoration, throw/impact transition, stale flight rejection, ordered checkpoints, and ten delivery/result/reset cycles. Four shared server connections and one parcel attachment at released boundaries remained stable.

The ten-cycle portion relocates player and parcel as fixture setup. It establishes transition/cleanup behavior, not traversability or movement security. Pure geometric tie checks are not evidence of simultaneous human catch timing.

`TestRelayMultiplayer.server.luau` ran through `StudioTestService.ExecuteMultiplayerTestAsync` with **2, 3, and 4 real clients**. Each returned `ok=true` with 16 passing checks: one simultaneous pickup winner, handoff request/consent/replay rejection, charged physics throw, aimed catch request and actual airborne reception, sole carrier/server ownership/speed restoration, death release/no refill, and fixed endurance after a departure. Temporary harness removed from edit mode afterward.

## Executed client input and latency checks

The actual client controller handled E pickup and hold/release F throwing. Studio-only response measurements time from the client's request send to receipt of its matching server acknowledgement; they are bounded diagnostic Attributes on the GUI, not subjective feel ratings.

| Added delay in each direction | Action | Acknowledgement time | Result |
|---|---|---:|---|
| 0 ms | E pickup | 64.59 ms | accepted |
| 0 ms | F release throw | 66.76 ms | accepted |
| 100 ms | E pickup | 266.18 ms | accepted |
| 200 ms | E pickup | 467.66 ms | accepted |
| 200 ms | Q placement | 448.93 ms | accepted |

These are single samples, not statistical latency distributions or catch responsiveness certification. Starting network settings were all zero; original 0/0 latency and zero jitter/loss were restored.

## Executed route traversal

`TestRoute.luau` completed the extended course with actual Humanoid walking after initial pickup setup, using the closed-gate blue bypass, eastern barrier detour, all six ordered checkpoints, one eight-second rest, and explicit delivery. Elapsed 72.93 seconds; peak sampled parcel speed 24 studs/second (the configured follow cap); gate remained closed. See [raw result](RelayRouteResult.json). This establishes one solo navigation case, not human enjoyment or exhaustive collision safety.

## Device and Output observations

- iPhone 14 landscape emulation reported a 749×388 viewport. HUD and compact two-column action layout were inspected. Physical-device performance/finger operation remain unverified.
- Simulated mouse clicks did not produce client input events during this emulation session; on-screen activation is **unverified**, not passed. Desktop keyboard input and server-boundary actions are distinct evidence.
- No gameplay-script exception appeared during the successful runs. Output contains the existing `rbxassetid://203785492` asset-type warning; its source has not yet been conclusively isolated.

## Open acceptance work

- Fresh uncoached tester: discovery near 30 seconds, independent completion, confusion, voluntary repeat play; record solo rest and team relay pacing.
- Human carry/throw/catch feel under the delay profiles; actual desktop aimed-E catch and touch charge/catch activation.
- Expand runtime races beyond the current arbitration tests: contested live catches, same-step impact/catch/exhaustion/handoff combinations, embedded-space exhaustion, reset/recovery stamina conservation, and malformed/spam regressions.
- Record safe-placement normal-impact speeds and full-charge unobstructed throw range for M3; the initial floor-impact flight sample (16.14-stud displacement, 49.00-stud/s sampled speed) is not a production damage threshold.
- Save the final native relay checkpoint after verification. The root baseline file is pre-extension. Automatic menu saving could not proceed: the Windows helper reported `failed to activate captured window`, then `coordinate input geometry is unavailable` after refreshed window selection. No final native save is claimed. Use Studio File → Download a Copy and save `M1-relay-verify.rbxl` at the repository root before closing Studio.

M1 is not Done. M2 entry remains closed until the applicable exit-gate evidence is recorded.

Additional live edge fixture passed: ordinary placement without a reachable surface rejected while retaining carry; zero stamina then released anyway; subsequent death did not refill stamina. The fixture temporarily anchored the character above the floor, then restored it. This covers unavailable placement, not every embedded-geometry fallback.

Final cleanup observed: Studio returned to Edit, device simulation stopped, all network shaping zero, no runtime LivePackage in edit mode, and exactly six active source scripts/modules (Config, Server, Bootstrap, Stamina, Transfer, Client); test harnesses absent from runtime hierarchy.

All six final active source bodies matched their local snapshots, ignoring trailing newline differences. Source equality is not a native place save.
