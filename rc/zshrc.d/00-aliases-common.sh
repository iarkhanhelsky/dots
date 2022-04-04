alias inflate='ruby -r zlib -e "puts Zlib::Inflate.inflate(STDIN.read)"'

# aliases
if command bat --version 1>/dev/null ; then
    alias ccat='bat'
else
    alias ccat='cat'
fi

alias k=kubectl
