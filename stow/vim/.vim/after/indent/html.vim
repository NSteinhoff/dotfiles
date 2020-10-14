setlocal textwidth=100
setlocal shiftwidth=2
setlocal formatexpr&
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw.'\ --print-width='.&tw
endif
