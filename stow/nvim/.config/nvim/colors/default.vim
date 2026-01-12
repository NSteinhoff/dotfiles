" --- Intro
highlight clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=16
set bg=dark
let g:colors_name="default"

" Black       0    DarkGray       8
" DarkRed     1    LightRed       9
" DarkGreen   2    LightGreen    10
" DarkYellow  3    LightYellow   11
" DarkBlue    4    LightBlue     12
" DarkMagenta 5    LightMagenta  13
" DarkCyan    6    LightCyan     14
" LightGray   7    White         15

highlight   NormalFloat   cterm=NONE   ctermfg=NONE   ctermbg=8

" --- Outro
syntax enable

" vim: foldmethod=marker
