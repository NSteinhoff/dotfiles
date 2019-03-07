" CUSTOM COMMANDS
" ---------------

"--- General ---
    " Escaping modes
    " inoremap jk <c-\><c-n>
    " tnoremap jk <c-\><c-n>
    " vnoremap jk <c-\><c-n>

    " Switch to alternative buffer
    nnoremap <leader>b :e #<cr>

    " Insert newline
    nnoremap <leader>o mpo<esc>`p
    nnoremap <leader>O mpO<esc>`p

    " Navigate splits
    " nnoremap <c-j> <c-w><c-j>
    " nnoremap <c-k> <c-w><c-k>
    " nnoremap <c-l> <c-w><c-l>
    " nnoremap <c-h> <c-w><c-h>

    " Remove highlights of last search results
    nnoremap <silent> <space> :nohlsearch<Bar>:echo<CR>

    " Make arrow keys do something useful -- resizing windows
    nnoremap <silent> <Left> :vertical resize -1<CR>
    nnoremap <silent> <Right> :vertical resize +1<CR>
    nnoremap <silent> <Up> :resize +1<CR>
    nnoremap <silent> <Down> :resize -1<CR>

    " Execute current file
    nnoremap <silent> <leader>ef :!%:p<cr>

    " Execute current line
    nnoremap <silent> <leader>el :y x<cr>:@x<cr>

    " Insert directory of current file in command mode
    cnoremap %% <c-r>=fnameescape(expand('%:h')).'/'<cr>


"--- Searching ---
    " Search for the name under the cursor in all files with the same extension
    nnoremap <leader>* *:vimgrep //j **/*%:e \| bo copen<CR>

    " Search for the last search pattern in all files with the same extension
    nnoremap <leader>/ :vimgrep //j **/*%:e \| bo copen<CR>

    " Closing parenthesis
    inoremap {{<cr> {<cr>}<esc>O
    inoremap [[<cr> [<cr>]<esc>O
    inoremap ((<cr> (<cr>)<esc>O


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
        au FileType scala command! -buffer Format execute '!scalafmt % -c ' . expand('~') . '/.scalafmt.conf' | e
    augroup END


"--- Show syntax highlight groups
    command! Highlights :so $VIMRUNTIME/syntax/hitest.vim


"--- Show file overview
    augroup overview
        autocmd!
        au FileType * :let b:overview_pattern='^#\+'
        au FileType vim :let b:overview_pattern='^\s*"-\+\s\w\+'
        au FileType clojure :let b:overview_pattern='^\s*(\(defn\?\|ns\)\s\w\+'
        au FileType python :let b:overview_pattern='\v^\s*(class\s\u|(async\s)?def\s\U)\w+'
        au FileType scala :let b:overview_pattern='\v^\s*((case\s)?(class|object)\s\u|def\s\U)\w+'
    augroup END
    command! Overview execute 'g/' . b:overview_pattern . '/p' | nohlsearch
    command! Loverview execute 'lvimgrep /' . b:overview_pattern . '/j %' | lopen


"--- Populate/extend arglist from external command
    command! -nargs=1 Args args `=systemlist(<q-args>)`
    command! -nargs=1 Argadd argadd `=systemlist(<q-args>)`

"--- Run command as a job and write to buffer
    command! -nargs=1 Run echo job_start(<q-args>, {"out_io": "buffer", "out_name": <q-args>})

"--- Snippets ---
    " Insert current date and time as 'ctime'
    iabbrev ddc <C-R>=strftime("%c")<CR>
    " Insert current date ctime 'YYYY-MM-DD'
    iabbrev ddd <C-R>=strftime("%Y-%m-%d")<CR>
    " Insert current date with weekday 'Weekday, YYYY-MM-DD'
    iabbrev ddw <C-R>=strftime("%a, %Y-%m-%d")<CR>

"--- Builds / Make / Dispatch
    nnoremap <F9> :Dispatch<CR>
    nnoremap <F10> :Dispatch!<CR>
    augroup my_dispatch_defaults
        autocmd!
        autocmd FileType python let b:dispatch = 'pytest --tb=short -q %'
    augroup END

"--- TCR ---
    nnoremap <F5> :Dispatch! tcr<CR>
