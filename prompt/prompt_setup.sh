#!/bin/bash
set -e

echo "Setting up Zsh, Oh My Zsh, and Powerlevel10k..."

# 1. Install Oh My Zsh (unattended so it doesn't halt the script)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# 2. Install Powerlevel10k via Homebrew
echo "Installing Powerlevel10k..."
brew install powerlevel10k

# Check if it's already sourced in .zshrc; if not, append it.
if ! grep -q "powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
    echo "Adding Powerlevel10k to .zshrc..."
    echo -e "\n# Activate Powerlevel10k" >> "$HOME/.zshrc"
    echo "source \$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> "$HOME/.zshrc"

    # Enable instant prompt at the very top of .zshrc for performance
    sed -i '' '1i\
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.\
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then\
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"\
fi\
' "$HOME/.zshrc"
fi

# 3. Symlink the .p10k.zsh configuration
# (Assuming the .p10k.zsh file is in the root of your setup repository)
echo "Symlinking Powerlevel10k configuration..."
if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    echo "Existing .p10k.zsh found. Backing it up to .p10k.zsh.bak..."
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
fi
ln -sf "$PWD/.p10k.zsh" "$HOME/.p10k.zsh"

# 4. Print Font Installation Instructions
echo ""
echo "========================================================================"
echo "                   ACTION REQUIRED: INSTALL FONTS                       "
echo "========================================================================"
echo "To render the Powerlevel10k icons correctly, you must install the"
echo "Meslo Nerd Font patched for Powerlevel10k."
echo ""
echo "1. Download these four files:"
echo "   - https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
echo "   - https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
echo "   - https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
echo "   - https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
echo ""
echo "2. Double-click each downloaded .ttf file and click 'Install Font'."
echo ""
echo "3. Configure your terminal to use the font:"
echo "   - Apple Terminal: Preferences > Profiles > Text > Font -> 'MesloLGS NF'"
echo "   - iTerm2: Preferences > Profiles > Text > Font -> 'MesloLGS NF'"
echo ""
echo "More info: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
echo "========================================================================"
