# DOTS (...)

<p align="center"><strong>minimalist configurations</strong></p>
<p align="center">
  <code>.zshrc</code> • <code>.zshrc.d/*</code> • <code>.profile</code> • <code>.tmux.conf</code> • <code>.claude/*</code>
</p>
<p align="center">
  <code>git</code> • <code>zsh</code> • <code>tmux</code> • <code>direnv/jump/jenv</code> • <code>shims</code>
</p>

<p align="center">
  <pre>
██████╗  ██████╗ ████████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
██║  ██║██║   ██║   ██║   ███████╗
██║  ██║██║   ██║   ██║   ╚════██║
██████╔╝╚██████╔╝   ██║   ███████║
╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
  </pre>
</p>

Personal dotfiles + bootstrap scripts for a fast, consistent shell setup across
macOS and Linux.

If you want one repo to manage shell config, platform-specific overlays, and a
small "download-on-first-use" tool system, this is that repo.

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [What Happens During Install](#what-happens-during-install)
- [Day-to-Day Usage](#day-to-day-usage)
- [Vim Quick Start](#vim-quick-start)
- [Repository Map](#repository-map)
- [Optional AI Config](#optional-ai-config)
- [Shims](#shims)

## Quick Start

Bootstrap in one command:

```sh
curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

Defaults:
- `DOTS_HOME="$HOME"`
- `DOTS_DIR="$DOTS_HOME/Projects/github/dots"`

Common overrides:

```sh
# Use a custom checkout location
DOTS_DIR="$HOME/some/other/path/dots" \
  curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash

# Test in an isolated home directory
DOTS_HOME="/tmp/dots-test-home" \
  curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

Manual fallback:

```sh
git clone --recurse-submodules https://github.com/iarkhanhelsky/dots.git ~/Projects/github/dots
cd ~/Projects/github/dots
./bin/dots-setup
```

After install, quick sanity check:
- Open a new shell (`zsh`) and confirm your prompt/plugins are active.
- Run `./bin/dots-setup` from the repo once to verify no setup issues.

## Prerequisites

Required:
- `git`
- `bash`
- `zsh`

Optional but supported:
- `jenv`
- `jump`
- `direnv`
- `bat`

If optional tools are installed, config and shims use them automatically.

## What Happens During Install

`install.sh` does the following:
- Verifies `git` and `bash` are available.
- Uses `DOTS_HOME`/`DOTS_DIR` (or defaults) and exports `HOME="$DOTS_HOME"`.
- If the repo does not exist: clone with submodules, then run `./bin/dots-setup`.
- If the repo exists and is clean: `git pull --ff-only --recurse-submodules`,
  update submodules, then run `./bin/dots-setup`.
- If local changes exist: exit without overwriting anything.

`./bin/dots-setup` then performs dotfiles linking + configure scripts.

## Day-to-Day Usage

- **Update your setup:** rerun the bootstrap command, or
  `cd "$DOTS_DIR" && ./bin/dots-setup`
  after pulling changes yourself.
- **When updates fail:** if installer reports local changes, commit/stash/discard
  in `DOTS_DIR`, then rerun.
- **Changing machines/environments:** reuse the same bootstrap command and set
  `DOTS_HOME`/`DOTS_DIR` if needed.

## Vim Quick Start

If you use Vim casually, this repo now includes [`rc/vimrc`](rc/vimrc) with
simple defaults for single-file edits and git commit messages.

- **Undo/redo**
  - `u` undo
  - `Ctrl-r` redo
  - `:earlier 5m` / `:later 5m` for time-based undo travel
- **Yank/paste**
  - Native Vim still works (`yy`, `yw`, `p`, `P`)
  - `<leader>y` copy to system clipboard (`<leader>` is `Space`)
  - `<leader>p` / `<leader>P` paste from system clipboard
  - Useful registers: `"` (default), `"0` (last yank), `"+` (system clipboard)
- **Commit messages**
  - In `git commit` buffers: spellcheck is enabled and wrapping is tuned for
    the common 72-character body style.
- **Optional plugins**
  - `rc/vimrc` includes a commented `vim-plug` block with lightweight options:
    `vim-sensible`, `vim-surround`, `vim-commentary`.
  - Config works without plugins; uncomment only if you want them.
- **A few commands that dramatically improve daily use**
  - Navigation: `w` / `b` / `e` (word moves), `0` / `^` / `$` (line start/non-blank/end)
  - Editing: `ciw` (change word), `di(` (delete inside parentheses), `da"` (delete around quotes)
  - Search: `/text` then `n` / `N` for next/previous match
  - Buffers: `:e file` open file, `:bnext` and `:bprev` switch between open buffers

## Repository Map

- `rc/`: base dotfile sources (linked into `$HOME` as hidden files).
- `rc/shared/`: shared assets linked once and consumed by multiple tools.
- `rc-darwin/` and `rc-linux/`: OS-specific overlays.
- `configure/`: post-link setup scripts used by `./bin/dots-setup`.
- `bin/dots-setup`: orchestration for link/configure phases.
- `shims/`: shim runtime, generated launchers, and shim definitions.
- `tmux/`: tmux assets/plugins used by this setup.
- `zsh-plugins/`: bundled zsh plugin sources.

What this changes in practice:
- Dotfiles in `$HOME` are managed as symlinks into this repo.
- Existing targets can be replaced during linking.
- Configure scripts from `configure*/` run during setup.

## Optional AI Config

This repo can also manage personal Claude/Cursor config using the same linking model.
If you do not use it, you can safely ignore this section.

- Personal agents: `rc/claude/agents/*.md` -> `~/.claude/agents/*.md`
- Shared skills source: `rc/shared/skills/*/SKILL.md` -> `~/.shared/skills/*/SKILL.md`
- Claude skills link: `~/.claude/skills` -> `~/.shared/skills`
- Cursor skills link: `~/.cursor/skills` -> `~/.shared/skills`

## Shims

Shims let you expose CLI tools that are downloaded on demand and cached outside
this repository.

- Supported platforms: `darwin/arm64`, `linux/amd64`
- Cache root: `~/.cache/dm-dots/shims`
- Cache invalidation: definition-file hash (definition changes trigger refresh)

### Add a New Shim

1. Scaffold shim launcher + placeholder definition:

```sh
./shims/dm-shim add <tool-name>
```

2. Edit `shims/defs/<tool-name>.env`:

```sh
TOOL_VERSION="v0.0.0"
TOOL_URL="gh://owner/repo/{version}/asset-{os}-{arch}.tar.gz"
TOOL_FILE="path/inside/archive/to/binary"
```

Notes:
- `gh://...` expands to
  `https://github.com/<owner>/<repo>/releases/download/...`
- Supported placeholders: `{version}`, `{os}`, `{arch}`
- Optional overrides:
  - `TOOL_MODE` (`auto`, `binary`, `tar.gz`, `zip`)
  - `TOOL_URL_DARWIN_ARM64`, `TOOL_URL_LINUX_AMD64`
  - `TOOL_FILE_DARWIN_ARM64`, `TOOL_MODE_LINUX_AMD64`

3. Commit:
- `shims/bin/<tool-name>`
- `shims/defs/<tool-name>.env`

### Use a Shim

Reload shell config, then run the tool name directly.

Example:

```sh
my-tool --help
```

On first run, the shim downloads and caches the binary. Later runs use cache.
