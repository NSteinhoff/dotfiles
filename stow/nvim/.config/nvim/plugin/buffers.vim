augroup buffers
    autocmd!
    autocmd BufNewFile,BufReadPost,BufFilePost *.c,*.h let b:yang = fnamemodify(expand('<afile>'), ':r')..(expand('<afile>') =~ '.c$' ? '.h' : '.c')
    autocmd BufNewFile,BufReadPost,BufFilePost *.js,*.jsx,*.ts,*.tsx let b:yang = ftutils#javascript#get_alt(expand('<afile>'))
augroup END

command! A call buffers#yang()
command! BufDeletHidden call foreach(getbufinfo()->filter({ _, b -> b.hidden })->map({ _, b -> b.bufnr }), "execute 'bdelete '.. v:val")
