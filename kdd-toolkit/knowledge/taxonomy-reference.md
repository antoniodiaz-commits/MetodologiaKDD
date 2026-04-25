# KDD Taxonomy Reference

Condensed reference for the three-axis Knowledge-Driven Development taxonomy.

---

## The Three Axes

| Axis | Purpose | Persistence |
|------|---------|-------------|
| **Knowledge** | What the organization knows | Persistent — survives across projects |
| **Work** | What is being changed right now | Ephemeral — tied to a specific change |
| **Governance** | Decisions that bridge knowledge and work | Mixed — ADRs persist, RFCs close |

---

## Knowledge Artifacts (Persistent)

| Layer | ID Pattern | Scope | Purpose |
|-------|-----------|-------|---------|
| **Architecture** | `ARCH-NNN` or `ARCH-AREA-NNN` | Cross-cutting technical decisions | Patterns, infrastructure, NFRs |
| **Domain** | `DOM-AREA-NNN` | Business knowledge | Rules, regulations, domain concepts |
| **Product** | `PROD-AREA-NNN` | Product requirements | User journeys, capabilities |
| **Feature** | `FEAT-AREA-NNN` | Specific functionality | Behaviors, interfaces |
| **Documentation** | `DOC-AREA-NNN` | Reference materials | Guides, runbooks, standards |

**Lifecycle**: `draft` → `active` → `deprecated`

**Layer selection heuristic**:
- Constrains many features → ARCH
- Owned by domain expert → DOM
- Owned by product owner → PROD
- Describes user-facing behavior → FEAT
- Explains how to do something → DOC

---

## Work Artifacts (Ephemeral)

| Type | ID Pattern | Layer | Purpose | Parent |
|------|-----------|-------|---------|--------|
| **WRK-SPEC** | `WRK-SPEC-NNN` | work-spec | What & why — scope, constraints, activated knowledge | — |
| **WRK-PLAN** | `WRK-PLAN-NNN` | work-plan | How — architecture approach, task decomposition | WRK-SPEC |
| **WRK-TASK** | `WRK-TASK-NNN` | work-task | Do — atomic implementable unit | WRK-PLAN |

**Lifecycle**: `draft` → `active` → `completed` → `archived`

**Key field**: `activates` — lists Knowledge Artifacts that provide context for this work.

**Hierarchy**: WRK-TASK → (parent) → WRK-PLAN → (parent) → WRK-SPEC

---

## Governance Artifacts (Bridge)

| Type | ID Pattern | Purpose | Lifecycle |
|------|-----------|---------|-----------|
| **RFC** | `RFC-NNN` | Propose changes to standards | `draft` → `discussion` → `accepted`/`rejected` |
| **ADR** | `ADR-NNN` | Record decisions with rationale | `proposed` → `accepted` → `superseded` |
| **RULE** | `RULE-NNN` | Codify constraints for automation | `active` → `deprecated` |

---

## Dependency Relations

| Relation | Direction | Meaning | Typical usage |
|----------|-----------|---------|---------------|
| `implements` | Knowledge → Knowledge | Realizes a higher-level spec | FEAT → PROD, DOM → Regulation |
| `constrained-by` | Knowledge → Knowledge | Must respect constraints | DOM → ARCH, FEAT → DOM |
| `extends` | Knowledge → Knowledge | Adds detail at same layer | DOM-002 → DOM-001 |
| `uses-data-from` | Knowledge → Knowledge | Consumes data defined elsewhere | FEAT → DOM |
| `activates` | Work → Knowledge | Injects knowledge as context | WRK-SPEC → DOM, ARCH |
| `depends-on` | Work → Work | Sequencing between tasks | WRK-TASK → WRK-TASK |
| `parent` | Work → Work | Hierarchy | Task → Plan → Spec |
| `supersedes` | Any → Any | Replacement chain | New → deprecated |

**Inverse relations** (auto-derived by the CLI):
`implements` ↔ `implemented-by`, `constrained-by` ↔ `constrains`, `extends` ↔ `extended-by`, `activates` ↔ `activated-by`

---

## Confidence Levels

| Level | Meaning | Criteria |
|-------|---------|----------|
| **HIGH** | Confirmed and reliable | Validated by testing **AND** expert review |
| **MEDIUM** | Partially confirmed | Validated by testing **OR** expert review |
| **LOW** | Inferred, needs validation | Captured from observation, not yet validated |

---

## Contextual Activation Pipeline

```
1. Explicit  →  2. Transitive  →  3. Filtered  →  4. Budgeted
```

1. **Explicit**: Author declares `activates: [spec-ids]` in WRK-SPEC frontmatter
2. **Transitive**: Graph traversal (BFS, configurable depth) expands the activation set
3. **Filtered**: Remove deprecated, irrelevant, or mismatched-layer specs
4. **Budgeted**: Limit by work level:

| Work level | Budget |
|-----------|--------|
| WRK-TASK | 2–5 specs |
| WRK-PLAN | 3–7 specs |
| WRK-SPEC | 5–10 specs |

---

## Consolidation Checklist

When a WRK-SPEC completes, review:

1. **ADR review** — Undocumented design decisions? → Create ADRs
2. **Spec delta** — Activated specs need corrections? → Update + version bump
3. **New knowledge** — Domain rules discovered? → Create new specs (LOW confidence)
4. **Rule extraction** — Business rules hardcoded? → Formalize as DOM specs
5. **Pattern capture** — Reusable patterns introduced? → Create ARCH specs
6. **Confidence upgrade** — Specs validated by implementation? → Promote confidence + evidence

---

## Activation Matrix: Work Phase × Knowledge

| Phase | Work Artifact | Knowledge Activated | Governance Produced |
|-------|--------------|--------------------|--------------------|
| Specify | WRK-SPEC | DOM, PROD, regulatory | RFCs (if gap found) |
| Plan | WRK-PLAN | ARCH, NFRs, API standards | ADRs (design decisions) |
| Implement | WRK-TASK | FEAT, business rules, testing | — |
| Consolidate | — | — | ADRs, updated specs, new RULEs |
