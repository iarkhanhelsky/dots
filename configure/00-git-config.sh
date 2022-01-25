#!/bin/bash
GIT_CONFIG="git config --global"

echo ":: Set git aliases"

# Remove all aliases
for al in $($GIT_CONFIG --get-regexp '^alias\.' | awk '{print $1}'); do
    echo "  Unset: $al"
    $GIT_CONFIG --unset "$al"
done

# Update with new set of aliases
$GIT_CONFIG alias.slog "log --color --graph --pretty=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an <%ae>%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit"
$GIT_CONFIG alias.glog "log --graph --oneline --branches"

echo ":: Updated"
$GIT_CONFIG --get-regexp '^alias\.'  | awk '{print "   - " $1}'
