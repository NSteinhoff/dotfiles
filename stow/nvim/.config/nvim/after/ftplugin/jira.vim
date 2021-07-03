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
        execute a:lnum.'s/\(^\s*([x/])\)\s\+\([^-].\{-}\)\s*$/\1 -\2-'
    endif
endfunction

nnoremap <buffer> <silent> <space> :call <sid>toggle_completed(line('.'))<cr>
nnoremap <buffer> <silent> - :call <sid>toggle_strikethrough(line('.'))<cr>
vnoremap <buffer> <silent> <space> :call <sid>toggle_completed(line('.'))<cr>
vnoremap <buffer> <silent> - :call <sid>toggle_strikethrough(line('.'))<cr>
