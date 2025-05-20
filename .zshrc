# ⚡ Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 🌐 START LOCALS
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_COLLATE=C
export LC_TIME=en_US.UTF-8
# 🌐 END LOCALS

# 🛠️ START Bin installations
export PATH="$HOME/bin:$PATH"
# 🛠️ END Bin installations

# 🔧 START oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  pj 
  command-not-found
  zsh-autosuggestions   
  zsh-completions 
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
# 🔧 END oh-my-zsh

# 🏷️ START ALIAS
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias sourcesh="source ~/.zshrc"
alias nvmupdate="nvm install --reinstall-packages-from=current 'lts/*' && nvm alias default 'lts/*' && nvm use 'lts/*'"
alias dotfiles="code ~/.local/share/chezmoi"
alias chezcommit="chezmoi cd && git add . && git commit -m 'Auto-commit from chezmoi alias' && git push || echo 'An error occurred during the commit/push process.'"
alias chezapply="chezmoi apply"
alias chezterm="chezmoi re-add ~/Library/Preferences/com.googlecode.iterm2.plist"
alias chezcd="code ~/.local/share/chezmoi"
alias npmglobal="npm list -g --depth=0"
alias aliases="alias | grep -E 'alias ' | sed -e 's/alias //'"
alias mvn-no-tests="mvn clean install -DskipTests"
alias gitempty='function _gitempty() { git commit --allow-empty -m "$1"; }; _gitempty'
alias mkvenv='python -m venv .venv && source .venv/bin/activate'
alias chezapply-noscripts="chezmoi apply --exclude scripts"
# 🏷️ END ALIAS

# 🛤️ START PATHS


BREW_BIN="/opt/homebrew/bin"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$BREW_BIN:$PATH"

# 🌍 START Global specific paths

# 🐍 START PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d "$PYENV_ROOT" ]] && export PATH="$PYENV_ROOT/bin:$PATH" 
if [[ -z "$VIRTUAL_ENV" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
# 🐍 END PYENV

export PROJECT_PATHS="~/Developer"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 🌍 END Global specific paths

# 🛤️ END PATHS

# 📝 START EDITOR
export EDITOR="${SSH_CONNECTION:+vim}"
export EDITOR="${EDITOR:-mvim}"
# 📝 END EDITOR

# ⚙️ START Compilation flags
export ARCHFLAGS="-arch arm64"
# ⚙️ END Compilation flags


# 🧩 START Custom Functions
function tree() {
    command tree -I "node_modules|dist|.git" "$@"
}
# 🧩 END Custom Functions

# 🔁 START ZSH FUNCTIONS
nvm_auto_use() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
}

auto_activate_venv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    deactivate
  fi
  if [[ -f .venv/bin/activate ]]; then
    source ./.venv/bin/activate
  elif [[ -f venv/bin/activate ]]; then
    source ./venv/bin/activate
  fi
}
# 🔁 END ZSH FUNCTIONS

# 🪝 START ZSH Hooks (directory change)
add-zsh-hook chpwd nvm_auto_use
add-zsh-hook chpwd auto_activate_venv
# 🪝 END ZSH Hooks

# 🚀 START Functions to be run right now
nvm_auto_use
auto_activate_venv
# 🚀 END Functions

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
