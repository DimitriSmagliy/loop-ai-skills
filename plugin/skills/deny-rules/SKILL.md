---
name: deny-rules
description: Sets up sensible permission deny rules in .claude/settings.json to block reads of .env and secrets, rm -rf, force pushes and production hosts, and explains each rule. Use when the user says lock down Claude, make Claude safer, protect my secrets, add deny rules, or stop Claude touching production.
disable-model-invocation: true
allowed-tools: Read Glob Write Edit
---

# Deny Rules

Deny rules are the hard floor: they win over allow rules and "don't ask again" approvals. Docs: https://code.claude.com/docs/en/permissions.md

## Steps

1. Read `.claude/settings.json` if it exists. Never overwrite it: MERGE into the existing `permissions.deny` array and keep every other key.
2. Propose this starter set, then ask the user which to keep and which production hosts to add (ask for the real host names, do not guess):

| Rule | Why |
| --- | --- |
| `Read(./.env)`, `Read(./.env.*)` | Env files hold live credentials |
| `Read(./secrets/**)` | Same for a secrets folder |
| `Read(~/.ssh/**)`, `Read(~/.aws/**)` | Keys and cloud credentials never belong in a chat |
| `Bash(rm -rf:*)` | Recursive force delete is not undoable |
| `Bash(git push --force:*)`, `Bash(git push -f:*)` | Rewrites shared history |
| `Bash(git reset --hard:*)` | Throws away uncommitted work |
| `Bash(sudo:*)` | No root from an agent |
| `Bash(ssh <prod-host>:*)`, `Bash(scp:*<prod-host>*)` | Replace `<prod-host>` with your real production host |

3. Show the final JSON diff and ASK before writing. Write to the project file `.claude/settings.json` only (shared with the team). Personal-only rules go in `.claude/settings.local.json`, which must stay gitignored.
4. After writing, validate it parses as JSON. Tell the user to restart the session or run `/permissions` to confirm the rules are loaded.
5. Be honest about limits: Bash patterns match command prefixes and can be bypassed with a differently written command, so deny rules reduce risk but are not a sandbox. Suggest the sandbox setting for stronger isolation.
