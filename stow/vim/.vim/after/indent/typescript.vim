setlocal fex&
if executable('prettier')
    execute 'setlocal formatprg=prettier\ --stdin-filepath\ %\ --tab-width='.&sw
endif
