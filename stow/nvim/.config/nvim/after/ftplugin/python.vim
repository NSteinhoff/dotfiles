setlocal keywordprg=:Search\ devdocs\ python
set define=^\\s*\\(def\\\|class\\)

compiler flake8

iabbrev <buffer> ifmain if __name__ == "__main__":

let b:repl = 'python3'
let b:interpreter = 'python3'
