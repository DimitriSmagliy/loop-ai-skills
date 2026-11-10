---
name: secret-guard
description: Scans the repo and Claude Code settings for committed secrets and checks that .claude/settings.local.json is gitignored. Use when the user says check for secrets, leaked keys, is my repo safe to push, audit before publishing, or mentions settings.local.json or "don't ask again" approvals leaking.
allowed-tools: Read Grep Glob Bash(bash *scan.sh*) Bash(git check-ignore:*) Bash(git ls-files:*)
---

# Secret Guard

Why: `.claude/settings.local.json` stores "don't ask again" approvals, and those approvals can contain pasted tokens or full commands with credentials inside. If that file is committed it leaks. Check it first.

## Steps

1. Run the read-only scanner (it never prints secret values, only file, line and kind):
   `bash ${CLAUDE_SKILL_DIR}/scan.sh`
2. Review each hit. Judge real versus placeholder (`YOUR_KEY_HERE`, `example`, test fixtures).
3. Report in this format: CRITICAL (real-looking secret committed or tracked), WARN (not ignored, or in untracked files), OK.
4. If `.claude/settings.local.json` or `.env*` is NOT gitignored: show the exact lines you would append to `.gitignore` and ASK before writing. Appending to the repo's `.gitignore` is the only write this skill may do.
5. If a secret is already committed, tell the user to rotate it first (revoking it is the real fix), then explain that removing it from git history is a separate step. Do NOT run history rewrites, force pushes or `git rm` yourself.
6. Never print a full secret in your answer. Show at most the first 4 characters, then `...`.
7. This skill only reads the current repo. Do not scan other directories, upload anything or call the network.
