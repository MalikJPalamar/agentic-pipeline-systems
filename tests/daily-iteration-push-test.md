# Test Spec: daily-iteration.yml Push Retry Fix

This document describes how to verify the fix for the silent `git push || true` failure
in `.github/workflows/daily-iteration.yml`. Each scenario is reproducible locally using
a mock git remote (a bare repo on disk) that can simulate push failures.

---

## Setup: Mock Git Remote

All three scenarios share a common local setup. Run once before each scenario:

```bash
# 1. Create a bare repo to act as the remote
mkdir /tmp/mock-remote && git init --bare /tmp/mock-remote

# 2. Clone it as your working repo
git clone /tmp/mock-remote /tmp/test-repo
cd /tmp/test-repo
git config user.name "Test"
git config user.email "test@test.com"

# 3. Create an initial commit so main branch exists
echo "init" > README.md
git add README.md
git commit -m "init"
git push origin main

# 4. Copy the relevant step from daily-iteration.yml into a local script
#    (see each scenario below for the exact script to run)
```

To simulate push failures, we use a **hook** in the bare remote that exits 1 on demand:

```bash
# Install a failing pre-receive hook in the mock remote
cat > /tmp/mock-remote/hooks/pre-receive << 'EOF'
#!/bin/bash
echo "ERROR: simulated push rejection" >&2
exit 1
EOF
chmod +x /tmp/mock-remote/hooks/pre-receive
```

To make the remote accept pushes again (scenario 2), remove or replace the hook:

```bash
cat > /tmp/mock-remote/hooks/pre-receive << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x /tmp/mock-remote/hooks/pre-receive
```

---

## Scenario 1: Push Fails All 3 Attempts → Workflow Fails + Issue Created

**Goal**: Verify that when `git push` fails every attempt (initial + 2 retries), the step
exits non-zero and triggers the `gh issue create --label iteration-failed` call.

**Pre-condition**: Mock remote has the failing `pre-receive` hook (always rejects).

### Steps

```bash
# From /tmp/test-repo with the failing hook in place

# Simulate the commit step first
echo "autoresearch: $(date -u +%Y-%m-%d)" >> autoresearch.tsv
git add autoresearch.tsv
git diff --cached --quiet || git commit -m "autoresearch: daily iteration $(date -u +%Y-%m-%d)"

# Now run the push step (paste the exact bash block from the fixed workflow)
PUSH_MAX_RETRIES=2
push_attempt=0
push_success=false
while [ $push_attempt -le $PUSH_MAX_RETRIES ]; do
  if git push; then
    push_success=true
    break
  fi
  push_attempt=$((push_attempt + 1))
  if [ $push_attempt -le $PUSH_MAX_RETRIES ]; then
    echo "Push failed (attempt $push_attempt/$PUSH_MAX_RETRIES), retrying in 5s..." >&2
    sleep 5
  fi
done

if [ "$push_success" = "false" ]; then
  echo "All push attempts failed — would create GitHub issue here" >&2
  # In CI, this is: gh issue create --title "..." --label iteration-failed ...
  exit 1
fi
```

### Expected Outcome

- `git push` is called 3 times total (1 initial + 2 retries).
- "Push failed (attempt 1/2)" and "Push failed (attempt 2/2)" messages appear on stderr.
- The script exits with code `1`.
- In actual GitHub Actions, `gh issue create --label iteration-failed` runs and a new
  issue is created in the repo.

### Pass Criteria

- [ ] Exit code is `1` (not `0`).
- [ ] Exactly 3 `git push` attempts are visible in the output (from the mock remote's
  rejection messages).
- [ ] "All push attempts failed" message appears on stderr.
- [ ] In CI: a GitHub issue with label `iteration-failed` is created.

---

## Scenario 2: Push Fails Twice Then Succeeds → Workflow Succeeds

**Goal**: Verify that after 1 or 2 failed attempts, a successful push causes the step
to exit 0 without creating a failure issue.

**Pre-condition**: Start with the failing hook, then switch to the passing hook after the
first rejection. To simulate "fails twice then succeeds", use a counter-based hook:

```bash
# Counter-based hook: fail the first 2 pushes, then accept
cat > /tmp/mock-remote/hooks/pre-receive << 'EOF'
#!/bin/bash
COUNT_FILE=/tmp/push-count
count=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
count=$((count + 1))
echo $count > "$COUNT_FILE"
if [ $count -le 2 ]; then
  echo "ERROR: simulated rejection (attempt $count)" >&2
  exit 1
fi
exit 0
EOF
chmod +x /tmp/mock-remote/hooks/pre-receive
rm -f /tmp/push-count  # reset counter
```

### Steps

```bash
# From /tmp/test-repo with the counter-based hook

# Simulate the commit step
echo "autoresearch: $(date -u +%Y-%m-%d)" >> autoresearch.tsv
git add autoresearch.tsv
git diff --cached --quiet || git commit -m "autoresearch: daily iteration $(date -u +%Y-%m-%d)"

# Run the push step (same block as Scenario 1)
PUSH_MAX_RETRIES=2
push_attempt=0
push_success=false
while [ $push_attempt -le $PUSH_MAX_RETRIES ]; do
  if git push; then
    push_success=true
    break
  fi
  push_attempt=$((push_attempt + 1))
  if [ $push_attempt -le $PUSH_MAX_RETRIES ]; then
    echo "Push failed (attempt $push_attempt/$PUSH_MAX_RETRIES), retrying in 5s..." >&2
    sleep 5
  fi
done

if [ "$push_success" = "false" ]; then
  echo "All push attempts failed — would create GitHub issue here" >&2
  exit 1
fi

echo "Push succeeded on attempt $((push_attempt + 1))"
```

### Expected Outcome

- Attempt 1: rejected by hook (count=1).
- Attempt 2: rejected by hook (count=2).
- Attempt 3: accepted by hook (count=3).
- Script exits with code `0`.
- No failure issue created.

### Pass Criteria

- [ ] Exit code is `0`.
- [ ] "Push failed (attempt 1/2)" and "Push failed (attempt 2/2)" messages appear.
- [ ] "Push succeeded" message appears (not "All push attempts failed").
- [ ] In CI: no `iteration-failed` issue is created.
- [ ] The commit is visible on the remote: `git log origin/main --oneline -1` shows the
  new autoresearch commit.

---

## Scenario 3: Nothing to Commit → Step Exits 0 Silently

**Goal**: Verify that when there is nothing staged (no new commits since last push), the
step detects this and exits 0 without calling `git push` at all.

**Pre-condition**: Working tree is clean; last commit is already on remote.

```bash
# Ensure the repo is clean and up to date with remote
cd /tmp/test-repo
git status  # should show "nothing to commit, working tree clean"
git log origin/main..HEAD --oneline  # should show nothing
```

### Steps

```bash
# Simulate the full "Commit autoresearch updates" step:

git config user.name "UAPP Daily Iteration"
git config user.email "uapp@centaurion.me"
git add autoresearch/results.tsv 2>/dev/null || true  # file may not exist in test repo

# The key guard: only push if there was actually a commit
if git diff --cached --quiet; then
  echo "Nothing staged; skipping push."
  exit 0
fi

git commit -m "autoresearch: daily iteration $(date -u +%Y-%m-%d)"

# Retry loop (same as above)
PUSH_MAX_RETRIES=2
push_attempt=0
push_success=false
while [ $push_attempt -le $PUSH_MAX_RETRIES ]; do
  if git push; then
    push_success=true
    break
  fi
  push_attempt=$((push_attempt + 1))
  if [ $push_attempt -le $PUSH_MAX_RETRIES ]; then
    echo "Push failed (attempt $push_attempt/$PUSH_MAX_RETRIES), retrying in 5s..." >&2
    sleep 5
  fi
done

if [ "$push_success" = "false" ]; then
  echo "All push attempts failed" >&2
  exit 1
fi
```

### Expected Outcome

- `git diff --cached --quiet` returns 0 (nothing staged).
- Script prints "Nothing staged; skipping push." and exits with code `0`.
- `git push` is never called.

### Pass Criteria

- [ ] Exit code is `0`.
- [ ] "Nothing staged; skipping push." is printed (or equivalent).
- [ ] No `git push` is invoked (add `set -x` to verify — no push command in the trace).
- [ ] In CI: step succeeds with green checkmark, no issue created.

> **Note**: The existing `daily-iteration.yml` already handles this via
> `git diff --cached --quiet || git commit -m "..."` — the commit is only made if there
> are staged changes. The push guard must mirror this logic: if no commit was made, skip
> the push entirely (exit 0), because there is nothing new to push.

---

## Quick Regression Check

After any change to the workflow, run the following to confirm no other steps were
accidentally modified:

```bash
git diff HEAD~1 -- .github/workflows/daily-iteration.yml | diffstat
# Expected: only the "Commit autoresearch updates" step changed
# Expected: diff is ≤ 40 lines added/removed
git diff HEAD~1 -- .github/workflows/daily-iteration.yml | wc -l
```
