---
name: handoff
description: Writes or updates a HANDOFF.md so a fresh Claude Code session can pick up exactly where this one stopped. Use when the user says handoff, wrap up, I'm out of context, new session, continue tomorrow, or the conversation is getting long.
argument-hint: "[optional note about what to emphasise]"
allowed-tools: Read Grep Glob Write Bash(git status:*) Bash(git diff:*) Bash(git log:*) Bash(git branch:*)
---

# Handoff

Goal: a new session reads ONE short file and continues without re-exploring.

## Current repo state (live)

- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`
- Status: !`git status --short 2>/dev/null | head -30`
- Recent commits: !`git log --oneline -8 2>/dev/null`

## Steps

1. If `HANDOFF.md` exists in the repo root, read it and UPDATE it. Do not start over.
2. Write or update `HANDOFF.md` (max 100 lines) with these sections:
   - **Goal**: one sentence on what we are building or fixing.
   - **Done**: bullets of what is finished and verified (say how it was verified).
   - **In progress**: the exact file(s) and function(s) being edited, and the next concrete step.
   - **Decisions**: choices made and why, so the next session does not relitigate them.
   - **Gotchas**: failing tests, flaky commands, traps already hit.
   - **Read first**: at most 5 files, as `path:line`.
   - **Run**: the commands to build, test and start the project.
3. Facts only. Never put API keys, tokens, passwords or `.env` contents in the file. Replace them with the variable name.
4. Only write `HANDOFF.md` in the repo root. Do not touch anything else.
5. Finish by telling the user: "Start the next session and say: read HANDOFF.md and continue." Use the argument as an emphasis note if one was given: $ARGUMENTS
