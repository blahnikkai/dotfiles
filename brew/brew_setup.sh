#!/bin/bash
set -e

echo "Setting up Homebrew..."

# Check if Homebrew is installed by looking for its executable
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Note: On a fresh Apple Silicon Mac or Linux machine, you may need to add
    # the Homebrew initialization commands here to add it to your PATH before continuing.
fi

# Run brew bundle, explicitly pointing to your Brewfile
# (Assuming the script is run from the root of your setup directory)
brew bundle --file=./brew/Brewfile
