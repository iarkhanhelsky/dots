if command gls 1>/dev/null 2>/dev/null; then
    alias ls='gls -lh --group-directories-first --color=always'
fi
alias lsa='ls -a'
