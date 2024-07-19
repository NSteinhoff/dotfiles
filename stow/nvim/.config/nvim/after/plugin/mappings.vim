"{{{ Sanitizer
augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
    autocmd CmdwinEnter * nnoremap <buffer> <bs> <bs>
    autocmd CmdwinEnter * nnoremap <buffer> <space> <space>
    autocmd CmdwinEnter * nnoremap <buffer> <c-n> <c-n>
    autocmd CmdwinEnter * nnoremap <buffer> <c-p> <c-p>
augroup END
"}}}

nnoremap g? <cmd>help my-stuff<cr>

"{{{ <leader> / Wildchar
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<c-z>
"}}}

" Execute script
nnoremap <leader><leader> <cmd>w<bar>Run<cr>

"{{{ Open Settings
nnoremap <leader>,, <cmd>edit $MYVIMRC<cr>
nnoremap <leader>,m <cmd>EditPlugin mappings<cr>
nnoremap <leader>,f <cmd>EditFtplugin<cr>
nnoremap <leader>,i <cmd>EditIndent<cr>
nnoremap <leader>,c <cmd>EditColorscheme<cr>
"}}}

"{{{ Basics / Improving standard mappings
nnoremap <esc> <cmd>nohlsearch<bar>diffupdate<cr>
nnoremap <c-h> <cmd>nohlsearch<bar>diffupdate<cr>

" Toggle folds with <space>
nnoremap <space> za
nnoremap <c-w><c-o> <cmd>diffoff!<bar>only<cr>

" Insert tabs as spaces after the first non-blank character
imap <Tab> <plug>(smarttab)

" Yank to clipboard with "" (Why would I ever explicitly need to target
" the unnamed register anyways?)
noremap "" "+
nnoremap "? <cmd>registers "0123456789-+/<cr>
nnoremap '? <cmd>Marks<cr>
nnoremap '! <cmd>Delmarks!<cr>

" Close all folds but show the cursorline
nnoremap zV <cmd>normal zMzv<cr>

" Run 'q' macro
nnoremap Q @q
vnoremap Q :normal @q<cr>

" Repeat '.' in range
vnoremap . :normal .<cr>

" Move over visual lines unless a count is given
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')

" Move over sections
" from `help section`
map <silent> [[ ?{<CR>w99[{
map <silent> ][ /}<CR>b99]}
map <silent> ]] j0[[%/{<CR>
map <silent> [] k$][%?}<CR>

 " Change word under cursor and make it repeatable
nnoremap c* <cmd>let @/ = '\<'..expand('<cword>')..'\>'<cr>cgn
nnoremap cg* <cmd>let @/ = expand('<cword>')<cr>cgn

" Exchange current selection with last text yanked
vmap x <plug>(exchange)

" Escape terminal mode
tnoremap <c-\><c-\> <c-\><c-n>
" tnoremap <esc> <c-\><c-n>
"}}}

"{{{ Viewport
" Window resizing with the arrow keys
nnoremap <left>  5<c-w><
nnoremap <right> 5<c-w>>
nnoremap <up>    2<c-w>+
nnoremap <down>  2<c-w>-

" Open split and toggle between 3/4 and 1/4 viewport width
nnoremap <silent> <expr> <bar>
            \ v:count == 0
            \ ? winlayout()[0] == 'leaf' <bar><bar> (winlayout()[0] == 'col' && winlayout()[1][0][0] == 'leaf')
            \   ? '<c-w>v'
            \   : '<cmd>vertical resize '..(winwidth(0) < &columns / 4 * 3 ? &columns / 4 * 3: &columns / 4)..'<cr>'
            \ : '<bar>'
"}}}

"{{{ Cycling lists
nnoremap ]a <cmd>next<cr>
nnoremap [a <cmd>previous<cr>

nnoremap ]b <cmd>bnext<cr>
nnoremap [b <cmd>bprevious<cr>

nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprevious<cr>
if empty(maparg("<c-n>", "n"))|nnoremap <c-n> <cmd>cnext<cr>|endif
if empty(maparg("<c-p>", "n"))|nnoremap <c-p> <cmd>cprevious<cr>|endif

nnoremap ]l <cmd>lnext<cr>
nnoremap [l <cmd>lprevious<cr>
if empty(maparg("<c-j>", "n"))|nnoremap <c-j> <cmd>lnext<cr>|endif
if empty(maparg("<c-k>", "n"))|nnoremap <c-k> <cmd>lprevious<cr>|endif

nnoremap [t <cmd>tprevious<cr>
nnoremap ]t <cmd>tnext<cr>
"}}}

"{{{ Arglist
nnoremap ]A <cmd>argadd %<bar>echo "Added arg '"..expand("%").."'"<cr>
nnoremap [A <cmd>argdelete %<bar>echo "Removed arg '"..expand("%").."'"<cr>
"}}}

"{{{ Search and replace
vnoremap * y<cmd>let @/=@"<cr>n
nnoremap gs :%s/
vnoremap gs :s/

nnoremap <expr> gS ':%s/\C\V\<'.expand('<cword>').'\>/'
vnoremap gS y:%s/\C\V<c-r>=escape(@", '\/.')<cr>/
"}}}

"{{{ Highlight matches
nnoremap <expr> gm v:count <= 1 ? '<cmd>Match<cr>' : '<cmd>Match'.v:count.'<cr>'
nnoremap <expr> gM v:count <= 1 ? '<cmd>match<cr>' : '<cmd>'.v:count.'match<cr>'
vnoremap gm y:<c-u>Match <c-r>"<cr>
"}}}

"{{{ Format
" Mnemonic:
"   < and > change indentation
"   <> => 'indent all'
nnoremap <silent> <> <cmd>Fmt!<cr>
"}}}

"{{{ Fix
" Mnemonic:
"   ! change / modify / action
"   > into file
nnoremap <silent> !> <cmd>Fix<cr>
"}}}

"{{{ Close all utility windows
nnoremap <silent> <c-w><space>   <cmd>cclose<bar>lclose<cr><c-w>z
nnoremap <silent> <c-w><c-space> <cmd>cclose<bar>lclose<cr><c-w>z
"}}}

"{{{ Preview / Hover
" Preview definition
nmap <silent> <c-w>} <plug>(preview)
vmap <silent> <c-w>} <plug>(preview)
nmap <silent> <c-space> <c-w>}
vmap <silent> <c-space> <c-w>}
"}}}

"{{{ Completion
" <c-space> is used for smart completion.
" By default it completes tags. This could be remapped to omni-completion
" or LSP completion for supported languages or filetypes.
inoremap <expr> <c-space> empty(&omnifunc) ? '<c-x><c-]>' : '<c-x><c-o>'

" Paths:
" imap <c-x><c-h> <c-r>=complete#localpath()<cr>
imap <c-l> <c-r>=complete#localpath()<cr>
"}}}

"{{{ Running builds with `<key>
nmap m<space> <cmd>wall<bar>make!<cr>
"}}}

"{{{ Quality of life
vnoremap v iw

" Change indentation of selected lines
vnoremap <tab> >gv
vnoremap <s-tab> <gv

" Not sure that these work everywhere
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" Switch to alternative buffer
nmap <bs> <c-^>
nnoremap <c-^> <cmd>call buffers#alternative()<cr>
nnoremap <leader>a <cmd>call buffers#yang()<cr>

" Missing `:tab split` mapping
" Like <c-w>T, but without removing the window from the current page.
" Also works when there is only one window.
nnoremap <silent> <c-w>t <cmd>tab split<bar>diffoff<cr>
nmap <c-w><c-t> <c-w>t
" nnoremap <c-n> gt
" nnoremap <c-p> gT

" Grep, i.e. poor man's 'go-to-reference'
" These use the location list, because they are meant to be used frequently
" and should not conflict with the more groomed quickfix lists.
nnoremap <silent> gr <cmd>let @/=expand("<cword>")<bar>execute "silent grep! '\\b"..@/.."\\b'"<bar>set hlsearch<cr>
vnoremap <silent> gr y:let @/=escape(@", '.\|$[]()')<bar>execute 'silent grep! '..shellescape(@/, '\|')<bar>set hlsearch<cr>
nnoremap <silent> ga <cmd>let @/=expand("<cword>")<bar>execute "silent grepadd! '\\b"..@/.."\\b'"<bar>set hlsearch<cr>
vnoremap <silent> ga y:let @/=escape(@", '.\|$[]()')<bar>execute 'silent grepadd! '..shellescape(@/, '\|')<bar>set hlsearch<cr>

" Outline
nmap gO <cmd>TagToc<cr>
"}}}

"{{{ Leader mappings
"{{{ Buffer Switching
nnoremap <leader>bb :call buffers#recent()<cr>:buffer<space>
nnoremap <leader>bv :call buffers#recent()<cr>:vert sbuffer<space>
nnoremap <leader>bt :call buffers#recent()<cr>:tab sbuffer<space>

nnoremap <leader>bd :call buffers#recent()<cr>:bdelete<space>
nnoremap <leader>bD :call buffers#recent()<cr>:bdelete<c-b>

nnoremap <leader>bT :buffer term://<c-z>
"}}}

" Toggle Scratch buffer
nnoremap <leader>bs <cmd>Scratch<cr>

" Journal
nnoremap <leader>bJ <cmd>Journal<cr>

" Changed Files
nnoremap <leader>c <cmd>ChangedFiles<cr>

" File Finder: <leader>f
nnoremap <leader>f <plug>(filefinder)

" Live Search
nmap <leader>G <plug>(livegrep-resume)
nmap <leader>g <plug>(livegrep-new)
vmap <leader>g <plug>(livegrep-selection)

" Switching tabs
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <leader>'.i.' '.i.'gt'
endfor
nnoremap <c-w><c-[> gT
nnoremap <c-w><c-]> gt

"{{{ (c): Changes / Diffing
nmap <expr> dp (&diff ? '<cmd>diffput<cr>' : '<cmd>DiffThis<cr>')
nmap dP :DiffThis <c-z>
"}}}

"{{{ (gb): Git Blame
nmap <silent> gb <plug>(git-blame)
vmap <silent> gb <plug>(git-blame)
"}}}

"{{{ (gh): Stealth Mode
nnoremap <silent> gh <cmd>StealthToggle<cr>
"}}}

"{{{ Theme and Colors
nnoremap <F7> <cmd>silent !toggle-light-dark<cr>
"}}}

"{{{ Git add  / reset current file
nmap ]g <plug>(git-add)
nmap [g <plug>(git-reset)
"}}}

"{{{ Reviewing
nmap ]r <plug>(git-review-next)
nmap [r <plug>(git-review-prev)
nmap ]R <plug>(git-review-mark-seen)
nmap [R <plug>(git-review-first)
"}}}

" vim: foldmethod=marker
