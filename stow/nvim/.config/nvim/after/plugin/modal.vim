let s:toggle_colors = v:true

" Colorscheme based on situation
let s:default_colors = get(g:, 'colors_name', 'default')

function s:is_debugging()
    try
        return luaeval('require("dap").session() ~= nil')
    catch
        return v:false
    endtry
endfunction

function s:set_colors()
    let l:colors = s:is_debugging() ? "wildcharm"
                \                   : s:default_colors

    if get(g:, 'colors_name', 'default') !=# l:colors
        execute 'noautocmd colorscheme '.l:colors
    endif
endfunction

augroup modal
    autocmd!
    " Visual blockwise (CTRL-V) is matched by \x16
    autocmd ModeChanged [vV\x16]*:* let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
    autocmd ModeChanged *:[vV\x16]* let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
    autocmd WinEnter,WinLeave * let &l:relativenumber = &l:number && mode() =~# '^[vV\x16]'
    if s:toggle_colors
        autocmd CursorHold * call s:set_colors()
        autocmd Colorscheme * let s:default_colors = expand("<amatch>")
    endif
augroup END
