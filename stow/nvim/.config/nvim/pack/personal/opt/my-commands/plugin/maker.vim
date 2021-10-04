command! -count=50 -nargs=+ -bang TSplit
    \ silent execute '!tmux '
    \.(<bang>0 ? 'new-window -n <q-args> ' : 'split-window -f -l <count>\% '
    \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
    \.' -d -c '.getcwd().' '.shellescape('<args>; sleep 2')
    \|silent redraw

command! -count=50 -nargs=* -bang TMake
    \ silent call commander#make#kill_window(commander#make#makeprg(<q-args>))
    \|silent execute '!tmux '
    \.(<bang>0 ? 'new-window -n '''.commander#make#makeprg(<q-args>).''' ' : 'split-window -f -l <count>\% '
    \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
    \.' -d -c '.getcwd().' '.commander#make#shell_cmd(<q-args>)
    \|silent redraw

command! -count=50 -bang TTailErr
    \ if findfile(&errorfile) != ''
    \|silent execute '!tmux '
    \.(<bang>0 ? 'new-window' : 'split-window -f -l <count>\% '
    \.(expand('<mods>') =~ 'vertical' ? ' -h ' : ' -v '))
    \.' -d -c '.getcwd().' '.shellescape('tail -F '.&errorfile)
    \|silent redraw | endif


nnoremap <silent> <plug>(maker-sync-loc) <cmd>lmake<cr>
nnoremap <silent> <plug>(maker-sync) <cmd>make<cr>
nnoremap <silent> <plug>(maker-split) <cmd>33TMake<cr>
nnoremap <silent> <plug>(maker-background) <cmd>TMake!<cr>

nnoremap <expr> <plug>(maker-show-log) !empty(findfile(&errorfile)) ? '<cmd>!cat '.&errorfile.'<cr>' : '<cmd>echo "No errorfile"<cr>'
nnoremap <expr> <plug>(maker-load-errors) &ft == 'qf' ? '<cmd>cclose<cr>' : '<cmd>cfile<cr>'
nnoremap <expr> <plug>(maker-local-load-errors) &ft == 'qf' ? '<cmd>lclose<cr>' : '<cmd>lfile<cr>'
nnoremap <expr> <plug>(maker-edit-errors) !empty(findfile(&errorfile)) ? '<cmd>tab split '.&errorfile.'<cr>' : '<cmd>echo "No errorfile"<cr>'

function s:ignore_make_errors()
    if empty(&errorformat)|return|endif
    if empty(&makeprg)|return|endif
    if &makeprg !~ '^make'|return|endif
    if &errorformat =~ '%-Gmake: \*\*\*%\.%#'|return|endif

    let local = empty(&l:errorformat) ? '' : 'local'
    execute 'set'..local..' errorformat^=%+Gmake:\ ***%.%#'
endfunction

augroup my-maker
    autocmd!
    autocmd QuickFixCmdPre * call s:ignore_make_errors()
augroup END
