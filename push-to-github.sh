#!/bin/bash
# push-to-github.sh — Create and push the agentic-pipeline-systems repo
# Run from the directory containing this script
# Requires: gh CLI authenticated (gh auth login)

set -e

REPO_NAME="agentic-pipeline-systems"
REPO_OWNER="MalikJPalamar"

echo "📦 Creating GitHub repo: ${REPO_OWNER}/${REPO_NAME}"
gh repo create "${REPO_OWNER}/${REPO_NAME}" \
  --public \
  --description "Phone → Agents → Production — autonomous agentic pipelines with TDD, autoresearch, and multi-agent orchestration" \
  --clone=false 2>/dev/null || echo "Repo may already exist, continuing..."

echo "🔧 Initializing git..."
git init
git add -A
git commit -m "feat: initial agentic pipeline systems infrastructure

- 6 gh-aw pipeline workflows (web-page, content, data, SEO, code-feature, daily-iteration)
- 5 agent role definitions (orchestrator, spec, build, test, review)
- Autoresearch loop (Karpathy pattern) with program.md, methodology, results tracking
- TDD-first approach: tests written before code in every pipeline
- Component registry + design system for 3 brands (AOB, BuilderBee, Centaurion)
- GSD-compatible planning structure (.planning/PROJECT.md, CONTEXT.md, ROADMAP.md)
- Daily scheduled iteration: feature dev + test coverage + security scanning at 9pm CET"

git branch -M main
git remote add origin "https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
git push -u origin main

echo ""
echo "✅ Pushed to https://github.com/${REPO_OWNER}/${REPO_NAME}"
echo ""
echo "Next steps:"
echo "  1. gh secret set ANTHROPIC_API_KEY     # in the new repo"
echo "  2. gh extension install github/gh-aw   # if not already installed"
echo "  3. gh aw compile                       # compile workflows to .lock.yml"
echo "  4. git add . && git commit -m 'chore: add compiled workflows' && git push"
echo "  5. gh aw run web-page-pipeline --input spec='{...}'  # test it"
