# CLAUDE.md — Knowledge-Driven Development Framework

## Project Context

This is the **canonical framework** for Knowledge-Driven Development (KDD). It consolidates and supersedes:
- `AI4Arquitecture/KID_v2.md` — Strategic/commercial vision (KID)
- `AI4Modernization/core/spec-driven-approach/methodology.md` — Technical operationalization

Those documents remain as historical references. This project is the single source of truth.

## Language

English. This framework targets international delivery teams and multi-geography clients.

## Structure

```
spec-driven/
├── foundation/                  # Layer 1: Strategic foundations
│   ├── manifesto.md             # The "why" — problems + thesis
│   ├── pillars.md               # 3 pillars: Spec-Driven, Evolutive, Agentic
│   └── principles.md            # 4 design principles
│
├── knowledge-architecture/      # Layer 2: Knowledge architecture
│   ├── unified-taxonomy.md      # ★ Three-axis taxonomy: Knowledge + Work + Governance
│   ├── spec-types.md            # Artifact types + governance lifecycle
│   └── spec-anatomy.md          # Standard spec structure + YAML frontmatter
│
├── apps/                        # Applications
│   └── spec-graph/              # Knowledge graph CLI + library (source)
│       ├── spec-graph.mjs       # CLI (thin wrapper)
│       ├── spec-graph-lib.mjs   # Core library (importable pure functions)
│       ├── spec-graph-viewer.html # Interactive D3.js graph viewer
│       └── package.json         # Dependencies (commander, gray-matter)
│
├── kdd-toolkit/                 # ★ Distributable Claude Code plugin
│   ├── .claude-plugin/          # Plugin manifest
│   ├── cli/                     # spec-graph CLI (bundled copy)
│   ├── skills/                  # 7 slash commands (/kdd:spec-*)
│   ├── agents/                  # KDD Spec Assistant (conversational agent)
│   └── knowledge/               # Condensed framework reference
│
├── docs/                        # Operational documentation
│   ├── getting-started.md       # Entry point for new adopters
│   ├── guides/                  # How-to guides (create specs, plan work, governance)
│   ├── reference/               # Quick lookup (artifact matrix, checklists, adoption levels)
│   ├── patterns/                # Recipes (brownfield, vertical taxonomy, spec-as-prompt)
│   └── *.html                   # Published HTML docs (corporate scroll style)
│
├── infra/                       # Firebase Hosting deployment
│   ├── firebase.json            # Hosting config (multi-site, target: kdd-docs)
│   ├── .firebaserc              # Firebase project strata-491313 + targets
│   ├── deploy.sh                # Build + auth injection + deploy script
│   ├── index.html               # Documentation portal (landing page)
│   ├── auth-snippet.html        # Auth gate snippet (injected into docs by deploy.sh)
│   └── public/                  # Generated — deploy output (gitignored)
│
├── examples/specs/              # Example Knowledge Artifacts (CIB domain)
├── examples/work/               # Example Work Artifacts (WRK-SPEC, WRK-PLAN, WRK-TASK)
└── examples/verticals/          # Vertical taxonomy examples (CIB)
```

## Conventions

- All documents are Markdown
- Formal contracts use native formats: OpenAPI, AsyncAPI, JSON Schema
- Spec IDs follow the pattern: `TYPE-AREA-NNN` (e.g., `DOM-RISK-001`) for Knowledge Artifacts, `WRK-TYPE-NNN` (e.g., `WRK-SPEC-001`) for Work Artifacts
- Confidence levels: HIGH / MEDIUM / LOW
- Status lifecycle: Draft → Active → Deprecated (knowledge specs), Draft → Active → Completed → Archived (work specs), Proposed → Accepted → Superseded (ADRs)
- Three artifact axes: Knowledge (persistent), Work (ephemeral), Governance (bridge) — see `knowledge-architecture/unified-taxonomy.md`

## Working with this framework

When creating or updating specs:
1. Check `knowledge-architecture/spec-anatomy.md` for the standard structure
2. Use the correct spec type from `knowledge-architecture/spec-types.md`
3. Place domain knowledge according to the vertical taxonomy (see `examples/verticals/cib-taxonomy.md` for CIB)
4. Ensure YAML frontmatter is complete and valid
5. Run `node apps/spec-graph/spec-graph.mjs --specs <dir> validate` to check integrity

## Knowledge Graph CLI

Install: `cd apps/spec-graph && npm install && cd ../..`

```bash
node apps/spec-graph/spec-graph.mjs --specs <dir> <command> [options]
```

Commands: `build [--html]`, `visualize`, `impact <id>`, `orphans`, `validate`, `stats`, `filter`, `path <a> <b>`, `context <id> [--depth N]`, `upgrade-impact`.

### `upgrade-impact` — Multi-repo dependency update analysis

Analyzes the impact of upstream spec changes on local work artifacts. Designed for multi-repo setups where knowledge specs are imported as submodules/dependencies.

```bash
spec-graph --specs . upgrade-impact --dep <dir> --from <ref> --to <ref> [--scope work|all] [--json]
```

- `--dep <dir>`: Subdirectory of the dependency repo (e.g., `.specs/domain`)
- `--from <ref>`: Previous git ref (tag, commit, `HEAD~1`)
- `--to <ref>`: New git ref (default: `HEAD`)
- `--scope`: `work` (default) filters to work artifacts only; `all` includes everything
- `--json`: Machine-readable output for CI integration

Severity levels: **HIGH** (activates/implements direct), **MEDIUM** (depends-on/constrained-by direct), **LOW** (transitive depth > 1).

Library function: `upgradeImpact(changedSpecs, graph, { scope })` in `spec-graph-lib.mjs`.

See [README.md](README.md#knowledge-graph-cli) for full command reference and programmatic library API.

## Claude Code Slash Commands

Project-local commands (`.claude/commands/`):
- `/spec-graph <command> [args]` — Query the knowledge graph inline (impact, filter, path, context, etc.)
- `/spec-context <task description>` — Contextual activation: find relevant specs for a task and synthesize a brief
- `/spec-validate [--specs <dir>]` — Validation + interpreted health report
- `/spec-impact <spec-id>` — Impact analysis with business context and review sequence
- `/spec-activate <task-or-id> [--pattern bundle|layered|retrieval]` — Full activation pipeline + prompt generation
- `/spec-create <description>` — One-shot spec creation from natural language
- `/spec-consolidate <WRK-SPEC-ID>` — Post-work consolidation: ADRs, spec updates, knowledge capture

## KDD Toolkit Plugin

`kdd-toolkit/` is a **distributable Claude Code plugin** that packages the CLI, all slash commands, a conversational agent, and condensed framework reference. Teams adopting KDD install this plugin — they don't need the full `spec-driven/` repo.

See `kdd-toolkit/README.md` for installation and usage. Plugin skills are namespaced as `/kdd:spec-*`.

## Published Documentation

HTML docs are published to Firebase Hosting at **https://kdd-docs.web.app**, protected by Google sign-in (domain: `nfq.es`).

### How it works

- `docs/*.html` — Source HTML documents (corporate scroll style, self-contained)
- `infra/deploy.sh` — Copies docs to `public/`, injects auth gate from `auth-snippet.html`, deploys to Firebase
- `infra/index.html` — Portal page with doc cards (auth embedded directly)
- `infra/auth-snippet.html` — Reusable auth snippet using Google Identity Services + sessionStorage

### Adding a new document

1. Create the HTML in `docs/` (use existing docs as style reference)
2. Add a mapping line in `infra/deploy.sh` in the `DOCS` array: `["Source Name.html"]="url-slug.html"`
3. Add a card in `infra/index.html` inside the `doc-grid` div
4. Run `./infra/deploy.sh`

### Firebase project

- **Project**: `strata-491313` (GCP project "Strata")
- **Hosting site**: `kdd-docs` (multi-site — does NOT touch the main Strata app)
- **URL**: https://kdd-docs.web.app
- **Auth**: Google Identity Services with OAuth client `605248850504-ho9henin8ssfmcblljocrn0ak0jua49h.apps.googleusercontent.com`
- **Deploy**: `cd infra && ./deploy.sh` (requires `firebase-tools` CLI + auth)

### Currently published docs

| Slug | Source | Content |
|------|--------|---------|
| `kdd-foundation` | `NFQ - Knowledge Driven Framework foundation.html` | Strategic foundation: manifesto, pillars, principles |
| `kdd-operational` | `NFQ - Knowledge Driven Framework docs.html` | Operational docs: guides, reference, patterns |
| `spec-graph-vs-vector-db` | `NFQ - Spec Graph vs Vector DB.html` | Comparative: knowledge graph vs vector DB |
| `anatomy-coding-agent` | `NFQ - Anatomy of a Coding Agent.html` | Technical: agent architecture + KDD convergence |

## Vertical focus

The initial taxonomy is detailed for **CIB (Corporate & Investment Banking)**. Other verticals (Retail Banking, Insurance, Telco, Utilities) will be added as extensions.
