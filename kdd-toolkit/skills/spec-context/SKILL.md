---
description: "Contextual activation: find and synthesize relevant specs for a task"
---

Contextual activation: find and synthesize relevant specs for a task.

## Specs Directory

Determine the specs directory:
1. If $ARGUMENTS includes `--specs <dir>`, extract that directory
2. Otherwise, look for a `specs/` directory in the project root
3. If neither exists, ask the user

## CLI

Find the spec-graph CLI by searching for `spec-graph.mjs`:
- Check `node_modules/.bin/spec-graph` (npm installed)
- Search for files matching `**/cli/spec-graph.mjs` or `**/spec-graph/spec-graph.mjs`

## Process

Given the task description: $ARGUMENTS

### Step 1: Discover relevant specs

Run multiple queries to find relevant specs:

```bash
# Search by keywords in filter
node <cli-path> --specs <specs-dir> filter --format json

# If you identify a likely root spec, get its context
node <cli-path> --specs <specs-dir> context <spec-id> --depth 2 --format json
```

Think about which domains, layers, and tags are relevant to the task description.

### Step 2: Read spec files

For each relevant spec found, read the actual .md file to get the full content (not just frontmatter metadata).

### Step 3: Synthesize

Present a structured brief:

```
## Contextual Brief: [task summary]

### Architecture Layer
- [spec summaries relevant to the task]

### Domain Layer
- [domain knowledge, rules, constraints]

### Feature Layer
- [existing features that relate]

### Gaps Identified
- [knowledge not covered by existing specs]

### Recommended Actions
- [what specs to create/update before implementing]
```

## Notes

- This implements the "contextual activation" pattern from the Agentic pillar
- The goal is: before working on a task, activate all formalized knowledge relevant to it
- If no specs seem relevant, say so — that itself is valuable information (knowledge gap)
- For full activation with prompt generation, use `/kdd:spec-activate` instead
