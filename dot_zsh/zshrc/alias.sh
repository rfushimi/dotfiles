# zsh specific aliases

# Source common aliases
source ~/.common_alias.sh

# save current directory and source ~/.zshrc and get back to the directory
alias reload="pwd > ~/.zshrc_pwd; source ~/.zshrc; cd `cat ~/.zshrc_pwd`"

alias ud="update-dotfiles; chezmoi apply; source ~/.zshrc"
alias sz="source ~/.zshrc"
alias zs="source ~/.zshrc"
