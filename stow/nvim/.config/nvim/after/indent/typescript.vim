setlocal shiftwidth=4
setlocal formatexpr&
if executable('npx')
    setlocal formatexpr=
    execute 'setlocal formatprg=npx\ prettier\ --stdin-filepath\ '.(empty(expand('%')) ? 'tmp.ts' : '%').'\ --config-precedence=prefer-file\ --tab-width='.&sw
endif
