" --------------------------------- Helpers ----------------------------------{{{
augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost .vimrc,vimrc source % "
augroup END

function! s:header(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=').' '
    let fillchar = '-'
    let ncols = 79

    " Set the text that goes in-between the separators
    if a:words != ''
        let text = ' '.a:words
    elseif expand('<cword>') != ''
        let text = ' '.expand('<cword>')
    else
        let text = ''
    endif

    " Build the rulers line
    let ruler = prefix.repeat(fillchar, ncols - strlen(prefix))

    " Build the title line
    let title = prefix.text

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), title)
    call append(line('.')-1, ruler)
    call append(line('.'), ruler)

    call cursor(line('.')+1, col('$'))
endfunction

" Create an 80 column wide header starting at the current cursor
" position. The header text can be passed as an arguments or left blank
" to use the word under the cursor. With no argument or word under
" cursor, will simply draw the separator line.
function! s:center(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=').' '
    let fillchar = '-'
    let ncols = 79
    "
    " Set the text that goes in-between the separators
    if a:words != ''
        let text = ' '.a:words.' '
    elseif expand('<cword>') != ''
        let text = ' '.expand('<cword>').' '
    else
        let text = ''
    endif

    " We start at the current cursor column, divide the rule into two
    " parts and fit the text in-between
    let cstart = col('.')
    let width = ncols - cstart
    let sepwidth = (width - strlen(text) - strlen(prefix)) / 2

    " Build the header line
    let header =
        \ repeat(' ', cstart-1)
        \ .prefix
        \ .repeat(fillchar, sepwidth)
        \ .text

    " Because of odd column numbers, this might not be the same width as the
    " fill before the header text. This ensures that we always hit the desired
    " total width
    let fill_after = repeat(fillchar, ncols - strlen(header))

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), header.fill_after)
    call cursor(line('.'), col('$'))
endfunction

command! -nargs=? Center call s:center(<q-args>)
command! -nargs=? Header call s:header(<q-args>)

"}}}


" -------------------------------- Defaults ----------------------------------{{{

if !has('nvim')
    silent source $VIMRUNTIME/defaults.vim
    runtime ftplugin/man.vim
endif

"}}}


" --------------------------------- Behavior ---------------------------------{{{

set modeline
set hidden
set updatetime=100
set wildmode=longest:full,full
set path=,,.

"}}}


" --------------------------------- Editing ----------------------------------{{{

" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab

" Set 'formatoptions'  to break comment  lines but not other  lines, and
" insert the comment leader when hitting <CR> or using "o".
set formatoptions-=t
set formatoptions+=croql

" Use 'par' for gq / Q formatting when it's available
if executable('par')
    set formatprg=par
endif

"}}}


" ----------------------------------- Tags -----------------------------------{{{

" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags=./tags,./tags;,tags,tags;

" I've set up a git hook that get's installed for all repositories that
" creates tags files on git actions that change the index (commits,
" checkouts, merges, etc.). This file lives in the .git/ directory.
set tags+=./.git/tags,./.git/tags;,.git/tags,.git/tags;

"}}}


" ------------------------------- Autoread -------------------------------------{{{

set autoread
augroup autoread_settings
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END

"}}}


" --------------------------------- Display ----------------------------------{{{

set number
set foldmethod=indent

set scrolloff=10
set sidescrolloff=5
set nowrap

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+

" Gracefully handle unavailable colorscheme. The desired colorscheme
" might not be installed yet. This happens after cloning and installing
" the dotfiles for the first time. Otherwise you'd have to click through
" the error messages manually.
try
    colorscheme dim
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
    colorscheme default
    set background=dark
endtry

"}}}


" ---------------------------------- Commands --------------------------------{{{
" What's the current compiler?
function! s:which_compiler()
    if exists('b:current_compiler')
        return b:current_compiler
    elseif exists('g:current_compiler')
        return g:current_compiler
    else
        return 'NONE'
endfunction
command! WhichCompiler echo s:which_compiler()

function! s:describe_compiler()
    if exists('g:current_compiler')
        let gcompiler = g:current_compiler
    else
        let gcompiler = 'NONE'
    endif
    if exists('b:current_compiler')
        let bcompiler = b:current_compiler
    else
        let bcompiler = 'NONE'
    endif

    echo "Compiler: "
    echo "\tGlobal: ".gcompiler
    echo "\tLocal: ".bcompiler
    verbose set mp?
    verbose set ef?
endfunction
command! DescribeCompiler call s:describe_compiler()
"}}}


" --------------------------------- Mappings ---------------------------------{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'

" Mapping CTRL-SPACE
" I use <C-Space> to run makers (make, dispatch, neomake).
" Mapping <C-Space> seems to be tricky (Neovim seems to do fine).
" Typing <C-v><C-Space> prints ^@, but the resulting mapping
" is listed under <Nul>. So I'm mapping <Nul> directly for now.
"
" Clear search highlighting with <CTRL-SPACE> and <SPACE>
if maparg('<Nul>', 'n') ==# ''
    nnoremap <silent> <Nul> :nohlsearch<CR>
    nnoremap <silent> <Space> :nohlsearch<CR>
endif

""" Mappings that only apply for different file types.
augroup custom_filetype_specific_commands
    autocmd!

    " <SPACE> is used for the "most commonly triggered action" for each filetype.
    " Send the top-level form to the REPL
    autocmd FileType clojure nnoremap <buffer> <space> :Eval<cr>
    " Default mapping for all other filetypes
augroup END

" <F5> is always set to make the project
nnoremap <F5> :make<cr>
nnoremap <leader><F5> :DescribeCompiler<cr>
nnoremap <leader>? :DescribeCompiler<cr>

" [ and ] mappings to navigate lists
nnoremap [a :previous<cr>
nnoremap ]a :next<cr>

nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>

nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>

nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>

nnoremap [t :tprevious<cr>
nnoremap ]t :tnext<cr>

"}}}


" --------------------------------- Plugins ----------------------------------{{{

" Personal plugins
packadd differ
packadd pomodoro

" Install minpac as an optional package if it's not already installed.
let minpac_path = has('nvim') ? '~/.config/nvim/pack/minpac/opt/minpac' : '~/.vim/pack/minpac/opt/minpac'
let minpac_source = 'https://github.com/k-takata/minpac.git'
if empty(glob(minpac_path)) | exe 'silent !git clone '.minpac_source.' '.minpac_path | endif

" Minpac is only needed when doing changes to the plugins such as updating
" or deleting.
"
" Instead the commands below add the package on demand.
if exists('*minpac#init')
    call minpac#init()
    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " |||                   |||
    " ||| Add plugins below |||
    " vvv                   vvv

    " Runners:
    " Unsure whether to use 'neomake' or tpope's 'dispatch'.
    " 'neomake' seems simpler, and I'm not yet a heavy user.
    " One compiler / maker is usually enough.
    " 'neomake' also has the nice concept of local and global makers.
    " call minpac#add('neomake/neomake')

    " REPL:
    " Tmux based REPL integration using 'tslime'
    call minpac#add('jgdavey/tslime.vim')

    " Clojure:
    " nRepl integration
    call minpac#add('bhurlow/vim-parinfer')
    call minpac#add('tpope/vim-fireplace')

    " FTPlugings:
    "call minpac#add('sheerun/vim-polyglot')
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')
endif

" Load all packages in 'start/'
packloadall

" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()


" Plugin Configuration:
let g:python_highlight_all = 1

"}}}


" ------------------------------------ REPL ------------------------------------{{{

" Send text block to tmux pane
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

"}}}


" -------------------------------- Abbreviations --------------------------------{{{

" Insert dates:
" Last modification date of the current file
iabbrev <expr> ddf strftime("%c", getftime(expand('%')))
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")

"}}}


" --------------------------------- Statusline ---------------------------------{{{
function! StatuslineErrors()
    let nqf = len(getqflist())
    let nloc = len(getloclist(0))
    if nloc || nqf
        return ' ['.nqf.'|'.nloc.'] '
    else
        return ''
    endif
endfunction

function! StatuslineArgs()
    let nargs = argc()
    let idx = argidx() + 1
    if nargs > 1
        return ' ['.idx.'/'.nargs.'] '
    else
        return ''
    endif
endfunction

function! StatuslineCompiler()
    let compiler = s:which_compiler()
    if compiler == 'NONE'
        return ''
    else
        return ' ['.compiler.'] '
    endif
endfunction

function! MyStatusline()
    let BAR         = '%*'
    let OPT         = '%#Question#'
    let SEP         = '%='

    let file        = '%y %f '
    let args        = '%{StatuslineArgs()} '
    let tags        = '%m %h %w %q '
    let compiler    = '%{StatuslineCompiler()}'
    let errors      = '%{StatuslineErrors()}'
    let position    = ' ☰ %l:%c | %p%% '

    return file.OPT.args.tags.SEP.errors.compiler.BAR.position
endfunction

set laststatus=2
set statusline=%!MyStatusline()
"}}}

" ------------------------------ Filetype Options ------------------------------{{{

augroup filetype_specific_options
    autocmd!
    autocmd BufNewFile,BufRead *.pyi set ft=python
    autocmd FileType man setlocal nolist
augroup END

"}}}

" vim:foldmethod=marker textwidth=0
