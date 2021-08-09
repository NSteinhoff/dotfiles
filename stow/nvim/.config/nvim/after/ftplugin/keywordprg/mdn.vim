if(exists(':Open'))
    command -buffer -nargs=1 MDNSearch Open https://developer.mozilla.org/en-US/search?q=<args>
    setlocal keywordprg=:MDNSearch
endif
