#!/bin/bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
  echo "TPM already installed at $TPM_DIR"
else
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install plugins non-interactively
echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"
