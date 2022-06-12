command TagToc call tags#toc()
command TagIndex call tags#toc(1)

nnoremap <plug>(tag-toc) <cmd>TagToc<cr>
