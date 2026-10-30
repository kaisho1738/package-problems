# Package Problems

Current design: [GDD v0.4 — Development refinement](Package_Problems_GDD_v0.4_Development_Refinement.md).

Review summary: [Changes, remaining decisions, and suggested improvements](Package_Problems_GDD_v0.4_Review.md).

[GDD v0.3](Package_Problems_GDD_v0.3_Three_Strikes.md) is preserved as the historical source. Use v0.4 for the current design review; its new proposals are not owner-confirmed production requirements.

This repository currently contains design documents and local game-development skills, not an implemented game. The TDS and implementation roadmap described in the GDD are future deliverables.

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
