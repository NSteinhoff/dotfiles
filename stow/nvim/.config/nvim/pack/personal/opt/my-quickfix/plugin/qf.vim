" Add the :Cfilter and :Lfilter commands
packadd cfilter

" set quickfixtextfunc=qf#textfunc
" command! QuickfixPathshorten let g:quickfix_pathshorten = !get(g:, 'quickfix_pathshorten', 0)
command! Ctab if getqflist({'nr': 0}).nr|tab split|botright copen|only|else|echo "No quickfix list."|endif
command! Ltab if getloclist(0, {'nr': 0}).nr|tab split|botright lopen|only|else|echo "No location list."|endif

""" Free error lists
command! -bar Cfree call setqflist([], 'f')
command! -bar Lfree call setloclist(0, [], 'f')

""" Mappings
nnoremap <plug>(qf-ctoggle) <cmd>call qf#ctoggle()<cr>
nnoremap <plug>(qf-ltoggle) <cmd>call qf#ltoggle()<cr>
nnoremap <plug>(qf-ctab) <cmd>Ctab<cr>
nnoremap <plug>(qf-ltab) <cmd>Ltab<cr>
nnoremap <plug>(qf-cprev) <cmd> call qf#cycle_qf(0)<cr>
nnoremap <plug>(qf-cnext) <cmd> call qf#cycle_qf(1)<cr>
nnoremap <plug>(qf-lprev) <cmd> call qf#cycle_loc(0)<cr>
nnoremap <plug>(qf-lnext) <cmd> call qf#cycle_loc(1)<cr>

augroup my-qf
    autocmd!
    if exists('##QuitPre')
        " Close the corresponding location list when a window is closed
        autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
    endif
augroup END

call abbrev#cmdline('ctab', 'Ctab')
call abbrev#cmdline('ltab', 'Ltab')
call abbrev#cmdline('cfree', 'Cfree')
call abbrev#cmdline('lfree', 'Lfree')
