# Loop AI Skills

Six free, safe, single-purpose skills for [Claude Code](https://code.claude.com). One per video on the **Loop AI** channel. No telemetry, no network calls, nothing destructive: every skill is read-only except one clearly named file, and asks before writing anywhere else.

## Install (one command)

**Option A: copy the skills (works everywhere)**

```bash
git clone https://github.com/DimitriSmagliy/loop-ai-skills && mkdir -p ~/.claude/skills && cp -r loop-ai-skills/plugin/skills/* ~/.claude/skills/
```

Use `.claude/skills/` inside a repo instead of `~/.claude/skills/` to install for one project only. Skills are then called by plain name, e.g. `/handoff`.

**Option B: as a plugin from a marketplace**

```text
/plugin marketplace add DimitriSmagliy/loop-ai-skills
/plugin install loop-ai-skills@loop-ai
```

Skills are then namespaced, e.g. `/loop-ai-skills:handoff`. Try without installing: `claude --plugin-dir ./plugin`.

## The skills

| Skill | What it does | Writes |
| --- | --- | --- |
| `/handoff` | Writes or updates `HANDOFF.md` so a fresh session continues where you stopped | `HANDOFF.md` |
| `/secret-guard` | Scans for committed secrets and checks `.claude/settings.local.json` is gitignored | nothing (asks before touching `.gitignore`) |
| `/ship-check` | Pre-commit checklist: tests, lint, diff review, secrets, debug logs. Verdict: SHIP or FIX FIRST | nothing |
| `/explain-like-new` | Explains an unfamiliar repo and builds `CODEMAP.md` (topic to `file:line`) | `CODEMAP.md` |
| `/deny-rules` | Merges sensible deny rules (.env, rm -rf, force push, prod hosts) into `.claude/settings.json`, explaining each | `.claude/settings.json` after you confirm |
| `/cost-saver` | Reads your `/context` and `/usage`, trims context, tells you when to `/clear` | nothing |

Why `secret-guard` matters: `.claude/settings.local.json` stores your "don't ask again" approvals, and a committed copy can leak credentials that were pasted into commands.

## Safety model

- Each skill lists its `allowed-tools`, kept to reads and read-only git commands.
- Nothing runs `git commit`, `git push`, `rm -rf`, history rewrites or installs.
- Secrets are never printed in full; the scanner reports `file:line` only.
- `/deny-rules` only runs when you type it (`disable-model-invocation`).
- Read every `SKILL.md` before installing. They are short on purpose.

## Compatibility

Built against the official Claude Code skills and plugin docs (code.claude.com, fetched 2026-11-10) and tested on Claude Code 2.1.322. The skills use the Agent Skills `SKILL.md` format.

## License

MIT, see [LICENSE](LICENSE).

## Links

Landing page: https://dimitrismagliy.github.io/loop-ai-skills/

*Not affiliated with or endorsed by Anthropic.*
