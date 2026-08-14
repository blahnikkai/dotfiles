#!/bin/bash
set -e

echo "Setting up Neovim..."

# 1. Ensure the base config directory exists
mkdir -p "$HOME/.config"

# 2. Safely handle existing configurations
if [ -d "$HOME/.config/nvim" ] || [ -L "$HOME/.config/nvim" ]; then
    echo "Existing Neovim config found. Backing it up to ~/.config/nvim.bak..."
    rm -rf "$HOME/.config/nvim.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# 3. Create the symlink (points ~/.config/nvim to your setup/nvim folder)
# $PWD ensures it uses the absolute path of your setup directory
ln -sf "$PWD/nvim" "$HOME/.config/nvim"

# 4. Headlessly install plugins
# This command assumes you use lazy.nvim.
# If you use Packer or vim-plug, the command will be slightly different.
echo "Bootstrapping plugins..."
nvim --headless "+Lazy! sync" +qa

# 5. Print the cheat sheet
echo ""
echo "========================================================"
echo "             NEOVIM ENVIRONMENT READY                   "
echo "========================================================"
cat "$PWD/cheatsheet.txt"
echo "========================================================"
