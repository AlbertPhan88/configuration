#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$SCRIPT_DIR/.tmux.conf"
TARGET="$HOME/.tmux.conf"

# Install tmux if not present
if ! command -v tmux &>/dev/null; then
    echo "Installing tmux..."
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y tmux
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y tmux
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm tmux
    elif command -v brew &>/dev/null; then
        brew install tmux
    else
        echo "Error: Could not detect package manager. Install tmux manually."
        exit 1
    fi
fi

# Install xclip for clipboard support (Linux only)
if [[ "$(uname)" == "Linux" ]] && ! command -v xclip &>/dev/null; then
    echo "Installing xclip for clipboard support..."
    if command -v apt &>/dev/null; then
        sudo apt install -y xclip
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y xclip
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm xclip
    fi
fi

# Symlink tmux config
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "Backing up existing ~/.tmux.conf to ~/.tmux.conf.bak"
    mv "$TARGET" "$TARGET.bak"
fi

ln -sf "$TMUX_CONF" "$TARGET"
echo "Symlinked $TMUX_CONF -> $TARGET"

# Reload if tmux is running
if tmux list-sessions &>/dev/null; then
    tmux source-file "$TARGET"
    echo "Tmux config reloaded."
fi

echo "Done! tmux $(tmux -V) is ready."
