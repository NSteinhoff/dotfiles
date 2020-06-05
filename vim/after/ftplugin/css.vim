" Prefer Omni-completion over tag completion
inoremap <buffer> <C-SPACE> <C-X><C-O>

" Formatting
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
endif
