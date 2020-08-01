" Vim plugin for interacting with a terminal buffer from a text buffer
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" License:      Public Domain

if exists("g:loaded_repl") | finish | endif | let g:loaded_repl = 1

function s:buffer_status() abort
    let status = {}
    let status.cmd = s:cmd()
    let [bufnr, hidden] = s:bufnr()
    let status.bufnr = bufnr
    let status.hidden= hidden
    return status
endfunction

function s:cmd()
    return get(b:, 'repl', 'NONE')
endfunction

function s:repl_name()
    return 'REPL '.s:cmd()
endfunction

function s:bufnr()
    for buf in getbufinfo(s:repl_name())
        return [buf.bufnr, buf.hidden]
    endfor
    return [-1, 0]
endfunction

function s:start(bang) abort
    if s:cmd() == 'NONE'
        echomsg "REPL command undefined. Set b:repl='cmd' to enabel a REPL for this buffer."
        return
    endif

    let [buf, hidden] = s:bufnr()
    if buf == -1
        let cmd = s:cmd()
        call term_start(cmd, {'vertical': a:bang, 'term_name': s:repl_name()})
        normal G
        wincmd p
    elseif hidden
        execute (a:bang?'vertical ':'').'sb '.buf
        normal G
        wincmd p
    else
        execute bufwinnr(buf).'windo close'
    endif
endfunction

function s:send_string(s)
    if s:bufnr()[0] == -1 | call s:start(0) | endif
    let msg = trim(a:s, "\n")
    let [buf, _] = s:bufnr()
    call term_sendkeys(buf, msg."\n")
endfunction

function s:send(start, end, ...)
    if a:0
        let text = join(map(copy(a:000), { _, v -> expand(v) }), " ")
    else
        let text = join(getline(a:start, a:end), "\n")
    endif

    call s:send_string(text)
endfunction

function s:send_selection(type, ...)
    let sel_save = &selection
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent exe "normal! gvy"
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    else
        silent exe "normal! `[v`]y"
    endif

    call s:send_string(@@)
endfunction

command ReplStatus echo <SID>buffer_status()
command -bang ReplStart call <SID>start(<q-bang> == '!')
command -range -nargs=* ReplSend call <SID>send(<line1>, <line2>, <f-args>)
nnoremap <Plug>ReplStatus :ReplStatus<CR>
nnoremap <Plug>ReplStart :ReplStart<CR>
nnoremap <silent> <Plug>ReplSendSelection :set opfunc=<SID>send_selection<CR>g@
vnoremap <silent> <Plug>ReplSendSelection :<C-U>call <SID>send_selection(visualmode(), 1)<CR>
nnoremap <silent> <Plug>ReplSendNewline :call <SID>send_string('')<CR>
nnoremap <silent> <Plug>ReplSendLine :ReplSend<CR>
nnoremap <Plug>ReplSendCmd :<C-U>ReplSend 
nmap <Plug>ReplSendBlock <Plug>ReplSendSelectionap
