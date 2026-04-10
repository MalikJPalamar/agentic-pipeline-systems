# Agentic Pipeline Systems

### Phone → Agents → Production — zero humans in the execution loop

<p align="center">
  <strong>By <a href="https://centaurion.me">Malik Palamar</a></strong> — Centaurion.me / BuilderBee / Alchemy of Breath<br>
  Built on <a href="https://github.com/github/gh-aw">GitHub Agentic Workflows</a> + <a href="https://github.com/gsd-build/get-shit-done">GSD</a> + Autoresearch
</p>

---

## What This Is

An infrastructure repo for **autonomous agentic pipelines** — from a voice command on your phone to a live deployed artifact, with no human in the execution loop. Think DevOps, but for AI agents.

Each pipeline is a `gh-aw` workflow: a Markdown file that compiles to a hardened GitHub Actions YAML. Agents run sandboxed inside Actions, produce output through safe-outputs (PRs, issues), pass CI quality gates, and deploy automatically.

## Architecture

```
Phone (voice/text)
  → Telegram bot (intent → structured JSON spec)
    → GitHub API: workflow_dispatch
      → gh-aw workflow (.md in .github/workflows/)
        → Agent swarm runs in GitHub Actions
          → TDD: tests written FIRST, code must pass
          → Prototype built against component registry
          → PR created via safe-outputs
            → CI quality gates (Lighthouse, Playwright, ESLint)
              → Auto-merge on green / phone approval on amber
                → Dokploy webhook → live deployment
                  → Post-deploy verification agent
                    → Telegram notification: live URL + scores
```

## Design Principles

1. **Phone-first** — if you need a laptop to intervene, it's not autonomous (Centaurion Level 9)
2. **TDD** — tests written before code, agent must pass them before PR creation
3. **Prototype-driven** — component registry + design system, not generation from scratch
4. **Autoresearch** — every pipeline self-improves: measure → hypothesize → experiment → keep/discard
5. **Spec-driven (GSD)** — structured specs prevent context rot, phases prevent drift
6. **Multi-agent** — orchestrator assigns work, specialists execute, reviewers validate
7. **Daily iteration** — scheduled workflows run overnight for feature dev, testing, security

## Pipelines

| Pipeline | Trigger | Output | Deploy |
|----------|---------|--------|--------|
| `web-page` | "Build landing page for X" | HTML/React + assets | Dokploy / Vercel |
| `content` | "Write blog post about X" | Markdown → CMS | WP Engine / GHL |
| `data` | "Generate monthly report" | Dashboard / PDF | Supabase / Email |
| `seo` | "Optimize pages for Y" | Updated meta + content | Git push |
| `code-feature` | "Add feature X to project Y" | Feature branch → PR | Dokploy |
| `daily-iteration` | Scheduled (9pm CET) | Tests, fixes, security patches | Auto-merge |

## Multi-Agent Orchestration

```
┌─────────────────────────────────────────────┐
│              ORCHESTRATOR AGENT              │
│  Reads spec → decomposes → assigns work     │
│  Monitors progress → handles failures       │
└──────┬──────────┬──────────┬───────────┬────┘
       │          │          │           │
  ┌────▼───┐ ┌───▼────┐ ┌──▼───┐ ┌────▼─────┐
  │ SPEC   │ │ BUILD  │ │ TEST │ │ REVIEW   │
  │ AGENT  │ │ AGENT  │ │ AGENT│ │ AGENT    │
  │        │ │        │ │      │ │          │
  │ Parse  │ │ Code   │ │ TDD  │ │ Security │
  │ intent │ │ from   │ │ first│ │ a11y     │
  │ load   │ │ spec + │ │ then │ │ perf     │
  │ reg.   │ │ comps  │ │ impl │ │ brand    │
  └────────┘ └────────┘ └──────┘ └──────────┘
```

## Daily Scheduled Iteration (Autoresearch Pattern)

Every weekday at 9pm CET, a scheduled workflow runs:

1. **Feature iteration** — picks highest-priority open issue, plans fix, implements, tests
2. **Test coverage** — identifies untested paths, writes tests, submits PR
3. **Security scan** — runs dependency audit + static analysis, auto-patches known CVEs
4. **Methodology evolution** — scores yesterday's output, proposes ONE improvement, keep/discard

The autoresearch loop (Karpathy pattern):
```
Hypothesis → Experiment → Measure → Keep or Discard → Repeat
```

Applied to every pipeline: each run is scored on a **Composite Metric** (accuracy + actionability + coverage), logged to `autoresearch/results.tsv`, and methodology evolves monotonically.

## Quick Start

```bash
# 1. Install gh-aw CLI
gh extension install github/gh-aw

# 2. Clone this repo
git clone https://github.com/MalikJPalamar/agentic-pipeline-systems.git
cd agentic-pipeline-systems

# 3. Set secrets
gh secret set ANTHROPIC_API_KEY

# 4. Compile workflows
gh aw compile

# 5. Test the web-page pipeline
gh aw run web-page-pipeline --input spec='{"title":"Test Page","purpose":"Smoke test","brand":"centaurion","tone":"bold","cta_text":"Go","cta_url":"#"}'

# 6. Initialize GSD for structured development
npx get-shit-done-cc --claude --local
/gsd:init
```

## Project Structure

```
.github/workflows/          ← gh-aw Markdown workflows + compiled YAML
  web-page-pipeline.md
  content-pipeline.md
  daily-iteration.md
  ...
.planning/                  ← GSD project state
  CONTEXT.md
  ROADMAP.md
  phases/
agents/                     ← Agent role definitions
  orchestrator.md
  spec-agent.md
  build-agent.md
  test-agent.md
  review-agent.md
autoresearch/               ← Self-improvement loop
  program.md                ← Governing methodology (human-controlled)
  methodology.md            ← Active methodology (agent-evolved)
  results.tsv               ← Experiment log
  changelog.md              ← Keep/discard history
skills/                     ← Pipeline-specific resources
  shared/design-system.json
  web-page/registry.json
  content/templates.json
tests/                      ← TDD test specs (written before code)
docs/                       ← Architecture docs
```

## License

MIT
