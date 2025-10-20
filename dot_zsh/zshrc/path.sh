#!/bin/zsh

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

export XDG_CONFIG_HOME
export XDG_CACHE_HOME
export XDG_DATA_HOME
export XDG_STATE_HOME

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# rcmdnk/file/brew-file
if [ -d /opt/homebrew ]; then
    if [ -f $(brew --prefix)/etc/brew-wrap ]; then
        source $(brew --prefix)/etc/brew-wrap
    fi
fi

# User specific paths
export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/homebrew/opt/ruby/bin"

# CUDA (WSL2)
# https://zenn.dev/yumefuku/articles/wsl2-llm-install
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Load bun completions only if compinit is available
if [ -s "$BUN_INSTALL/_bun" ] && (( $+functions[compdef] )); then
    source "$BUN_INSTALL/_bun"
fi

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# LM Studio CLI
export PATH="$PATH:$HOME/.lmstudio/bin"

# Jetski
[ -d "$HOME/.jetski/jetski/bin" ] && export PATH="$HOME/.jetski/jetski/bin:$PATH"

# Google Cloud SDK (Homebrew Cask)
if [ -d "/opt/homebrew/Caskroom/google-cloud-sdk" ]; then
    source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
    source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi
