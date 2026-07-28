#!/usr/bin/env bash
# Builds the offline install fallback from the plugin source in this repo.
#
# Why this exists: most clients install from the marketplace, which self-updates. Clients behind a
# corporate network that blocks GitHub cannot, so they upload this archive by hand instead, during
# a session with a consultant.
#
# It is a BUILD ARTIFACT, never hand-edited. That is the whole point. The marketplace copy and this
# archive come from the same directory and carry the same version string, so the only way they
# diverge is time: an uploaded archive is frozen at the version it was built from and receives no
# updates, while a marketplace install does. The setup guide says that in plain words.
#
# Format note: the archive is a .zip, deliberately, not a .plugin. The Claude desktop uploader's
# file picker offers both and the backend accepts only .zip, rejecting .plugin with a generic
# "Upload failed" (anthropics/claude-code#40414, reported 2026-03, closed stale 2026-05, still
# reproducing). Shipping .zip sidesteps a failure the client cannot diagnose. Recheck before
# changing the extension.
#
# Usage:  ./scripts/build-offline-zip.sh
# Output: dist/neonframe-ai-brain-v<version>.zip
set -euo pipefail

cd "$(dirname "$0")/.."

PLUGIN_DIR="plugins/neonframe-ai-brain"
MANIFEST="$PLUGIN_DIR/.claude-plugin/plugin.json"
MARKETPLACE=".claude-plugin/marketplace.json"

VERSION=$(python3 -c "import json;print(json.load(open('$MANIFEST'))['version'])")
MKT_VERSION=$(python3 -c "import json;print(json.load(open('$MARKETPLACE'))['plugins'][0]['version'])")

# A mismatch here means an update would reach marketplace clients and not offline ones, or the
# reverse. Fail loudly rather than ship two things calling themselves the same version.
if [ "$VERSION" != "$MKT_VERSION" ]; then
  echo "ERROR: version mismatch. plugin.json is $VERSION, marketplace.json is $MKT_VERSION." >&2
  echo "Bump both, then rebuild." >&2
  exit 1
fi

# Every skill must carry a name and a description, and the description has a hard 1024
# character limit (platform.claude.com/docs/en/agents-and-tools/agent-skills/overview).
# An over-long description is invalid and there is nothing downstream that would catch it,
# so check here rather than discover it after publishing.
python3 - "$PLUGIN_DIR" <<'PYVALIDATE'
import pathlib, re, sys

plugin_dir = pathlib.Path(sys.argv[1])
skills = sorted(p for p in (plugin_dir / "skills").iterdir() if p.is_dir())
problems = []
for s in skills:
    skill_md = s / "SKILL.md"
    if not skill_md.is_file():
        problems.append(f"{s.name}: no SKILL.md")
        continue
    text = skill_md.read_text(encoding="utf-8")
    name = re.search(r"^name:\s*(.+)$", text, re.M)
    desc = re.search(r"^description:\s*(.+)$", text, re.M)
    if not name:
        problems.append(f"{s.name}: no name in frontmatter")
    elif name.group(1).strip() != s.name:
        problems.append(f"{s.name}: frontmatter name is {name.group(1).strip()!r}")
    if not desc:
        problems.append(f"{s.name}: no description in frontmatter")
    elif len(desc.group(1)) > 1024:
        problems.append(f"{s.name}: description is {len(desc.group(1))} chars, limit is 1024")

print(f"Validated {len(skills)} skills: " + ", ".join(s.name for s in skills))
if problems:
    print("ERROR: plugin validation failed.", file=sys.stderr)
    for p in problems:
        print(f"  - {p}", file=sys.stderr)
    sys.exit(1)
PYVALIDATE

OUT="dist/neonframe-ai-brain-v${VERSION}.zip"
mkdir -p dist
rm -f "$OUT"

# Zip the plugin directory's CONTENTS, so .claude-plugin/ and skills/ sit at the archive root.
# That is the layout the installer expects; an extra wrapping directory makes the upload fail.
( cd "$PLUGIN_DIR" && zip -r -X -q "../../$OUT" . -x '.DS_Store' -x '**/.DS_Store' )

echo "Built $OUT"
echo "sha256: $(shasum -a 256 "$OUT" | cut -d' ' -f1)"
echo
echo "Archive root (must show .claude-plugin/ and skills/ at top level):"
unzip -l "$OUT" | head -12

# --- tier three: one archive per skill -------------------------------------
# The last resort, for a client who can neither add the marketplace nor upload a plugin.
# Individual skills go in one at a time under Customize > Skills > + > Create skill >
# Upload a skill. Each archive wraps ONE directory named exactly for the skill, holding
# its SKILL.md and any references it loads, which is the layout that uploader expects.
#
# It is genuinely worse than the other two routes: it is one upload per skill and nothing
# added this way auto-updates. The menu path itself is the documented one for claude.ai
# (support.claude.com "How to create custom skills"), and that personal skill library is
# shared with Cowork. Use it only when the first two routes fail.
SKILLS_OUT="dist/skills-v${VERSION}"
rm -rf "$SKILLS_OUT"
mkdir -p "$SKILLS_OUT"

COUNT=0
for SKILL_PATH in "$PLUGIN_DIR"/skills/*/; do
  SKILL=$(basename "$SKILL_PATH")
  ( cd "$PLUGIN_DIR/skills" && zip -r -X -q "../../../$SKILLS_OUT/${SKILL}.zip" "$SKILL" \
      -x '.DS_Store' -x '**/.DS_Store' )
  COUNT=$((COUNT + 1))
done

echo
echo "Built $COUNT per-skill archives in $SKILLS_OUT/"
echo "Each must contain exactly one top-level directory named for its skill:"
unzip -l "$SKILLS_OUT/humanizer.zip" | head -10
