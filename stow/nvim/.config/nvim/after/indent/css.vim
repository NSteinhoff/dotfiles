setlocal shiftwidth=2
setlocal formatexpr&
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --config-precedence=prefer-file\ --tab-width='.&sw
endif
