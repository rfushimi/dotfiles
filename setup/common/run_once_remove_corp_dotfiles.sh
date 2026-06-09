#!/bin/bash
# Remove legacy corp-dotfiles repository as it has been merged into chezmoi.

if [ -d "$HOME/corp-dotfiles" ]; then
  echo "Removing legacy corp-dotfiles directory..."
  rm -rf "$HOME/corp-dotfiles"
fi

# Also remove the symlink in the chezmoi source directory if it exists on the target?
# Wait, the symlink was in the source directory, not target.
# Chezmoi doesn't deploy the symlink because it's ignored in .chezmoiignore or .gitignore.
# Actually, the symlink is in the source directory, so we should delete it from the source directory.
