function! s:has_repl()
    return get(b:, 'repl', 'NONE') != 'NONE'
endfunction

function! s:bufnr()
    if !s:has_repl() | return -1 | endif
    let bufname = bufname("^term*".b:repl."$")
    if bufname == '' | return -1 | endif
    let bufs = getbufinfo(bufname)
    return bufs[0]['bufnr']
endfunction

function! s:hidden(buf)
    return a:buf != -1 ? getbufinfo(a:buf)[0]['hidden'] : 0
endfunction

function! s:start(bang) abort
    if !s:has_repl()
        echo "REPL command undefined. Set b:repl='cmd' to enabel a REPL for this buffer."
        return
    endif

    let buf = s:bufnr()
    if buf != -1
        echo 'REPL running for ft='.&ft.' in buffer #'.buf.(s:hidden(buf) ? '(hidden)': '')
        return
    endif

    if a:bang
        botright vsplit
    else
        botright split
    endif
    let ft = &ft
    execute 'terminal '.b:repl
    let b:ft = ft
    wincmd p
endfunction

function! s:put(buf)
    let @@ = substitute(@@, "\n*$", "", "").''
    let alt_save = @#
    execute 'buffer '.a:buf
    put
    buffer #
    let @# = alt_save
endfunction

function! s:send_range(start, end)
    if !s:has_repl() | return | endif
    let buf = s:bufnr()
    if buf == -1
        echo 'No REPL running for ft='.&ft.'. Start a REPL with :ReplStart'
        return
    endif

    let reg_save = @@

    let @@ = join(getbufline('', a:start, a:end), "\n")

    call s:put(buf)

    let @@ = reg_save
endfunction

function! s:send_selection(type, ...)
    if !s:has_repl() | return | endif
    let buf = s:bufnr()
    if buf == -1
        echo 'No REPL running for ft='.&ft.'. Start a REPL with :ReplStart'
        return
    endif

    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent exe "normal! gvy"
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    else
        silent exe "normal! `[v`]y"
    endif

    call s:put(buf)

    let &selection = sel_save
    let @@ = reg_save
endfunction

command! -bang ReplStart call <SID>start(<q-bang> == '!')
command! -range ReplSend call <SID>send_range(<line1>, <line2>)
nnoremap <silent> <Plug>ReplSend :set opfunc=<SID>send_selection<CR>g@
vnoremap <silent> <Plug>ReplSend :<C-U>call <SID>send_selection(visualmode(), 1)<CR>
nmap <Plug>ReplSendLine V<Plug>ReplSend
