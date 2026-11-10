#!/usr/bin/env bash
# Read-only secret scan. Prints file:line only, never the matched value.
# Usage: bash scan.sh [dir]   (default: git toplevel or cwd)
set -u
cd "${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}" || exit 1
echo "== Scanning: $(pwd)"

echo "== gitignore check"
for f in .claude/settings.local.json .env .env.local; do
  if [ -e "$f" ]; then
    if git check-ignore -q "$f" 2>/dev/null; then echo "OK    $f exists and is gitignored"
    else echo "WARN  $f exists and is NOT gitignored"; fi
    if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then echo "CRIT  $f is TRACKED by git"; fi
  fi
done
if [ -d .git ] && ! git check-ignore -q .claude/settings.local.json 2>/dev/null; then
  echo "WARN  .claude/settings.local.json is not covered by .gitignore (add it)"
fi

echo "== pattern scan (values hidden)"
PATTERNS='AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{32,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{10,}|(api[_-]?key|secret|token|passwd|password)["'"'"' ]*[:=]["'"'"' ]*[A-Za-z0-9/+_=-]{16,}'
FILES=$( { git ls-files 2>/dev/null; ls .claude/settings.local.json .env .env.local 2>/dev/null; } | sort -u)
[ -z "$FILES" ] && FILES=$(find . -type f -not -path './.git/*' -not -path './node_modules/*' | head -2000)
OUT=$(mktemp)
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.zip|*.lock|*.woff*|*.ico) continue;; esac
  [ "$(wc -c <"$f")" -gt 1000000 ] && continue
  grep -nIE "$PATTERNS" "$f" 2>/dev/null | cut -d: -f1 | while read -r n; do
    echo "HIT   $f:$n (possible secret, value hidden)"
  done
done <<< "$FILES" > "$OUT"
head -50 "$OUT"
echo "== done: $(wc -l < "$OUT" | tr -d ' ') possible hit(s) (display capped at 50)"
rm -f "$OUT"
