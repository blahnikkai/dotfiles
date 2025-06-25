#!/bin/zsh
echo "Setting up symlinks..."

ln -s ~/dotfiles/.editorconfig ~/.editorconfig
ln -s ~/dotfiles/.flake8 ~/.flake8
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.profile ~/.profile
ln -s ~/dotfiles/.zshrc ~/.zshrc

echo "Done!"
