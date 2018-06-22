" COLORSCHEME
" -----------
set t_Co=256
set background=dark
try
    if !empty($VIM_COLORSCHEME)
        colorscheme $VIM_COLORSCHEME
    else
        " Prefered default colorscheme
        colorscheme toy-blocks
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    " Colorschemes not installed yet
    " This happens when first installing bundles
    colorscheme default
endtry
