function s:journal(replace, mods, fpath)
    let winnr = bufwinnr(bufnr(a:fpath))
    if winnr == -1
        execute a:mods..' '..(a:replace ? 'edit' : 'split')..' +set\ nobuflisted '..a:fpath
    else
        execute winnr .. 'wincmd w'
    endif
endfunction

command! -bang -bar Journal call s:journal(<bang>0, '<mods>', '~/Dropbox/Notes/journal.md')
command! -bang -bar DevDiary call s:journal(<bang>0, '<mods>', '~/Dropbox/Notes/dev-diary.md')
command! -bang -bar Tasks call s:journal(<bang>0, '<mods>', '~/Dropbox/Notes/tasks.md')
