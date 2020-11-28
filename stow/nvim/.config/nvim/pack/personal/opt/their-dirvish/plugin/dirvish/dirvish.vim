packadd vim-dirvish
" packadd vim-dirvish-git

command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

augroup dirvish_buffer_mappings
    autocmd!
    autocmd Filetype dirvish nmap <buffer> <SPACE> <CR>
    autocmd Filetype dirvish nmap <buffer> cd <cmd>cd %<CR>
    autocmd Filetype dirvish nmap <buffer> q q
augroup END
