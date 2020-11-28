setlocal shiftwidth=4
setlocal formatexpr&
if executable('npx')
    setlocal formatexpr=
    execute 'setlocal formatprg=npx\ prettier\ --stdin-filepath\ '.(empty(expand('%')) ? 'tmp.js' : '%').'\ --config-precedence=prefer-file\ --tab-width='.&sw
endif
