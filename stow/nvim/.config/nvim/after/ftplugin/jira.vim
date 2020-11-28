setlocal spell
setlocal wrap

function s:toggle_completed(lnum)
    let text = getline(a:lnum)
    if text =~ '^\s*(x)'
        execute a:lnum.'s$^\(\s*\)(x)$\1(/)'
    elseif text =~ '^\s*(/)'
        execute a:lnum.'s$^\(\s*\)(/)$\1(x)'
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

nnoremap <buffer> <silent> <space> :call <SID>toggle_completed(line('.'))<CR>
nnoremap <buffer> <silent> <BS> :call <SID>toggle_strikethrough(line('.'))<CR>
vnoremap <buffer> <silent> <space> :call <SID>toggle_completed(line('.'))<CR>
vnoremap <buffer> <silent> <BS> :call <SID>toggle_strikethrough(line('.'))<CR>
