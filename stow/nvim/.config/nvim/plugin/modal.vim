augroup modal
    autocmd!
    " Visual blockwise (CTRL-V) is matched by \x16
    autocmd ModeChanged [vV\x16]*:* let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
    autocmd ModeChanged *:[vV\x16]* let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
    autocmd WinEnter,WinLeave * let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
augroup END
