---
name: repo-bootstrap
description: Set up and verify this dotfiles repository on a new machine. Use when installing or troubleshooting bootstrap setup.
---

# Repo Bootstrap

Use this skill when the user needs to install, update, or validate this dotfiles repository.

## What to Check

- Confirm required tools exist: `git` and `bash`.
- Confirm `DOTS_HOME` and `DOTS_DIR` expectations.
- Run installer or fallback flow as requested.
- Verify `./bin/dots-setup` completed and symlinks were created.

## Standard Install Paths

- Default repository path: `~/Projects/github/dots`
- Installer script: `install.sh`
- Main setup command inside repo: `./bin/dots-setup`

## Commands

Fresh bootstrap:

```sh
curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

Custom path:

```sh
DOTS_DIR="$HOME/some/other/path/dots" curl -fsSL https://raw.githubusercontent.com/iarkhanhelsky/dots/main/install.sh | bash
```

Manual fallback:

```sh
git clone git@github.com:iarkhanhelsky/dots.git --recurse-submodules ~/Projects/github/dots
cd ~/Projects/github/dots
./bin/dots-setup
```

## Troubleshooting

- If installer exits due to dirty repo, ask user to commit, stash, or discard local changes.
- If shell changes are not visible, reload shell or start a new terminal session.
