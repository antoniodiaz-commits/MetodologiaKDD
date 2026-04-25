# Spec Anatomy Reference

Condensed reference for spec structure: YAML frontmatter schema and body sections by type.

---

## YAML Frontmatter Schema

### Required Fields (all artifact types)

| Field | Type | Values |
|-------|------|--------|
| `id` | string | `TYPE-AREA-NNN` (knowledge) or `WRK-TYPE-NNN` (work) |
| `type` | enum | `spec`, `rfc`, `adr`, `guide`, `template`, `rule` |
| `layer` | enum | `architecture`, `domain`, `product`, `feature`, `documentation`, `work-spec`, `work-plan`, `work-task` |
| `status` | enum | Depends on type (see lifecycles in taxonomy-reference.md) |
| `confidence` | enum | `high`, `medium`, `low` (knowledge artifacts only) |
| `version` | semver | e.g., `"1.2.0"` |
| `owner` | string | Team or individual responsible |

### Optional Fields

| Field | Applies to | Type | Purpose |
|-------|-----------|------|---------|
| `domain` | Knowledge | string | Functional domain from taxonomy |
| `subdomain` | Knowledge | string | Subdomain within domain |
| `created` | All | date | Creation date |
| `updated` | All | date | Last modification date |
| `reviewers` | All | list | Required reviewers |
| `dependencies` | All | list of `{id, relation}` | Structural spec-to-spec deps |
| `tags` | All | list | Free-form tags for discovery |
| `supersedes` | All | string | ID of spec this replaces |
| `activates` | Work only | list of strings | Knowledge spec IDs to inject as context |
| `parent` | WRK-PLAN, WRK-TASK | string | ID of parent work artifact |
| `scope` | WRK-TASK | object | `{includes: [...], excludes: [...]}` file boundaries |

### Frontmatter Example (Knowledge)

```yaml
---
id: DOM-RISK-001
type: spec
layer: domain
domain: Markets & Trading
subdomain: Risk Management
status: active
confidence: high
version: "1.2.0"
created: 2026-01-15
updated: 2026-03-01
owner: risk-architecture-team
reviewers: [market-risk-sme, cib-architecture]
dependencies:
  - id: ARCH-002
    relation: implements
  - id: DOM-REG-001
    relation: constrained-by
tags: [risk, var, market-risk]
---
```

### Frontmatter Example (Work)

```yaml
---
id: WRK-SPEC-001
type: work
layer: spec
title: VaR Engine Redesign
status: draft
version: "0.1.0"
owner: risk-analytics-team
activates:
  - DOM-RISK-001
  - ARCH-002
  - DOM-REG-001
tags: [var, performance, redesign]
---
```

---

## Body Sections by Layer

### Knowledge Artifacts

**All knowledge specs** follow: Intent → Definition → Acceptance Criteria → Evidence → Traceability

The **Definition** section structure varies by layer:

| Layer | Definition subsections |
|-------|----------------------|
| **Architecture** | Context → Decision → Rationale → Consequences |
| **Domain** | Concept → Rules → Constraints → Examples |
| **Product** | Purpose → Actors → Flow → Acceptance Criteria |
| **Feature** | Purpose → Inputs → Behavior → Outputs |
| **Documentation** | Purpose → Audience → Content outline |

### Work Artifacts

| Type | Body sections |
|------|--------------|
| **WRK-SPEC** | Problem Statement → Proposed Solution → Activated Knowledge → Constraints → Acceptance Criteria → Open Questions |
| **WRK-PLAN** | Architecture Approach → Task Decomposition → Constraints → Risk Assessment → Dependencies |
| **WRK-TASK** | Objective → Technical Specification → Acceptance Criteria → Test Strategy |

### Governance Artifacts

| Type | Body sections |
|------|--------------|
| **RFC** | Problem Statement → Proposed Solution → Alternatives → Impact Assessment → Discussion |
| **ADR** | Context → Decision → Rationale → Consequences → Related Specs |

---

## ID Pattern Reference

| Artifact | Pattern | Examples |
|----------|---------|---------|
| Architecture | `ARCH-NNN` or `ARCH-AREA-NNN` | `ARCH-002`, `ARCH-INT-001` |
| Domain | `DOM-AREA-NNN` | `DOM-RISK-001`, `DOM-REG-001` |
| Product | `PROD-AREA-NNN` | `PROD-TRADE-001` |
| Feature | `FEAT-AREA-NNN` | `FEAT-KYC-001` |
| Documentation | `DOC-AREA-NNN` | `DOC-API-001` |
| Work Spec | `WRK-SPEC-NNN` | `WRK-SPEC-001` |
| Work Plan | `WRK-PLAN-NNN` | `WRK-PLAN-001` |
| Work Task | `WRK-TASK-NNN` | `WRK-TASK-001` |
| RFC | `RFC-NNN` | `RFC-001` |
| ADR | `ADR-NNN` | `ADR-015` |
| Rule | `RULE-NNN` | `RULE-005` |

---

## Context Window Optimization (for Spec-as-Prompt)

When injecting specs into agent context:

| Spec section | Include? | Why |
|-------------|----------|-----|
| Frontmatter (summary) | Yes | ID, confidence, status — helps agent understand the spec's role |
| Intent | Yes | Essential for understanding purpose |
| Definition | Yes | The core content |
| Acceptance Criteria | Yes | Contract the agent must meet |
| Evidence | Optional | Only if agent needs validation context |
| Traceability | No | Not useful for generation |

Budget: A typical WRK-TASK activation (2–5 specs) should fit in 3,000–8,000 tokens.
