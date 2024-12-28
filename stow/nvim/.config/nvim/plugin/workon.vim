" Open workspace
"
" :WorkOn directory
"   Open workspace directory in a new tab

" :WorkOn!
"   Open workspace in current tab
"
" :WorkOn
"   Reset workspace to global working directory
command! -nargs=? -complete=dir -bang WorkOn if <bang>1 | tab split | endif
        \ | if expand('<args>') == ''
        \ |     execute 'tcd '..getcwd(-1, -1)
        \ | else
        \ |     tcd <args> | e .
        \ | endif
