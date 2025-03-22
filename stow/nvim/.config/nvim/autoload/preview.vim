let s:jump_on_double_click = v:true

function preview#preview_word(word)
    let started_in_preview = &previewwindow
    " Get the word under cursor
    let word = empty(a:word) ? expand("<cword>") : a:word

    " If the word does not contain a letter
    if word !~ '\a'
        return
    endif

    " Delete any existing highlight before showing another tag
    if started_in_preview
        match none
    else
        " Jump to preview window
        silent! wincmd P
        if &previewwindow
            if s:jump_on_double_click
                " Check for double click
                let [_, l, c; _] =  getcurpos() 
                let [pword, ppos] = get(w:, 'matched_word', ['', [0, 0]])
                if pword == word && ppos == [l, c]
                    " Cursor is on the previous match. Stop here!
                    return
                endif
            endif

            " Delete existing highlight
            match none
            " Back to old window
            wincmd p
        endif
    endif

    " Try displaying a matching tag for the word under the cursor
    try
        execute "ptag " .. word
    catch
        " No matching tag, so let's run a :psearch on the word
        let save_ignorecase = &ignorecase
        set noignorecase
        let save_path = &l:path
        " Allow the path to be adjusted by the ftplugin.
        " For C files, this can limit the search path to local files,
        " skipping the system headers.
        let &l:path = get(b:, 'preview_search_path', &l:path)
        try
            execute "psearch " .. word
        catch 
            return
        finally
            let &ignorecase = save_ignorecase
            let &l:path = save_path
        endtry
    endtry

    " Jump to preview window
    silent! wincmd P
    if !&previewwindow
        return
    endif

    if has("folding")
        " Don't want a closed fold
        silent! .foldopen
    endif
    " To end of previous line
    call search("$", "b")
    let word = substitute(word, '\\', '\\\\', "")
    " Position cursor on match
    call search('\<\V' .. word .. '\>')
    " Add a match highlight to the word at this position
    hi previewWord term=bold ctermbg=green guibg=green
    let [_, l, c; _] = getcurpos()
    exe 'match previewWord "\%' .. l .. 'l\%' .. c .. 'c\k*"'
    " Record the matched word to check for double clicks
    let w:matched_word = [word, [l, c]]

    if !started_in_preview
        " Back to old window
        wincmd p
    endif
endfun
