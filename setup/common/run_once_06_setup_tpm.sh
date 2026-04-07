#!/bin/bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Installing tmux plugins..."
# Clean up any leftover session, then start a detached tmux with our config
tmux kill-session -t _tpm_setup 2>/dev/null || true
tmux -f "$HOME/.config/tmux/tmux.conf" new-session -d -s _tpm_setup
"$TPM_DIR/bin/install_plugins"
tmux kill-session -t _tpm_setup 2>/dev/null || true
echo "TPM plugins installed."
