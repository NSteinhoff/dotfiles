function smarttab#smarttab()
    if &expandtab == 1
        return "\<tab>"
    endif

    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<tab>"
    endif

    let num_spaces = &ts - virtcol('.') % &ts

    return repeat(' ', num_spaces)
endfunction
