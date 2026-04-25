# KDD Toolkit — Gemini Code Assist

Knowledge-Driven Development toolkit for delivery teams using Gemini. Manage specs, analyze knowledge graphs, activate context for AI agents, and guide spec creation — all from Gemini Code Assist.

## What's Included

| Component | Description |
|-----------|-------------|
| **7 Skills** | Slash commands: `/kdd:spec-graph`, `/kdd:spec-validate`, `/kdd:spec-context`, `/kdd:spec-impact`, `/kdd:spec-activate`, `/kdd:spec-create`, `/kdd:spec-consolidate` |
| **1 Agent** | `kdd-spec-assistant` — conversational guide for multi-step KDD workflows (create specs, plan work, consolidate knowledge) |
| **CLI** | `spec-graph` — knowledge graph builder, validator, and analyzer |
| **Knowledge base** | Condensed KDD framework reference (taxonomy, spec anatomy, quick reference) |

## Installation

### As a project dependency

```bash
# Copy the gemini/ folder to your project root
cp -r gemini/ <your-project>/gemini/

# Install CLI dependencies
cd <your-project>/gemini/cli && npm install
```

### As a git submodule

```bash
# Add to your project
git submodule add <repo-url> .gemini

# Install CLI dependencies
cd .gemini/cli && npm install
```

## Setup

Create a `specs/` directory in your project root — this is where the toolkit looks for specs by default:

```bash
mkdir specs
```

## Usage

### Skills (slash commands)

```
/kdd:spec-validate                          # Health report for your specs
/kdd:spec-validate --specs ./my-specs       # Custom specs directory

/kdd:spec-impact DOM-RISK-001              # Impact analysis for a spec
/kdd:spec-context "settlement netting"      # Find relevant specs for a topic
/kdd:spec-activate WRK-TASK-001            # Generate activation prompt for a task
/kdd:spec-create "domain spec for payment validation rules"
/kdd:spec-consolidate WRK-SPEC-001         # Post-work knowledge consolidation

/kdd:spec-graph stats                      # Graph metrics
/kdd:spec-graph filter --layer domain      # Filter specs
```

### Agent

Start a conversation with the KDD Spec Assistant for guided, multi-step workflows:

- **Create a Knowledge Spec**: "I want to formalize our settlement netting rules"
- **Create Work Artifacts**: "Plan the VaR engine redesign"
- **Consolidate**: "We finished WRK-SPEC-001, let's capture what we learned"

### CLI (standalone)

```bash
node cli/spec-graph.mjs --specs <dir> <command> [options]

# Commands: build, validate, stats, filter, impact, context, orphans, path, visualize
```

## Project Structure

```
gemini/
├── agents/                       # Conversational agent (AGENT.md)
├── cli/                          # spec-graph CLI + library
├── skills/                       # 7 slash commands
├── knowledge/                    # KDD framework reference
├── settings.json                 # Default permissions
└── README.md
```

## Specs Directory Convention

The toolkit looks for specs in this order:
1. Explicit `--specs <dir>` argument
2. `specs/` directory in your project root
3. Current directory

## Learn More

- [KDD Framework](https://github.com/your-org/spec-driven) — Full framework documentation
- `knowledge/taxonomy-reference.md` — Three-axis taxonomy
- `knowledge/spec-anatomy-reference.md` — Spec structure and frontmatter
- `knowledge/quick-reference.md` — Artifact matrix and checklist
