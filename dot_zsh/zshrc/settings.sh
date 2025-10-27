# History settings
setopt share_history
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt inc_append_history         # Immediately append to history file
setopt HIST_IGNORE_SPACE          # Don't save commands starting with space
setopt HIST_REDUCE_BLANKS         # Remove extra blanks from history
setopt EXTENDED_HISTORY           # Save timestamp and duration

<<<<<<< HEAD
# コマンド実行後すぐに履歴ファイルへ追記
setopt inc_append_history
setopt extended_history
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt numeric_glob_sort
=======
# Directory stack settings
setopt AUTO_PUSHD                 # Automatically push directories to stack on cd
setopt PUSHD_IGNORE_DUPS          # Don't push duplicate directories
setopt PUSHD_MINUS                # Use cd -<n> to access directory stack

# Glob settings
setopt EXTENDED_GLOB              # Enable extended globbing
setopt GLOB_DOTS                  # Glob matches dotfiles

# Error correction
setopt CORRECT                    # Correct command spelling mistakes
>>>>>>> 7e1e711a88 (dotfiles sync)

export SD_EDITOR="code --wait"
export UV_PYTHON=3.11

setopt auto_cd
cdpath=(~ ~/dev)
