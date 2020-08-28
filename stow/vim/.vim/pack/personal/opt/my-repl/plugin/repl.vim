" Vim plugin for interacting with a terminal buffer from a text buffer
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" License:      Public Domain

if exists("g:loaded_repl") | finish | endif | let g:loaded_repl = 1

function s:buffer_status() abort
    let status = {}
    let status.cmd = s:cmd()
    let [bufnr, windows] = s:bufnr()
    let status.bufnr = bufnr
    let status.windows = windows
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
        return [buf.bufnr, buf.windows]
    endfor
    return [-1, []]
endfunction

function s:start(bang) abort
    if s:cmd() == 'NONE'
        echomsg "REPL command undefined. Set b:repl='cmd' to enabel a REPL for this buffer."
        return
    endif

    let [buf, windows] = s:bufnr()
    let is_running = buf != -1
    let is_visible = len(windows) != 0

    if is_running && is_visible
        execute bufwinnr(buf).'windo close'
        return
    endif

    if !is_running
        let cmd = s:cmd()
        call term_start(cmd, {'vertical': a:bang, 'term_name': s:repl_name()})
    elseif !is_visible
        execute (a:bang?'vertical ':'').'sbuffer '.buf
    endif

    " Tmux copy-mode style mappings
    tnoremap <c-w>] <c-\><c-n>
    tnoremap <c-w><c-]> <c-\><c-n>
    nnoremap <buffer> q a
    normal G
    execute 'wincmd '.(a:bang?'L':'J')
    wincmd p
endfunction

function s:send_string(s)
    if s:bufnr()[0] == -1 | call s:start(0) | endif
    let msg = trim(a:s, "\n")
    let [buf, _] = s:bufnr()
    call term_sendkeys(buf, msg."\n")
endfunction

function s:send(start, end, args)
    if a:args != ''
        let text = a:args
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
command -range -nargs=? ReplSend call <SID>send(<line1>, <line2>, <q-args>)
nnoremap <Plug>ReplStatus :ReplStatus<CR>
nnoremap <Plug>ReplStart :ReplStart!<CR>
nnoremap <silent> <Plug>ReplSendSelection :set opfunc=<SID>send_selection<CR>g@
vnoremap <silent> <Plug>ReplSendSelection :<C-U>call <SID>send_selection(visualmode(), 1)<CR>
nnoremap <silent> <Plug>ReplSendNewline :call <SID>send_string('')<CR>
nnoremap <silent> <Plug>ReplSendLine :ReplSend<CR>
nnoremap <silent> <Plug>ReplSendFile :%ReplSend<CR>
nnoremap <silent> <Plug>ReplSendAbove :0,.ReplSend<CR>
nnoremap <silent> <Plug>ReplSendBelow :.,$ReplSend<CR>
nnoremap <Plug>ReplSendCmd :<C-U>ReplSend 
nnoremap <Plug>ReplInterrupt :ReplSend <CR>
nnoremap <Plug>ReplEOF :ReplSend <CR>
nmap <Plug>ReplSendBlock m`<Plug>ReplSendSelectionap``
nmap <Plug>ReplSendBlockGoToNext <Plug>ReplSendBlock}
