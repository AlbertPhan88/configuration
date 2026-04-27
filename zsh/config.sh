#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install zsh
if ! command -v zsh &>/dev/null; then
    echo "Installing zsh..."
    sudo apt-get install -y zsh
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# Install MesloLGS NF fonts
echo "Installing MesloLGS NF fonts..."
mkdir -p "$HOME/.local/share/fonts"
for font in "MesloLGS NF Regular" "MesloLGS NF Bold" "MesloLGS NF Italic" "MesloLGS NF Bold Italic"; do
    dest="$HOME/.local/share/fonts/${font}.ttf"
    if [ ! -f "$dest" ]; then
        curl -fLo "$dest" "https://github.com/romkatv/powerlevel10k-media/raw/master/${font// /%20}.ttf"
    fi
done
fc-cache -fv &>/dev/null

# Symlink .zshrc
if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Backing up existing ~/.zshrc to ~/.zshrc.bak"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo "Symlinked .zshrc -> $HOME/.zshrc"

# Symlink .p10k.zsh
if [ -e "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
fi
ln -sf "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
echo "Symlinked .p10k.zsh -> $HOME/.p10k.zsh"

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    sudo chsh -s "$(which zsh)" "$(whoami)"
fi

echo "Done! Open a new terminal to start using zsh with Powerlevel10k."
