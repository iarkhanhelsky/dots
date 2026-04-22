# DOTS (...)

Opinionated shell scripts and config to make a local environment feel like home.
This setup is intended to work on both Linux and macOS systems and stay
portable across different machines (work/home) and development environments
(Go/Java/Ruby/...).

## Install

If Ruby is installed locally, setup is straightforward:

```sh
git clone git@github.com:iarkhanhelsky/dots.git --recurse-submodules
cd dots
rake
```

## Prerequisites

Required:

- `ruby` for running `rake`
- `zsh`

Optional but supported:

- `jenv`
- `jump`
- `direnv`
- `bat`

If these tools are installed, the shell config and shims will make use of
them when available.

## Structure

`TBD`

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
