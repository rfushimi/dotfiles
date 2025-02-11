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
export PATH="$HOME/.uv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Users/ryohei/.lmstudio/bin"
