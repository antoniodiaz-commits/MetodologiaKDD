---
description: Quick-create a spec from a natural language description
---

Quick-create a spec from a natural language description — one-shot, non-conversational.

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

Given: $ARGUMENTS — a free-text description (e.g., "domain spec for settlement netting rules in CIB")

### Step 1: Parse and classify

From the description, determine:

| Field | How to infer |
|-------|-------------|
| **Axis** | Keywords: "domain"/"architecture"/"product"/"feature"/"documentation"/"work-spec" etc. |
| **Layer** | Business rules → domain, patterns → architecture, user journey → product, specific behavior → feature, how-to → documentation |
| **Domain** | Named domain or infer from topic |
| **Subdomain** | Specific grouping within domain |
| **Title** | Core topic from description |

Default to Knowledge/Domain if ambiguous.

### Step 2: Determine next available ID

```bash
node <cli-path> --specs <specs-dir> stats
node <cli-path> --specs <specs-dir> filter --layer <layer> --format json
```

Scan existing specs for highest ID number in the determined type and area. Calculate next available.

### Step 3: Find related specs

```bash
node <cli-path> --specs <specs-dir> filter --domain <domain> --format json
node <cli-path> --specs <specs-dir> filter --layer <layer> --format json
```

Identify dependency candidates:
- Same domain → likely `constrained-by` or `uses-data-from`
- Architecture layer → likely `implements`
- Same subdomain → likely `extends`

### Step 4: Generate the spec file

**Knowledge spec template:**

```markdown
---
id: [generated ID]
type: spec
layer: [layer]
domain: [domain]
subdomain: [subdomain]
status: draft
confidence: low
version: "0.1.0"
created: [today]
updated: [today]
owner: "{owner}"
reviewers: []
dependencies:
  - id: [suggested dep]
    relation: [relation type]
tags: [inferred tags]
---

# [ID] — [Title]

## Intent

{Describe what this spec defines and why it exists.}

## Definition

### [Subsections vary by layer]

{Architecture: Context → Decision → Rationale → Consequences}
{Domain: Concept → Rules → Constraints → Examples}
{Product: Purpose → Actors → Flow → Acceptance Criteria}
{Feature: Purpose → Inputs → Behavior → Outputs}
{Documentation: Purpose → Audience → Content outline}

## Acceptance Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Evidence

| Type | Reference | Date | Confidence impact |
|------|-----------|------|-------------------|
| {type} | {reference} | {date} | Initial → LOW |

## Traceability

| Relation | Target | Description |
|----------|--------|-------------|
| {relation} | {target} | {description} |
```

**Work spec templates** follow the same pattern — use WRK-SPEC, WRK-PLAN, or WRK-TASK body structure as appropriate (see `knowledge/spec-anatomy-reference.md` for body sections by type).

### Step 5: Save and report

Write the file to the specs directory (in the appropriate subdirectory based on layer if the directory uses subdirectories).

```
## Spec Created

- **File**: [path]
- **ID**: [generated ID]
- **Type**: [layer]
- **Dependencies suggested**: [list with rationale]

### Next steps
1. Fill in the `{placeholder}` sections
2. Set the `owner` field
3. Review suggested dependencies
4. Run `/kdd:spec-validate` to verify integrity
```

## Notes

- Always start at `confidence: low`, `status: draft`, `version: "0.1.0"`
- Use `{placeholder}` for content the user needs to fill in
- If the description is detailed, pre-fill body sections instead of placeholders
