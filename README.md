# Package Problems

**New session: read [the milestone handoff index](state/README.md), then [the active M1 summary](state/m1/Summary.md).** Update the active summary after each work session and on milestone completion.

Current design: [GDD v0.4 — Development refinement](Package_Problems_GDD_v0.4_Development_Refinement.md).

Review summary: [Changes, remaining decisions, and suggested improvements](Package_Problems_GDD_v0.4_Review.md).

Development plan: [Milestone roadmap v0.1](Package_Problems_Roadmap_v0.1.md), revised for cooperative relays and the connected world: M1 relay tasks, M2 run/station flow, gated M3A–D world/failure/environment work, and M4–M8 integration/release/future scope.

M1 prototype: [Technical design](Package_Problems_M1_TDS_v0.1.md) and [verification evidence / remaining playtests](state/m1/Evidence.md). The implementation is open in Studio; source snapshots and rebuild/test scripts are in `state/m1/`.

[GDD v0.3](Package_Problems_GDD_v0.3_Three_Strikes.md) is preserved as the historical source. Use v0.4 for the current design review; its unselected proposals are not owner-confirmed production requirements. Cooperative relays, carrying stamina, throwing, and assisted catching are now confirmed in DEC-014–018; endurance values remain provisional.

This repository contains design documents, the roadmap, local game-development skills, and M1 implementation snapshots. M1 is in Verify: stamina/throw/catch and the extended relay route are implemented with solo, real multi-client, route, and client latency evidence. See [relay evidence](state/m1/RelayEvidence.md) for remaining human/input/edge-case checks and final checkpoint status. The pre-change native backup is `M1-before-relay.rbxl`. Read the evidence log before treating a milestone as complete.

## Agent Workspace

This repository also serves as the local configuration, context, and skill storage for AI agent development of the Roblox game **Package Problems**.

## Architecture Overview

This project uses a hybrid local/cloud architecture:

- **Local Workspace (this repository):** Stores GDDs, project context, agent setups, and custom `.skills` or `.agents` directories.
- **Cloud Storage (Roblox Studio):** Live game assets, maps, 3D models, and Luau scripts are stored on Roblox's cloud servers.

Because the agent interacts through the **Roblox Server MCP (Model Context Protocol)** inside Roblox Studio, Rojo is not required to map or sync local code files.

## Tools

- **Roblox Studio** with the built-in Roblox Server MCP enabled
- **Codex** (MCP-compatible agent)
- **Node.js** for managing agent skills via `npx`
