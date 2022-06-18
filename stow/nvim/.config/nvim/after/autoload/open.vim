function! open#uri(s)
    return a:s == '' ? (expand('%') == '' ? getcwd() : expand('%'))
        \ : a:s == '.' ? getcwd()
        \ : a:s =~ '^https\?://[a-zA-Z0-9\-./#?=&_ ]\+$' ? escape(substitute(a:s, ' ', '%20', 'g'), '#%')
        \ : expandcmd(a:s)
endfunction
