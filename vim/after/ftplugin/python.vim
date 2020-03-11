set define=^\\s*\\(def\\\|class\\)

compiler mypy

iabbrev <buffer> ifmain if __name__ == "__main__":

setlocal keywordprg=:DD

nnoremap <buffer> <F6> :!black %<cr>
nnoremap <buffer> <F7> :CompileWith flake8<cr>
nnoremap <buffer> <F8> :CompileWith pytest<cr>
