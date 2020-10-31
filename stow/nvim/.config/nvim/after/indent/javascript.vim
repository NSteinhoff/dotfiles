setlocal shiftwidth=4
setlocal formatexpr&
if executable('npx')
    setlocal formatexpr=
    execute 'setlocal formatprg=npx\ prettier\ --stdin-filepath\ %\ --config-precedence=prefer-file\ --tab-width='.&sw
endif
