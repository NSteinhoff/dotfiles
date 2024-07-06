function preview#preview_word(word)

    " don't do this in the preview window
    if &previewwindow
        return
    endif

    let w = empty(a:word) ? expand("<cword>") : a:word  " get the word under cursor

    " if the word does not contain a letter
    if w !~ '\a'
        return
    endif

    " Delete any existing highlight before showing another tag
    silent! wincmd P                    " jump to preview window
    if &previewwindow           " if we really get there...
        match none                        " delete existing highlight
        wincmd p                  " back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
        exe "ptag " .. w
    catch
        try
            exe "psearch " .. w
        catch 
            return
        endtry
    endtry

    silent! wincmd P                    " jump to preview window
    if !&previewwindow
        return
    endif
    if has("folding")
        silent! .foldopen            " don't want a closed fold
    endif
    call search("$", "b")          " to end of previous line
    let w = substitute(w, '\\', '\\\\', "")
    call search('\<\V' .. w .. '\>')       " position cursor on match
    " Add a match highlight to the word at this position
    hi previewWord term=bold ctermbg=green guibg=green
    exe 'match previewWord "\%' .. line(".") .. 'l\%' .. col(".") .. 'c\k*"'
    wincmd p                  " back to old window
endfun
