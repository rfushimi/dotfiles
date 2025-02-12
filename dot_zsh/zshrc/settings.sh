setopt share_history

export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# コマンド実行後すぐに履歴ファイルへ追記
setopt inc_append_history
