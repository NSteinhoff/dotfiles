" COLORSCHEME
" -----------
set t_Co=256
set background=dark
try
    if !empty($COLORSCHEME)
        colorscheme $COLORSCHEME
    else
        " Prefered default colorscheme
        colorscheme minimal  " $HOME/dotfiles/vim/colors/minimal.vim
        let $MYCOLORSCHEME = $HOME . '/dotfiles/vim/colors/minimal.vim'
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    " Colorschemes not installed yet
    " This happens when first installing bundles
    colorscheme default
endtry
