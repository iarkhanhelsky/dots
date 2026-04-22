# DOTS (...)

Opinionated set of shell scripts to make local environment feel like home.
This setup intended to work on both Linux and MacOS systems, and be portable
enough to use on different machines (work/home) and different dev environments
(go/java/ruby/...)

## Install

Having ruby installed locally it's pretty straightforward to setup:

```
$ git clone git@github.com:iarkhanhelsky/dots.git --recurse-submodules
$ cd dots
$ rake 
```

## Perequesities

This packages MUST present:

* ruby
* zsh
* ???

This packages MAY present^[1]:

* jenv
* jump
* direnv
* rbenv
* bat

[1] means we'll try to make best use of them. It's also todo list to setup

## Structure

`TBD`

## Shims

This repo includes a lightweight shim runtime for tools that should be downloaded
on demand and cached outside the repo.

- Supported platforms: `darwin/arm64` and `linux/amd64`
- Cache location: `~/.cache/dm-dots/shims/...`
- Cache invalidation: definition content hash (updating a definition triggers a
  redownload automatically)

### Add a new shim

1. Scaffold shim + definition:

```
./shims/dm-shim add <tool-name>
```

2. Edit `shims/defs/<tool-name>.env`:

```
TOOL_VERSION="v0.0.0"
TOOL_URL="gh://owner/repo/{version}/asset-{os}-{arch}.tar.gz"
TOOL_FILE="path/inside/archive/to/binary"
```

`gh://` expands to:
`https://github.com/<owner>/<repo>/releases/download/...`

Placeholders supported in `TOOL_URL`:
- `{version}`
- `{os}` (`darwin` / `linux`)
- `{arch}` (`arm64` / `amd64`)

Optional fields:
- `TOOL_MODE` (`auto` (default), `binary`, `tar.gz`, `zip`)
- `TOOL_FILE` (required for `tar.gz` and `zip`)
- Per-platform overrides are supported with suffixes, for example:
  `TOOL_URL_DARWIN_ARM64`, `TOOL_URL_LINUX_AMD64`,
  `TOOL_FILE_DARWIN_ARM64`, `TOOL_MODE_LINUX_AMD64`

3. Commit generated shim launcher at `shims/bin/<tool-name>` and the definition
   file.

### Use a shim

After reloading shell config, just run `<tool-name>`.
The shim downloads once, then executes from cache.
