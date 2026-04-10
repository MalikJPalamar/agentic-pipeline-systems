# CONTEXT.md — UAPP (Universal Agent-to-Production Pipeline)

## Domain Boundary

This project lives in the `MalikJPalamar/gh-aw` repository (fork of `github/gh-aw`). It extends GitHub Agentic Workflows with custom pipeline specs for autonomous web page, content, data, SEO, and code-feature generation — all triggerable from a phone.

## Canonical References

| Ref | Source | Purpose |
|-----|--------|---------|
| gh-aw docs | https://github.github.com/gh-aw/ | Workflow syntax, safe-outputs, frontmatter, network config |
| gh-aw create guide | https://github.com/github/gh-aw/blob/main/create.md | How to author new workflows |
| GSD methodology | https://github.com/gsd-build/get-shit-done | Spec-driven development, /gsd:* commands |
| UAPP v1 spec | Prior chat: Universal Agent-to-Production Pipeline | Original architecture: voice → spec → agents → deploy |
| Centaurion Level 9 | github.com/MalikJPalamar/centaurion-agentic-engineering-lvl | Phone-first autonomous deployment definition |
| AgentOps | https://github.com/AgentOps-AI/agentops | Observability layer for agent monitoring |

## Decisions by Category

### Architecture
- **GitHub Actions IS the orchestrator** — no custom agent runner needed. gh-aw compiles Markdown to hardened YAML.
- **Safe-outputs pattern** — agents never get direct write access. PRs and issues are created through validated outputs.
- **Static HTML first** — no build tools, no npm in the pipeline. Pages are self-contained HTML + Tailwind CDN. Build complexity added in later milestones.

### Integration
- **Telegram bot triggers via `workflow_dispatch`** — GitHub API endpoint, JSON spec as input payload.
- **Dokploy deploys on merge** — webhook on `main` branch push. Already configured on Hostinger VPS.
- **AgentOps added per-workflow** — 2-line integration, MIT license, tracks tokens and costs.

### Scope
- **Five pipeline types** — web-page, content, data, SEO, code-feature. Each is a separate `.md` workflow.
- **Component registry before voice interface** — inside-out build order. Agents need parts before commands.
- **preview-only is default deploy target** — until CI gates are proven reliable.

## Claude's Discretion

- Template selection when spec doesn't specify one
- Design decisions within brand constraints (layout, imagery, section ordering)
- Whether to create 1 or multiple files for a page
- Copy generation when spec provides only purpose/audience (not full text)

## Deferred Ideas

- [ ] React/Next.js pages (requires build step in pipeline)
- [ ] Image generation via AI (requires additional API access)
- [ ] A/B test variant generation
- [ ] Multi-language page generation
- [ ] Integration with Mighty Networks for community pages
- [ ] WordPress direct publish (vs git-push to WP Engine)
