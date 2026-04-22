_dots_shims_source="${${(%):-%N}:A}"
_dots_repo_root="${_dots_shims_source:h:h:h}"
_dots_shims_bin="${_dots_repo_root}/shims/bin"

if [ -d "${_dots_shims_bin}" ]; then
  path=("${_dots_shims_bin}" $path)
fi

unset _dots_shims_source _dots_repo_root _dots_shims_bin
