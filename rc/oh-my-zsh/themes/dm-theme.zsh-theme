local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
    local user_symbol='$'
fi

local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch='$(git_prompt_info)%{$reset_color%}'
local hg_branch='$(hg_prompt_info)'
local vcs_info="${git_branch}${hg_branch}"

kubectl_prompt_info () {
    local kube_ctx
    kube_ctx="$(awk '/current-context:/ { print $2 }' "${KUBECONFIG:-$HOME/.kube/config}")"
    if [[ "${kube_ctx}" != "" ]]
    then
        echo "%{$fg_bold[blue]%}k8s:(%{$fg[magenta]%}${kube_ctx}%{$fg_bold[blue]%})%{$reset_color%} "
    fi
}

local k8s_info='$(kubectl_prompt_info)'


PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby}${vcs_info}${k8s_info}
╰─%B${user_symbol}%b "
RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%} %{$fg[yellow]%}✗%{$reset_color%}%{$fg_bold[blue]) "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})%{$reset_color%} "
