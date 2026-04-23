#!/usr/bin/env bash
set -euo pipefail

shared_skills_dir="${HOME}/.shared/skills"
claude_skills_link="${HOME}/.claude/skills"
cursor_skills_link="${HOME}/.cursor/skills"

if [ ! -d "${shared_skills_dir}" ]; then
  printf 'Skip shared skills linking: %s does not exist.\n' "${shared_skills_dir}"
  exit 0
fi

mkdir -p "${HOME}/.claude" "${HOME}/.cursor"
rm -rf "${claude_skills_link}" "${cursor_skills_link}"
ln -s "${shared_skills_dir}" "${claude_skills_link}"
ln -s "${shared_skills_dir}" "${cursor_skills_link}"

printf 'Linked shared skills for Claude and Cursor.\n'
