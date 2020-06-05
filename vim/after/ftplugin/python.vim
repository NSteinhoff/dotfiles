set define=^\\s*\\(def\\\|class\\)

compiler flake8

iabbrev <buffer> ifmain if __name__ == "__main__":

if exists(':DD')
    setlocal keywordprg=:DD
endif

if executable('black')
    setlocal formatprg=black\ -\ 2>/dev/null
endif
