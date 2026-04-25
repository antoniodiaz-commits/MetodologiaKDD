---
description: Validate the knowledge graph and produce an interpreted health report
---

Validate the knowledge graph and produce an interpreted health report.

## Specs Directory

Determine the specs directory:
1. If $ARGUMENTS includes `--specs <dir>`, use that directory
2. Otherwise, look for a `specs/` directory in the project root
3. If neither exists, ask the user where their specs are located

## CLI

Find the spec-graph CLI by searching for `spec-graph.mjs`:
- Check `node_modules/.bin/spec-graph` (npm installed)
- Search for files matching `**/cli/spec-graph.mjs` or `**/spec-graph/spec-graph.mjs`

## Process

### Step 1: Run diagnostics

Execute all three commands:

```bash
node <cli-path> --specs <specs-dir> validate
node <cli-path> --specs <specs-dir> orphans
node <cli-path> --specs <specs-dir> stats
```

### Step 2: Interpret results

For each issue found, classify and explain:

**Broken references:**
- Which spec references a non-existent ID?
- Likely cause: typo, deleted spec, or spec not yet created
- Suggested fix: correct the ID or create the missing spec

**Dependency cycles:**
- List the specs in the cycle
- Explain why cycles are problematic (infinite traversal, unclear ownership)
- Suggest which edge to break and why

**Orphan specs:**
- For each orphan, check its layer and domain
- Suggest likely connections based on domain/layer proximity
- Flag whether the orphan is truly isolated or just missing a declaration

**Stale specs (draft status, low confidence):**
- Prioritize by impact: how many other specs depend on them?
- Recommend which to promote or deprecate first

**Frontmatter issues:**
- Missing required fields
- Invalid enum values (status, confidence, layer)
- Malformed dependencies

### Step 3: Produce Health Report

Present as a structured report:

```
## Knowledge Graph Health Report

### Summary
- Total specs: N
- Issues found: N (critical: N, warning: N, info: N)

### Critical Issues
[Broken refs, cycles — must fix before relying on the graph]

### Warnings
[Orphans, stale specs — should fix for graph quality]

### Recommendations
[Prioritized list of actions]

### Graph Metrics
[Stats output — layers, domains, confidence distribution]
```

## Notes

- Critical issues = broken refs, cycles, invalid frontmatter
- Warnings = orphans, stale specs, low confidence with dependents
- Info = stats, distribution metrics
- If everything passes, say so — a clean bill of health is valuable information
