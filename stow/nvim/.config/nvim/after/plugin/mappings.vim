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

"{{{ <leader> / Wildchar
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<c-z>
"}}}

"{{{ Basics / Improving standard mappings
nnoremap <esc> <cmd>nohlsearch<bar>diffupdate<cr>
nnoremap <c-w><c-o> <cmd>diffoff!<bar>only<cr>

" Toggle folds with <space>
nnoremap <space> za

" Yank to clipboard with "" (Why would I ever explicitly need to target
" the unnamed register anyways?)
noremap "" "+

" Close all folds but show the cursorline
nnoremap zV <cmd>normal zMzv<cr>

" Run 'q' macro
nnoremap Q @q
vnoremap Q :normal @q<cr>

" Repeat '.' in range
vnoremap . :normal .<cr>

" Move over visual lines unless a count is given
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')

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

nnoremap [l <cmd>lprevious<cr>
nnoremap ]l <cmd>lnext<cr>

nnoremap [t <cmd>tprevious<cr>
nnoremap ]t <cmd>tnext<cr>
"}}}

"{{{ Search and replace
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
nnoremap <silent> `<space>  <cmd>call qf#ctoggle()<cr>
nnoremap <silent> <leader><space>  <cmd>call qf#ltoggle()<cr>
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

" Missing `:tab split` mapping
" Like <c-w>T, but without removing the window from the current page.
" Also works when there is only one window.
nnoremap <silent> <c-w>t <cmd>tab split<bar>diffoff<cr>

" Grep, i.e. poor man's 'go-to-reference'
nmap <silent> gr :silent grep! <c-r><c-w><cr>
vmap <silent> gr y:silent grep! <c-r>"<cr>

" Outline
nmap gO <cmd>TagToc<cr>
"}}}

"{{{ Leader mappings
" Splits
nnoremap <leader>s :sbuffer <c-z>
nnoremap <leader>v :vert sbuffer <c-z>
nnoremap <leader>t :tab sbuffer <c-z>

nnoremap <leader>e <cmd>Explore<cr>

" Fuzzy Find: <leader>f
nnoremap <leader>f <cmd>FileFinder<cr>

" Grep
nnoremap <leader>g :silent grep! <c-r>=expand("<cword>")<cr>
vnoremap <leader>g y:silent grep! <c-r>=shellescape(@")<cr>
"}}}

"{{{ (c): Changes / Diffing
nmap <expr> dp (&diff ? '<cmd>diffput<cr>' : '<cmd>DiffThis<cr>')
nmap dP :DiffThis <c-z>
"}}}

"{{{ (gb): Git Blame
nmap <silent> gb <plug>(git-blame)
vmap <silent> gb <plug>(git-blame)
"}}}

"{{{ Theme and Colors
nnoremap <F7> <cmd>silent !toggle-light-dark<cr>
nnoremap <F8> <cmd>CycleColorNext<cr>
"}}}

"{{{ TOC / Document symbols based on tags
nmap gw <cmd>TagToc<cr>
"}}}

" vim: foldmethod=marker
