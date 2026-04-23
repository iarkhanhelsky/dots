#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/iarkhanhelsky/dots.git"
DOTS_HOME="${DOTS_HOME:-$HOME}"
DOTS_DIR="${DOTS_DIR:-$DOTS_HOME/Projects/github/dots}"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "Missing dependency '$cmd'. ${hint}"
  fi
}

run_setup_script() {
  log "==> Running setup script in ${DOTS_DIR}"
  (cd "$DOTS_DIR" && ./bin/dots-setup)
}

ensure_dependencies() {
  require_command git "Install git and retry."
  require_command bash "Install bash and retry."
}

install_fresh() {
  local parent_dir
  parent_dir="$(dirname "$DOTS_DIR")"
  mkdir -p "$parent_dir"

  log "==> Cloning ${REPO_URL} into ${DOTS_DIR}"
  git clone --recurse-submodules "$REPO_URL" "$DOTS_DIR"
  run_setup_script
}

update_existing() {
  if [ ! -d "$DOTS_DIR/.git" ]; then
    fail "DOTS_DIR exists but is not a git repository: ${DOTS_DIR}"
  fi

  if [ -n "$(cd "$DOTS_DIR" && git status --porcelain)" ]; then
    fail "Local changes detected in ${DOTS_DIR}. Commit/stash/discard them, then rerun."
  fi

  log "==> Updating existing checkout in ${DOTS_DIR}"
  (
    cd "$DOTS_DIR"
    git pull --ff-only --recurse-submodules
    git submodule update --init --recursive
  )

  run_setup_script
}

main() {
  ensure_dependencies
  export HOME="$DOTS_HOME"
  log "==> Using DOTS_HOME=${DOTS_HOME}"
  log "==> Using DOTS_DIR=${DOTS_DIR}"

  if [ -d "$DOTS_DIR" ]; then
    update_existing
  else
    install_fresh
  fi

  log "==> Done"
}

main "$@"
