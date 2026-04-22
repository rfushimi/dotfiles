#!/bin/zsh

# GNU coreutils: must be set here (not .zshenv) because macOS path_helper
# in /etc/zprofile reorders PATH after .zshenv, pushing gnubin behind /usr/bin.
if [ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi

# Zsh-specific tool completions/integrations (that need compinit/compdef)
if (( $+functions[compdef] )); then
    # Bun completions
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
    
    # GCloud completions are handled in env.sh for path, 
    # but zsh-specific completion might need extra care if not handled by OMZ/Zinit
fi
