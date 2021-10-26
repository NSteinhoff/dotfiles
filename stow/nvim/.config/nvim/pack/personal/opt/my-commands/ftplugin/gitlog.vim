nnoremap <buffer> <space> <cmd>call b:peek_commit()<cr>
nnoremap <buffer> <cr> <cmd>call b:open_commit()<cr>
nnoremap <buffer> <expr> R '<cmd>Review '..getline('.')..'<cr>'

let s:help_msg = 'Usage:'
if bufname() =~ 'timeline$'
    let s:help_msg .= ' p(i)eek/(o)pen/(p)atch file; <c-space> add to diff; '
    nnoremap <buffer> i <cmd>call b:peek_file()<cr>
    nnoremap <buffer> o <cmd>call b:open_file()<cr>
    nnoremap <buffer> p <cmd>call b:peek_patch()<cr>
    nnoremap <buffer> <c-space> <cmd>if b:peek_file() != -1<bar>diffthis<bar>wincmd p<bar>endif<cr>
endif

let s:help_msg .= ' <space>/<cr> peek/open commit'
if getline(1) != s:help_msg
    call append(0, s:help_msg)
endif
