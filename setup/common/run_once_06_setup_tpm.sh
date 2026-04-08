#!/bin/bash
set -euo pipefail

if ! command -v tmux &>/dev/null; then
  echo "tmux not found, skipping TPM setup"
  exit 0
fi

# XDG-compatible paths (matches TPM's auto-detection for ~/.config/tmux/tmux.conf)
PLUGIN_DIR="$HOME/.config/tmux/plugins"
TPM_DIR="$PLUGIN_DIR/tpm"

mkdir -p "$PLUGIN_DIR"

if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Installing tmux plugins..."
tmux kill-session -t _tpm_setup 2>/dev/null || true
tmux new-session -d -s _tpm_setup
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$PLUGIN_DIR/"
"$TPM_DIR/bin/install_plugins"
tmux kill-session -t _tpm_setup 2>/dev/null || true
echo "TPM plugins installed."
