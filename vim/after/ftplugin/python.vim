set define=^\\s*\\(def\\\|class\\)

compiler flake8

iabbrev <buffer> ifmain if __name__ == "__main__":

if exists(':DD')
    setlocal keywordprg=:DD
endif

let b:interpreter = 'python -'
