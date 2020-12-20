nnoremap <buffer> . <CMD>call b:peek()<CR>
nnoremap <buffer> o <CMD>call b:open()<CR>
nnoremap <buffer> <SPACE> <CMD>call b:peek_commit()<CR>
nnoremap <buffer> <CR> <CMD>call b:open_commit()<CR>

let s:help_msg = '<- (.) show; (o)pen; <SPACE> show commit; <CR> open commit'

function s:help()
    let l:ns = nvim_create_namespace('gitlog_help')
    call nvim_buf_clear_namespace(0, l:ns, 0, -1)
    call nvim_buf_set_virtual_text(0, l:ns, line('.') - 1, [[s:help_msg, 'Comment']], {})
endfunction

au CursorMoved <buffer> call s:help()
