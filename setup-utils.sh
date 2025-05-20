#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Wait for Homebrew install to complete properly
    if [ -f /opt/homebrew/bin/brew ]; then
        echo "Homebrew installed at /opt/homebrew/bin/brew"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        echo "Homebrew installed at /usr/local/bin/brew"
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "❌ Homebrew installation failed. brew not found."
        exit 1
    fi
fi

# Install nvm if not installed
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash &> /dev/null
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"  # Load nvm
else
    echo "NVM is not installed. Skipping LTS version installation and default alias setup."
    exit 1
fi

# Check if NVM is loaded successfully
if command -v nvm > /dev/null 2>&1; then
    echo "NVM is installed. Checking for latest LTS version..."
    
    # Check if the latest LTS version is installed
    LTS_VERSION=$(nvm ls-remote --lts | tail -1 | awk '{print $1}')
    
    if ! nvm ls "$LTS_VERSION" > /dev/null 2>&1; then
        echo "Installing the latest LTS version: $LTS_VERSION"
        nvm install lts/*
    else
        echo "Latest LTS version ($LTS_VERSION) is already installed."
    fi

    # Set default to latest LTS
    echo "Setting NVM default to the latest LTS version..."
    nvm alias default lts/*
else
    echo "Failed to load NVM. Skipping LTS version installation and default alias setup."
    exit 1
fi

DEVELOPER_FOLDER="$HOME/Developer"

if [[ ! -d "$DEVELOPER_FOLDER" ]]; then
  echo "Creating Developer folder at $DEVELOPER_FOLDER..."
  mkdir -p "$DEVELOPER_FOLDER"
else
  echo "Developer folder already exists at $DEVELOPER_FOLDER."
fi

# Move dot_p10k.zsh to the user's home directory and rename it to .p10k.zsh
if [ -f "$SCRIPT_DIR/dot_p10k.zsh" ]; then
    echo "Moving dot_p10k.zsh to $HOME/.p10k.zsh..."
    mv "$SCRIPT_DIR/dot_p10k.zsh" "$HOME/.p10k.zsh"
else
    echo "❌ dot_p10k.zsh not found in $SCRIPT_DIR. Skipping move and rename."
fi
# Move .zshrc to the user's home directory
if [ -f "$SCRIPT_DIR/.zshrc" ]; then
    echo "Moving .zshrc to $HOME/.zshrc..."
    mv "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
else
    echo "❌ .zshrc not found in $SCRIPT_DIR. Skipping move."
fi