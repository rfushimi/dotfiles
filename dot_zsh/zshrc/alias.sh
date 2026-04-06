# Zsh-specific aliases

# Source common aliases
[ -f "$HOME/.common_alias.sh" ] && source "$HOME/.common_alias.sh"

alias reload="source ~/.zshrc"
alias ud="update-dotfiles && chezmoi apply && source ~/.zshrc"
alias sz="source ~/.zshrc"
alias zs="source ~/.zshrc"

# ============================================================================
# Git Aliases (that might be shell specific)
# ============================================================================
alias g="git"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Gemini CLI with dotfiles workspaces
alias gemini-dot="gemini --include-directories ~/.local/share/chezmoi,~/corp-dotfiles"
