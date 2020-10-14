setlocal shiftwidth=2
setlocal formatexpr&
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
endif
