# KDD Adoption Program — Software Delivery

**Format**: 4 weeks
**Modality**: Weekly workshop (2h) + Real-project coaching (1-2h/week) + Autonomous work (2-3h/week)
**Commitment**: ~5-7h/week per person (20-28h total program)

---

## 1. Framing

### Program objective

The development team **gets familiar with the KDD methodology, understands its value, and starts applying it** on their real project.

Over 4 weeks, the team:

1. **Understands** why structured knowledge changes the way software is built — especially with AI
2. **Practices** by writing real specs from their project (domain rules, architecture decisions, features)
3. **Experiences** the value: uses specs as context for AI agents in feature development and code generation
4. **Adopts** a sustainable cycle where every delivery enriches the knowledge base

### The problem KDD solves

Four failure patterns in teams adopting AI without a knowledge methodology:

1. **Tool-first**: The team adopts the tool (Copilot, ChatGPT) without defining what knowledge it needs. Result: generic suggestions, uncritical acceptance.
2. **Black-box**: Generated code works but nobody understands why. No traceability from requirement to implementation.
3. **Infinite rewrites**: Without clear specs, AI agents generate, devs reject, regenerate, adjust... infinite cycle without convergence.
4. **No governance**: Every developer uses AI their own way. No standard, no audit trail, no organizational learning.

### Thread

```
Week 1: Write specs             →  The team captures what it knows (domain, architecture)
Week 2: Connect specs           →  The graph takes shape, relationships provide context
Week 3: Activate specs + agent  →  Knowledge works for the team (features + code generation)
Week 4: Consolidate + sustain   →  Knowledge grows with every delivery
```

### Audience

| Role | Program role |
|------|-------------|
| Tech Lead / Architect | Champion, writes ARCH specs, leads governance |
| Senior Developer | Writes DOM/FEAT specs, executes work artifacts |
| Developer | Contributes specs from their area, uses spec-as-prompt |
| QA / Tester | Validates acceptance criteria, writes test specs |

**Recommended size**: 4-8 people.

### Greenfield vs Brownfield

| Aspect | Greenfield | Brownfield |
|--------|------------|------------|
| **Starting point** | No code or prior decisions | Existing code, implicit decisions, tech debt |
| **First focus** | Foundational ARCH + DOM of the domain | DOM for critical rules (the ones that cause bugs) |
| **Data source** | Design documents, stakeholder interviews | Git history, Slack threads, tribal knowledge |
| **Risk** | Over-engineering specs before validating | "We already know this, why document?" |
| **Quick win** | Specs as input for AI generation from day 1 | Capture the rule that caused the last production bug |

### Prerequisites

Before week 1, every participant must complete the following:

#### Required reading

| Resource | What it covers | Time |
|----------|---------------|------|
| [KDD Strategic Foundation](https://kdd-docs.web.app/kdd-foundation) | Why KDD exists: the manifesto, three pillars, four design principles | 30 min |
| [KDD Operational Documentation](https://kdd-docs.web.app/kdd-operational) | How to use KDD: guides, reference, patterns | 45 min (skim sections relevant to SDLC) |
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
- Access to at least one AI coding tool (Claude Code, Cursor, Copilot, etc.)

### Tools

| Tool | Purpose | When |
|------|---------|------|
| **Git + Markdown editor** | Write and version specs | From week 1 |
| **spec-graph CLI** | Validate, navigate, activate context | From week 1 |
| **AI coding agent** (Claude Code, Cursor, Copilot, etc.) | Spec-driven development with specs as context | From week 3 |

---

## 2. Week 1 — Foundations: Taxonomy, anatomy, and first specs

> **Objective**: The team understands the KDD framework, masters spec structure, and writes their first DOM and ARCH specs on their real project.

### Workshop (2h)

#### Block 1: KDD Taxonomy — Three artifact axes (25 min)

| Axis | Nature | SDLC examples | Persists? |
|------|--------|---------------|-----------|
| **Knowledge** | What the organization knows | ARCH, DOM, PROD, FEAT, DOC | Yes — grows across projects |
| **Work** | What the team is doing now | WRK-SPEC, WRK-PLAN, WRK-TASK | No — scoped to a delivery |
| **Governance** | How knowledge evolves | ADR (decisions), RULE (constraints), RFC (proposals) | Yes — bridges Knowledge and Work |

**Knowledge spec types for SDLC**:

| Type | ID | What it captures | When to create |
|------|----|-----------------|----------------|
| **Architecture** | ARCH | Technical constraints, patterns, infrastructure decisions | Cross-cutting technical decisions |
| **Domain** | DOM | Business rules, regulatory requirements, domain logic | Rules that multiple features must respect |
| **Product** | PROD | Product-level requirements, user journeys | End-to-end capabilities |
| **Feature** | FEAT | Specific functionality, screens, behaviors | User-facing behavior |
| **Documentation** | DOC | Guides, tutorials, onboarding materials | How-to knowledge |

**Work spec types**:

| Type | ID | What it captures | When to create |
|------|----|-----------------|----------------|
| **Work Spec** | WRK-SPEC | What to build and why, with activated knowledge | Starting a new feature or change |
| **Work Plan** | WRK-PLAN | How to build it (task decomposition, approach) | After WRK-SPEC is defined |
| **Work Task** | WRK-TASK | Atomic unit, implementable by 1 person or agent | Individual implementation units |

Heuristic: Does it affect many features? → **ARCH**. Does the domain expert own it? → **DOM**. Does product own it? → **PROD**. Is it user-facing behavior? → **FEAT**. Is it a how-to? → **DOC**.

#### Block 2: Spec anatomy (25 min)

Every spec has two parts: **YAML frontmatter** (machine-readable metadata) + **Markdown body** (human-readable content).

**Frontmatter** — required fields:

```yaml
---
id: DOM-PAYMENTS-001              # Unique identifier: TYPE-AREA-NNN
type: knowledge                   # knowledge | work | governance
layer: domain                     # architecture | domain | product | feature | documentation
title: Domestic transfer limits
status: draft                     # draft → active → deprecated
confidence: medium                # low | medium | high
version: "0.1.0"
owner: payments-team
domain: payments
tags: [transfers, limits, compliance]
dependencies:
  - id: ARCH-001
    type: constrained-by          # constrained-by | implements | extends | depends-on
---
```

**Body** — standard sections:

| Section | Purpose |
|---------|---------|
| **Intent** | Why does this spec exist? 2-3 sentences. The most important section. |
| **Definition** | The actual content: rules, decisions, capabilities, behavior. |
| **Acceptance Criteria** | How do we know it's correctly implemented? Checklist. |
| **Evidence** | What validates this spec? Test results, regulatory refs, sign-offs. |

**Dependencies** — how specs connect:

| Relation | Meaning | Example |
|----------|---------|---------|
| `constrained-by` | Must respect constraints from another spec | DOM constrained-by ARCH |
| `implements` | Implements a higher-level spec | FEAT implements PROD |
| `extends` | Adds detail to another spec at the same level | DOM-002 extends DOM-001 |
| `depends-on` | Generic dependency | Any layer |
| `activates` | Work artifact activates knowledge as context | WRK-SPEC activates DOM, ARCH |

#### Block 3: Live demo — Your first spec (30 min)

The facilitator writes a spec live. The topic should come from the team's own context — ideally discussed before the workshop. Good candidates:

- A **recent client request** that required clarifying a business rule
- A **recent bug** whose root cause was an undocumented domain rule
- An **architecture decision** the team made recently but didn't formalize
- A **recurring question** that new team members always ask

> **Tip for facilitators**: Ask the team beforehand: *"What's the last thing you had to explain twice?"* — that's your first spec.

**Example** (generic — replace with the team's real topic):

```yaml
---
id: DOM-PAYMENTS-001
type: knowledge
layer: domain
title: Domestic transfer limits
status: draft
confidence: medium
version: "0.1.0"
owner: payments-team
domain: payments
tags: [transfers, limits, compliance]
dependencies:
  - id: ARCH-001
    type: constrained-by
---

## Intent
Define maximum transfer amounts for domestic payments,
ensuring compliance with AML thresholds.

## Definition

### Transfer Limits

| Customer Tier | Single Transfer | Daily Aggregate |
|---------------|---------------:|----------------:|
| Standard      |        €10,000 |         €25,000 |
| Premium       |        €50,000 |        €100,000 |
| Corporate     |       €500,000 |      €1,000,000 |

### Rules
- Transfers exceeding the single limit require dual approval.
- Daily aggregate is calculated on a rolling 24-hour window.
- Corporate limits may be overridden per-client via RULE artifacts.

## Acceptance Criteria
- [ ] Payment service enforces single-transfer limits by tier
- [ ] Daily aggregate check runs before authorization
- [ ] Dual approval flow triggers above threshold

## Evidence
- AML regulation reference: EU Directive 2015/849
- Business validation: Product owner sign-off pending
```

**First spec-graph commands**:

```bash
spec-graph validate          # Any errors in the specs?
spec-graph stats             # How many specs do we have? What types?
```

#### Block 4: Guided exercise (10 min)

Each participant picks a topic from their own area — think of:
- A business rule you've had to explain to a colleague recently
- A client requirement that was discussed last sprint
- An architecture constraint that isn't written anywhere

Write the complete YAML frontmatter for a spec on that topic (frontmatter only, body during autonomous work).

### Coaching (1-2h)

#### Brownfield
1. Identify 3-5 critical domain rules: the ones that cause recurring bugs, require constant explanation, or are one person's tribal knowledge
2. Write DOM specs for each identified rule
3. Coexistence strategy: specs coexist with existing wikis; gradual migration

#### Greenfield
1. Define foundational ARCH specs: tech stack, architecture patterns, integration constraints
2. Write DOM specs for the project's domain: entities, business rules, validations
3. Use specs as the single source of truth from day 1

#### Both
- Complete frontmatter, honest `confidence` levels (low/medium for first specs)
- Declare dependencies between specs
- `spec-graph validate` when done

### Autonomous work

- Each member writes 1-2 specs from their area
- Repository setup:
  ```
  specs/
  ├── architecture/    # ARCH specs
  ├── domain/          # DOM specs
  ├── product/         # PROD specs
  ├── features/        # FEAT specs
  └── docs/            # DOC specs
  ```

### Week 1 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| `specs/` directory created | ✓ | ✓ |
| DOM specs written | 3 | 5+ |
| ARCH specs written | 2 | 3+ |
| Dependencies declared | ✓ | ✓ |
| `spec-graph validate` executed | ✓ | ✓ |
| Team aligned on taxonomy and anatomy | ✓ | ✓ |

---

## 3. Week 2 — The graph: Relationships, governance, and quality

> **Objective**: The team connects specs into a navigable graph, introduces governance (ADR, RULE), and raises spec quality through review.

### Workshop (2h)

#### Block 1: The knowledge graph — From isolated specs to a network (30 min)

Individual specs have value, but exponential value is in the **relationships**.

```
ARCH-001 (microservices pattern)
    │
    ├── constrained-by ←── DOM-PAYMENTS-001 (transfer limits)
    │                          │
    │                          └── implements ←── FEAT-TRANSFER-001 (transfer screen)
    │
    └── constrained-by ←── DOM-PAYMENTS-002 (AML validation)
                               │
                               └── implements ←── FEAT-AML-001 (AML check service)
```

**spec-graph** to navigate the graph:

```bash
spec-graph build --html              # Interactive graph visualization
spec-graph context DOM-PAYMENTS-001 --depth 2   # What's connected?
spec-graph impact ARCH-001                       # What's affected if this changes?
spec-graph orphans                               # Specs without connections
```

#### Block 2: Governance — RFC → SPEC → ADR (45 min)

| Artifact | When to use | Example |
|----------|-------------|---------|
| **RFC** | Significant change affecting multiple teams/specs | Migrate from REST to gRPC |
| **SPEC** | New knowledge, local improvement | New domain rule |
| **ADR** | Record a decision (with or without prior RFC) | "We chose PostgreSQL because..." |
| **RULE** | Permanent constraint applying to multiple specs | "Every feature requires a WRK-SPEC" |

**ADR structure**:

```yaml
---
id: ADR-001
type: governance
layer: architecture
title: Selection of primary database
status: accepted
date: 2026-03-25
---

## Context
[Situation that motivated the decision]

## Decision
[One clear sentence]

## Rationale
[Why this option and not the alternatives]

## Consequences
- **Positive**: ...
- **Negative**: ...
- **Risks**: ...

## Alternatives considered
1. [Option B] — discarded because...
```

**Tip**: Write ADRs even for rejected proposals — the reasoning has value.

#### Block 3: Spec quality — Confidence levels and review (25 min)

| Level | Meaning | When to assign |
|-------|---------|----------------|
| **LOW** | Inferred, not validated | First capture from docs or conversations |
| **MEDIUM** | Validated OR reviewed | Tested in code or reviewed by peer |
| **HIGH** | Validated AND reviewed | Tested in production and reviewed by domain expert |

Review checklist:
- Is frontmatter complete?
- Are dependencies declared?
- Are acceptance criteria testable?
- Is the confidence level honest?

```bash
spec-graph validate       # Integrity errors
spec-graph orphans        # Specs without connections
spec-graph stats          # Overview
```

#### Block 4: Live demo — Write an ADR + review specs (20 min)

- **Brownfield**: Retroactive ADR — mine a past architecture decision and document it
- **Greenfield**: Foundational ADR — document a recent stack decision

Then cross-review 2-3 specs in pairs using the quality checklist.

### Coaching (1-2h)

#### Brownfield
1. Mine past decisions: review git history, Slack threads, meeting notes
2. Write 2-3 retroactive ADRs
3. Complete dependencies between week 1 specs

#### Greenfield
1. Write foundational ADRs: stack, framework, communication patterns
2. Establish ARCH specs with well-declared dependencies

#### Both
- Cross-review week 1 specs
- Raise confidence levels where appropriate
- `spec-graph validate` clean
- Resolve orphans

### Autonomous work

- Each member writes 1+ new spec and reviews 2 specs from peers
- Explore the graph with `spec-graph build --html`
- Connect orphaned specs

### Week 2 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| ADRs written | 2 | 4+ |
| `spec-graph validate` without errors | ✓ | ✓ |
| Graph visualized (`build --html`) | ✓ | ✓ |
| Cross-review completed | ✓ | ✓ |
| Orphans resolved | ✓ | ✓ |
| Total specs accumulated | 10 | 15+ |

---

## 4. Week 3 — Activation: Specs as context for agents

> **Objective**: The team learns to **activate** specs as context and use them with an AI agent for spec-driven feature development. This is the week where everything clicks.

### Workshop (2h)

#### Block 1: Contextual activation — The pipeline (30 min)

**The problem**: an AI coding agent without project-specific context generates generic code. An agent with the right specs as context generates code aligned with the team's architecture, domain rules, and patterns.

**Activation pipeline** — 4 steps to select which specs to pass to the agent:

| Step | What it does | How | Tool |
|------|-------------|-----|------|
| **1. Explicit** | Identify what knowledge the task needs | `activates` field in WRK-SPEC | Team knowledge |
| **2. Transitive** | Follow dependencies for complete context | `spec-graph context <id> --depth 2` | spec-graph CLI |
| **3. Filtered** | Remove specs not relevant to the current scope | By SDLC phase, domain, layer | Manual or flag |
| **4. Budgeted** | Limit the bundle to what the agent can process | 5-10 specs per WRK-SPEC, 2-5 per WRK-TASK | Pragmatism |

**Activation matrix by SDLC phase**:

| Phase | Primary specs | Secondary specs | Typical bundle |
|-------|--------------|-----------------|----------------|
| **Requirements** | PROD (product vision), DOM (business rules) | ARCH (constraints) | 4-8 specs |
| **Design** | ARCH (patterns), DOM (rules) | PROD (context), FEAT (existing behavior) | 5-10 specs |
| **Build** | FEAT (what to build), DOM (rules to respect) | ARCH (patterns to follow) | 3-7 specs |
| **Test** | DOM (rules to validate), FEAT (expected behavior) | PROD (acceptance criteria) | 3-6 specs |
| **Review** | ADR (decisions), ARCH (standards) | DOM (compliance) | 2-5 specs |

#### Block 2: Work artifacts — WRK-SPEC → WRK-PLAN → WRK-TASK (20 min)

| Artifact | Purpose | Owner | Scope |
|----------|---------|-------|-------|
| **WRK-SPEC** | What and why (scope, constraints, activated knowledge) | Tech Lead / Architect | Complete feature |
| **WRK-PLAN** | How (task decomposition, technical approach) | Tech Lead | Implementation approach |
| **WRK-TASK** | Do (atomic unit, implementable by 1 person or agent) | Dev / AI Agent | Specific files |

Key field in WRK-SPEC — `activates`:

```yaml
activates:
  - DOM-PAYMENTS-001    # Transfer limits rule
  - ARCH-002            # Validation pattern
  - FEAT-TRANSFER-003   # Existing transfer feature
```

**Sizing**: 3-8 WRK-TASKs per WRK-PLAN. If more, the scope is too broad.

#### Block 3: Spec-driven development agent — Live demo (40 min)

**Scenario**: The team needs to implement a new feature. They use specs as context for an AI coding agent.

**Complete flow**:

```
1. FEATURE REQUEST
   "Add dual approval for transfers above €10,000"
        │
2. WRK-SPEC (what and why)
   → activates: DOM-PAYMENTS-001, ARCH-002, FEAT-TRANSFER-001
        │
3. ACTIVATE CONTEXT
   → spec-graph context WRK-SPEC-001 --depth 2
   → Bundle: domain rules + architecture patterns + existing feature behavior
        │
4. WRK-PLAN + WRK-TASKs — with agent assistance
   → Agent receives bundle + WRK-SPEC
   → Proposes implementation plan aligned with architecture
   → Decomposes into atomic tasks
        │
5. IMPLEMENT EACH WRK-TASK — with agent
   → Agent receives task + relevant specs from bundle
   → Generates code that respects domain rules (not invented)
   → Code follows architecture patterns (not generic)
   → Acceptance criteria from specs validate the output
        │
6. CONSOLIDATE
   → DOM updated if business rules were clarified during development
   → ARCH updated if new patterns were established
   → FEAT updated to reflect new behavior
   → ADR written for significant decisions made during implementation
```

**Live demo**: execute this flow with a real feature from the team's backlog using Claude Code, Cursor, or equivalent.

**Prompt template for feature implementation**:

```markdown
## Feature to implement
[Paste WRK-SPEC content: what, why, acceptance criteria]

## Domain rules that apply
[Paste DOM specs — business rules this feature must respect]

## Architecture patterns to follow
[Paste ARCH specs — patterns, constraints, standards]

## Existing feature behavior
[Paste FEAT spec — how the affected area works today]

## Previous decisions
[Paste related ADRs]

## Task
Implement the following specific task:
[Paste WRK-TASK content]

Ensure the implementation:
- Respects all domain rules from the DOM specs
- Follows architecture patterns from ARCH specs
- Passes the acceptance criteria from the WRK-SPEC
```

**Prompt template for code review with specs**:

```markdown
## Code to review
[Paste or reference the code]

## Specs this code should satisfy
[Paste relevant DOM, ARCH, FEAT specs]

## Question
Does this code correctly implement the specs?
Are there any domain rules being violated?
Are there architecture patterns not being followed?
What acceptance criteria pass/fail?
```

#### Block 4: Hands-on exercise (30 min)

In pairs:
1. Pick a feature from the backlog (real or recent)
2. Write a WRK-SPEC with `activates` pointing to existing knowledge specs
3. Run `spec-graph context <WRK-SPEC-ID> --depth 2` to see the activation bundle
4. Feed the bundle to an AI agent and ask for an implementation plan
5. Compare: does the plan respect domain rules? Follow architecture patterns? Is it better than without specs?

### Coaching (1-2h)

1. Take a real feature/task from the current sprint
2. Write WRK-SPEC with `activates` pointing to relevant specs
3. Decompose into WRK-PLAN + 2-3 WRK-TASKs
4. Execute activation + agent flow for at least 1 WRK-TASK
5. Review: does the generated code align with specs?

#### Brownfield extra
- Activation reveals gaps: specs that should exist but haven't been written
- Document as spec backlog

#### Greenfield extra
- Use the activation bundle directly for generation
- Compare agent output with and without activated specs

### Autonomous work

- Each member implements 1 task using spec-as-prompt: activation bundle → agent → code → validate against acceptance criteria
- Refine specs based on what the agent "needed" and didn't find
- Write 1-2 new specs revealed as necessary during practice

### Anti-pattern

> **Don't feed the agent everything** — select relevant specs. A bundle of 20 specs produces diffuse code; a bundle of 3-5 focused specs produces precise, aligned implementations.

### Week 3 deliverables

| Criterion | Minimum | Desirable |
|-----------|---------|-----------|
| Feature with WRK-SPEC written | 1 | 2+ |
| WRK-PLAN + WRK-TASKs created | 1 plan + 2 tasks | 1 plan + 4+ tasks |
| Activation + agent flow executed | 1 task | 3+ tasks |
| Prompt templates documented | 2 (implement + review) | 3+ |
| Specs refined after agent practice | 2 | 5+ |

---

## 5. Week 4 — Consolidate: Metrics, quality, and sustainability

> **Objective**: Establish a metrics baseline, practice the consolidation cycle, and define how the team will continue growing knowledge autonomously.

### Workshop (2h)

#### Block 1: The consolidation cycle (30 min)

The **Evolutive** pillar in action: how every delivery returns knowledge to the base.

```
Standards → Adapt → Execute & Validate → Consolidate → Standards (updated)
```

After completing a WRK-SPEC:
1. Were undocumented domain rules discovered? → Create/update DOM specs
2. Were architecture decisions made? → Write ADR
3. Were reusable patterns identified? → Create ARCH or FEAT specs
4. Did any constraint change? → Update existing spec + version bump
5. Can confidence be raised? → LOW→MEDIUM→HIGH based on validation

**The consolidation checklist** makes this systematic, not ad-hoc.

#### Block 2: RULE specs — "How we work" codified (15 min)

Examples:
- "Every new feature requires a WRK-SPEC with `activates` before implementation"
- "Every architecture change requires an ADR"
- "Specs are reviewed in PRs like code"
- "Confidence level is updated after production validation"

#### Block 3: Adoption metrics (25 min)

Four metrics to measure whether knowledge is working for the team:

| Metric | What it measures | How to measure |
|--------|-----------------|---------------|
| **Spec Coverage** | % of active features/rules with a corresponding spec | Cross-reference backlog with spec repository |
| **Agent Alignment** | Quality of agent output with specs vs without | Qualitative team evaluation |
| **Consolidation Rate** | % of deliveries that produce spec updates | Count WRK-SPECs with completed consolidation |
| **Decision Documentation** | % of architecture decisions with an ADR | Count ADRs vs known decisions |

Precision is not required: informed team estimates are sufficient to establish a baseline.

#### Block 4: Roadmap and sustainability (30 min)

**What already works** (consolidate):
- Writing specs as part of the development workflow
- Using activation + agent for feature implementation
- Consolidating after each significant delivery
- Reviewing specs periodically

**What comes next** (roadmap):

| Horizon | Focus | Capabilities |
|---------|-------|-------------|
| **Month 2-3** | CI integration | `spec-graph validate` in pipelines, orphan detection, graph publishing |
| **Month 3-5** | Code generation pipelines | Specs as input for automated generation, generated artifacts linked to specs |
| **Month 5+** | Full agent orchestration | Automated activation pipeline, semi-automatic consolidation, RFC→SPEC→ADR integrated |

**Program retrospective** (facilitated):
- Which specs were most useful for development?
- Where is the biggest knowledge gap?
- Is the consolidation cycle sustainable?
- Do the agent prompts need improvement?

### Coaching (1-2h)

1. **Measure baseline**: current state of the 4 metrics
2. **Full graph review**: resolve all gaps, orphans, broken dependencies
3. **Write 2-3 ADRs** for decisions made during the program
4. **Codify 2-3 RULEs** the team has adopted
5. **Plan month 2**: which specs are missing? what to automate first?

### Autonomous work

- Document metrics baseline
- Identify 1-2 champions who will lead continued adoption
- Schedule **weekly spec review** (30 min) as part of the workflow
- Complete pending specs
- Retrospective as ADR

### Anti-pattern

> **Don't over-engineer specs before validating** — start with low/medium confidence and let production validation raise them. Perfectionism kills adoption.

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

## 6. Summary: Greenfield vs Brownfield

| Week | Greenfield | Brownfield |
|------|------------|------------|
| **1** | Foundational ARCH + DOM of the domain | DOM for critical rules (the ones that cause bugs) |
| **2** | Foundational ADRs, design-time dependencies | Retroactive ADRs, discover implicit dependencies |
| **3** | Activation bundle as direct input for generation | Activation reveals knowledge gaps |
| **4** | Clean baseline + accelerate toward generation | Complete coverage + close gaps |

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

### Guides

| Document | Content |
|----------|---------|
| `spec-driven/docs/guides/create-knowledge-spec.md` | Creating knowledge specs |
| `spec-driven/docs/guides/create-work-spec.md` | WRK-SPEC → WRK-PLAN → WRK-TASK |
| `spec-driven/docs/guides/contextual-activation.md` | Activation pipeline (4 steps) |
| `spec-driven/docs/guides/governance-cycle.md` | RFC → SPEC → ADR |
| `spec-driven/docs/guides/consolidation.md` | Work→Knowledge consolidation |
| `spec-driven/docs/patterns/spec-as-prompt.md` | Specs as context for agents |
| `spec-driven/docs/patterns/brownfield-adoption.md` | Adopting KDD in existing projects |

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
*Adaptation: Software Delivery (SDLC)*
