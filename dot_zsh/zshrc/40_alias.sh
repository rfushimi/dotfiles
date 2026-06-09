# Zsh-specific aliases

# Source common aliases
[ -f "$HOME/.common_alias.sh" ] && source "$HOME/.common_alias.sh"

ud() {
    update-dotfiles "$@"
    chezmoi apply
    source ~/.zshrc
}

# Draftbox: quick note-taking in VS Code
alias draft='code ~/Draftbox --profile "Draftbox"'
