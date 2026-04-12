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

# tm - attach (or create) the main tmux session.
# Uses iTerm2's tmux control mode (-CC) when launched from iTerm2,
# and a plain tmux attach everywhere else (Ghostty, Linux, WSL).
tm() {
    if [ "$TERM_PROGRAM" = "iTerm.app" ] || [ "$LC_TERMINAL" = "iTerm2" ]; then
        tmux -CC new -A -s main
    else
        tmux new -A -s main
    fi
}

# Open internal short links (b/123, cl/456, cr/789, go/foo-bar)
o() {
    if command -v open >/dev/null 2>&1; then
        open "http://$1"
    else
        xdg-open "http://$1"
    fi
}
