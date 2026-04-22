urlencode() {
    local input
    if (( $# > 0 )); then
        input="$*"
    else
        input="$(cat)"
    fi

    local i ch out hex
    out=""
    local LC_ALL=C

    for (( i = 1; i <= ${#input}; i++ )); do
        ch="${input[i]}"
        case "${ch}" in
            [a-zA-Z0-9.~_-])
                out+="${ch}"
                ;;
            *)
                printf -v hex '%02X' "'${ch}"
                out+="%${hex}"
                ;;
        esac
    done

    printf '%s\n' "${out}"
}

urldecode() {
    local input
    if (( $# > 0 )); then
        input="$*"
    else
        input="$(cat)"
    fi

    local i len ch hex out
    i=1
    len=${#input}
    out=""

    while (( i <= len )); do
        ch="${input[i]}"

        if [[ "${ch}" == "%" && $(( i + 2 )) -le ${len} ]]; then
            hex="${input[i+1]}${input[i+2]}"
            if [[ "${hex}" == [0-9A-Fa-f][0-9A-Fa-f] ]]; then
                out+="$(printf "\\x${hex}")"
                (( i += 3 ))
                continue
            fi
        fi

        if [[ "${ch}" == "+" ]]; then
            out+=" "
            (( i += 1 ))
            continue
        fi

        out+="${ch}"
        (( i += 1 ))
    done

    printf '%s\n' "${out}"
}

alias uenc='urlencode'
alias udec='urldecode'
