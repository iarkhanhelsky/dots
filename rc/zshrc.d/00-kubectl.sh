if command kubectl 1>/dev/null 2>/dev/null; then
    alias k=kubectl
    alias watchk="watch kubectl $@"

    source <(kubectl completion zsh)
fi