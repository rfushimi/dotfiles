#!/bin/zsh

# Source centralized environment settings (PATH, tools, etc.)
# This file is shared between Bash and Zsh.
[ -f "$HOME/.zsh/zshrc/env.sh" ] && source "$HOME/.zsh/zshrc/env.sh"

# Zsh-specific tool completions/integrations (that need compinit/compdef)
if (( $+functions[compdef] )); then
    # Bun completions
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
    
    # GCloud completions are handled in env.sh for path, 
    # but zsh-specific completion might need extra care if not handled by OMZ/Zinit
fi
