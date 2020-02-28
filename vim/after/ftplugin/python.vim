set define=^\\s*\\(def\\\|class\\)
compiler mypy
iabbrev <buffer> ifmain if __name__ == "__main__":
setlocal keywordprg=:DD
