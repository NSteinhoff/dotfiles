set buftype=nofile bufhidden=wipe nobuflisted noswapfile

let s:rip_grep = 'rg --vimgrep --smart-case'

let s:git_grep = 'git grep -n -i -I'

augroup live-grep
    autocmd!
    autocmd InsertLeave,TextChanged <buffer> cgetbuffer
    autocmd TextChanged,TextChangedI <buffer>
        \ if getpos('.')[1] == 1 && len(getline(1)) >= 3
        \|call deletebufline('', 2, '$')
        \|call append('$', ['---'])
        \|if getline(1) != ''
        \|call append('$', systemlist((finddir('.git', ';') ? s:git_grep : s:rip_grep).' '.shellescape(getline(1))))
        \|endif
        \|endif
augroup END

nnoremap <SPACE> <C-W>gF
nnoremap <CR> gF
