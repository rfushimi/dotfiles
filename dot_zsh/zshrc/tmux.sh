# Auto-attach to tmux session "main" on mac-studio
# Works both locally (iTerm2) and via SSH (iTerm2 -CC integration)
if [[ "$HOST" == *"Studio"* ]] && [[ -z "$TMUX" ]]; then
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]] || [[ -n "$SSH_CONNECTION" ]]; then
    exec tmux -CC new-session -A -s main
  fi
fi
