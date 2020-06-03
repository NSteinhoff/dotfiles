
" Formatting
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
    let b:format_on_write = 1
endif
