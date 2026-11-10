---
name: ship-check
description: Pre-commit checklist that runs tests and lint, reviews the diff, and catches secrets and leftover debug logs before you commit or push. Use when the user says ship it, ready to commit, pre-commit check, before I push, is this safe to commit, or review my changes.
allowed-tools: Read Grep Glob Bash(git status:*) Bash(git diff:*) Bash(git log:*)
---

# Ship Check

## The change

- Files: !`git status --short 2>/dev/null | head -40`
- Size: !`git diff HEAD --stat 2>/dev/null | tail -15`

## Checklist (do all, report each as PASS / FAIL / SKIPPED with a reason)

1. **Tests**: find the project's test command (package.json scripts, Makefile, pytest, cargo, go). Run it and read the exit code. A failing or hidden failure (piped through `tail`) is a FAIL.
2. **Lint / types**: run the project's linter and type checker if they exist. Do not install new tools without asking.
3. **Diff review**: read `git diff HEAD`. Look for unintended files, accidental large changes, TODO/FIXME you added, commented-out code, and changes unrelated to the task.
4. **Debug leftovers**: search ONLY the changed lines for `console.log`, `print(`, `debugger`, `dbg!`, `binding.pry`, `.only(`, `fdescribe`.
5. **Secrets**: search the diff for keys, tokens, passwords and `.env` content. If `secret-guard` is installed, suggest running it for a full scan.
6. **Commit hygiene**: is the change one logical unit? Suggest a one-line commit message in the repo's existing style (see `git log --oneline -5`).

## Rules

- Never run `git commit`, `git push`, `git add -A` or anything destructive. This skill only inspects and reports.
- End with a verdict: SHIP / FIX FIRST, plus the short list of what to fix. Offer to fix issues, but wait for a yes.
