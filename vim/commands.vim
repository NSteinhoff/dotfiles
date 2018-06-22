" CUSTOM COMMANDS
" ---------------

"--- General ---
    " Escaping modes
    inoremap jk <c-\><c-n>
    tnoremap jk <c-\><c-n>

    " Switch to alternative buffer
    nnoremap <leader>b :e #<cr>

    " Escape Terminal mode
    " tnoremap <esc> <c-\><c-n>

    " Insert newline
    nnoremap <leader>o mpo<esc>`p
    nnoremap <leader>O mpO<esc>`p

    " Navigate splits
    nnoremap <c-j> <c-w><c-j>
    nnoremap <c-k> <c-w><c-k>
    nnoremap <c-l> <c-w><c-l>
    nnoremap <c-h> <c-w><c-h>

    " Remove highlights of last search results
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

    " Close Preview window
    nnoremap <silent> <C-Space> :pclose<CR>

    " Make arrow keys do something useful -- resizing windows
    nnoremap <silent> <Left> :vertical resize -1<CR>
    nnoremap <silent> <Right> :vertical resize +1<CR>
    nnoremap <silent> <Up> :resize +1<CR>
    nnoremap <silent> <Down> :resize -1<CR>


"--- Searching ---
    " Search for the name under the cursor in all files with the same extension
    nnoremap <leader>* *:vimgrep //j **/*%:e \| bo copen<CR>

    " Search for the last search pattern in all files with the same extension
    nnoremap <leader>/ :vimgrep //j **/*%:e \| bo copen<CR>

    " Closing parenthesis
    inoremap {{<cr> {<cr>}<esc>O
    inoremap [[<cr> [<cr>]<esc>O
    inoremap ((<cr> (<cr>)<esc>O

    " Insert current date and time as 'ctime'
    inoremap ddc <C-R>=strftime("%c")<CR>
    " Insert current date ctime 'YYYY-MM-DD'
    inoremap ddd <C-R>=strftime("%Y-%m-%d")<CR>


"--- List item navigation
    " Argument list
    nnoremap [a :previous<CR>
    nnoremap ]a :next<CR>
    nnoremap [A :first<CR>
    nnoremap ]A :last<CR>

    " Buffer list
    nnoremap [b :bprevious<CR>
    nnoremap ]b :bnext<CR>
    nnoremap [B :bfirst<CR>
    nnoremap ]B :blast<CR>

    " Quickfix list
    nnoremap [q :cprevious<CR>
    nnoremap ]q :cnext<CR>
    nnoremap [Q :cfirst<CR>
    nnoremap ]Q :clast<CR>

    " Location list
    nnoremap [l :lprevious<CR>
    nnoremap ]l :lnext<CR>
    nnoremap [L :lfirst<CR>
    nnoremap ]L :llast<CR>

    " Tag match list
    nnoremap [t :tprevious<CR>
    nnoremap ]t :tnext<CR>
    nnoremap [T :tfirst<CR>
    nnoremap ]T :tlast<CR>


"--- Filetype specific commands
    augroup filetype_commands
        autocmd!
        au BufEnter *vimrc nnoremap <buffer> <cr> :source %<cr>
        au FileType python nnoremap <buffer> _bp oimport pdb; pdb.set_trace()<Esc>
        au FileType python nnoremap <buffer> _BP Oimport pdb; pdb.set_trace()<Esc>
    augroup END