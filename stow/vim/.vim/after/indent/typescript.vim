setlocal shiftwidth=4
setlocal formatexpr&
if executable('prettier')
    setlocal formatexpr=
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
endif
