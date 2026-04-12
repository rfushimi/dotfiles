# ============================================================================
# fzf - full-power setup with fd source + bat/eza previews
# ============================================================================
# Requires: fzf, fd, bat, eza (all in Brewfile).

# Default source: fd honors .gitignore and is faster than find. --hidden
# picks up dotfiles, --follow follows symlinks, --exclude .git keeps
# results clean inside repos.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height=60% --layout=reverse --border --inline-info --color=bg+:#1e1e1e,hl:#56b6c2,hl+:#56b6c2,info:#98c379,prompt:#61afef,pointer:#e5c07b,marker:#e5c07b,spinner:#c678dd,header:#5c6370'

# Ctrl-T: pick files from the current directory tree into the command line.
#   e.g. `vim <C-t>` -> fuzzy pick -> path inserted at cursor.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null' --preview-window=right:60%:wrap"

# Alt-C: fuzzy cd into any subdirectory of the current dir.
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {} 2>/dev/null'"

# Source fzf's official zsh integration. This wires up:
#   - Ctrl-T  (file picker, uses FZF_CTRL_T_* above)
#   - Alt-C   (directory jumper, uses FZF_ALT_C_* above)
#   - Ctrl-R  (history picker; atuin later overrides this in dot_zshrc
#              because atuin's init runs after imports.sh)
#   - **<TAB> (fzf-powered completion for cd/kill/ssh/etc.)
# Requires fzf >= 0.48.
if command -v fzf >/dev/null; then
    source <(fzf --zsh) 2>/dev/null
fi

# fzf-tab preview: when tabbing through a completion, show what we're
# looking at. Directories get an eza tree, files get a bat preview.
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level=2 --color=always --icons $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    if [[ -d $realpath ]]; then
        eza --tree --level=2 --color=always --icons $realpath 2>/dev/null
    elif [[ -f $realpath ]]; then
        bat --color=always --line-range=:200 $realpath 2>/dev/null
    fi
'
