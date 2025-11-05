# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with chezmoi (v2.59.0+). It contains configuration files, scripts, and utilities for setting up and maintaining development environments across multiple platforms (macOS, Linux/WSL, Windows).

## Chezmoi Architecture

### Source and Target States

- **Source directory**: `~/.local/share/chezmoi/` (this repository)
- **Target directory**: `~/` (your home directory)
- **Working with files**:
  - Files prefixed with `dot_` become `.filename` in home directory
  - Files prefixed with `private_` have permissions set to 0600
  - Files with `.tmpl` extension are processed as Go templates before deployment

### Template System

This repository uses chezmoi's Go template system extensively:

- Access to `.chezmoi.os` (darwin/linux/windows), `.chezmoi.arch`, `.chezmoi.hostname`
- Conditional rendering based on OS: `{{ if eq .chezmoi.os "darwin" }}`
- WSL detection: `{{ if (.chezmoi.kernel.osrelease | lower | contains "microsoft") }}`
- Templates are used for platform-specific configurations and setup scripts

### Key Directories

- `setup/`: Platform-specific installation and configuration scripts
  - `setup/mac/`: macOS-specific setup (Homebrew, packages, coreutils)
  - `setup/wsl/`: WSL-specific configuration
  - `setup/windows/`: Windows setup (Chocolatey, PowerShell)
  - `setup/common/`: Cross-platform utilities
  - Scripts prefixed with `run_once_` execute only on first application
  - Scripts prefixed with `run_` execute on every `chezmoi apply`

- `dot_zsh/`: Zsh configuration
  - Uses Zinit plugin manager
  - Powerlevel10k theme
  - Modular configuration in `dot_zsh/zshrc/*.sh` loaded via `imports.sh`

- `dot_utils/`: Custom utilities and scripts
  - `api/`: LLM API clients (Gemini, Claude) for translation tasks
  - `src/LLMTools/`: Python package with LLM utilities (uses uv/pdm)

- `dot_bin/`: Executable scripts added to PATH
  - `sd`: Script directory tool
  - `osc52`: Terminal clipboard utility
  - `things`: Things.app CLI integration

- `dot_hammerspoon/`: macOS Hammerspoon configuration
  - Application launcher shortcuts (Cmd+Escape for Chrome, Cmd+` for iTerm, etc.)
  - Window management (Option+arrows for positioning/maximizing)

- `private_dot_config/`: Application-specific configurations
  - `alacritty/`: Terminal emulator config
  - `brewfile/`: Homebrew bundle file
  - `models.toml`: LLM model configurations

## Common Operations

### Testing Changes

```bash
# View what would change
chezmoi diff

# Preview changes for specific file
chezmoi diff ~/.zshrc

# See source state of a file
chezmoi cat ~/.zshrc
```

### Applying Changes

```bash
# Apply all changes
chezmoi apply

# Apply specific file
chezmoi apply ~/.zshrc

# Verbose output
chezmoi -v apply
```

### Editing Files

```bash
# Edit source state (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Edit and apply immediately
chezmoi edit --apply ~/.zshrc

# Navigate to source directory
chezmoi cd
```

### Adding New Files

```bash
# Add file to chezmoi management
chezmoi add ~/.newconfig

# Add as template (for platform-specific content)
chezmoi add --template ~/.gitconfig
```

### Syncing with Git

```bash
# From source directory (chezmoi cd)
git add .
git commit -m "Description"
git push

# Or use chezmoi's git commands
chezmoi git add .
chezmoi git commit -m "Description"
chezmoi git push
```

### Initial Setup on New Machine

```bash
# Mac
mkdir -p .bin
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.bin init --apply rfushimi

# Linux/WSL
mkdir -p .bin
apt update && apt install -y curl git zsh && \
  chsh -s /usr/bin/zsh && \
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.bin init --apply rfushimi
```

## Platform-Specific Setup Scripts

### Execution Order

Scripts in `setup/` run in alphabetical order:
1. `run_once_before_*`: Runs before other scripts (e.g., package manager installation)
2. `run_once_00_*`, `run_once_01_*`, etc.: Numbered for explicit ordering
3. `run_*`: Non-once scripts run every time

### Mac Setup Sequence
1. Install Homebrew (`run_once_01_install_packages.sh.tmpl`)
2. Install uv Python package manager (`run_once_02_install_uv.sh`)
3. Install GNU coreutils (`run_once_03_coreutils.sh.tmpl`)
4. Set macOS defaults (`run_once_04_default.sh`)

### Common Tools
- `run_once_setup_uv.sh`: Installs uv and creates virtual environment at `~/.local/share/uv`
- `run_once_get_sd.sh`: Installs the sd script directory tool

## LLM Tools Architecture

The `dot_utils/api/` directory implements a modular LLM client system:

- **Base interface**: `LLMClient/LLMClient.py` defines common interface
- **Implementations**: `LLMClient/Claude.py`, `LLMClient/Gemini.py`
- **CLI tools**: `translate.py` (Gemini-based translation via stdin/stdout)
- **Configuration**: API keys and settings managed via environment or config files

### Adding New LLM Providers
1. Create new client in `LLMClient/<Provider>.py` implementing the base interface
2. Create CLI script in `api/` directory using the new client
3. Add dependencies to `dot_utils/src/LLMTools/pyproject.toml`

## Important Notes

- `.chezmoiignore` excludes build artifacts, node_modules, virtualenvs, IDE configs
- The repository includes a `dot_gemini/GEMINI.md` file with Google-internal workflow instructions (relevant only in corporate context)
- Zsh completions for `sd` are auto-generated in `~/.zsh/completions`
- Git is configured to use SSH for GitHub URLs (even if HTTPS is specified)
- Uses uv for Python dependency management (modern pip replacement)

## Development Environment Preferences

This section documents conventions and shared configurations across development projects in `~/dev/`.

### Package Managers

**IMPORTANT**: Always use the specified package managers for consistency:

- **Python projects**: Use `uv` exclusively
  - Running scripts: `uv run python script.py`
  - Installing packages: `uv add package-name`
  - Syncing dependencies: `uv sync`
  - Never use `pip` or `virtualenv` directly

- **JavaScript/Node projects**: Use `pnpm` exclusively
  - Installing dependencies: `pnpm install`
  - Running scripts: `pnpm dev`, `pnpm build`, etc.
  - Never use `npm` or `yarn` (even if package.json scripts reference `npm run`)

### SvelteKit Projects Common Stack

All SvelteKit projects (`~/dev/planner/svelte`, `~/dev/f1-dash`, `~/dev/techo`, `~/dev/asset-dash`) share:

**Core Technologies**:
- Svelte 5 (latest)
- SvelteKit 2
- TypeScript
- Vite 7
- Tailwind CSS 4 (with `@tailwindcss/vite` plugin)

**Testing**:
- Vitest for unit tests (with browser and server test projects)
- Playwright for E2E tests
- Test setup: Client tests (`.svelte.{test,spec}.{js,ts}`) run in browser, server tests run in Node

**Common Development Commands**:
```bash
pnpm dev          # Start development server
pnpm build        # Build for production
pnpm preview      # Preview production build
pnpm check        # Type checking with svelte-check
pnpm check:watch  # Watch mode type checking
pnpm lint         # Run ESLint and Prettier checks
pnpm format       # Format code with Prettier
pnpm test:unit    # Run Vitest unit tests
pnpm test:e2e     # Run Playwright E2E tests
```

### Vite Development Server Configuration

**Network Access**: Always configure Vite to listen on hostname for network accessibility:

```typescript
// vite.config.ts
export default defineConfig({
  server: {
    host: 'mac-studio',  // Standard hostname for main workstation
    // port: 6600,       // Optional: specify custom port (default 5173)
  }
});
```

**Port Assignments** (avoid conflicts):
- Default: 5173 (Vite default)
- `~/dev/techo`: 6600 (custom port)
- `~/dev/planner/svelte`: Uses `allowedHosts: ['m100']` approach

### Database Projects (Drizzle ORM)

Projects using Drizzle ORM + libSQL/SQLite (`f1-dash`, `techo`, `asset-dash`):

**Required Environment Variable**:
- `DATABASE_URL` - Database connection string (e.g., `file:local.db`)

**Common Database Commands**:
```bash
pnpm db:generate  # Generate migration files from schema
pnpm db:push      # Push schema changes directly to database
pnpm db:migrate   # Run pending migrations
pnpm db:studio    # Open Drizzle Studio (database GUI)
pnpm db:seed      # Seed database (if available)
```

**Schema Location**: `src/lib/server/db/schema.ts`
**Client Location**: `src/lib/server/db/index.ts`

### Cloudflare Projects

Projects deploying to Cloudflare Pages/Workers (`f1-dash`, `asset-dash`):

**Adapter**: `@sveltejs/adapter-cloudflare`
**Tools**: Wrangler CLI for local development and deployment

**Common Commands**:
```bash
pnpm dev          # Usually wraps: wrangler pages dev -- vite dev
pnpm deploy       # Build and deploy: pnpm build && wrangler deploy
pnpm cf-typegen   # Generate TypeScript types for Workers
```

**Platform Integration**:
- Access platform bindings via `event.platform.env` in SvelteKit
- Worker types in `src/worker-configuration.d.ts` (auto-generated)

### Project-Specific Notes

**planner** (`~/dev/planner`):
- Hybrid Python/JavaScript project
- Python backend: Use `uv run` for all Python commands
- Svelte frontend: Located in `svelte/` subdirectory, use `pnpm` commands
- Protobuf compilation: `pnpm proto` (from root) compiles for both Python and JavaScript
- Development: Run backend simulations with `uv run`, serve web UI with `cd svelte && pnpm dev`

**f1-dash** (`~/dev/f1-dash`):
- F1 data dashboard using OpenF1 API
- Cloudflare Pages deployment with D1 database bindings
- Custom dev command uses Wrangler for local Cloudflare environment

**techo** (`~/dev/techo`):
- Custom port 6600 for dev server
- Authentication with `@auth/sveltekit`
- Form handling with `sveltekit-superforms`

**asset-dash** (`~/dev/asset-dash`):
- Personal finance tracking dashboard
- Data visualization with Plotly.js and D3
- CSV import/export with PapaParse
