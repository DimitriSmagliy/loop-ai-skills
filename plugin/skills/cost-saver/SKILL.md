---
name: cost-saver
description: Shows where context and tokens are going and trims them with concrete tips, including when to /clear, /compact or start a fresh session. Use when the user says I'm hitting my limit, usage is too high, save tokens, session feels slow, context is full, or reduce cost.
allowed-tools: Read Glob Bash(wc:*)
---

# Cost Saver

Most of your usage is the whole conversation being re-read every turn, so a long session gets more expensive with each message.

## Steps

1. Ask the user to run `/context` (it shows what fills the window) and `/usage` (plan consumption), then paste or describe the result. You cannot run these built-in commands yourself.
2. Measure what you can (CLAUDE.md sizes in bytes): !`wc -c CLAUDE.md .claude/CLAUDE.md ~/.claude/CLAUDE.md 2>/dev/null`
3. Diagnose, then give at most 5 specific fixes ranked by savings:
   - **Clear points**: after a feature is committed or the topic changes, `/clear`. Before that, write a handoff (`/handoff`) so nothing is lost.
   - **Compact**: `/compact focus on <current task>` when the same task continues but history is long.
   - **Trim always-loaded text**: CLAUDE.md procedures that are only sometimes needed belong in skills, which load on demand.
   - **Prune tools**: unused MCP servers and skills cost context every turn. `/doctor` flags unused ones.
   - **Smaller reads**: use Grep and line ranges instead of reading whole files, and use subagents for broad searches so the noise stays out of the main thread.
   - **Right-size the model**: use a lighter model for routine edits, and keep the strongest for hard design problems.
4. Never edit CLAUDE.md, settings or MCP config without showing the change and asking first.
5. Keep the answer short: a ranked list, one line per fix, with the exact command to run.
