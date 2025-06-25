#!/bin/zsh
echo "Setting up symlinks..."

ln -sf ~/dotfiles/.editorconfig ~/.editorconfig
ln -sf ~/dotfiles/.flake8 ~/.flake8
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/.zshrc ~/.zshrc

echo "Done!"
