
# ---------------------------------------------------
# History
# ---------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_FIND_NO_DUPS
setopt share_history
setopt hist_reduce_blanks

# Ignore blank
setopt SH_WORD_SPLIT

# ---------------------------------------------------
# Options
# ---------------------------------------------------

autoload -Uz colors ; colors
autoload -Uz compinit ; compinit

setopt auto_cd
setopt correct
cdpath=(.. ~ ~/dev)
