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
command -buffer Reload call livegrep#update(0, bufnr('%'))

inoremap <buffer> <cr> <esc><cmd>call livegrep#goto(3)<cr>
inoremap <buffer> <c-c> <esc><cmd>Cancel<cr>

nnoremap <buffer> <space> <cmd>call livegrep#goto(line('.'))<cr>
nnoremap <buffer> <cr> <cmd>call livegrep#goto(line('.'))<cr>
nnoremap <buffer> <bs> <cmd>Cancel<cr>
nnoremap <buffer> <expr> i line('.') == 1 ? 'i' : '1GI'
nnoremap <buffer> <expr> I line('.') == 1 ? 'I' : '1GI'
nnoremap <buffer> <expr> a line('.') == 1 ? 'a' : '1GA'
nnoremap <buffer> <expr> A line('.') == 1 ? 'A' : '1GA'
nnoremap <buffer> X <cmd>Export<cr>
nnoremap <buffer> R <cmd>Reload<cr>
nnoremap <buffer> gs <cmd>call livegrep#export('%')<cr>:cdo s/\v=getline(1)/
nnoremap <buffer> gS <cmd>call livegrep#export('%')<cr>:cfdo %s/\v=getline(1)/

onoremap <buffer> i<bar> <cmd>normal! T<bar>vt<bar><cr>
onoremap <buffer> a<bar> <cmd>normal! F<bar>vf<bar><cr>
