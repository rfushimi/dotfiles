# GEMINI.md: fushimi's Dotfiles (Chezmoi Managed)

This directory (`~/.local/share/chezmoi`) contains the source files for fushimi's personal dotfiles, managed by `chezmoi`.

**CRITICAL: NEVER edit files directly in the home directory (e.g., `~/.zshrc`). ALWAYS edit the source files within this directory and then apply the changes.**

## Workflow

1.  **Edit:** Modify the source files in `~/.local/share/chezmoi/`.
2.  **Apply:** Run `chezmoi apply` to deploy the changes to the home directory.

## Key Conventions & File Naming

*   **`dot_` prefix:** Files/directories starting with `dot_` will have the `.` prefix in the home directory (e.g., `dot_zshrc` -> `~/.zshrc`).
*   **`.tmpl` suffix:** These files are Go templates. They are processed by `chezmoi` to generate the final file, allowing for OS or host-specific configurations using conditions like `{{ if eq .chezmoi.os "darwin" }}`.
*   **`private_` prefix:** Files/directories starting with `private_` will have their permissions set to `0600` (read/write only by owner).
*   **`executable_` prefix:** Files starting with `executable_` will have the execute bit set. These are typically scripts placed in `~/bin`.
*   **`run_once_` prefix (in `setup/`):** Scripts in the `setup/` directories with this prefix are run only once when `chezmoi init` or `chezmoi apply` is first run.
*   **`run_` prefix (in `setup/`):** Scripts in the `setup/` directories with this prefix are run every time `chezmoi apply` is executed.

## Directory Structure

*   `dot_bin/`: Contains executable scripts that will be linked into `~/bin`.
*   `dot_gemini/`: Configuration for Gemini.
*   `dot_hammerspoon/`: Hammerspoon configuration for macOS window management and shortcuts.
*   `dot_utils/`: Utility scripts, including Python scripts for interacting with LLMs.
*   `dot_zsh/`: Zsh configuration.
    *   `imports.sh`: Sources all `.sh` files in `dot_zsh/zshrc/`.
    *   `zshrc/`: Modular Zsh configuration files (aliases, paths, settings, etc.).
*   `private_dot_config/`: Application configurations (alacritty, starship, brewfile, etc.).
*   `private_dot_ssh/`: SSH configuration.
*   `setup/`: Installation and setup scripts for different environments (common, mac, wsl, corp-mac).
*   `dot_zshrc`: Main entry point for Zsh configuration.
*   `dot_bashrc.tmpl`: Main entry point for Bash configuration.
*   `dot_gitconfig.tmpl`: Git configuration.
*   `LLM.md`: **IMPORTANT** Detailed instructions for an LLM (like you) on how to edit files in this repository. Consult this file for specific guidance on where to make changes.

## Making Changes (LLM Guidelines)

**ALWAYS CONSULT `LLM.md` before making changes.** It contains specific instructions on where to add aliases, paths, environment variables, and other configurations, especially for the Zsh setup.

*   **Zsh:** Most changes will go into one of the files in `dot_zsh/zshrc/`. `LLM.md` has a table guiding where to put things (e.g., `path.sh` for PATH, `alias.sh` for aliases).
*   **Bash:** Edit `dot_bashrc.tmpl`.
*   **Git:** Edit `dot_gitconfig.tmpl`.
*   **New Scripts:** Add to `dot_bin/` with `executable_` prefix.

## Common Tasks

*   **Add an alias (Zsh):** Add to `dot_zsh/zshrc/alias.sh`.
*   **Add to PATH (Zsh):** Add to `dot_zsh/zshrc/path.sh`.
*   **Install software:** Add to the appropriate `setup/` script (e.g., `setup/mac/run_once_brew.sh`).

Remember to run `chezmoi apply` after making changes.
