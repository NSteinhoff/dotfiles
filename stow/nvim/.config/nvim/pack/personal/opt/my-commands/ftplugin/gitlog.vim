nnoremap <buffer> . <CMD>call b:peek()<CR>
nnoremap <buffer> o <CMD>call b:open()<CR>
nnoremap <buffer> <SPACE> <CMD>call b:peek_commit()<CR>
nnoremap <buffer> <CR> <CMD>call b:open_commit()<CR>

let s:help_msg = 'Usage: (./o) peek/open file; (<SPACE>/<CR>) peek/open commit'

if getline(1) != s:help_msg
    call append(0, s:help_msg)
endif
