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
    autocmd BufLeave <buffer> call livegrep#histpush()
augroup END

command -buffer       Cancel keepalt b#
command -buffer -bang Export call livegrep#export('%', <bang>0)
command -buffer       Reload call livegrep#update(0, bufnr('%'), v:true)
command -buffer       Grepit execute 'grep '..getline(1)

inoremap <buffer> <c-n>      <cmd>call setline(1, livegrep#history(1))<cr><end>
inoremap <buffer> <c-p>      <cmd>call setline(1, livegrep#history(-1))<cr><end>
inoremap <buffer> <cr>  <esc><cmd>call livegrep#goto(3)<cr>
inoremap <buffer> <c-c> <esc><cmd>Cancel<cr>

nnoremap <buffer> R    <cmd>Reload<cr>
nnoremap <buffer> X    <cmd>Export<cr>
nnoremap <buffer> <bs> <cmd>Cancel<cr>

" Jump to result (and export)
nnoremap <buffer> <space> <cmd>call livegrep#goto(line('.'))<cr>
nnoremap <buffer> <cr>    <cmd>call livegrep#goto(line('.'), v:true)<cr>

" Quickly jump to the input line
nnoremap <buffer> <expr> i line('.') == 1 ? 'i' : '1GI'
nnoremap <buffer> <expr> a line('.') == 1 ? 'a' : '1GA'
nnoremap <buffer>        I 1GI
nnoremap <buffer>        A 1GA

" Export and search/replace
nnoremap <buffer> gs <cmd>call livegrep#export('%')<cr>:cdo s/
nnoremap <buffer> gS <cmd>call livegrep#export('%')<cr>:cfdo %s/

" Text object or patterns inbetween pipes, i.e. |<pattern>|
onoremap <buffer> i<bar> <cmd>normal! T<bar>vt<bar><cr>
onoremap <buffer> a<bar> <cmd>normal! F<bar>vf<bar><cr>
