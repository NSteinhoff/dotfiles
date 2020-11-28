function s:toggle_completed(lnum)
    let text = getline(a:lnum)
    if text =~ '^\s*(x)'
        execute a:lnum.'s$^\s*(x)$(/)'
    elseif text =~ '^\s*(/)'
        execute a:lnum.'s$^\s*(/)$(x)'
    endif
endfunction

function s:toggle_strikethrough(lnum)
    let text = getline(a:lnum)
    if text =~ '^\s*([x/])\s\+-[^-].*-\s*$'
        execute a:lnum.'s/\(^\s*([x/])\)\s\+-\s*\([^-].\{-}\)\s*-\s*$/\1 \2'
    elseif text =~ '^\s*([x/])\s\+.*$'
        execute a:lnum.'s/\(^\s*([x/])\)\s\+\([^-].\{-}\)\s*$/\1 - \2 -'
    endif
endfunction

nnoremap <buffer> <space> :call <SID>toggle_completed(line('.'))<CR>
nnoremap <buffer> <BS> :call <SID>toggle_strikethrough(line('.'))<CR>
vnoremap <buffer> <space> :call <SID>toggle_completed(line('.'))<CR>
vnoremap <buffer> <BS> :call <SID>toggle_strikethrough(line('.'))<CR>
