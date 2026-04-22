# DOTS (...)

Opinionated shell scripts and config to make a local environment feel like home.
This setup is intended to work on both Linux and macOS systems and stay
portable across different machines (work/home) and development environments
(Go/Java/Ruby/...).

## Install

One-liner bootstrap:

```sh
curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

By default, the installer uses `~/Projects/github/dots`.
You can override that path:

```sh
DOTS_DIR="$HOME/some/other/path/dots" curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

For testing in an isolated home directory, you can override home as well:

```sh
DOTS_HOME="/tmp/dots-test-home" curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

`DOTS_HOME` changes where `rake` writes dotfiles, and `DOTS_DIR` defaults to
`$DOTS_HOME/Projects/github/dots`.

Installer behavior:
- If the repo is missing, it clones with submodules and runs `rake`.
- If the repo exists and is clean, it fast-forwards + updates submodules, then runs `rake`.
- If local changes are present, it exits without overwriting them.

Manual setup (fallback):

```sh
git clone git@github.com:iarkhanhelsky/dots.git --recurse-submodules ~/Projects/github/dots
cd ~/Projects/github/dots
rake
```

## Prerequisites

Required:

- `git` (used by installer and updates)
- `ruby`
- `rake` (usually installed with Ruby)
- `zsh` (for the shell config this repo installs)

Optional but supported:

- `jenv`
- `jump`
- `direnv`
- `bat`

If these tools are installed, the shell config and shims will make use of
them when available.

## Structure

- `rc/`: base dotfile sources. Files here are linked into `$HOME` as hidden
  files (for example, `rc/zshrc` -> `$HOME/.zshrc`).
- `rc-darwin/` and `rc-linux/`: platform overlays selected automatically based
  on your OS.
- `configure/`: post-link scripts run by `rake configure`.
- `lib/` + `Rakefile`: linking and setup orchestration.
- `shims/`: shim runtime (`shims/dm-shim`), generated launchers (`shims/bin/`),
  and tool definitions (`shims/defs/`).
- `tmux/`: tmux assets/plugins used by the shell/tmux setup.
- `zsh-plugins/`: bundled plugin sources.

Setup flow in short:

- `install.sh` checks for `git`, `ruby`, and `rake`.
- It uses `DOTS_HOME` (default: `$HOME`) and `DOTS_DIR` (default:
  `$DOTS_HOME/Projects/github/dots`).
- For an existing checkout, updates run only when the repo is clean.
- `rake` runs two phases:
  - `link`: symlink selected `rc*` files into `$HOME`.
  - `configure`: execute `configure*.sh` scripts for your platform/host.

What gets changed:

- Dotfiles in `$HOME` are managed as symlinks to this repository.
- Existing targets are replaced during linking.
- Setup scripts from `configure*/` are executed during `rake`.

## AI Config

This repository can also manage personal AI config using the same bootstrap +
linking model as the rest of the dotfiles.

- Claude personal agents live in `rc/claude/agents/*.md` and are linked to
  `~/.claude/agents/*.md`.
- Shared skills live in `rc/claude/skills/*/SKILL.md` and are linked to
  `~/.claude/skills/*/SKILL.md`.

This keeps a single source of truth for personal skills while supporting
Claude-only personal agents.

## Shims

This repo includes a lightweight shim runtime for tools that should be
downloaded on demand and cached outside the repo.

- Supported platforms: `darwin/arm64` and `linux/amd64`
- Cache location: `~/.cache/dm-dots/shims/...`
- Cache invalidation: definition content hash (updating a definition triggers a
  redownload automatically)

### Add a new shim

1. Scaffold a shim and definition:

```sh
./shims/dm-shim add <tool-name>
```

2. Edit `shims/defs/<tool-name>.env`:

```sh
TOOL_VERSION="v0.0.0"
TOOL_URL="gh://owner/repo/{version}/asset-{os}-{arch}.tar.gz"
TOOL_FILE="path/inside/archive/to/binary"
```

`gh://` expands to
`https://github.com/<owner>/<repo>/releases/download/...`

Placeholders supported in `TOOL_URL`:
- `{version}`
- `{os}` (`darwin` / `linux`)
- `{arch}` (`arm64` / `amd64`)

Optional fields:
- `TOOL_MODE` (`auto` by default; supported values: `binary`, `tar.gz`, `zip`)
- `TOOL_FILE` (required for `tar.gz` and `zip`)
- Per-platform overrides are supported with suffixes, for example:
  `TOOL_URL_DARWIN_ARM64`, `TOOL_URL_LINUX_AMD64`,
  `TOOL_FILE_DARWIN_ARM64`, `TOOL_MODE_LINUX_AMD64`

3. Commit the generated shim launcher at `shims/bin/<tool-name>` and the
   definition file.

### Use a shim

After reloading your shell config, run `<tool-name>`.
The first run downloads the tool into cache; later runs execute it from there.
