# Package Problems — Agent Workspace

This repository serves as the local configuration, context, and skill storage for the AI agent development of the Roblox game **"Package Problems"**. 

## Architecture Overview

This project uses a hybrid local/cloud architecture optimized for AI agent collaboration:
* **Local Workspace (This Repo):** Stores Game Design Documents (GDD), project context, agent setups, and custom `.skills` or `.agents` directories.
* **Cloud Storage (Roblox Studio):** All live game assets, maps, 3D models, and Luau scripts are stored directly on Roblox's cloud servers. 

Because the agent interacts directly via the **Roblox Server MCP (Model Context Protocol)** inside Roblox Studio, **Rojo is not required** to map or sync local code files.

---

### Tools
* **Roblox Studio** (with the built-in Roblox Server MCP enabled)
* **Codex** (MCP Compatible agent)
* **Node.js** (for managing agent skills via `npx`)

