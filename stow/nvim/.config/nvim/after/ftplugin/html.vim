" Automaticall insert the closing
" tag and start editing the content.
" inoremap <buffer> >< ></<C-X><C-O><ESC>cit

if exists(':DD')
    setlocal keywordprg=:DD
endif

let b:format_on_write = 0
