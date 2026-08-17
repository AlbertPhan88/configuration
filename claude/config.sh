#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS="$CLAUDE_DIR/settings.json"
TELECLAUDE_DIR="${TELECLAUDE_DIR:-$HOME/projects/teleclaude}"

if ! command -v claude &>/dev/null; then
    echo "Error: claude not found. Install Claude Code first:"
    echo "  https://claude.com/claude-code"
    exit 1
fi

mkdir -p "$HOOKS_DIR"

# settings.json — rendered from the template, $HOME expanded.
# Hook commands run through a shell, but the template is expanded here anyway
# so the installed file is readable and independent of shell quoting.
if [ -e "$SETTINGS" ]; then
    echo "Backing up existing settings.json to settings.json.bak"
    cp "$SETTINGS" "$SETTINGS.bak"
fi
sed "s|\$HOME|$HOME|g" "$SCRIPT_DIR/settings.json" > "$SETTINGS"
echo "Wrote $SETTINGS"

# skills — symlinked per-skill so live state files (LOG.md, PROPOSALS.md)
# written during sessions land in this repo and stay version-controlled.
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    [ -d "$skill_dir" ] || continue
    name="$(basename "$skill_dir")"
    target="$CLAUDE_DIR/skills/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Warning: $target exists and is not a symlink, skipping"
        continue
    fi
    ln -sfn "${skill_dir%/}" "$target"
done
echo "Symlinked skills -> $CLAUDE_DIR/skills"

# teleclaude hooks — symlinked from the teleclaude repo so the scripts stay
# version-controlled in one place rather than forked into this repo.
if [ -d "$TELECLAUDE_DIR/scripts" ]; then
    for hook in pre_tool_use stop user_prompt_submit session_start session_end; do
        src="$TELECLAUDE_DIR/scripts/$hook.sh"
        if [ -f "$src" ]; then
            ln -sf "$src" "$HOOKS_DIR/$hook.sh"
        else
            echo "Warning: $src not found, skipping"
        fi
    done
    echo "Symlinked teleclaude hooks -> $HOOKS_DIR"
else
    echo "Warning: teleclaude repo not found at $TELECLAUDE_DIR"
    echo "  Hooks reference scripts that will not exist; they fail open (exit 0),"
    echo "  so sessions still work. Clone it and re-run, or set TELECLAUDE_DIR."
fi

# herdr integration — installs its own hook and re-adds its SessionStart entry,
# which is why it runs after settings.json is written. The hook file it drops in
# is herdr-managed and overwritten on every update, so it is not tracked here.
if command -v herdr &>/dev/null; then
    herdr integration install claude
else
    echo "Note: herdr not on PATH, skipping its Claude integration."
    echo "  Install herdr, then run: herdr integration install claude"
fi

cat <<'EOF'

Done. Plugins are not restored automatically (the commands prompt for trust):

  claude plugin marketplace add intellidiotx/imagination
  claude plugin install sdlc@imagination

Open a new Claude Code session to pick up the settings.
EOF
