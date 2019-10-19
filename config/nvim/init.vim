"--------------------------------- Helpers ----------------------------------{{{
augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost init.vim source % "
augroup END

function! s:header(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=')
    let fillchar = '-'
    let ncols = 80

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

" Create an 80 column wide header starting at the current cursor position.
" The header text can be passed as an arguments or left blank to use the word
" under the cursor. With no argument or word under cursor, will simply draw
" the separator line.
function! s:center(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=')
    let fillchar = '-'
    let ncols = 80

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
    let sepwidth = (width - strlen(text)) / 2

    " Build the header line
    let header =
        \ repeat(' ', cstart-1)
        \ .prefix
        \ .repeat(fillchar, sepwidth)
        \ .text
        \ .repeat(fillchar, sepwidth)

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), header)
    call cursor(line('.'), col('$'))
endfunction

command! -nargs=? Center call s:center(<q-args>)
command! -nargs=? Header call s:header(<q-args>)

"}}}


"--------------------------------- Behavior ---------------------------------{{{

set hidden
set updatetime=100
set wildmode=longest:full,full
set path=,,.

"}}}


"--------------------------------- Editing ----------------------------------{{{

" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
set formatoptions-=t
set formatoptions+=croql

"}}}


"----------------------------------- Tags -----------------------------------{{{

" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags=./tags,./tags;,tags,tags;

" I've set up a git hook that get's installed for all repositories that creates
" tags files on git actions that change the index (commits, checkouts, merges, etc.).
" This file lives in the .git/ directory.
set tags+=./.git/tags,./.git/tags;,.git/tags,.git/tags;

"}}}


"------------------------------- Autoread -------------------------------------{{{

set autoread
augroup autoread_settings
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END

"}}}


"--------------------------------- Display ----------------------------------{{{

set number
set inccommand=nosplit

set foldmethod=indent

set scrolloff=10
set sidescrolloff=5
set nowrap

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+

" Gracefully handle unavailable colorscheme.
" The desired colorscheme might not be installed yet. This happens
" after cloning and installing the dotfiles for the first time.
" Otherwise you'd have to click through the error messages manually.
try
    colorscheme minimal
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
    colorscheme default
    set background=dark
endtry

"}}}


"-------------------------------- Providers ---------------------------------{{{

let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'

"}}}


"---------------------------------- Commands --------------------------------{{{

"}}}


"--------------------------------- Mappings ---------------------------------{{{

" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'

" Clear search highlighting with <ESC>
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
endif

""" Mappings that only apply for different file types.
augroup custom_filetype_specific_commands
    autocmd!

    " <SPACE> is used for the "most commonly triggered action" for each filetype.
    " Send the top-level form to the REPL
    autocmd FileType clojure nnoremap <buffer> <space> :Eval<cr>
    " Default mapping for all other filetypes
    autocmd FileType * if maparg('<space>', 'n') ==# '' | nnoremap <buffer> <space> :echo 'SPACE!'<cr> | endif

augroup END

" <F5> is always set to make the project
nnoremap <F5> :make<cr>

" We might have Neomake installed
if exists("*neomake#Make")
    nnoremap <C-space> :Neomake!<cr>
endif

" <C-Space> is intended for quick tasks and might be mapped to an asynchronous
" maker such as Neomake or Dispatch.
" If it's not already set, fall back to make
if maparg('<C-space>', 'n') ==# ''
    nnoremap <C-space> :make<cr>
endif

"}}}


"--------------------------------- Plugins ----------------------------------{{{

" Personal plugins
packadd pomodoro

" Install minpac as an optional package if it's not already installed.
if empty(glob('~/.config/nvim/pack/minpac/opt/minpac'))
    silent !git clone https://github.com/k-takata/minpac.git
        \ ~/.config/nvim/pack/minpac/opt/minpac
endif

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

    " Colorschemes:
    " Try to stick to the defaults
    " call minpac#add('dikiaap/minimalist')
    " call minpac#add('jdsimcoe/abstract.vim')
    " call minpac#add('sainnhe/gruvbox-material')
    " call minpac#add('chriskempson/base16-vim')

    " FTPlugings:
    " call minpac#add('sheerun/vim-polyglot')
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


"------------------------------------ REPL ------------------------------------{{{

" Send text block to tmux pane
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

"}}}


"-------------------------------- Abbreviations --------------------------------{{{

" Insert dates:
" Last modification date of the current file
iabbrev <expr> ddf strftime("%c", getftime(expand('%')))
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")

"}}}

" vim:foldmethod=marker textwidth=0
