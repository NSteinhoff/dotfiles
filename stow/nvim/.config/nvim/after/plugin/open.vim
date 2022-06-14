""" Open with default application
function! s:uri(s)
    return a:s == '' ? (expand('%') == '' ? getcwd() : expand('%'))
        \ : a:s == '.' ? getcwd()
        \ : a:s =~ '^https\?://[a-zA-Z0-9\-./#?=&_ ]\+$' ? escape(substitute(a:s, ' ', '%20', 'g'), '#%')
        \ : expandcmd(a:s)
endfunction
command -nargs=? Open silent execute '!'..(system('uname') =~? 'darwin' ? 'open' : 'xdg-open')..' '..s:uri(<q-args>)
