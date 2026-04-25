---
description: Analyze the impact of changing a spec — affected artifacts, risk classification, review sequence
---

Analyze the impact of changing a spec, with business context and recommended review sequence.

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

Given: $ARGUMENTS (spec ID, e.g. `DOM-RISK-001`)

### Step 1: Gather graph data

Run both commands:

```bash
node <cli-path> --specs <specs-dir> impact <spec-id>
node <cli-path> --specs <specs-dir> context <spec-id> --depth 2 --format json
```

### Step 2: Read the source spec

Read the spec file to understand its content, domain, and purpose. Note its:
- Layer, domain, confidence
- Key rules or decisions it defines
- Acceptance criteria

### Step 3: Classify affected specs

For each spec in the impact output, read enough to classify:

| Classification | Criteria |
|---------------|----------|
| **Direct — HIGH** | Has `implements` or `activates` relation to the changed spec |
| **Direct — MEDIUM** | Has `depends-on` or `constrained-by` relation |
| **Transitive — LOW** | Reached via depth > 1, indirect relationship |

For work artifacts (WRK-*) in the impact set:
- Flag active ones as "in-flight risk" — they may be implementing stale knowledge
- Note completed ones as "potential rework"

### Step 4: Produce impact report

```
## Impact Analysis: [SPEC-ID] — [Title]

### Change Summary
[What this spec defines and why changing it matters]

### Direct Impact (HIGH)
| Spec | Title | Relation | Risk |
|------|-------|----------|------|
[Specs with direct dependency — review first]

### Indirect Impact (MEDIUM)
| Spec | Title | Path | Risk |
|------|-------|------|------|
[Specs with transitive dependency]

### Work Artifacts at Risk
| Artifact | Status | Impact |
|----------|--------|--------|
[Active WRK-* that activate or depend on this spec]

### Recommended Review Sequence
1. [First spec to update — closest dependency]
2. [Second — cascading impact]
...

### Notes
[Any governance actions needed: ADRs, RFCs, version bumps]
```

## Notes

- If no specs are impacted, say so — it means the spec is either a leaf or orphaned
- For specs with many dependents (>5), group by layer or domain for readability
- Always mention if changing this spec should trigger a version bump in dependents
