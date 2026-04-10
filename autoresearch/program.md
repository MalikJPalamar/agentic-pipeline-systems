# Autoresearch Program — Agentic Pipeline Systems

> Adapted from [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) methodology.
> Core loop: **Hypothesis → Experiment → Measure → Keep or Discard → Repeat.**

## Purpose

This governs how every pipeline in this repo self-improves over time. The human (Malik) controls this file. The agent evolves `methodology.md` within the boundaries defined here.

## The Optimization Metric

**Composite Score (CS)** = `(0.40 × Accuracy) + (0.30 × Actionability) + (0.30 × Coverage)`

### Accuracy (AC) — "Did it work?"
- For web-page: Lighthouse scores meet thresholds, tests pass, no regressions
- For content: Readability scores on target, SEO checks pass
- For code: Tests pass, no new lint errors, no regressions
- For daily-iteration: Features work, security patches don't break anything

### Actionability (AK) — "Was it meaningful?"
- Did the change address a real issue (not cosmetic)?
- Can the output be deployed without human editing?
- Does the output match the original intent?

### Coverage (CV) — "How thorough?"
- How much of the spec was addressed?
- Were edge cases handled?
- Were all required sections/features built?

## Evolution Rules

1. **One experiment at a time** — never change two things simultaneously
2. **Measure over 3 runs** — keep if CS improves over 3 consecutive runs, discard if not
3. **Simplicity criterion** — if a change adds complexity but doesn't improve CS, discard
4. **Human veto** — Malik can override any keep/discard decision by editing this file
5. **Never regress safety** — security checks cannot be removed or weakened
6. **Git is memory** — every experiment committed with `experiment:` prefix, every keep/discard logged

## What the Agent CAN Evolve (methodology.md)

- Template structures and default sections
- Test threshold values (e.g., Lighthouse scores)
- Agent prompt refinements
- Build order and parallelism patterns
- Report formatting
- Component registry additions

## What the Agent CANNOT Evolve (this file)

- The Composite Score formula
- The keep/discard protocol (3-run measurement window)
- Security check requirements
- TDD enforcement (tests before code)
- Safe-output restrictions
- Budget guardrails
