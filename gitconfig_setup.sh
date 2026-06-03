#!/bin/bash

# Path to your dotfiles repo's gitconfig (edit this if needed)
DOTFILES_GITCONFIG="$HOME/dotfiles/.gitconfig.extra"

# Main gitconfig file
USER_GITCONFIG="$HOME/.gitconfig"

# Include line to add
INCLUDE_LINE="[include]\n    path = $DOTFILES_GITCONFIG"

# Ensure the dotfiles config file exists
if [ ! -f "$DOTFILES_GITCONFIG" ]; then
  echo "❌ $DOTFILES_GITCONFIG does not exist. Please check the path."
  exit 1
fi

# Create the user's .gitconfig if it doesn't exist
touch "$USER_GITCONFIG"

# Check if the include already exists
if grep -Fxq "    path = $DOTFILES_GITCONFIG" "$USER_GITCONFIG"; then
  echo "✅ $DOTFILES_GITCONFIG is already included in $USER_GITCONFIG"
else
  echo -e "\n$INCLUDE_LINE" >> "$USER_GITCONFIG"
  echo "✅ Included $DOTFILES_GITCONFIG in $USER_GITCONFIG"
fi

