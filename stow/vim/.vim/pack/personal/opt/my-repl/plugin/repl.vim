" Vim plugin for interacting with a terminal buffer from a text buffer
" Maintainer:   Niko Steinhoff <niko.steinhoff@gmail.com>
" License:      Public Domain

if exists("g:loaded_repl") | finish | endif | let g:loaded_repl = 1

function s:cmd()
    return get(b:, 'repl', 'NONE')
endfunction

function s:repl_name()
    return 'REPL '.s:cmd()
endfunction

function s:bufinfo()
    for buf in getbufinfo(s:repl_name())
        return [buf.bufnr, buf.windows]
    endfor
    return [-1, []]
endfunction

function s:buffer_status() abort
    let status = {}
    let status.cmd = s:cmd()
    let [bufnr, windows] = s:bufinfo()
    let status.bufnr = bufnr
    let status.windows = windows
    return status
endfunction

function s:start(bang) abort
    if s:cmd() == 'NONE'
        echomsg "REPL command undefined. Set b:repl='cmd' to enabel a REPL for this buffer."
        return
    endif
    let cmd = s:cmd()
    call term_start(cmd, {'vertical': a:bang, 'term_name': s:repl_name()})

    " Tmux copy-mode style mappings
    tnoremap <c-w>] <c-\><c-n>
    tnoremap <c-w><c-]> <c-\><c-n>
    nnoremap <buffer> q a
endfunction

function s:show(bang) abort
    let [buf, windows] = s:bufinfo()
    let is_running = buf != -1
    let is_visible = len(windows) != 0

    if is_running && is_visible
        return
    endif

    if !is_running
        call s:start(a:bang)
    elseif !is_visible
        execute (a:bang?'vertical ':'').'sbuffer '.buf
    endif

    normal G
    execute 'wincmd '.(a:bang?'L':'J')
    wincmd p
endfunction

function s:hide(bang) abort
    let [buf, windows] = s:bufinfo()
    let is_running = buf != -1
    let is_visible = len(windows) != 0

    if is_running && is_visible
        execute bufwinnr(buf).'windo close'
    endif
endfunction

function s:toggle(bang) abort
    let [buf, windows] = s:bufinfo()
    let is_running = buf != -1
    let is_visible = len(windows) != 0

    if is_running && is_visible
        call s:hide(a:bang)
    else
        call s:show(a:bang)
    endif
endfunction

function s:send_text(text)
    call s:show(0)
    let msg = trim(a:text, "\n")
    let [buf, _] = s:bufinfo()
    call term_sendkeys(buf, msg."\n")
endfunction

function s:send_lines(start, end, args)
    if a:args != ''
        let text = a:args
    else
        let text = join(getline(a:start, a:end), "\n")
    endif

    call s:send_text(text)
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

    call s:send_text(@@)
endfunction

command ReplStatus echo <SID>buffer_status()
command -bang ReplToggle call <SID>toggle(<q-bang> == '!')
command -range -nargs=? ReplSend call <SID>send_lines(<line1>, <line2>, <q-args>)
nnoremap <Plug>ReplStatus :ReplStatus<CR>
nnoremap <Plug>ReplToggle :ReplToggle!<CR>
nnoremap <silent> <Plug>ReplSendSelection :set opfunc=<SID>send_selection<CR>g@
vnoremap <silent> <Plug>ReplSendSelection :<C-U>call <SID>send_selection(visualmode(), 1)<CR>
nnoremap <silent> <Plug>ReplSendNewline :call <SID>send_text('')<CR>
nnoremap <silent> <Plug>ReplSendLine :ReplSend<CR>
nnoremap <silent> <Plug>ReplSendFile :%ReplSend<CR>
nnoremap <silent> <Plug>ReplSendAbove :0,.ReplSend<CR>
nnoremap <silent> <Plug>ReplSendBelow :.,$ReplSend<CR>
nnoremap <Plug>ReplSendCmd :<C-U>ReplSend 
nnoremap <Plug>ReplInterrupt :ReplSend <CR>
nnoremap <Plug>ReplEOF :ReplSend <CR>
nmap <Plug>ReplSendBlock m`<Plug>ReplSendSelectionap``
nmap <Plug>ReplSendAdvanceBlock <Plug>ReplSendBlock}
