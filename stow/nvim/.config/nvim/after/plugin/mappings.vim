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

" Execute script
nnoremap <leader><leader> <cmd>w<bar>Run<cr>

"{{{ Open Settings
nnoremap <leader>,, <cmd>edit $MYVIMRC<cr>
nnoremap <leader>,m <cmd>EditPlugin mappings<cr>
nnoremap <leader>,f <cmd>EditFtplugin<cr>
nnoremap <leader>,i <cmd>EditIndent<cr>
nnoremap <leader>,c <cmd>EditColorscheme<cr>
"}}}

"{{{ <leader> / Wildchar
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<c-z>
"}}}

"{{{ Basics / Improving standard mappings
nnoremap <esc> <cmd>nohlsearch<bar>diffupdate<cr>
nnoremap <c-h> <cmd>nohlsearch<bar>diffupdate<cr>
nnoremap <c-w><c-o> <cmd>diffoff!<bar>only<cr>

" Toggle folds with <space>
nnoremap <space> za

" Insert tabs as spaces after the first non-blank character
" inoremap <expr> <tab> getline('.')[:col('.')-2] =~ '^\s*$' ? '<tab>' : repeat(' ', &sw - (virtcol('.') - 1) % &sw)

" Yank to clipboard with "" (Why would I ever explicitly need to target
" the unnamed register anyways?)
noremap "" "+
nnoremap "? <cmd>registers<cr>

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
" Taken from `help section`
map <silent> [[ ?{<cr>w99[{
map <silent> ][ /}<cr>b99]}
map <silent> ]] j0[[%/{<cr>
map <silent> [] k$][%?}<cr>

 " Change word under cursor and make it repeatable
nnoremap c* <cmd>let @/ = '\<'..expand('<cword>')..'\>'<cr>cgn
nnoremap cg* <cmd>let @/ = expand('<cword>')<cr>cgn

" Escape terminal mode
tnoremap <c-\><c-\> <c-\><c-n>
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
            \   : '<cmd>vertical resize '..(winwidth(0) > &columns / 4 ? &columns / 4 : &columns / 4 * 3)..'<cr>'
            \ : '<bar>'
"}}}

"{{{ Cycling lists
nnoremap [a <cmd>previous<cr>
nnoremap ]a <cmd>next<cr>

nnoremap [b <cmd>bprevious<cr>
nnoremap ]b <cmd>bnext<cr>

nnoremap [q <cmd>cprevious<cr>
nnoremap ]q <cmd>cnext<cr>
if empty(maparg("<c-p>", "n"))|nnoremap <c-p> <cmd>cprevious<cr>|endif
if empty(maparg("<c-n>", "n"))|nnoremap <c-n> <cmd>cnext<cr>|endif

nnoremap [l <cmd>lprevious<cr>
nnoremap ]l <cmd>lnext<cr>
if empty(maparg("<c-k>", "n"))|nnoremap <c-k> <cmd>lprevious<cr>|endif
if empty(maparg("<c-j>", "n"))|nnoremap <c-j> <cmd>lnext<cr>|endif

nnoremap [t <cmd>tprevious<cr>
nnoremap ]t <cmd>tnext<cr>
"}}}


"{{{ Search and replace
vnoremap * y<cmd>let @/=@"<cr>n
nnoremap gs :%s/
vnoremap gs :s/

nnoremap <expr> gS ':%s/\C\V\<'.expand('<cword>').'\>/'
vnoremap gS y:%s/\C\V<c-r>=escape(@", '\/')<cr>/
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
nnoremap <silent> <> <cmd>Fmt<cr>
"}}}

"{{{ Fix
" Mnemonic:
"   ! change / modify / action
"   > into file
nnoremap <silent> !> <cmd>Fix<cr>
"}}}

"{{{  Errors: Quickfix / Location Lists
nnoremap <silent> `<space>  <cmd>clist<cr>
nnoremap <silent> <leader><space>  <cmd>llist<cr>
"}}}

"{{{ Close all utility windows
nnoremap <silent> <c-w><space>   <cmd>cclose<bar>lclose<cr><c-w>z
nnoremap <silent> <c-w><c-space> <cmd>cclose<bar>lclose<cr><c-w>z
"}}}

"{{{ Preview / Hover
" Preview definition
nnoremap <expr><silent> <c-space>         !empty(tagfiles()) ? '<c-w>}' : !empty(expand('<cword>')) ? ':psearch <c-r><c-w><cr>' : ''
vnoremap <expr><silent> <c-space>         !empty(tagfiles()) ? 'y:ptag <c-r>"<cr>' !empty(expand('<cword>')) ? : 'y:psearch /.*<c-r>".*/<cr>' : ''

" Signature help via :ptag
inoremap <expr><silent> <c-h> '<cmd>ptag '.expand('<cword>').'<cr>'
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
nnoremap <silent> gr <cmd>let @/=expand("<cword>")<bar>execute "silent grep! '\\b"..@/.."\\b'"<bar>set hlsearch<cr>
vnoremap <silent> gr y:let @/=escape(@", '\|/')<bar>execute 'silent grep! '..shellescape(@/, '\|')<bar>set hlsearch<cr>

" LiveGrep
nmap <leader>G <plug>(livegrep-resume)
nmap <leader>g <plug>(livegrep-new)

" Outline
nmap gO <cmd>TagToc<cr>
"}}}

"{{{ Leader mappings
"{{{ Buffer Switching
nnoremap <leader>b :call buffers#recent()<cr>:buffer<space>
nnoremap <leader>s :call buffers#recent()<cr>:sbuffer<space>
nnoremap <leader>v :call buffers#recent()<cr>:vert sbuffer<space>
nnoremap <leader>t :call buffers#recent()<cr>:tab sbuffer<space>

nnoremap <leader>d :call buffers#recent()<cr>:bdelete<space>
nnoremap <leader>D :call buffers#recent()<cr>:bdelete<c-b>
" for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
"     execute 'nnoremap <leader>'.i.' <cmd>call buffers#pos('.i.')<cr>'
" endfor
nnoremap <leader>T :buffer term://<c-z>
"}}}

" Scratch buffer
nnoremap <leader>S <cmd>Scratch<cr>

" Journal
nnoremap <leader>J <cmd>Journal<cr>

" Fuzzy Find: <leader>f
nnoremap <leader>f <cmd>FileFinder<cr>

" Switching tabs
nnoremap <c-\> gt
nnoremap <m-\> gT
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <leader>'.i.' '.i.'gt'
endfor

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
nnoremap <F8> <cmd>CycleColorNext<cr>
"}}}

"{{{ Open
nnoremap <silent> <leader>o <cmd>Open <cWORD><cr>
vnoremap <silent> <leader>o y:<C-U>Open <C-R>"<cr>
"}}}

" vim: foldmethod=marker
