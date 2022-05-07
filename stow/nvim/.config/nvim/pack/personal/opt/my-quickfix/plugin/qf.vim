" Add the :Cfilter and :Lfilter commands
packadd cfilter

command! -nargs=* -bang Cnew call qf#new(<q-args>, <bang>0)
command! Cadd call qf#add()

command! Ctab if getqflist({'nr': 0}).nr|tab split|botright copen|only|else|echo "No quickfix list."|endif
command! Ltab if getloclist(0, {'nr': 0}).nr|tab split|botright lopen|only|else|echo "No location list."|endif

""" Free error lists
command! -bar Cfree call setqflist([], 'f')
command! -bar Lfree call setloclist(0, [], 'f')

nnoremap <silent> <plug>(cycle-loc-forward) <cmd>call qf#cycle_loc(1)<cr>
nnoremap <silent> <plug>(cycle-loc-backward) <cmd>call qf#cycle_loc(0)<cr>
nnoremap <silent> <plug>(cycle-qf-forward) <cmd>call qf#cycle_qf(1)<cr>
nnoremap <silent> <plug>(cycle-qf-backward) <cmd>call qf#cycle_qf(0)<cr>
nnoremap <silent> <plug>(cycle-visible-forward) <cmd>call qf#cycle_visible(1)<cr>
nnoremap <silent> <plug>(cycle-visible-backward) <cmd>call qf#cycle_visible(0)<cr>

nnoremap <silent> <plug>(qf-new) <cmd>call qf#new('', v:count)<cr>
nnoremap <silent> <plug>(qf-add) <cmd>call qf#add()<cr>
vnoremap <silent> <plug>(qf-add) :call qf#add()<cr>

augroup my-qf
    autocmd!
    if exists('##QuitPre')
        " Close the corresponding location list when a window is closed
        autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
    endif
    " Open an appropriately sized list after running quickfix commands
    autocmd QuickFixCmdPost make,grep,grepadd,vimgrep,vimgrepadd,cfile,cgetfile,caddfile,cexpr,cgetexpr,caddexpr,cbuffer,cgetbuffer,caddbuffer execute 'cclose|'..min([10, len(getqflist())])..'cwindow'
    autocmd QuickFixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd,lfile,lgetfile,laddfile,lexpr,lgetexpr,laddexpr,lbuffer,lgetbuffer,laddbuffer execute 'lclose|'..min([10, len(getloclist(0))])..'lwindow'
augroup END
