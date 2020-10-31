augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <BS>
    " There seems to be a bug in netrw which sends a <space> after the '-' mapping
    autocmd Filetype netrw nnoremap <buffer> <SPACE> <SPACE>
augroup END

" --- Basics{{{
" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <C-P> :find <C-Z>

" Switch to alternative buffer
nnoremap <BS> <C-^>
nnoremap <silent> <ESC><CR> :make<CR>
nnoremap <silent> <CR> :make!<CR>

" Window resizing with the arrow keys
map  <left>   5<C-W><
map  <right>  5<C-W>>
map  <up>     5<C-W>+
map  <down>   5<C-W>-

" Terminal
" Use a shortcut that is similar to the TMUX copy mode shortcut for exiting
" insert mode in terminal buffers.
tmap <c-w>[ <c-\><c-n>
tmap <c-w><c-[> <c-\><c-n>
"}}}

" --- Scrolling{{{
" Scrolling the window with CTRL-HJKL
nnoremap <C-J> 3<C-E>
nnoremap <C-K> 3<C-Y>
nnoremap <C-H> 3zh
nnoremap <C-L> 3zl
"}}}

" --- Comment / Uncomment{{{
" Mnemonic:
"   " -> Vim's comment string
"   <CR> -> line
"   => 'comment line'
nnoremap <silent> "<CR> :ToggleCommented<CR>
vnoremap <silent> "<CR> :ToggleCommented<CR>
"}}}

" --- Format{{{
" Mnemonic:
"   < and > change indentation
"   => 'indent all'
nnoremap <silent> <> :Format<CR>
"}}}

" --- Clear search highlights{{{
" <ESC>u is used by 'less' to clear highlights. Why not use the same?
nnoremap <silent> <ESC>u :nohlsearch<CR>
"}}}

" --- REPL{{{
" map s <Plug>ReplSendSelection
" nmap s! <Plug>ReplToggle
" nmap s? <Plug>ReplStatus
" nmap ss <Plug>ReplSendLine
" nmap sS <Plug>ReplSendFile
" nmap s< <Plug>ReplSendAbove
" nmap s> <Plug>ReplSendBelow
" nmap s: <Plug>ReplSendCmd
" nmap s<SPACE> <Plug>ReplSendBlock
" nmap s<CR> <Plug>ReplSendAdvanceBlock
"}}}

" --- Errors: Quickfix / Location Lists{{{
" Mnemonic:
"   (Q)uickfix
nnoremap <silent> Q :clist<CR>
"}}}

" --- Preview{{{
nnoremap <silent> <SPACE> :execute 'psearch '.expand('<cword>')<CR>
vnoremap <silent> <SPACE> y:psearch <C-R>"<CR>

" Preview tag under cursor
map <NUL> <C-SPACE>
imap <NUL> <C-SPACE>
nnoremap <C-SPACE> <C-W>}
nnoremap g<C-SPACE> <C-W>g}

" Preview selection
vnoremap <silent> <C-SPACE> y:ptag <C-R>"<CR>
vnoremap <silent> g<C-SPACE> y:ptselect <C-R>"<CR>

" Close the preview window
nnoremap <ESC><ESC> <C-W>z
nnoremap <ESC><SPACE> <C-W>z

" Complete tag
inoremap <C-SPACE> <C-X><C-]>
"}}}

" --- Cycling{{{
" Quickly cycling a list
" (currently Buffers)
" nnoremap <silent> <C-P> :bprevious<CR>
nnoremap <silent> <C-N> :bnext<CR>
"}}}

" --- Toggle Settings{{{
" Exetending 'vim-unimpaired'
" T: s(T)atusbar
nnoremap <silent> [o_ :set ls=2<CR>
nnoremap <silent> ]o_ :set ls=0<CR>
nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')
"}}}

" --- <LEADER>{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<C-Z>

" Quick Keys
vnoremap <leader>= :Align<CR>
nnoremap <leader>! :!%:p<CR>
nnoremap <leader>x :Run<CR>
vnoremap <leader>x :Run<CR>
nnoremap <leader>X :%Run<CR>
nnoremap <leader>o :BufOnly<CR>
nnoremap <leader>f :Format<CR>

" Switch buffers
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>

" Searching
nnoremap <silent> <leader>* :execute 'vimgrep /' . expand('<cword>') . '/ ' . expand('%')<CR>
nnoremap <silent> <leader>gg :execute 'grep -r --include=*.'.expand('%:e').' '.expand('<cword>').' .'<CR>
nnoremap <silent> <leader>gG :execute 'grep -r '.expand('<cword>').' .'<CR>
nnoremap <silent> <leader>rg :execute 'Rg '.expand('<cword>')<CR>
vnoremap <silent> <leader>* y:execute 'vimgrep /\V' . escape(@", '\/') . '/ '  . expand('%')<CR>
vnoremap <silent> <leader>gg y:execute 'grep -r --include=*.'.expand('%:e').' '.shellescape(@").' .'<CR>
vnoremap <silent> <leader>gG y:execute 'grep -r '.shellescape(@").' .'<CR>
vnoremap <silent> <leader>rg y:execute 'Rg '.shellescape(@")<CR>

" Edit Settings files
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <leader>ef :EditFtplugin<CR>
nnoremap <leader>ed :EditFtdetect<CR>
nnoremap <leader>ec :EditCompiler<CR>
nnoremap <leader>es :EditSyntax<CR>
nnoremap <leader>ei :EditIndent<CR>
nnoremap <leader>eo :EditColorscheme<CR>

" File Explorer
nnoremap <leader>E :Explore<CR>
nnoremap <leader>V :Vexplore<CR>
nnoremap <leader>T :Texplore<CR>
augroup mappings_netrw
    autocmd!
    autocmd Filetype netrw nmap <buffer> l <CR>
    autocmd Filetype netrw nmap <buffer> h -
    autocmd Filetype netrw nmap <buffer> L gn
augroup END
"}}}

" --- differ/vim-igitt{{{
nnoremap <silent> d; :Dstatus<CR>
nnoremap <silent> d@ :Dremote<CR>
nnoremap <silent> d! :Dremote!<CR>
nnoremap <silent> du :Dupdate<CR>
nnoremap <silent> d< :Dprevious<CR>
nnoremap <silent> d> :Dnext<CR>
nnoremap <silent> d. :Dthis<CR>
nnoremap <silent> d, :Dpatch<CR>
nnoremap <silent> d~ :Dpatch!<CR>
nnoremap <silent> d" :Dcomment<CR>
nnoremap <silent> d& :Dcomment!<CR>
nnoremap <silent> dc :Dshowcomments<CR>
nnoremap <silent> dC :Dshowcomments!<CR>
"}}}

" vim:foldmethod=marker textwidth=0
