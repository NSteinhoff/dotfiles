nnoremap <buffer> <space> <cmd>call b:peek_commit()<cr>
nnoremap <buffer> <cr> <cmd>call b:open_commit()<cr>
nnoremap <buffer> <expr> R '<cmd>Review '..getline('.')..'<cr>'

let s:help_msg = 'Usage: (<space>/<cr>) peek/open commit'
if bufname() =~ 'timeline$'
    let s:help_msg .= '; (./o) peek/open file'
    nnoremap <buffer> . <cmd>call b:peek_file()<cr>
    nnoremap <buffer> o <cmd>call b:open_file()<cr>
endif

if getline(1) != s:help_msg
    call append(0, s:help_msg)
endif
