" any.vim
source ~/.vimrc

set guioptions-=m               " no menubar
set guioptions-=T               " no toolbar
set guioptions-=r               " no scrollbar

setlocal lines=25
setlocal columns=100
setlocal nonumber
setlocal noswapfile
setlocal buftype=nofile
setlocal bufhidden=hide

augroup AnyVim
    if executable('xsel')
        autocmd QuitPre <buffer> %w !xsel -ib
    elseif executable('pbcopy')
        autocmd QuitPre <buffer> %w !pbcopy
    endif
    autocmd BufEnter <buffer> if getregtype("*") != "" | 0put * | $d | endif
augroup END
