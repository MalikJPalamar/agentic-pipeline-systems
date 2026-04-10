# Methodology v1.0 — Active

> This file is evolved by the agent following `program.md` rules.
> Changes are tracked in `changelog.md` and scored in `results.tsv`.

## Web Page Pipeline Methodology

### Build Process
1. Spec Agent parses intent and loads component registry
2. Test Agent writes test specs (TDD) based on requirements
3. Build Agent scaffolds from template, applies design tokens
4. Build Agent generates section content from spec
5. Test Agent validates output against test specs
6. Review Agent checks security, a11y, performance, brand
7. Orchestrator creates PR via safe-outputs

### Quality Thresholds
- Lighthouse Performance: ≥ 80
- Lighthouse Accessibility: ≥ 90
- Lighthouse SEO: ≥ 85
- Page weight: < 100KB (excluding CDN)
- DOM depth: < 15 levels
- Color contrast: ≥ 4.5:1

### Default Behaviors
- Missing brand → use "centaurion"
- Missing sections → use template defaults
- Missing CTA → create generic "Learn More" linking to spec.purpose domain
- Missing tone → use "professional"

## Daily Iteration Methodology

### Priority Selection
1. Issues labeled `priority:high` first
2. Then `good-first-issue`
3. Then oldest open issue
4. Skip issues requiring multi-session work

### TDD Enforcement
- Test files named `{feature}.test.{ext}`
- Minimum 3 assertions per test file
- Edge cases: null input, empty string, boundary values
- Tests committed in same PR as implementation

### Security Scan Scope
- `npm audit` for Node.js dependencies
- Regex scan for hardcoded patterns: API keys, tokens, passwords
- HTTP → HTTPS URL audit
- Known vulnerable CDN version check
