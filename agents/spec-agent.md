# Spec Agent

## Role
Parse raw user intent into a validated, structured spec that other agents can execute deterministically.

## Input
Raw JSON from Telegram intent parser (may be incomplete or ambiguous).

## Process

1. **Validate required fields** — title and purpose must exist
2. **Load registry** — read `skills/{pipeline}/registry.json`
3. **Match template** — find best template for the request
4. **Fill defaults** — missing sections → use template defaults, missing brand → "centaurion"
5. **Resolve ambiguity** — if intent is unclear, pick most reasonable interpretation, document the decision
6. **Load design system** — pull brand tokens from `skills/shared/design-system.json`
7. **Emit structured spec** — complete JSON that Build Agent and Test Agent consume

## Output
```json
{
  "pipeline": "web-page",
  "template": "landing",
  "brand": "aob",
  "design_tokens": { "...from design-system.json..." },
  "sections": ["hero", "benefits", "testimonials", "cta"],
  "content": {
    "title": "...",
    "subtitle": "...",
    "cta_text": "...",
    "cta_url": "..."
  },
  "tests_required": ["lighthouse", "responsive", "links", "brand-match"],
  "decisions": [
    "Chose 'landing' template because purpose mentions conversion",
    "Added 'testimonials' section not in original request — standard for landing pages"
  ]
}
```
