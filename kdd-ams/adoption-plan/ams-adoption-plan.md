# KDD Adoption Program — Application Maintenance Services

**Format**: 4 weeks
**Modality**: Weekly workshop (2h) + Real-service coaching (1-2h/week) + Autonomous work (2-3h/week)
**Commitment**: ~5-7h/week per person (20-28h total program)

---

## 1. Framing

### Program objective

The maintenance team **gets familiar with the KDD methodology, understands its value, and starts applying it** on their real service.

Over 4 weeks, the team:

1. **Understands** why structured knowledge changes the way a service is operated
2. **Practices** by writing real specs from their service (known errors, runbooks, incidents)
3. **Experiences** the value: uses specs as context for AI agents in incident resolution and evolutive planning
4. **Adopts** a sustainable cycle where every incident and every evolutive enriches the knowledge base

### AMS workstreams

A maintenance service has two workstreams:

| Workstream | What the team does | How KDD helps |
|------------|-------------------|---------------|
| **Operations** | Resolve incidents, execute runbooks, diagnose | OPS-KE, OPS-RUN, WRK-INC → activation + agent for resolution |
| **Evolutives** | Develop improvements, new features, changes | The full taxonomy as context (ARCH, DOM, OPS-KE, FEAT, ADR) → WRK-SPEC → WRK-PLAN → WRK-TASK → spec-driven development |

KDD covers both — and the taxonomy bridges them. Operations primarily uses ARCH, OPS-KE, and OPS-RUN. Evolutives draw from the **full taxonomy**: domain specs (DOM) for business rules and regulatory constraints, architecture specs (ARCH) for system context, feature specs (FEAT) for existing behavior, and operational knowledge (OPS-KE) for known risks. The knowledge captured during operations directly feeds the context for evolutive development, and vice versa — an evolutive that changes architecture updates the same ARCH specs used for incident resolution.

The program starts with operations (weeks 1-2), connects to the full SDLC for evolutives (week 3), and shows how both workstreams share and enrich the same knowledge graph.

### Thread

```
Week 1: Write specs             →  The team captures what it knows
Week 2: Connect specs           →  The graph takes shape, relationships provide context
Week 3: Activate specs + agent  →  Knowledge works for the team (ops + evolutives)
Week 4: Consolidate + sustain   →  Knowledge grows with every incident and every evolutive
```

### Audience

| Role | Program role |
|------|-------------|
| Service Manager | Champion, end-to-end vision, leads governance |
| L2/L3 Engineer | Writes OPS-KE/OPS-RUN, handles complex resolutions |
| L1 Operator | Contributes runbooks, first user of agent-assisted resolution |
| Incident Manager | Validates post-mortems, ensures consolidation |

**Recommended size**: 4-8 people.

### New service vs Consolidated service

| Aspect | New service | Consolidated service |
|--------|-------------|----------------------|
| **Starting point** | Transition; no internal documentation | Tacit knowledge accumulated |
| **First focus** | OPS-RUN for critical procedures + ARCH | OPS-KE for recurring incidents |
| **Data source** | Outgoing team, code, inherited docs | Ticketing system, post-mortems, experience |
| **Risk** | Copying docs without validating against reality | "We already know this, why document?" |
| **Quick win** | First runbook as spec from day 1 | Codify the incident that consumes the most time |

### Prerequisites

Before week 1, every participant must complete the following:

#### Required reading

| Resource | What it covers | Time |
|----------|---------------|------|
| [KDD Strategic Foundation](https://kdd-docs.web.app/kdd-foundation) | Why KDD exists: the manifesto, three pillars, four design principles | 30 min |
| [KDD Operational Documentation](https://kdd-docs.web.app/kdd-operational) | How to use KDD: guides, reference, patterns | 45 min (skim sections relevant to AMS) |
| [Anatomy of a Coding Agent](https://kdd-docs.web.app/anatomy-coding-agent) | How AI coding agents work internally — context window, tool use, planning loops | 20 min |

#### Introductory AI courses (choose one)

| Course | Platform | Time |
|--------|----------|------|
| [Claude for Developers](https://docs.anthropic.com/en/docs/build-with-claude) | Anthropic | 1-2h |
| [Gemini API Quickstart](https://ai.google.dev/gemini-api/docs/quickstart) | Google | 1-2h |
| [GitHub Copilot Fundamentals](https://learn.microsoft.com/en-us/training/paths/copilot/) | Microsoft Learn | 1-2h |

The goal is not mastery — it's having a baseline understanding of what AI tools can do, so the program can focus on **how to use them with structured knowledge**.

#### Technical setup

- Git repository accessible to all participants
- Permissions to create directories and PRs
- Node.js 18+ (for spec-graph CLI)
- Access to at least one AI tool (Claude Code, Cursor, Copilot, etc.)
- Access to the ticketing system (Jira, ServiceNow, etc.) for incident history extraction

### Tools

| Tool | Purpose | When |
|------|---------|------|
| **Git + Markdown editor** | Write and version specs | From week 1 |
| **spec-graph CLI** | Validate, navigate, activate context | From week 1 |
| **AI agent** (Claude Code, Cursor, Copilot, etc.) | Assisted resolution with specs as context | From week 3 |

---

## 2. Week 1 — Foundations: Taxonomy, anatomy, and first specs

> **Objective**: The team understands the KDD framework, masters spec structure, and writes their first OPS-KE and OPS-RUN on their real service.

### Workshop (2h)

#### Block 1: Why KDD for maintenance (20 min)

Four failure patterns in teams without a knowledge methodology:

1. **Tribal knowledge**: Critical knowledge resides in 1-2 people. When they rotate, the team goes blind.
2. **Repetitive firefighting**: Same incidents resolved over and over without documenting root cause.
3. **Blind handover**: Service transition based on static docs that don't reflect operational reality.
4. **Reactive-only**: All time consumed by incidents. No capacity for prevention.

The solution: **specifications as a universal interface** — the artifact that survives team changes, scales knowledge across shifts, and enables humans and AI agents to operate with the same context.

#### Block 2: KDD Taxonomy — Three artifact axes (20 min)

| Axis | Nature | AMS examples | Persists? |
|------|--------|--------------|-----------|
| **Knowledge** | What the organization knows | OPS-KE, OPS-RUN, ARCH | Yes — grows with every project |
| **Work** | What the team is doing now | WRK-INC (incidents) | No — scoped to a concrete event |
| **Governance** | How knowledge evolves | ADR (decisions), RULE (constraints) | Yes — bridges Knowledge and Work |

**Spec types for AMS**:

| Type | ID | Axis | What it captures | When to create |
|------|----|------|-----------------|----------------|
| **Known Error** | OPS-KE | Knowledge | Failure pattern: symptoms, root cause, resolution, prevention | When a failure recurs or is high-impact |
| **Runbook** | OPS-RUN | Knowledge | Operational procedure: trigger, steps, validation, rollback | When a procedure is executed more than once |
| **Architecture** | ARCH | Knowledge | System map: components, dependencies, integrations | When onboarding a service or documenting a system |
| **Incident** | WRK-INC | Work | Concrete incident: what happened, which OPS-KE it activated, resolution | When resolving a P1/P2 incident |
| **Decision Record** | ADR | Governance | Decision with context and rationale | After a post-mortem or relevant operational change |
| **Rule** | RULE | Governance | Permanent constraint: "Every P1 requires a post-mortem within 48h" | When a practice becomes a norm |

Heuristic: Is it a recurring failure pattern? → **OPS-KE**. Is it a step-by-step procedure? → **OPS-RUN**. Did it just happen? → **WRK-INC**. Is it a decision we made? → **ADR**.

#### Block 3: Spec anatomy (30 min)

Every spec has two parts: **YAML frontmatter** (machine-readable metadata) + **Markdown body** (human-readable content).

**Frontmatter** — required fields:

```yaml
---
id: OPS-KE-PAYMENTS-001          # Unique identifier: TYPE-AREA-NNN
type: knowledge                   # knowledge | work | governance
layer: operations                 # operations | architecture | domain | ...
title: Payment API timeout due to exhausted connection pool
status: draft                     # draft → active → deprecated
confidence: medium                # low | medium | high
version: "0.1.0"
owner: maintenance-team
domain: payments
tags: [timeout, connection-pool, payments]
dependencies:
  - id: ARCH-PAYMENTS-001
    type: constrained-by          # constrained-by | implements | extends | resolves-with
---
```

**Body** — structure by type:

| Type | Required sections |
|------|------------------|
| **OPS-KE** | Symptoms, Root Cause, Diagnosis, Resolution (immediate + definitive), Prevention, Occurrence Count |
| **OPS-RUN** | Trigger, Prerequisites, Steps, Validation, Rollback |
| **ARCH** | Overview, Components, Dependencies, Integration Points |
| **WRK-INC** | Description, Timeline, Resolution, Consolidation (checklist) |

**Dependencies** — how specs connect:

| Relation | Meaning | Example |
|----------|---------|---------|
| `constrained-by` | Must respect constraints from another spec | OPS-KE constrained-by ARCH |
| `resolves-with` | Resolved by executing another artifact | OPS-KE resolves-with OPS-RUN |
| `activates` | Activates knowledge for a task | WRK-INC activates OPS-KE |
| `mitigated-by` | Mitigated by a procedure | WRK-INC mitigated-by OPS-RUN |
| `extends` | Adds detail to another spec at the same level | OPS-KE-002 extends OPS-KE-001 |

#### Block 4: Live demo + spec-graph (30 min)

Write an OPS-KE + OPS-RUN live from a real incident reported by the team.

**OPS-KE example**:

```yaml
---
id: OPS-KE-PAYMENTS-001
type: knowledge
layer: operations
title: Payment API timeout due to exhausted connection pool
status: draft
confidence: medium
version: "0.1.0"
owner: maintenance-team
domain: payments
tags: [timeout, connection-pool, payments]
dependencies:
  - id: ARCH-PAYMENTS-001
    type: constrained-by
  - id: OPS-RUN-PAYMENTS-001
    type: resolves-with
---

## Symptoms
- HTTP 504 Gateway Timeout on `/api/payments/*` endpoints
- Logs: `Connection pool exhausted, waiting for available connection`
- Metric: `db.pool.active_connections` > 95% of max

## Root Cause
Connection pool exhausted during concurrent transaction peaks (>500 TPS).
Pool configured with max_connections=50, insufficient for peak load.

## Diagnosis
1. Check `db.pool.active_connections` in Grafana
2. Check logs: `grep "pool exhausted" /var/log/payments.log`
3. Verify load: `select count(*) from pg_stat_activity`

## Resolution
### Immediate
Restart service → execute OPS-RUN-PAYMENTS-001

### Definitive
Increase `max_connections` to 100 in `application.yml`

## Prevention
- Alert on `db.pool.active_connections > 80%`
- Quarterly pool sizing review

## Occurrence Count
3 (last 6 months)
```

**First spec-graph commands**:

```bash
spec-graph validate          # Any errors in the specs?
spec-graph stats             # How many specs do we have? What types?
```

#### Block 5: Guided exercise (10 min)

Each participant identifies 1 recurring incident from their area and writes the complete YAML frontmatter for an OPS-KE (frontmatter only, body during autonomous work).

### Coaching (1-2h)

#### New service
1. Identify the 3-5 most critical operational procedures (those executed during transition)
2. Write an OPS-RUN for each
3. Create 2-3 ARCH specs for systems and dependencies

#### Consolidated service
1. Query ticketing system: filter by frequency and resolution time
2. Identify top 5 recurring incidents
3. Write an OPS-KE for each pattern

#### Both
- Complete frontmatter, `confidence: low` or `medium` (be honest at the start)
- Declare dependencies between specs (OPS-KE → OPS-RUN, OPS-KE → ARCH)
- `spec-graph validate` when done

### Autonomous work

- Each member writes 1-2 specs from their area
- Repository setup:
  ```
  specs/
  ├── known-errors/    # OPS-KE — failure patterns
  ├── runbooks/        # OPS-RUN — procedures
  ├── architecture/    # ARCH — system maps
  └── incidents/       # WRK-INC (from week 2)
  ```

### Week 1 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| `specs/` directory created | ✓ | ✓ |
| OPS-KE written | 3 | 5+ |
| OPS-RUN written | 2 | 3+ |
| Dependencies declared | ✓ | ✓ |
| `spec-graph validate` executed | ✓ | ✓ |
| Team aligned on taxonomy and anatomy | ✓ | ✓ |

---

## 3. Week 2 — The graph: Relationships, WRK-INC, and consolidation

> **Objective**: The team connects specs into a navigable graph, codifies incidents as WRK-INC, and practices the Work→Knowledge consolidation cycle.

### Workshop (2h)

#### Block 1: The knowledge graph — From isolated specs to a knowledge network (30 min)

Individual specs have value, but exponential value is in the **relationships**. An isolated OPS-KE is documentation; an OPS-KE connected to its OPS-RUN, its ARCH, and its WRK-INCs is **activatable knowledge**.

```
ARCH-PAYMENTS-001 (system)
    │
    ├── constrained-by ──→ OPS-KE-PAYMENTS-001 (timeout due to pool)
    │                          │
    │                          ├── resolves-with ──→ OPS-RUN-PAYMENTS-001 (restart)
    │                          │
    │                          └── activates ←── WRK-INC-001 (incident 03/15)
    │                                              WRK-INC-007 (incident 04/22)
    │
    └── constrained-by ──→ OPS-KE-PAYMENTS-002 (out of memory)
                               │
                               └── resolves-with ──→ OPS-RUN-PAYMENTS-003 (restart + heap)
```

**spec-graph** to navigate the graph:

```bash
spec-graph build --html              # Interactive graph visualization
spec-graph context OPS-KE-PAYMENTS-001 --depth 2   # What's connected to this OPS-KE?
spec-graph impact OPS-KE-PAYMENTS-001               # What's affected if this OPS-KE changes?
spec-graph orphans                                   # Specs without connections (suspicious)
```

#### Block 2: WRK-INC — The incident as a work artifact (30 min)

WRK-INC connects the **work world** (what just happened) with the **knowledge world** (what we know).

```yaml
---
id: WRK-INC-001
type: work
layer: incident
title: "P1 2026-03-15: Massive timeout on payments service"
status: resolved
created: 2026-03-15
resolved: 2026-03-15
owner: l2-engineer
activates:
  - OPS-KE-PAYMENTS-001
mitigated-by:
  - OPS-RUN-PAYMENTS-001
---

## Description
Generalized timeout on payments service between 14:30 and 15:15 UTC.

## Timeline
- 14:30 — Timeout alert triggered
- 14:35 — Symptoms matched to OPS-KE-PAYMENTS-001
- 14:40 — Executed OPS-RUN-PAYMENTS-001 (restart)
- 14:45 — Service restored
- 15:15 — Confirmed stable

## Resolution
Service restart (immediate resolution).
Definitive resolution pending: connection pool resize.

## Consolidation
- [x] OPS-KE-PAYMENTS-001: occurrence_count 2→3
- [x] ADR-OPS-001: Decided to prioritize pool resize
- [ ] OPS-KE-PAYMENTS-001: confidence medium→high (validated in production)
```

**Key relationships**:
- `activates` → which OPS-KE describes the failure pattern
- `mitigated-by` → which OPS-RUN was executed

#### Block 3: The consolidation cycle (45 min)

Every incident is a learning opportunity. Consolidation transforms **work** into **knowledge**:

```
Incident → Resolution → Consolidate → Updated knowledge
                              │
                   ┌──────────┴──────────┐
                   │                      │
             New pattern?           Known pattern?
                   │                      │
             Create OPS-KE          Update OPS-KE
             + OPS-RUN              (occurrence_count,
                                     confidence, resolution)
```

**Consolidation checklist** (execute after resolving each significant incident):

1. Is it a new pattern? → Create OPS-KE
2. Known pattern? → Update occurrence_count, refine resolution
3. Undocumented root cause? → Update OPS-KE
4. Missing runbook? → Create OPS-RUN
5. Operational decision taken? → Write ADR
6. Can confidence be raised? → LOW→MEDIUM (reviewed), MEDIUM→HIGH (validated in prod)

**Live exercise**: take the team's last resolved incident and run through the checklist.

#### Block 4: Demo — Codify a real incident (15 min)

1. Search ticketing for the last resolved P1/P2
2. Write WRK-INC with `activates` and `mitigated-by`
3. Run consolidation: which OPS-KE gets updated or created?
4. `spec-graph validate` + `spec-graph context`

### Coaching (1-2h)

#### New service
1. Codify 3-5 incidents from the outgoing team's history
2. Link to OPS-KE created in week 1
3. Identify missing OPS-KE

#### Consolidated service
1. Mine post-mortems from the last 6-12 months
2. Codify as retroactive WRK-INC
3. Practice consolidation: which OPS-KE get updated?

#### Both
- Review and improve week 1 specs
- Clean `spec-graph validate`
- `spec-graph build --html` to visualize the graph
- Identify and resolve orphans

### Autonomous work

- Each member codifies 1-2 incidents as WRK-INC
- Execute consolidation on at least 1 incident
- Connect orphaned specs
- Explore the graph with `spec-graph build --html`

### Anti-pattern

> **Don't skip consolidation** — if knowledge stays in the ticket, it wasn't discovered. Consolidation is what transforms tickets into specs.

### Week 2 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| WRK-INC codified | 3 | 5+ |
| Consolidation practiced | 1 | 3+ |
| `spec-graph validate` without errors | ✓ | ✓ |
| Graph visualized (`build --html`) | ✓ | ✓ |
| Orphans identified and resolved | ✓ | ✓ |
| Total specs accumulated | 10 | 15+ |

---

## 4. Week 3 — Activation: Specs as context for agents

> **Objective**: The team learns to **activate** specs as context and use them with an AI agent for assisted incident resolution and evolutive planning. This is the week where everything clicks.

### Workshop (2h)

#### Block 1: Contextual activation — The pipeline (30 min)

**The problem**: an AI agent without service-specific context gives generic answers. An agent with the right specs as context gives answers aligned with the team's operational reality.

**Activation pipeline** — 4 steps to select which specs to pass to the agent:

| Step | What it does | How | Tool |
|------|-------------|-----|------|
| **1. Explicit** | Identify the directly relevant spec | `activates` field in WRK-INC, or manual search by symptoms | Team knowledge |
| **2. Transitive** | Follow dependencies for complete context | `spec-graph context <id> --depth 2` | spec-graph CLI |
| **3. Filtered** | Remove specs not relevant to the current problem | By domain, type, or layer | Manual or flag |
| **4. Budgeted** | Limit the bundle to what the agent can process | 5-10 specs max per query | Pragmatism |

**Example**: a timeout alert arrives for the payments service.

```bash
# Step 1: Identify the relevant OPS-KE
# (by symptoms, or because the alert references it)

# Step 2: Get transitive context
spec-graph context OPS-KE-PAYMENTS-001 --depth 2

# Output:
# OPS-KE-PAYMENTS-001 (the known error)
#   → ARCH-PAYMENTS-001 (system architecture)
#   → OPS-RUN-PAYMENTS-001 (restart runbook)
#   → WRK-INC-001 (last time it happened)
#   → WRK-INC-007 (time before that)

# Step 3: Filter — we only need OPS-KE + ARCH + OPS-RUN
# Step 4: 3 specs — within budget
```

#### Block 2: Activation matrix for AMS (20 min)

Which specs to activate for each task?

| Task | Primary specs | Secondary specs | Typical bundle |
|------|--------------|-----------------|----------------|
| **Resolve incident** | OPS-KE (pattern), OPS-RUN (procedure) | ARCH (system context), previous WRK-INC (history) | 3-7 specs |
| **Diagnose unknown problem** | ARCH (topology), related OPS-KE (similar symptoms) | OPS-RUN (diagnostic procedures) | 4-8 specs |
| **Develop evolutive** | ARCH (affected system), DOM (business rules, regulatory), FEAT (current behavior) | OPS-KE (known risks), ADR (previous decisions), PROD (product context) | 5-12 specs |
| **Execute operational change** | ARCH (system), OPS-RUN (procedure), OPS-KE (risks) | ADR (previous decisions) | 4-6 specs |
| **Onboard new member** | ARCH (all), OPS-KE (top 5), OPS-RUN (critical) | ADR (decision context) | 8-12 specs |
| **Post-mortem** | WRK-INC (the incident), OPS-KE (if it existed), ARCH (system) | Previous similar WRK-INC | 3-6 specs |

#### Block 3: Incident resolution agent — Live demo (40 min)

**Scenario**: An incident arrives. The team uses specs as context for an AI agent that assists with resolution.

**Complete flow**:

```
1. ALERT
   "HTTP 504 on /api/payments/*"
        │
2. IDENTIFY OPS-KE
   → By symptoms: "timeout" + "payments" → OPS-KE-PAYMENTS-001
        │
3. ACTIVATE CONTEXT
   → spec-graph context OPS-KE-PAYMENTS-001 --depth 2
   → Bundle: OPS-KE-PAYMENTS-001 + ARCH-PAYMENTS-001 + OPS-RUN-PAYMENTS-001
        │
4. PROMPT THE AGENT
   "I'm resolving this incident. Here's the context
    from our service: [specs from bundle].
    Current symptoms: [observed symptoms].
    What's your analysis and what steps do you recommend?"
        │
5. AGENT RESPONDS
   → Diagnosis aligned with OPS-KE (not generic)
   → Resolution steps based on OPS-RUN (not invented)
   → Real architecture context (not assumed)
        │
6. RESOLVE + CONSOLIDATE
   → Execute resolution
   → WRK-INC + consolidation
```

**Live demo**: execute this flow with a real team incident using Claude Code, Cursor, or equivalent tool.

**Prompt template for incident resolution**:

```markdown
## Service context
[Paste ARCH spec content]

## Identified Known Error
[Paste OPS-KE spec content]

## Available Runbook
[Paste OPS-RUN spec content]

## Current incident
- Symptoms: [describe what's observed]
- Start time: [timestamp]
- Impact: [affected users/services]

## Question
Given this context, do you confirm this matches the known error?
What steps do you recommend and in what order?
Are there additional risks we should consider?
```

**Prompt template for unknown problem diagnosis**:

```markdown
## Service context
[Paste ARCH spec content]

## Service Known Errors
[Paste OPS-KE specs summary: id, title, symptoms]

## Observed symptoms
[Describe current symptoms]

## Question
Do any of the documented known errors match these symptoms?
If not, what diagnosis do you suggest based on the service architecture?
What diagnostic steps do you recommend?
```

#### Block 4: KDD for evolutives — The SDLC bridge (20 min)

A significant part of an AMS service is **developing evolutives**: functional improvements, new features, technical changes. Here, KDD connects directly with the software development lifecycle (SDLC).

**The connection**: evolutives draw from the **full KDD taxonomy**, not just operational specs. The context a developer needs includes:

| Taxonomy layer | Why it matters for evolutives | Example |
|----------------|------------------------------|---------|
| **ARCH** | System architecture, dependencies, integration points | Where does this service connect? What breaks if we change the DB? |
| **DOM** | Business rules, regulatory constraints, domain logic | What transfer limits apply? What AML rules must be preserved? |
| **FEAT** | Current feature behavior, acceptance criteria | How does the payment flow work today? |
| **PROD** | Product-level requirements, user journeys | What's the end-to-end customer experience? |
| **OPS-KE** | Known failure patterns, operational risks | What's known to break under load? |
| **ADR** | Previous decisions and their rationale | Why was this approach chosen over alternatives? |

**KDD flow for evolutives**: WRK-SPEC → WRK-PLAN → WRK-TASK

```
1. EVOLUTIVE REQUEST
   "We need to increase the connection pool and add auto-scaling"
        │
2. WRK-SPEC (what and why)
   → What to change, why, acceptance criteria
   → activates: ARCH-PAYMENTS-001, DOM-PAYMENTS-003, OPS-KE-PAYMENTS-001, ADR-OPS-001
        │
3. ACTIVATE CONTEXT
   → spec-graph context WRK-SPEC-001 --depth 2
   → Bundle: architecture + domain rules + known errors + feature behavior + decisions
        │
4. WRK-PLAN (how) — with agent assistance
   → Agent receives bundle + WRK-SPEC
   → Proposes implementation plan aligned with real architecture
   → Identifies risks based on OPS-KE and domain constraints from DOM specs
        │
5. WRK-TASK (atomic units)
   → Each task implementable by 1 person or agent
   → Each task inherits context from the plan
        │
6. CONSOLIDATE
   → ARCH updated if architecture changed
   → FEAT updated if feature behavior changed
   → OPS-KE updated or closed if the evolutive resolves the root cause
   → New OPS-RUN if new operational procedures are needed
   → DOM updated if business rules were clarified during development
```

**The same graph serves ops and development**: an OPS-KE documenting "timeout due to exhausted pool" is context for the engineer resolving the incident **and** for the developer implementing auto-scaling. A DOM spec defining transfer limits is context for validating an incident **and** for developing a new payment feature. There are no two separate worlds.

**Prompt template for evolutive planning**:

```markdown
## Requested evolutive
[Description of the change and acceptance criteria]

## System architecture
[Paste ARCH spec — components, dependencies, integration points]

## Domain rules and constraints
[Paste DOM specs — business rules, regulatory requirements that apply]

## Current feature behavior
[Paste FEAT spec — how the affected functionality works today]

## Known operational risks
[Paste OPS-KE specs that relate to the affected area]

## Previous decisions
[Paste related ADRs]

## Question
Given this context, propose an implementation plan.
What domain constraints must be preserved?
What risks do you identify based on the known errors?
Which specs (ARCH, FEAT, OPS-KE, OPS-RUN, DOM) would need updating after the change?
```

#### Block 5: Hands-on exercise (30 min)

In pairs, choose one exercise:

**Option A — Operations**:
1. One member simulates "the alert" (describes symptoms from a past incident)
2. The other executes the flow: identify OPS-KE → activate context → prompt the agent → evaluate response

**Option B — Evolutive**:
1. Identify a pending or recent change in the service
2. Activate relevant context (ARCH + OPS-KE + ADR)
3. Ask the agent for an implementation plan with the bundle as context
4. Evaluate: does the plan account for real architecture and known risks?

In both cases, compare: is the agent's response with specs better than without?

### Coaching (1-2h)

- Each sub-team executes the full activation + agent flow:
  - **Operations**: 1-2 real incidents (assisted resolution)
  - **Evolutives**: 1 pending change from the backlog (assisted planning)
- Refine prompts: what's missing? what's excess? how to improve the response?
- Identify specs that need more detail for the agent to be effective
- Document prompts that work as reusable templates

### Autonomous work

- Each member executes 1 activation + agent flow (incident or evolutive, their choice)
- Refine specs based on what the agent "needed" and didn't find in the bundle
- Write 1-2 new specs that were revealed as necessary during practice

### Anti-pattern

> **Don't feed the agent everything** — select relevant specs. A bundle of 20 specs produces diffuse responses; a bundle of 3-5 focused specs produces precise ones.

### Week 3 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| Activation + agent flow executed (ops) | 1 | 3+ |
| Activation + agent flow executed (evolutive) | 1 | 2+ |
| Prompt templates documented | 2 (ops + evolutive) | 3+ |
| Specs refined after agent practice | 2 | 5+ |
| New specs created from detected gaps | 1 | 3+ |

---

## 5. Week 4 — Consolidate: Quality, metrics, and sustainability

> **Objective**: Raise graph quality, establish a metrics baseline, and define how the team will continue growing knowledge autonomously.

### Workshop (2h)

#### Block 1: Basic governance — ADR and RULE (30 min)

Two governance artifacts that reinforce quality:

**ADR** — record operational decisions:

```yaml
---
id: ADR-OPS-001
type: governance
layer: decision
title: Prioritize connection pool resize over auto-scaling
status: accepted
date: 2026-03-16
---

## Context
After the P1 on 03/15 (WRK-INC-001), we need to decide between static pool
resize or dynamic auto-scaling implementation.

## Decision
Static resize to max_connections=100. Auto-scaling discarded due to
implementation complexity in the current environment.

## Consequences
- Faster resolution (1 sprint vs 3 sprints)
- Limited capacity: if load exceeds 100 conn, it will fail again
- Review in 6 months if load grows
```

**RULE** — codify permanent constraints:

- "Every P1 requires a post-mortem documented as ADR within 48h"
- "Every OPS-RUN requires Validation and Rollback sections"
- "Every new OPS-KE requires at least 1 linked WRK-INC"
- "Confidence is updated after production validation"

#### Block 2: Graph quality — Review and confidence levels (30 min)

```bash
spec-graph validate       # Integrity errors
spec-graph orphans        # Specs without connections
spec-graph stats          # Overview
spec-graph build --html   # Visualization for review
```

Team review of the full graph:
- Any OPS-KE without a linked OPS-RUN? (resolution gap)
- Any OPS-RUN without an OPS-KE? (procedure without context of when to use it)
- Any outdated ARCH?
- Are confidence levels honest?

Raise confidence after review:
- LOW→MEDIUM: spec reviewed by a peer
- MEDIUM→HIGH: spec validated in production (used in a real incident)

#### Block 3: Adoption metrics (20 min)

Four metrics to measure whether knowledge is working for the team:

| Metric | What it measures | How to measure |
|--------|-----------------|---------------|
| **OPS-KE Coverage** | % of recurring incidents with a documented OPS-KE | Cross-reference top ticketing incidents with existing specs |
| **First-time Resolution** | % of incidents resolved on first attempt | Compare before/after the program |
| **Consolidation Rate** | % of incidents that produce spec updates | Count WRK-INC with completed Consolidation section |
| **Agent Effectiveness** | Quality of agent response with specs vs without | Qualitative team evaluation |

Precision is not required: informed team estimates are sufficient to establish a baseline.

#### Block 4: Roadmap and sustainability (40 min)

**What already works** (consolidate):
- Writing specs as part of the operational workflow
- Using activation + agent for incident resolution and evolutive planning
- Consolidating after each significant incident
- Reviewing specs periodically

**What comes next** (roadmap):

| Horizon | Focus | Capabilities |
|---------|-------|-------------|
| **Month 2-3** | ITSM→specs bridge automation | Auto-generate WRK-INC drafts from Jira/ServiceNow, semi-automatic enrichment |
| **Month 3-5** | Semantic search over specs | Vector index over OPS-KE symptoms, automatic incident-to-known-error matching |
| **Month 5+** | Closed-loop operations | Pattern detection in WRK-INC, auto-propose OPS-KE, cross-service correlation |

**Program retrospective** (facilitated):
- Which specs were most useful?
- Where is the biggest gap?
- Is the consolidation cycle sustainable?
- Do the agent prompts need improvement?

### Coaching (1-2h)

1. **Measure baseline**: current state of the 4 metrics
2. **Full graph review**: resolve all gaps
3. **Write 2-3 ADRs** for decisions made during the program
4. **Codify 2-3 RULEs** the team has adopted
5. **Plan month 2**: which OPS-KE are missing? what to automate first?

### Autonomous work

- Document metrics baseline
- Identify 1-2 champions who will lead continued adoption
- Schedule **weekly spec review** (30 min) as part of the workflow
- Complete pending specs
- Retrospective as ADR

### Anti-pattern

> **Don't capture every ticket as an OPS-KE** — only recurring or high-impact patterns. If it happened once and won't repeat, it's not a known error. Signal matters more than volume.

### Week 4 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| Metrics baseline documented | ✓ | ✓ |
| ADRs written | 2 | 3+ |
| RULE specs created | 2 | 3+ |
| Clean graph (validate without errors) | ✓ | ✓ |
| Confidence levels reviewed | ✓ | ✓ |
| Month 2 roadmap defined | ✓ | ✓ |
| Champions identified | 1 | 2 |
| Weekly spec review scheduled | ✓ | ✓ |
| Total specs accumulated | 15 | 25+ |

---

## 6. Summary: New service vs Consolidated service

| Week | New service | Consolidated service |
|------|-------------|----------------------|
| **1** | OPS-RUN for critical procedures + ARCH | OPS-KE for top 5 recurring incidents |
| **2** | WRK-INC from outgoing team's history | WRK-INC from past year's post-mortems |
| **3** | Activation + agent to accelerate transition | Activation + agent to improve resolution + plan evolutives |
| **4** | Clean baseline + complete coverage | Baseline + close gaps + plan automation |

---

## 7. Reference material

### KDD Framework

| Document | Content |
|----------|---------|
| `spec-driven/foundation/manifesto.md` | Why KDD |
| `spec-driven/foundation/pillars.md` | Three pillars: Spec-Driven, Evolutive, Agentic |
| `spec-driven/knowledge-architecture/spec-anatomy.md` | Standard spec anatomy |
| `spec-driven/knowledge-architecture/spec-types.md` | Artifact types and lifecycle |
| `spec-driven/docs/getting-started.md` | First spec in 10 minutes |

### Operational guides

| Document | Content |
|----------|---------|
| `spec-driven/docs/guides/create-knowledge-spec.md` | Creating knowledge specs |
| `spec-driven/docs/guides/contextual-activation.md` | Activation pipeline (4 steps) |
| `spec-driven/docs/guides/governance-cycle.md` | RFC → SPEC → ADR |
| `spec-driven/docs/guides/consolidation.md` | Work→Knowledge consolidation |
| `spec-driven/docs/patterns/ams-adoption.md` | AMS adoption pattern (5 phases) |
| `spec-driven/docs/patterns/spec-as-prompt.md` | Specs as context for agents |

### Tools

| Command | Purpose |
|---------|---------|
| `spec-graph validate` | Validate graph integrity |
| `spec-graph stats` | Graph statistics |
| `spec-graph build --html` | Interactive visualization |
| `spec-graph context <id> --depth N` | Contextual activation bundle |
| `spec-graph impact <id>` | Transitive impact analysis |
| `spec-graph orphans` | Detect specs without connections |

---

*Program designed by NFQ Advisory — AI & Data Practice*
*Framework: Knowledge-Driven Development (KDD)*
*Adaptation: Application Maintenance Services (AMS)*
