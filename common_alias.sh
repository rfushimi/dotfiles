# Common aliases for both bash and zsh

alias du="du -h"
alias df="df -h"

alias ssh-keygen="ssh-keygen -t ed25519 -a 128"

alias w="npx wrangler"
alias ls='ls --color=auto'
alias ll='ls -lAh --time-style=long-iso --color=auto'

alias code-chezmoi="code ~/.local/share/chezmoi/"
alias code-sd="code ~/src/scripts"
alias activate="source .venv/bin/activate"
alias a="source .venv/bin/activate"

alias tm="tmux -CC new -A -s main"
