setlocal cursorline
setlocal scrolloff=0
setlocal nolist
setlocal nowrap

" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> j j
nnoremap <buffer> k k
nnoremap <buffer> - -
nnoremap <buffer> <cr> <cr>
nnoremap <buffer> <space> <cr>
nnoremap <buffer> <bs> <c-w>c

" Cycle through lists
nnoremap <buffer> <nowait> > <cmd>execute (get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0) ? 'l' : 'c')..'newer'<cr>
nnoremap <buffer> <nowait> < <cmd>execute (get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0) ? 'l' : 'c')..'older'<cr>
