nnoremap <buffer> <SPACE> <CMD>call b:peek_commit()<CR>
nnoremap <buffer> <CR> <CMD>call b:open_commit()<CR>
nnoremap <buffer> <expr> R '<CMD>Review '..getline('.')..'<CR>'

let s:help_msg = 'Usage: (<SPACE>/<CR>) peek/open commit'
if bufname() =~ 'timeline$'
    let s:help_msg .= '; (./o) peek/open file'
    nnoremap <buffer> . <CMD>call b:peek_file()<CR>
    nnoremap <buffer> o <CMD>call b:open_file()<CR>
endif

if getline(1) != s:help_msg
    call append(0, s:help_msg)
endif
