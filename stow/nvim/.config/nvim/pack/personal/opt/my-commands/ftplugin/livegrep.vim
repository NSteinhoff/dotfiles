set buftype=nofile bufhidden=wipe nobuflisted noswapfile

augroup live-grep
    autocmd!
    autocmd InsertLeave,TextChanged <buffer> cgetbuffer
    autocmd TextChanged,TextChangedI <buffer>
        \ if getpos('.')[1] == 1
        \|call deletebufline('', 2, '$')
        \|call append('$', ['---'])
        \|if getline(1) != ''
        \|call append('$', systemlist('rg --vimgrep --smart-case '.shellescape(getline(1))))
        \|endif
        \|endif
augroup END

nnoremap <SPACE> <C-W>gF
nnoremap <CR> gF
