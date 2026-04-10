# ROADMAP.md — UAPP

## Milestone 1: Phone to Production (Current)

### Phase 1: gh-aw Bootstrap ← START HERE
**Goal:** Get a single gh-aw workflow running: manual trigger → agent builds page → PR created.
**Must-haves:**
- gh-aw CLI installed and authenticated
- ANTHROPIC_API_KEY configured as repo secret
- `web-page-pipeline.md` committed to `.github/workflows/`
- Successfully compiled to `.lock.yml`
- `gh aw run web-page-pipeline` produces a PR with a working HTML page
**Acceptance:** PR exists with valid HTML, CI is green (or no CI yet — acceptable).

### Phase 2: Component Registry & Design System
**Goal:** Agent pulls from a typed catalog instead of generating from scratch.
**Must-haves:**
- `skills/web-page/registry.json` with 5+ templates
- `skills/shared/design-system.json` with AOB, BuilderBee, Centaurion tokens
- Workflow references registry during build
- Built pages use correct brand colors/fonts
**Acceptance:** Two pages built from same workflow, different brands — both match design system.

### Phase 3: Telegram Command Bridge
**Goal:** Voice/text on phone → GitHub workflow_dispatch → page built.
**Must-haves:**
- Telegram bot with intent parser (voice → JSON spec)
- GitHub API integration: `POST /repos/MalikJPalamar/gh-aw/dispatches`
- Confirmation flow: bot shows parsed spec, user confirms
- Error handling: bot reports if workflow fails
**Acceptance:** Voice message on Telegram → PR notification on same phone within 15 minutes.

### Phase 4: CI Quality Gates
**Goal:** Automated checks block bad deployments, agent self-corrects.
**Must-haves:**
- Lighthouse CI action (performance ≥ 80, accessibility ≥ 90)
- HTML validation check
- Link checker
- Auto-merge if all green
- Phone notification if amber/red with option to override
**Acceptance:** Intentionally broken page → CI blocks → agent fixes → CI passes → auto-merge.

### Phase 5: Deployment Bridge
**Goal:** Merged PR → live URL → phone notification.
**Must-haves:**
- Dokploy webhook on merge to main
- Post-deploy verification (agent loads live URL)
- Telegram notification with live link + scores
**Acceptance:** Full loop: phone voice → live URL notification on same phone < 20 minutes.

---

## Milestone 2: Pipeline Multiplication

### Phase 6: Content Pipeline
**Goal:** "Write a blog post about X" → WordPress/GHL publish-ready.

### Phase 7: Data Pipeline  
**Goal:** "Generate AOB monthly report" → Supabase dashboard / PDF.

### Phase 8: SEO Pipeline
**Goal:** "Optimize these pages for Y keyword" → updated meta + content PRs.

### Phase 9: Code Feature Pipeline
**Goal:** "Add feature X to project Y" → branch → PR → CI → merge.

---

## Milestone 3: Observability & Autonomy

### Phase 10: AgentOps Integration
**Goal:** Cost, token, and trace monitoring across all pipelines.

### Phase 11: Autonomous Iteration (Autoresearch Pattern)
**Goal:** Pipelines self-improve overnight: measure → diagnose → fix → measure.
