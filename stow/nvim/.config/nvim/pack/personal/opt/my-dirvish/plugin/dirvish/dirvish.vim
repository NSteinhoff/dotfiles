packadd vim-dirvish

let g:dirvish_mode = 2
let g:dirvish_relative_paths = 0

command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Texplore tab split | silent Dirvish <args>
