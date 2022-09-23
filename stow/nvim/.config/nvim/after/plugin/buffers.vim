augroup buffers
    autocmd!
    autocmd BufNewFile,BufReadPost,BufFilePost *.c,*.h let b:yang = fnamemodify(expand('<afile>'), ':r')..(expand('<afile>') =~ '.c$' ? '.h' : '.c')
    autocmd BufNewFile,BufReadPost,BufFilePost *.js,*.jsx,*.ts,*.tsx let b:yang = ftutils#javascript#get_alt(expand('<afile>'))
augroup END

command A call buffers#yang()
command -nargs=1 -complete=file Rename saveas <args> | silent bd # | silent !rm #
command Remove bd | silent !rm #
