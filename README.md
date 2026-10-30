# Package Problems

Current design: [GDD v0.4 — Development refinement](Package_Problems_GDD_v0.4_Development_Refinement.md).

Review summary: [Changes, remaining decisions, and suggested improvements](Package_Problems_GDD_v0.4_Review.md).

Development plan: [Milestone roadmap v0.1](Package_Problems_Roadmap_v0.1.md), including acceptance gates, an M1 task backlog, and iteration templates.

[GDD v0.3](Package_Problems_GDD_v0.3_Three_Strikes.md) is preserved as the historical source. Use v0.4 for the current design review; its new proposals are not owner-confirmed production requirements.

This repository contains design documents, the milestone roadmap, and local game-development skills. The technical design and implementation are the next planned deliverables; roadmap status does not certify the current contents of a live Studio place.

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
