" Add the :Cfilter and :Lfilter commands
packadd cfilter

command! Ctab if getqflist({'nr': 0}).nr|tab split|botright copen|only|else|echo "No quickfix list."|endif
command! Ltab if getloclist(0, {'nr': 0}).nr|tab split|botright lopen|only|else|echo "No location list."|endif

""" Free error lists
command! -bar Cfree call setqflist([], 'f')
command! -bar Lfree call setloclist(0, [], 'f')

""" Mappings
nnoremap <leader>q <cmd>call qf#ctoggle()<cr>
nnoremap <leader>l <cmd>call qf#ltoggle()<cr>
nnoremap <leader>Q <cmd>Ctab<cr>
nnoremap <leader>L <cmd>Ltab<cr>

augroup my-qf
    autocmd!
    if exists('##QuitPre')
        " Close the corresponding location list when a window is closed
        autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
    endif
augroup END
