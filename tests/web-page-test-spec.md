# Web Page Test Spec Template

## Usage
Test Agent generates a concrete version of this for each web page pipeline run, filling in spec-specific values.

## Assertions

### Structure
- [ ] File exists at `pages/{name}/index.html`
- [ ] Valid HTML5 (DOCTYPE, html, head, body)
- [ ] `<meta charset="UTF-8">` present
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1.0">` present
- [ ] `<title>` matches spec title
- [ ] `<meta name="description">` present and ≤ 160 chars

### Sections
- [ ] All sections from spec exist as elements with `data-section` attributes
- [ ] Sections appear in spec-defined order
- [ ] Hero section contains H1 with spec title
- [ ] CTA button exists with correct text and href

### Responsive
- [ ] No horizontal scroll at 375px width
- [ ] No horizontal scroll at 768px width
- [ ] Text readable at 375px (font-size ≥ 14px)
- [ ] Touch targets ≥ 44px × 44px on mobile

### Performance
- [ ] Total HTML file size < 100KB
- [ ] No inline base64 images > 5KB
- [ ] External resources only from allowed CDN domains
- [ ] No render-blocking scripts in `<head>`

### Accessibility
- [ ] All `<img>` have `alt` attribute
- [ ] Color contrast ratio ≥ 4.5:1 for body text
- [ ] Heading hierarchy sequential (no level skips)
- [ ] `<html lang="en">` present
- [ ] Interactive elements have focus styles
- [ ] ARIA labels on icon-only buttons

### Brand
- [ ] Primary color matches design-system.json for specified brand
- [ ] Google Font loaded matches design-system.json
- [ ] No hardcoded colors outside design system

### SEO
- [ ] Open Graph tags: og:title, og:description, og:type
- [ ] Twitter Card tags: twitter:card, twitter:title
- [ ] Canonical URL if applicable
- [ ] Schema.org WebPage structured data

### Security
- [ ] No inline `onclick` or `javascript:` URLs
- [ ] No external scripts outside allowed domains
- [ ] No `<form>` actions pointing to unknown endpoints
- [ ] No hardcoded credentials or API keys
