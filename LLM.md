# Dotfiles Editing Guide

This is a chezmoi-managed dotfiles repository.
Source directory: ~/.local/share/chezmoi/ → Target: ~/

## CRITICAL: Edit source files only

Always edit files in THIS directory (the chezmoi source), never the target files in ~/.
After editing, the user runs `chezmoi apply` to deploy.

## Chezmoi naming conventions

- `dot_` prefix → `.` in target (e.g. `dot_zsh/` → `~/.zsh/`)
- `private_` prefix → 0600 permissions
- `.tmpl` suffix → Go template (use `{{ if eq .chezmoi.os "darwin" }}` etc.)
- `executable_` prefix → executable bit set

## Zsh module system (dot_zsh/zshrc/)

All `.sh` files in `dot_zsh/zshrc/` are auto-sourced by `dot_zsh/imports.sh`.

| File | Purpose |
|------|---------|
| `path.sh` | PATH exports, environment variables, tool initialization (cargo, nvm, pnpm, bun, etc.) |
| `alias.sh` | Shell aliases |
| `settings.sh` | Zsh options (history, glob, cd), editor settings, UV_PYTHON |
| `fzf.sh` | fzf-related functions and keybindings |
| `host.sh` | Host-specific powerlevel10k prompt segments |
| `os.sh.tmpl` | OS-specific settings (macOS/Linux/Windows conditionals) |
| `arch.sh.tmpl` | Architecture-specific settings |
| `corp.sh.tmpl` | Corporate environment settings |
| `ud.sh.tmpl` | `update-dotfiles` function (git sync) |
| `pm2.sh` | pm2 settings |

### Decision guide for zsh edits

- Adding a PATH or sourcing a tool → `path.sh`
- Adding an alias → `alias.sh`
- Changing zsh behavior (setopt, history, etc.) → `settings.sh`
- Adding an fzf-powered function → `fzf.sh`
- OS-specific config → `os.sh.tmpl`
- New module that doesn't fit above → create `dot_zsh/zshrc/<name>.sh`

## Executables (dot_bin/)

Scripts with `executable_` prefix are deployed to `~/bin/`. Use `#!/usr/bin/env bash`.

## Other key locations

- `dot_hammerspoon/` → macOS Hammerspoon config (app launchers, window management)
- `private_dot_config/` → App configs (alacritty, brewfile, models.toml, etc.)
- `setup/` → Installation scripts (run_once_ = first run only, run_ = every apply)
- `dot_utils/api/` → LLM client utilities (Python, uses uv)
