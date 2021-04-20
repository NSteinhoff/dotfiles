nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <BS> <C-W>c
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <C-N> <C-N>
nnoremap <buffer> <C-P> <C-P>
nnoremap <buffer> <nowait> <expr> > '<CMD>'..qf#cyclelists(1)..'<CR>'
nnoremap <buffer> <nowait> <expr> < '<CMD>'..qf#cyclelists(0)..'<CR>'
