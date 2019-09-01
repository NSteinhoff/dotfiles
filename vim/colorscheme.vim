" COLORSCHEME
" -----------

set t_Co=256
set background=dark
colorscheme abstract
finish
try
    if !empty($COLORSCHEME)
        colorscheme $COLORSCHEME
    else
        " Prefered default colorscheme
        colorscheme minimal
        let $MYCOLORSCHEME = $HOME . '/dotfiles/vim/colors/minimal.vim'
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    " Colorschemes not installed yet
    " This happens when first installing bundles
    colorscheme default
endtry
