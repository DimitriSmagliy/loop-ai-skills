---
name: explain-like-new
description: Explains an unfamiliar codebase to a newcomer and builds a CODEMAP.md that maps topics to file:line. Use when the user says explain this repo, I just joined this project, where is X implemented, give me a map of the code, onboard me, or opens a codebase they have not seen.
argument-hint: "[optional focus area]"
allowed-tools: Read Grep Glob Write Bash(git ls-files:*) Bash(git log:*) Bash(wc:*)
---

# Explain Like I'm New

## Repo snapshot

- Top level: !`ls -1 2>/dev/null | head -40`
- Tracked files: !`git ls-files 2>/dev/null | wc -l`

## Steps

1. Read README, the manifest (package.json, pyproject.toml, Cargo.toml, go.mod), and entry points. Do not read the whole repo.
2. Explain in plain language, max 25 lines: what the project does, how a request or command flows through it (entry point to output), and the 5 most important directories.
3. Write `CODEMAP.md` in the repo root as a table: `Topic | What it is | Where (path:line)`. Cover entry points, config, data models, core logic, tests, build/deploy. Every row must point to a real `path:line` you opened. Never invent a location.
4. Add a "Start here" list of 3 files in reading order, and a "Do not touch lightly" list (generated code, migrations, vendored code).
5. If an argument was given, go deeper on that area: $ARGUMENTS
6. Only write `CODEMAP.md` in the repo root. If it already exists, update it instead of replacing it.
