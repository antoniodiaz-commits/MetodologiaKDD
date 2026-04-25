---
description: "Consolidation assistant: analyze completed work and propose knowledge updates"
---

Consolidation assistant: analyze completed work and propose knowledge updates.

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

Given: $ARGUMENTS — a WRK-SPEC ID (e.g., `WRK-SPEC-001`)

### Step 1: Read the work artifact tree

1. Read the WRK-SPEC file
2. Find child WRK-PLAN(s) by searching for specs with `parent: <WRK-SPEC-ID>`
3. Find child WRK-TASKs for each WRK-PLAN

```bash
node <cli-path> --specs <specs-dir> context <WRK-SPEC-ID> --depth 3 --format json
node <cli-path> --specs <specs-dir> filter --format json
```

Read all found work artifacts to understand what was built, what decisions were made, and what was learned.

### Step 2: Read activated knowledge specs

From the WRK-SPEC's `activates` field, read each activated Knowledge Artifact. Note:
- Current version and confidence level
- Key rules and acceptance criteria
- Last update date

### Step 3: Run the consolidation checklist

**1. ADR Review — Architecture Decisions**
- Scan WRK-PLAN and WRK-TASK bodies for decision language: "chose", "decided", "opted for", "rejected", "trade-off"
- Check if ADRs already exist for each decision
- Propose new ADRs for undocumented decisions

**2. Spec Delta — Knowledge Corrections**
- Compare activated specs vs what work artifacts describe
- Look for: clarified rules, discovered edge cases, corrected assumptions
- Propose spec updates with version bumps

**3. New Knowledge Discovery**
- Domain knowledge in work artifacts without a corresponding spec
- Patterns introduced, rules discovered, constraints found
- Propose new specs at LOW confidence

**4. Rule Extraction**
- Business rules in WRK-TASK implementation notes that aren't formalized
- Propose DOM specs for hardcoded rules

**5. Pattern Capture**
- Reusable technical patterns in WRK-PLAN architecture approach
- Propose ARCH specs for novel patterns

**6. Confidence Upgrade**
- Did implementation validate activated specs?
- Propose upgrades with evidence: "Implemented and tested in WRK-TASK-NNN"

### Step 4: Produce consolidation report

```
## Consolidation Report: [WRK-SPEC-ID] — [Title]

### Work Summary
- WRK-SPEC: [ID] — [title] ([status])
- WRK-PLAN(s): [list]
- WRK-TASK(s): [list with status]
- Knowledge activated: [list of spec IDs]

### 1. ADRs to Create
| Decision | Context | Proposed ADR ID |
|----------|---------|----------------|

### 2. Specs to Update
| Spec | Current Version | Change | New Version |
|------|----------------|--------|-------------|

### 3. New Specs to Create
| Proposed ID | Type | Title | Confidence | Rationale |
|-------------|------|-------|------------|-----------|

### 4. Confidence Upgrades
| Spec | Current | Proposed | Evidence |
|------|---------|----------|----------|

### 5. Open Items
| Item | Source | Recommendation |
|------|--------|---------------|

### Recommended Actions (Priority Order)
1. [Highest impact first]
...

### Post-Consolidation
- Run `/kdd:spec-validate` to verify graph integrity
- Archive work artifacts (status → archived)
- Update WRK-SPEC status to completed
```

## Notes

- Consolidation is the mechanism that makes the Evolutive pillar concrete
- New knowledge starts at `confidence: low` or `medium`
- Focus on what helps the *next* team, not just documenting what was done
