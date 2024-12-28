"{{{ Options
"{{{ Colors
set notermguicolors
colorscheme ludite
"}}}

"{{{ Appearance
set noshowcmd
set cmdheight=1
set inccommand=split
set showmode
set number
set smoothscroll
set scrolloff=1
set sidescrolloff=1
set showmatch
set signcolumn=number
set shortmess+=s
set concealcursor=n
set laststatus=2
set showtabline=2
set title
"}}}

"{{{ Behavior
set ttimeoutlen=25
set noswapfile
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
" set wildignore+=*/node_modules/*
"}}}

"{{{ Get help
set keywordprg=:Search\ ddg
"}}}
"}}}

"{{{ Toggles
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
nnoremap yox <cmd>call options#toggle('cursorline')<bar>let &cursorcolumn=&cursorline<cr>
nnoremap yoy <cmd>Noyo<cr>
nnoremap yo? <cmd>set ignorecase? diff? spell?  list? number? relativenumber? laststatus? showtabline? virtualedit? wrap?<cr>

nnoremap yoa <cmd>echo "Toggle 'yoa' unused"<cr>
nnoremap yoe <cmd>echo "Toggle 'yoe' unused"<cr>
nnoremap yof <cmd>echo "Toggle 'yof' unused"<cr>
nnoremap yog <cmd>echo "Toggle 'yog' unused"<cr>
nnoremap yoj <cmd>echo "Toggle 'yoj' unused"<cr>
nnoremap yok <cmd>echo "Toggle 'yok' unused"<cr>
nnoremap yoo <cmd>echo "Toggle 'yoo' unused"<cr>
nnoremap yoq <cmd>echo "Toggle 'yoq' unused"<cr>
nnoremap you <cmd>echo "Toggle 'you' unused"<cr>
nnoremap yoz <cmd>echo "Toggle 'yoz' unused"<cr>

nnoremap yoA <cmd>echo "Toggle 'yoA' unused"<cr>
nnoremap yoB <cmd>echo "Toggle 'yoB' unused"<cr>
nnoremap yoC <cmd>echo "Toggle 'yoC' unused"<cr>
nnoremap yoD <cmd>echo "Toggle 'yoD' unused"<cr>
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
nnoremap yoS <cmd>echo "Toggle 'yoS' unused"<cr>
nnoremap yoT <cmd>echo "Toggle 'yoT' unused"<cr>
nnoremap yoU <cmd>echo "Toggle 'yoU' unused"<cr>
nnoremap yoV <cmd>echo "Toggle 'yoV' unused"<cr>
nnoremap yoW <cmd>echo "Toggle 'yoW' unused"<cr>
nnoremap yoX <cmd>echo "Toggle 'yoX' unused"<cr>
nnoremap yoY <cmd>echo "Toggle 'yoY' unused"<cr>
nnoremap yoZ <cmd>echo "Toggle 'yoZ' unused"<cr>
"}}}

" vim: foldmethod=marker
