" Visual blockwise (CTRL-V) is matched by \x16
autocmd ModeChanged [vV\x16]*:* let &l:relativenumber = mode() =~# '^[vV\x16]'
autocmd ModeChanged *:[vV\x16]* let &l:relativenumber = mode() =~# '^[vV\x16]'
autocmd WinEnter,WinLeave * let &l:relativenumber = mode() =~# '^[vV\x16]'

" Colorscheme based on situation
let s:default_colors = g:colors_name

function s:is_debugging()
    try
        return luaeval('require("dap").session() ~= nil')
    catch
        return v:false
    endtry
endfunction

function s:set_colors()
    let l:colors = s:is_debugging() ? "industry"
                \                   : s:default_colors

    if g:colors_name !=# l:colors
        execute 'noautocmd colorscheme '.l:colors
    endif
endfunction

augroup modal
    autocmd!
    autocmd CursorHold * call s:set_colors()
    autocmd Colorscheme * let s:default_colors = expand("<amatch>")
augroup END
