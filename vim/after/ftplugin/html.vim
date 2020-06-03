" Automaticall insert the closing
" tag and start editing the content.
inoremap <buffer> >< ></<C-X><C-O><ESC>cit

" Prefer Omni-completion over tag completion
inoremap <buffer> <C-SPACE> <C-X><C-O>

" Formatting
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
    let b:format_on_write = 1
endif
