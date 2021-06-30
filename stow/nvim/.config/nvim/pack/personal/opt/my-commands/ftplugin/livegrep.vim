set buftype=nofile nobuflisted noswapfile
setlocal nolist

augroup live-grep
    autocmd!
    autocmd BufEnter <buffer>    call livegrep#update(0, str2nr(expand('<abuf>')))
    autocmd TextChangedI <buffer> call livegrep#update(1, str2nr(expand('<abuf>')))
    autocmd TextChanged <buffer> call livegrep#update(0, str2nr(expand('<abuf>')))
    autocmd InsertLeave <buffer> call livegrep#update(0, str2nr(expand('<abuf>')))
    autocmd InsertEnter <buffer> call livegrep#insert_separator(str2nr(expand('<abuf>')), 'i')
    autocmd InsertLeave <buffer> call livegrep#insert_separator(str2nr(expand('<abuf>')), 'n')
augroup END

command -buffer Cancel keepalt b#
command -buffer -bang Export call livegrep#export('%', <bang>0)
command -buffer Reload call livegrep#update(0, 1)

inoremap <buffer> <CR> <esc><CMD>call livegrep#goto(3)<CR>
inoremap <buffer> <C-C> <esc><cmd>Cancel<CR>

nnoremap <buffer> <SPACE> <CMD>call livegrep#goto(line('.'))<CR>
nnoremap <buffer> <CR> <CMD>call livegrep#goto(line('.'))<CR>
nnoremap <buffer> <BS> <CMD>Cancel<CR>
nnoremap <buffer> <expr> i line('.') == 1 ? 'i' : '1GI'
nnoremap <buffer> <expr> I line('.') == 1 ? 'I' : '1GI'
nnoremap <buffer> <expr> a line('.') == 1 ? 'a' : '1GA'
nnoremap <buffer> <expr> A line('.') == 1 ? 'A' : '1GA'
nnoremap <buffer> X <CMD>Export<CR>
nnoremap <buffer> R <CMD>Reload<CR>
nnoremap <buffer> gs <CMD>call livegrep#export('%')<CR>:cdo s/\v=getline(1)/
nnoremap <buffer> gS <CMD>call livegrep#export('%')<CR>:cfdo %s/\v=getline(1)/

onoremap <buffer> i<bar> <CMD>normal! T<bar>vt<bar><CR>
onoremap <buffer> a<bar> <CMD>normal! F<bar>vf<bar><CR>
