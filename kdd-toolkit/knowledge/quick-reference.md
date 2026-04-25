# KDD Quick Reference

Artifact matrix + pre-PR checklist in one page.

---

## Artifact Matrix

### Knowledge Artifacts (Persistent)

| Type | Layer | ID Pattern | Key Relations |
|------|-------|------------|---------------|
| **ARCH** | Architecture | `ARCH-AREA-NNN` | Constrains DOM, PROD, FEAT |
| **DOM** | Domain | `DOM-AREA-NNN` | Implements regulations, constrained-by ARCH |
| **PROD** | Product | `PROD-AREA-NNN` | Implements strategy, constrains FEAT |
| **FEAT** | Feature | `FEAT-AREA-NNN` | Implements PROD, uses-data-from DOM |
| **DOC** | Documentation | `DOC-AREA-NNN` | Supports all layers |

### Work Artifacts (Ephemeral)

| Type | Layer | ID Pattern | Parent |
|------|-------|------------|--------|
| **WRK-SPEC** | Spec | `WRK-SPEC-NNN` | — |
| **WRK-PLAN** | Plan | `WRK-PLAN-NNN` | WRK-SPEC |
| **WRK-TASK** | Task | `WRK-TASK-NNN` | WRK-PLAN |

### Governance Artifacts (Bridge)

| Type | ID Pattern | Lifecycle |
|------|-----------|-----------|
| **RFC** | `RFC-NNN` | proposed → accepted/rejected |
| **ADR** | `ADR-NNN` | accepted → superseded |
| **RULE** | `RULE-NNN` | active → deprecated |

---

## Spec Checklist (Pre-PR)

### Frontmatter

- [ ] `id` follows pattern (`TYPE-AREA-NNN` or `WRK-TYPE-NNN`)
- [ ] `type` is valid: `spec`, `rfc`, `adr`, `guide`, `template`, `rule`
- [ ] `layer` matches the type
- [ ] `status` is a valid lifecycle value
- [ ] `confidence` is set (knowledge only): `low`, `medium`, `high`
- [ ] `version` follows semver
- [ ] `owner` is a real team or person

### Dependencies

- [ ] Every `dependencies[].id` references an existing spec
- [ ] Every `dependencies[].relation` is valid: `implements`, `constrained-by`, `extends`, `uses-data-from`, `depends-on`, `supersedes`
- [ ] No circular dependencies
- [ ] Relations make semantic sense

### Work Artifacts (additional)

- [ ] `activates` lists at least one Knowledge Artifact (WRK-SPEC)
- [ ] `parent` references an existing Work Artifact (WRK-PLAN, WRK-TASK)

### Body Sections

**Knowledge**: Intent ✓ | Definition ✓ | Acceptance Criteria ✓ | Evidence ✓
**Work**: Problem Statement/Objective ✓ | Activated Knowledge ✓ | Acceptance Criteria ✓
**Governance**: Context ✓ | Decision/Proposal ✓ | Rationale ✓ | Alternatives ✓

### Validation

```bash
spec-graph --specs <dir> validate    # Check integrity
spec-graph --specs <dir> orphans     # Check connectivity
```
