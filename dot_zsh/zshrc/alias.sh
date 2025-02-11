# alias
alias du="du -h"
alias df="df -h"

alias ssh-keygen="ssh-keygen -t ed25519 -a 128"

# save current directory and source ~/.zshrc and get back to the directory
alias reload="pwd > ~/.zshrc_pwd; source ~/.zshrc; cd \`cat ~/.zshrc_pwd\`"

alias w="npx wrangler"
alias ls='ls --color=auto'
alias ll='ls -lAh --time-style=long-iso --color=auto'

alias ud="update-dotfiles; chezmoi apply; source ~/.zshrc"
alias code-chezmoi="code ~/.local/share/chezmoi/"
alias code-sd="code ~/src/scripts"
alias sz="source ~/.zshrc"
alias zs="source ~/.zshrc"
alias pm2g="PM2_HOME=~/.local/share/pm2g pm2"
alias docker="podman"
alias docker-compose="podman-compose"
