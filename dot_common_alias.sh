# Common aliases for both bash and zsh

alias du="du -h"
alias df="df -h"

alias ssh-keygen="ssh-keygen -t ed25519 -a 128"

alias w="npx wrangler"
alias ll='ls -lAh'
alias la='ls -a'

alias code-chezmoi="code ~/.local/share/chezmoi/"
alias code-sd="code ~/src/scripts"
alias activate="source .venv/bin/activate"
alias a="source .venv/bin/activate"

alias tm="tmux -CC new -A -s iterm -t main"

# Open internal short links (b/123, cl/456, cr/789, go/foo-bar)
o() {
    if command -v open >/dev/null 2>&1; then
        open "http://$1"
    else
        xdg-open "http://$1"
    fi
}
