# PROJECT: Universal Agent-to-Production Pipeline (UAPP)

## GSD Spec — Initialized 2026-04-02

---

## Vision

**One sentence:** Phone command → agents build → live deployment — no humans in the execution loop.

**Metaphor:** A **printing press pipeline**. You speak (input), the typesetter (agent) formats it, the press (Git + CI/CD via gh-aw) stamps it, and the newsstand (Dokploy/Vercel/hosting) displays it. Any typesetter can feed the same press. Any press can feed any newsstand.

**Level 9 design constraint:** Phone-first. If you need a laptop to intervene, it's still Level 7 with a deploy script.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    COMMAND LAYER                             │
│  Phone (voice/text) → Telegram/Claude → Intent Parsing      │
└──────────────────────────┬──────────────────────────────────┘
                           │ workflow_dispatch (GitHub API)
┌──────────────────────────▼──────────────────────────────────┐
│                    ORCHESTRATION LAYER                       │
│  gh-aw (GitHub Agentic Workflows)                           │
│  - Markdown specs → compiled Actions YAML                    │
│  - Sandboxed execution, safe-outputs, network isolation      │
│  - Multi-engine: Claude / Codex / Copilot                    │
└──────────────────────────┬──────────────────────────────────┘
                           │ agent runs in GitHub Actions
┌──────────────────────────▼──────────────────────────────────┐
│                    EXECUTION LAYER                           │
│  Pipeline-specific agents (code, content, data, SEO)         │
│  - Component registry → scaffold → build → test              │
│  - GSD spec-driven: no context rot, verified outputs         │
└──────────────────────────┬──────────────────────────────────┘
                           │ PR created via safe-outputs
┌──────────────────────────▼──────────────────────────────────┐
│                    QUALITY GATE LAYER                        │
│  CI/CD checks: Lighthouse, tests, visual regression          │
│  - Auto-merge if green OR phone approval if amber            │
│  - AgentOps observability: cost, tokens, traces              │
└──────────────────────────┬──────────────────────────────────┘
                           │ merge → webhook
┌──────────────────────────▼──────────────────────────────────┐
│                    DEPLOYMENT LAYER                          │
│  Dokploy (Hostinger VPS) / Vercel / GHL                      │
│  - Git-push deploy                                           │
│  - Post-deploy verification: agent loads live URL             │
│  - Notification to phone with live link                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Pipelines (Each is a gh-aw workflow)

| Pipeline       | Input                          | Output                         | Deploy Target        |
|----------------|--------------------------------|--------------------------------|----------------------|
| **Web Page**   | "Build landing page for X"     | HTML/React page + assets       | Dokploy / Vercel     |
| **Content**    | "Write blog post about X"      | Markdown → WordPress/GHL       | WP Engine / GHL      |
| **Data**       | "Generate AOB monthly report"  | Dashboard / PDF / Supabase     | Supabase / Email     |
| **SEO**        | "Optimize X pages for Y"       | Updated meta, content, links   | Git push to site     |
| **Code**       | "Add feature X to project Y"   | Feature branch → PR → merge    | Dokploy              |

---

## Tech Stack

| Layer            | Tool                        | Why                                              |
|------------------|-----------------------------|--------------------------------------------------|
| Command          | Telegram Bot API            | Voice/text, TTS, mobile-native                   |
| Intent Parsing   | Claude API                  | Natural language → structured spec                |
| Orchestration    | gh-aw (GitHub Actions)      | Markdown workflows, sandboxed, auditable          |
| Execution        | Claude Code / Codex         | Multi-engine, spec-driven via GSD                 |
| Quality Gates    | Lighthouse, Playwright, ESLint | Deterministic backpressure                     |
| Observability    | AgentOps                    | Token costs, session traces, LLM monitoring       |
| Deployment       | Dokploy (VPS)               | Git-push deploy, already running                  |
| Notification     | Telegram Bot API            | Close the loop back to phone                      |
| Spec Management  | GSD (get-shit-done)         | Prevents context rot, phases work, verifies output|

---

## Milestones

### Milestone 1: Foundation (The Press)

Get a single gh-aw workflow running end-to-end: manual trigger → agent builds a static page → PR created → CI passes → deployed.

**Success criteria:** `gh aw run web-page-pipeline` produces a live URL within 10 minutes.

### Milestone 2: Phone Trigger (The Starter Gun)

Wire Telegram bot to GitHub API `workflow_dispatch`. Voice/text input → intent parsed → workflow triggered with parameters.

**Success criteria:** Voice message on Telegram → live URL notification on same phone.

### Milestone 3: Quality Gates (The Inspector)

Add Lighthouse, visual regression, and auto-merge logic. Amber results → phone approval gate. Green → auto-merge + deploy.

**Success criteria:** Sub-threshold Lighthouse score blocks deployment, agent self-corrects and re-runs.

### Milestone 4: Pipeline Multiplication

Clone the web page pipeline pattern to content, data, SEO, and code pipelines. Each is a separate `.md` workflow in `.github/workflows/`.

**Success criteria:** Five pipelines operational, all phone-triggerable.

### Milestone 5: Observability & Cost Control

Integrate AgentOps for token/cost tracking. Add budget guardrails (kill workflow if estimated cost exceeds threshold).

**Success criteria:** Dashboard showing cost-per-pipeline, alert on budget breach.

---

## Phase Breakdown (GSD-compatible)

### Phase 1: gh-aw Setup & First Workflow
- Install gh-aw CLI on local machine
- Configure ANTHROPIC_API_KEY secret in MalikJPalamar/gh-aw
- Create `web-page-pipeline.md` workflow (see WORKFLOW-SPEC.md)
- Compile with `gh aw compile`
- Test with `gh aw run web-page-pipeline`
- Verify: PR created with built page, CI green, deployable

### Phase 2: Component Registry
- Create `registry.json` — typed component catalog
- Design system tokens (spacing, colors, typography)
- 5–10 starter templates (landing, blog, product, event, minimal)
- Agent reads registry, doesn't generate from scratch

### Phase 3: Telegram Command Interface
- Telegram bot with Whisper/Deepgram TTS
- Intent parser: voice → structured JSON spec
- GitHub API integration: `POST /repos/{owner}/{repo}/dispatches`
- Confirmation flow: bot sends spec summary, user approves

### Phase 4: CI/CD Quality Gates
- Lighthouse CI action (performance, accessibility, SEO thresholds)
- Playwright smoke tests (page loads, links work, forms submit)
- Visual regression (screenshot comparison against design system)
- Auto-merge on green, phone notification on amber/red

### Phase 5: Deployment Bridge
- Dokploy webhook on merge-to-main
- Post-deploy verification agent (loads live URL, checks SSL, runs synthetic flow)
- Telegram notification with live link + Lighthouse scores

### Phase 6: Pipeline Multiplication
- Clone web-page pattern → content-pipeline.md
- Clone → data-pipeline.md
- Clone → seo-pipeline.md
- Clone → code-feature-pipeline.md
- Each with pipeline-specific quality gates

### Phase 7: Observability Layer
- AgentOps integration in each workflow
- Cost-per-pipeline tracking
- Token budget guardrails (kill if over threshold)
- Weekly digest: pipelines run, costs, success rates

---

## Risks & Mitigations

| Risk                                    | Mitigation                                              |
|-----------------------------------------|---------------------------------------------------------|
| Agent produces garbage output           | Component registry + design system constraints          |
| Token costs spiral                      | AgentOps budget guardrails, model routing (cheap first)  |
| gh-aw is technical preview              | Fork already made, can pin to known-good version         |
| Spec fidelity from voice                | Multi-round confirmation on Telegram before dispatch     |
| CI gate flakiness                       | Retry logic, agent self-correction before escalation     |
| Dokploy webhook fails                   | Fallback: manual `git push` trigger, alert to phone      |

---

## Repository Structure

```
MalikJPalamar/gh-aw/
├── .github/
│   └── workflows/
│       ├── web-page-pipeline.md          ← gh-aw workflow (Markdown)
│       ├── web-page-pipeline.lock.yml    ← compiled Actions YAML
│       ├── content-pipeline.md           ← Phase 6
│       ├── data-pipeline.md              ← Phase 6
│       ├── seo-pipeline.md               ← Phase 6
│       └── code-feature-pipeline.md      ← Phase 6
├── skills/
│   ├── web-page/
│   │   ├── SKILL.md
│   │   └── registry.json
│   ├── content/
│   │   └── SKILL.md
│   └── shared/
│       └── design-system.json
├── .planning/                            ← GSD project state
│   ├── CONTEXT.md
│   ├── ROADMAP.md
│   └── phases/
└── AGENTS.md                             ← gh-aw agent configuration
```

---

## Decision Log

| Date       | Decision                                    | Rationale                                     |
|------------|---------------------------------------------|-----------------------------------------------|
| 2026-04-02 | Use gh-aw as orchestration layer            | GitHub Actions = built-in orchestrator, no custom infra needed |
| 2026-04-02 | GSD for spec management                     | Prevents context rot, phases work, verified outputs |
| 2026-04-02 | Telegram as phone interface                 | Already designed in UAPP v1, TTS support, mobile-native |
| 2026-04-02 | Component registry before voice interface   | Build inside-out: agents need parts before commands |
| 2026-04-02 | AgentOps for observability                  | 2-line integration, MIT, tracks cost/tokens/traces |
