" Automaticall insert the closing
" tag and start editing the content.
inoremap <buffer> >< ></<C-X><C-O><ESC>cit

" Prefer Omni-completion over tag completion
inoremap <buffer> <C-SPACE> <C-X><C-O>
