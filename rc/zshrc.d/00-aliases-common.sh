alias inflate='ruby -r zlib -e "puts Zlib::Inflate.inflate(STDIN.read)"'

# Resolve at runtime because shim PATH is added later.
ccat() {
    if (( $+commands[bat] )); then
        bat "$@"
    else
        cat "$@"
    fi
}
