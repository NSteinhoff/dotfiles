"{{{ --- OPTIONS ---
"{{{ Colors
set notermguicolors
colorscheme ludite
"}}}
"{{{ Appearance
set cmdheight=1
set previewheight=10
set inccommand=split
set showmode
set number
set scrolloff=1
set sidescrolloff=1
set showmatch
set signcolumn=number
set shortmess+=s
set concealcursor=n
set laststatus=2
set showtabline=2
"}}}
"{{{ Behavior
set ttimeoutlen=25                              " shorter key sequence timeout
set updatetime=250
set foldenable
set foldmethod=indent
set foldlevelstart=99                           " start with all folds opened
set foldcolumn=0
set mouse=nv                                    " enable mouse in normal and visual mode
set mousemodel=extend
set ignorecase                                  " ignore case in searches ...
set smartcase                                   " ... unless it includes capital letters
set tagcase=match                               " Match case in :tag searches
set splitright                                  " open vertical splits on the right
set sessionoptions+=options                     " remember options and mappings
set isfname-==
set fileformats=unix                            " show <CR><NL>
set jumpoptions=stack
set undofile
"}}}
"{{{ Special characters
"set fillchars=eob:·
set list
set listchars=
set listchars+=tab:¦\ 
set listchars+=trail:…
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:␣
set listchars+=eol:¬
set listchars+=lead:\ 
" set listchars+=multispace:\ \ \ ·               " Add markers for every 4 spaces
"}}}
"{{{ Text formatting
set tabstop=8
set shiftwidth=4
set softtabstop=-1
set expandtab

set nowrap
set linebreak
set breakindent                                 " indent wrapped lines
set showbreak=└                                 " prepend wrapped lines with this
set smartindent

set formatoptions=
set formatoptions+=l                            " don't wrap lines that were too long to begin with
" sentences
set formatoptions+=p                            " don't wrap after . + single space
" set cpoptions+=J                                " require double space after sentences
" set joinspaces                                  " double spaces after sentences
" comments
set formatoptions+=c                            " wrap comments
set formatoptions+=j                            " remove commentstring when joining comment lines
set formatoptions+=q                            " also format comments with 'gq'
set formatoptions+=r                            " continue comments when hitting <Enter>
" lists
set formatoptions+=n                            " recognize numbered lists
" recognize * and - as list headers
set formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\|[*-][\\t\ ]\\)\\s*
"}}}
"{{{ Completions
set wildmode=longest:full,full
set wildoptions=pum
set completeopt=menuone,noinsert,noselect
set shortmess+=c
"}}}
"{{{ Path and files
set path=,,.
set wildignore+=*.dSym/
set wildignore+=*/node_modules/*
"}}}
"{{{ Get help
set keywordprg=:Search\ ddg
"}}}
"}}}

"{{{ --- MAPPINGS ---
"{{{ <leader> / Wildchar
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
let maplocalleader = '\'
set wildcharm=<c-z>
"}}}
"{{{ Open Settings
nnoremap <leader>,, <cmd>edit +set\ foldlevel=0\|0 $MYVIMRC<cr>
nnoremap <leader>,o <cmd>edit +set\ foldlevel=1\|/---\\sOPTIONS $MYVIMRC<cr>
nnoremap <leader>,m <cmd>edit +set\ foldlevel=1\|/---\\sMAPPINGS $MYVIMRC<cr>
nnoremap <leader>,p <cmd>edit +set\ foldlevel=1\|/---\\sPACKAGES $MYVIMRC<cr>
nnoremap <leader>,f <cmd>EditFtplugin<cr>
nnoremap <leader>,i <cmd>EditIndent<cr>
nnoremap <leader>,c <cmd>EditColorscheme<cr>
nnoremap <leader>,t <cmd>EditTerminalSettings<cr>
"}}}
"{{{ Basics / Improving standard mappings
nnoremap <esc> <cmd>nohlsearch<bar>diffupdate<cr>

" Favourite global mark
nnoremap gz `Z

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

" Smarter C-P/N in the command line
cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"
"}}}
"{{{ Cycling lists
nnoremap ]a <cmd>next<cr>
nnoremap [a <cmd>previous<cr>

nnoremap ]b <cmd>bnext<cr>
nnoremap [b <cmd>bprevious<cr>

nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprevious<cr>

nnoremap ]l <cmd>lnext<cr>
nnoremap [l <cmd>lprevious<cr>

nnoremap ]t <cmd>tnext<cr>
nnoremap [t <cmd>tprevious<cr>

nnoremap ]p <cmd>ptnext<cr>
nnoremap [p <cmd>ptprevious<cr>
"}}}
"{{{ Arglist
nnoremap ]A <cmd>argadd %<bar>echo "Added arg '"..expand("%").."'"<cr>
nnoremap [A <cmd>argdelete %<bar>echo "Removed arg '"..expand("%").."'"<cr>
"}}}
"{{{ Search and replace
vnoremap * y<cmd>let @/=@"<cr>n
nnoremap gs :%s/
vnoremap gs :s/
nnoremap gS yiw:let @/=@"<cr>:%s/\C\V\<<c-r>=escape(@/, '\/.')<cr>\>/
vnoremap gS y:let @/=@"<cr>:%s/\C\V<c-r>=escape(@/, '\/.')<cr>/
"}}}
"{{{ Highlight matches
nnoremap <expr> gm v:count <= 1 ? '<cmd>Match<cr>' : '<cmd>Match'.v:count.'<cr>'
nnoremap <expr> gM v:count <= 1 ? '<cmd>match<cr>' : '<cmd>'.v:count.'match<cr>'
vnoremap gm y:<c-u>Match <c-r>"<cr>
"}}}
"{{{ Formatting and Fixing
" Mnemonic:
"   < and > change indentation
"   <> => 'indent all'
nnoremap <silent> <> <cmd>Fmt!<cr>
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
"{{{ Running builds/scripts
" Make
nmap m<space> <cmd>wall<bar>make!<cr>
" Execute script
nnoremap <leader><leader> <cmd>w<bar>Run<cr>
nnoremap g<cr> <cmd>w<bar>Run<cr>
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

" Grep, i.e. poor man's 'go-to-reference'
nnoremap <silent> gr <cmd>let @/=expand("<cword>")<bar>execute "silent grep! '\\b"..@/.."\\b'"<bar>set hlsearch<cr>
vnoremap <silent> gr y:let @/=escape(@", '.\|$[](){}')<bar>execute 'silent grep! '..shellescape(@/, '\|')<bar>set hlsearch<cr>
nnoremap <silent> ga <cmd>let @/=expand("<cword>")<bar>execute "silent grepadd! '\\b"..@/.."\\b'"<bar>set hlsearch<cr>
vnoremap <silent> ga y:let @/=escape(@", '.\|$[](){}')<bar>execute 'silent grepadd! '..shellescape(@/, '\|')<bar>set hlsearch<cr>

" Outline
nmap gO <cmd>Outline<cr>
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
"{{{ Toggle Scratch buffer
nnoremap <leader>s <cmd>Scratch<cr>
"}}}
"{{{ Open Journal
nnoremap <leader>j <cmd>Journal<cr>
"}}}
"{{{ Changed Files
nnoremap <leader>c <cmd>ChangedFiles<cr>
"}}}
"{{{ File Finder: <leader>f
nnoremap <leader>f <plug>(filefinder)
"}}}
"{{{ Live Search
nmap g/ <plug>(livegrep-new)
nmap <leader>G <plug>(livegrep-resume)
nmap <leader>g <plug>(livegrep-new)
vmap <leader>g <plug>(livegrep-selection)
"}}}
"{{{ Switching tabs
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <leader>'.i.' '.i.'gt'
endfor
nnoremap <c-w><c-[> gT
nnoremap <c-w><c-]> gt
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
"}}}
"{{{ Git add  / reset current file
nmap ]g <plug>(git-add)
nmap [g <plug>(git-reset)
nmap ]G <plug>(git-add)
nmap [G <plug>(git-reset)
"}}}
"{{{ Reviewing
nmap ]r <plug>(git-review-next)
nmap [r <plug>(git-review-prev)
nmap ]R <plug>(git-review-mark-seen)
nmap [R <plug>(git-review-first)
"}}}
"}}}
"{{{ Toggles
nnoremap yo? <cmd>set ignorecase? diff? spell?  list? number? relativenumber? laststatus? showtabline? virtualedit? wrap?<cr>
nnoremap yob <cmd>ToggleBlame<cr>
nnoremap yoc <cmd>execute 'colorscheme ' . (colors_name == 'ludite' ? 'minimal' : 'ludite')..'\|colorscheme'<cr>
nnoremap yod <cmd>call options#toggle('diff')<cr>
nnoremap yoh <cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()); print("Inlay hints " .. (vim.lsp.inlay_hint.is_enabled() and "enabled" or "disabled"))<cr>
nnoremap yoi <cmd>call options#toggle('ignorecase')<cr>
nnoremap yol <cmd>call options#toggle('list')<cr>
nnoremap yom <cmd>ToggleMarks<cr>
nnoremap yon <cmd>call options#toggle('number')<cr>
nnoremap yop <cmd>call options#toggle('spell')<cr>
nnoremap yor <cmd>call options#toggle('relativenumber')<cr>
nnoremap yos <cmd>call options#toggle('laststatus', 2, 0)<cr>
nnoremap yot <cmd>call options#toggle('showtabline', 2, 0)<cr>
nnoremap yov <cmd>call options#toggle('virtualedit', 'all', '')<cr>
nnoremap yow <cmd>call options#toggle('wrap')<cr>
nnoremap yok <cmd>call options#toggle('cursorline')<cr>
nnoremap yox <cmd>call options#toggle('cursorline')<bar>let &cursorcolumn=&cursorline<cr>
nnoremap yoy <cmd>Noyo<cr>

nnoremap yoD <cmd>exec &diff ? 'diffoff!' : 'windo diffthis'<cr>
nnoremap yoT <cmd>silent !toggle-light-dark<cr>
nnoremap yoS <cmd>StealthToggle<cr>

nnoremap yoa <cmd>echo "Toggle 'yoa' unused"<cr>
nnoremap yoe <cmd>echo "Toggle 'yoe' unused"<cr>
nnoremap yof <cmd>echo "Toggle 'yof' unused"<cr>
nnoremap yog <cmd>echo "Toggle 'yog' unused"<cr>
nnoremap yoj <cmd>echo "Toggle 'yoj' unused"<cr>
nnoremap yoo <cmd>echo "Toggle 'yoo' unused"<cr>
nnoremap yoq <cmd>echo "Toggle 'yoq' unused"<cr>
nnoremap you <cmd>echo "Toggle 'you' unused"<cr>
nnoremap yoz <cmd>echo "Toggle 'yoz' unused"<cr>

nnoremap yoA <cmd>echo "Toggle 'yoA' unused"<cr>
nnoremap yoB <cmd>echo "Toggle 'yoB' unused"<cr>
nnoremap yoC <cmd>echo "Toggle 'yoC' unused"<cr>
nnoremap yoE <cmd>echo "Toggle 'yoE' unused"<cr>
nnoremap yoF <cmd>echo "Toggle 'yoF' unused"<cr>
nnoremap yoG <cmd>echo "Toggle 'yoG' unused"<cr>
nnoremap yoH <cmd>echo "Toggle 'yoH' unused"<cr>
nnoremap yoI <cmd>echo "Toggle 'yoI' unused"<cr>
nnoremap yoJ <cmd>echo "Toggle 'yoJ' unused"<cr>
nnoremap yoK <cmd>echo "Toggle 'yoK' unused"<cr>
nnoremap yoL <cmd>echo "Toggle 'yoL' unused"<cr>
nnoremap yoM <cmd>echo "Toggle 'yoM' unused"<cr>
nnoremap yoN <cmd>echo "Toggle 'yoN' unused"<cr>
nnoremap yoO <cmd>echo "Toggle 'yoO' unused"<cr>
nnoremap yoP <cmd>echo "Toggle 'yoP' unused"<cr>
nnoremap yoQ <cmd>echo "Toggle 'yoQ' unused"<cr>
nnoremap yoR <cmd>echo "Toggle 'yoR' unused"<cr>
nnoremap yoU <cmd>echo "Toggle 'yoU' unused"<cr>
nnoremap yoV <cmd>echo "Toggle 'yoV' unused"<cr>
nnoremap yoW <cmd>echo "Toggle 'yoW' unused"<cr>
nnoremap yoX <cmd>echo "Toggle 'yoX' unused"<cr>
nnoremap yoY <cmd>echo "Toggle 'yoY' unused"<cr>
nnoremap yoZ <cmd>echo "Toggle 'yoZ' unused"<cr>
"}}}
"{{{ Quickfix/Location List
nmap g<space> <plug>(qf-ctoggle)
nmap g<bs> <plug>(qf-ltoggle)
nmap <leader>q <plug>(qf-ctoggle)
nmap <leader>l <plug>(qf-ltoggle)
nmap <leader>Q <plug>(qf-ctab)
nmap <leader>L <plug>(qf-ltab)
nmap <c-n> <plug>(qf-cnext)
nmap <c-p> <plug>(qf-cprev)
nmap <c-j> <plug>(qf-lnext)
nmap <c-k> <plug>(qf-lprev)
"}}}
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
"}}}

"{{{ --- BLOAT ---
"{{{ Disable
let s:loaded = [
\   "python3_provider",
\   "pythonx_provider",
\   "ruby_provider",
\   "node_provider",
\   "perl_provider",
\   "matchparen",
\   "matchit",
\   "netrwPlugin",
\   "tutor_mode_plugin",
\   "remote_plugins",
\   "gzip",
\   "tarPlugin",
\   "zipPlugin",
\   "2html_plugin",
\]

for name in s:loaded | let g:["loaded_" .. name] = 1 | endfor
"}}}
"{{{ Configure
"  Speed up diff syntax highlighting by disabling localization
let g:diff_translations = 0
"  Prefer C over C++ for header files
let g:c_syntax_for_h = 1
"  Better folding for markdown.
let g:markdown_folding = 1
"}}}
"}}}

"{{{ --- PACKAGES ---
if exists('$GIT_INDEX_FILE') | finish | endif
"{{{ Personal
packadd my-livegrep                            " Start grepping live with :lg
packadd! my-filefinder                          " Start simple file finder with :ff
packadd! my-statusline
packadd! my-tabline
packadd! my-git                                 " Git utilities (bloated): Show diff with :dd
packadd! my-quickfix                            " Quickfix niceties, mostly limited to quickfix windows
"}}}
"{{{ Third Party
set packpath+=~/Develop/Dotfiles/3rd

packadd! my-lsp                                 " Language Server configurations
packadd! my-dap                                 " Debugger
packadd! my-dirvish                             " Minimalist file browser (customized)

" Treesitter
let disable_treesitter = v:false
if disable_treesitter
    lua vim.treesitter.start = function() end
else
    packadd! my-treesitter                          " Language aware highlighting
endif
"}}}
"}}}

" vim: foldmethod=marker
