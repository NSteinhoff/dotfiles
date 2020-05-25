set define=^\\s*\\(def\\\|class\\)

compiler flake8

iabbrev <buffer> ifmain if __name__ == "__main__":

if executable('black')
    nnoremap <F6> :!black %<cr>
endif
