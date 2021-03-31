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


nnoremap <silent> <Plug>(maker-sync) <CMD>make<CR>
nnoremap <silent> <Plug>(maker-split) <CMD>vert TMake<CR>
nnoremap <silent> <Plug>(maker-background) <CMD>TMake!<CR>

nnoremap <expr> <Plug>(maker-show-log) !empty(findfile(&errorfile)) ? '<CMD>!cat '.&errorfile.'<CR>' : '<CMD>echo "No errorfile"<CR>'
nnoremap <expr> <Plug>(maker-load-errors) &ft == 'qf' ? '<CMD>cclose<CR>' : '<CMD>cfile<CR>'
nnoremap <expr> <Plug>(maker-local-load-errors) &ft == 'qf' ? '<CMD>lclose<CR>' : '<CMD>lfile<CR>'
nnoremap <expr> <Plug>(maker-edit-errors) !empty(findfile(&errorfile)) ? '<CMD>tab split '.&errorfile.'<CR>' : '<CMD>echo "No errorfile"<CR>'
