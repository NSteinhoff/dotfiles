if exists(':Open')
    command -buffer -nargs=1 DDG Open https://duckduckgo.com/?q=<args>
    setlocal keywordprg=:DDG
endif
