function s:journal(in_same_window, mods, fpath)
    let winnr = bufwinnr(bufnr(a:fpath))
    if winnr == -1
        execute a:mods..' '..(a:in_same_window ? 'edit' : 'split')..' +set\ nobuflisted '..a:fpath
    else
        execute winnr .. 'wincmd w'
    endif
endfunction

command! -bang -bar Journal call s:journal(<bang>0, '<mods>', get(g:, 'journal_path', '~/Dropbox/Notes/journal.md'))
command! -bang -bar DevDiary call s:journal(<bang>0, '<mods>', get(g:, 'dev_diary_path', '~/Dropbox/Notes/dev-diary.md'))
command! -bang -bar Tasks call s:journal(<bang>0, '<mods>', get(g:, 'tasks_path', '~/Dropbox/Notes/tasks.md'))
