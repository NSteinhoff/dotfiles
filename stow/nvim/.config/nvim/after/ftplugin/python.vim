set define=^\\s*\\(def\\\|class\\)

compiler flake8

iabbrev <buffer> ifmain if __name__ == "__main__":

let b:repl = 'python'
let b:interpreter = 'python'

if exists(':DD')
    setlocal keywordprg=:DD
endif
