---
description: Execute the spec-graph CLI — query, filter, and analyze the knowledge graph
---

Execute the spec-graph CLI and present results.

## Specs Directory

Determine the specs directory:
1. If $ARGUMENTS includes `--specs <dir>`, extract that directory and remove it from the arguments
2. Otherwise, look for a `specs/` directory in the project root
3. If neither exists, ask the user where their specs are located

## CLI

Find the spec-graph CLI by searching for `spec-graph.mjs`:
- Check `node_modules/.bin/spec-graph` (npm installed)
- Search for files matching `**/cli/spec-graph.mjs` or `**/spec-graph/spec-graph.mjs`
- If found, use: `node <path> --specs <specs-dir> <command> [options]`

## Available Commands

- **impact <spec-id>** — Show specs transitively affected by a change
- **orphans** — List specs with no connections
- **validate** — Check graph integrity
- **stats** — Show metrics overview
- **filter** — Filter specs (options: --layer, --domain, --confidence, --status, --tag, --format json)
- **path <from> <to>** — Find shortest path between two specs
- **context <spec-id>** — Get contextual activation bundle (add --depth N for deeper traversal)
- **build** — Rebuild graph.json (add --html for interactive viewer)
- **visualize** — Generate Mermaid diagram

## Execution

1. Parse the user's arguments: $ARGUMENTS
2. Run: `node <cli-path> --specs <specs-dir> <command> [options]`
3. Present the output in a clear, structured format
4. If the command is `context` or `impact`, briefly interpret the results — explain what the connections mean and any implications

## Notes

- For `filter`, combine multiple criteria as needed (they use AND logic)
- For `context`, suggest `--depth 2` if the user wants a broader view
