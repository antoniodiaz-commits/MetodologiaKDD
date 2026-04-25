---
description: "Contextual activation pipeline: discover specs and generate an actionable prompt for AI agents"
---

Contextual activation pipeline: discover relevant specs for a task and generate an actionable prompt for AI agents.

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

Given: $ARGUMENTS — either a WRK-TASK ID (e.g. `WRK-TASK-001`) or a free-text task description. May include options:
- `--pattern bundle|layered|retrieval` (default: `bundle`)
- `--save` (save output as `.prompt.md` file)

Parse the arguments to identify the task, pattern, and save flag.

### Step 1: Explicit Activation

**If input is a WRK-TASK ID:**
1. Read the WRK-TASK file
2. Follow `parent` to find the WRK-PLAN
3. Follow `parent` again to find the WRK-SPEC
4. Collect `activates` from the WRK-SPEC (and WRK-PLAN if present)

**If input is a free-text description:**
1. Parse keywords related to domain, layer, tags
2. Run discovery:
   ```bash
   node <cli-path> --specs <specs-dir> filter --format json
   ```
3. Identify candidate specs by matching domain, tags, and layer relevance

### Step 2: Transitive Expansion

For each explicitly activated spec:

```bash
node <cli-path> --specs <specs-dir> context <spec-id> --depth 2 --format json
```

Collect all transitive neighbors. Track graph distance from each explicit spec.

### Step 3: Filtered Activation

Remove specs that:
- Have `status: deprecated` or are superseded (unless explicitly activated)
- Are at a layer too abstract for the task scope
- Are at a layer too detailed for the task scope
- Would not change the implementation if removed

Present the filtered list to the user for confirmation before generating the prompt.

### Step 4: Budgeted Activation

Apply budget limits based on work level:

| Work level | Budget |
|-----------|--------|
| WRK-TASK | 2–5 specs |
| WRK-PLAN | 3–7 specs |
| WRK-SPEC | 5–10 specs |
| Free-text | 3–7 specs |

If filtered set exceeds budget, prioritize by:
1. Graph distance (closer = keep)
2. Confidence level (higher = keep)
3. Layer alignment (matching layer = keep)
4. Relation strength (`constrained-by` > `extends` > `uses-data-from`)

### Step 5: Read Activated Specs

Read each activated spec. Extract:
- Frontmatter (ID, type, status, confidence)
- Intent section
- Definition section
- Acceptance Criteria section
- Skip Evidence and Traceability (not useful for generation)

### Step 6: Generate Prompt

**Pattern: `bundle` (default)**

```markdown
# Activated Knowledge

## [SPEC-ID]: [Title]
[Full spec body — Intent, Definition, Acceptance Criteria]

## [SPEC-ID]: [Title]
[Full spec body]

---

# Your Task

## [TASK-ID]: [Title]
[Full task body]

Implement this task respecting all activated knowledge above.
All acceptance criteria — from both the task and activated specs — must be met.
```

**Pattern: `layered`**

```markdown
# Domain Rules (MUST follow)
[DOM specs — business rules, calculations, invariants]

# Architecture Constraints (MUST respect)
[ARCH specs — patterns, technology decisions, NFRs]

# Product Context (SHOULD align with)
[PROD/FEAT specs — user outcomes, success metrics]

# Task
[WRK-TASK with acceptance criteria]
```

**Pattern: `retrieval`**

```markdown
# Available Knowledge (summaries)
- [SPEC-ID]: [One-line summary of key rules/constraints]
...

# Full specs available via tool: read_spec(id)
When you need the full content of a spec, use the read_spec tool with its ID.

# Task
[Task body]
```

### Step 7: Output

```
## Activation Report

### Pipeline Summary
- Explicit: N specs
- Transitive: N specs
- Filtered: N specs
- Final (budgeted): N specs

### Activated Specs
| Spec | Title | Layer | Confidence | Source |
|------|-------|-------|------------|--------|

### Estimated Token Count
~N tokens

---
[Generated prompt]
```

If `--save`, write to `<task-id>.prompt.md` or `activation-<timestamp>.prompt.md`.

## Difference from /kdd:spec-context

- `/kdd:spec-context` = **discovery + brief** (for humans, to understand the landscape)
- `/kdd:spec-activate` = **full pipeline + prompt** (for agents, to execute work)
