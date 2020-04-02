source ~/.vimrc

augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost .vimrc,vimrc,init.vim source % "
augroup END


" --------------------------------- Editing -----------------------------------{{{
set inccommand=split

"}}}


" -------------------------------- Searching ----------------------------------{{{
set wildignore+=*/target/*

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
elseif executable('ag')
    set grepprg=ag\ --vimgrep\ --smart-case
endif
" }}}


" ---------------------------------- Colors -----------------------------------{{{

" Gracefully handle unavailable colorscheme. The desired colorscheme
" might not be installed yet. This happens after cloning and installing
" the dotfiles for the first time. Otherwise you'd have to click through
" the error messages manually.
try
    colorscheme minimal
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
    colorscheme default
    set background=dark
endtry

"}}}


" ------------------------------- Autoread -------------------------------------{{{

set autoread
augroup autoread_settings
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END

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
augroup tags
    autocmd!
    autocmd FileType scala,rust,python set tagfunc=myfuncs#fttags  " FileType specific tags
augroup END


"}}}


" ---------------------------------- Commands --------------------------------{{{
" Align text
" Using 'sed' and 'column' external tools
command! -range Align <line1>,<line2>!sed 's/\s\+/~/g' | column -s'~' -t
command! -nargs=1 -range AlignOn <line1>,<line2>!sed 's/\s\+<args>/ ~<args>/g' | column -s'~' -t

" Headers
command! -nargs=? Center call myfuncs#center(<q-args>)
command! -nargs=? Header call myfuncs#header(<q-args>)

command! WhichCompiler echo compiler#which()
command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)
command! DescribeCompiler call compiler#describe()

" Edit my filetype/syntax plugin files for current filetype.
command! -nargs=? -complete=compiler CompilerPlugin
            \ exe 'keepj tabedit $HOME/.vim/after/compiler/' . (empty(<q-args>) ? compiler#which() : <q-args>) . '.vim'

command! -nargs=? -complete=filetype FiletypePlugin
            \ exe 'keepj tabedit $HOME/.vim/after/ftplugin/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'

command! -nargs=? -complete=filetype SyntaxPlugin
            \ exe 'keepj tabedit $HOME/.vim/after/syntax/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'
"}}}


" --------------------------------- Mappings ---------------------------------{{{

" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Navigate Windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
set wildcharm=<C-Z>

" Window resizing with the arrow keys
map  <right>  10<c-w>>  "  increase  width
map  <left>   10<c-w><  "  decrease  width
map  <up>     10<c-w>+  "  increase  height
map  <down>   10<c-w>-  "  decrease  height

" Faster scrolling
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>

" Clear search highlights
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<CR>
endif
if maparg('<SPACE>', 'n') ==# ''
    nnoremap <silent> <SPACE> :nohlsearch<CR>
endif

" <F5> is always set to make the project
nnoremap <F5> :make!<cr>

" Display Quickfix items
nnoremap Q :clist<cr>

" ------------------------ Cycling lists with ] and [ -------------------------
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

nnoremap [p :ptprevious<cr>
nnoremap ]p :ptnext<cr>

nnoremap [u :earlier<cr>
nnoremap ]u :later<cr>

" --------------------------------- <LEADER> ----------------------------------
"
" SpaceVim inspired mappings without the baggage
" ===
"
" - Mappings for the most used commands
" - Don't replace builtin mappings except for the preview tags (those are terrible)
"

" Compiler
nnoremap <leader><leader> :make!<cr>

" Quick Keys [bdefqstv]
vnoremap <leader>a :Align<cr>

nnoremap <leader>x :close<cr>
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>w :bwipe<cr>
nnoremap <leader>e :edit **/*
nnoremap <leader>f :find **/*
nnoremap <leader>s :vsplit **/*
nnoremap <leader>t :tab sbuffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>

" Explore
nnoremap <leader>E :Explore<cr>
nnoremap <leader>V :Vexplore<cr>
nnoremap <leader>T :Texplore<cr>

" (?) Help / Info
nnoremap <leader>?c :DescribeCompiler<cr>

" (l) Lists
nnoremap <leader>la :args<cr>
nnoremap <leader>lb :ls<cr>
nnoremap <leader>lc :changes<cr>
nnoremap <leader>lj :jumps<cr>
nnoremap <leader>ll :llist<cr>
nnoremap <leader>lm :marks<cr>
nnoremap <leader>lq :clist<cr>
nnoremap <leader>lr :registers<cr>
nnoremap <leader>lt :tags<cr>
nnoremap <leader>lu :undolist<cr>

" (n) Note taking
nnoremap <leader>nn :tabedit $HOME/Dropbox/Documents/Notes/notes.md<cr>
nnoremap <leader>nj :tabedit $HOME/Dropbox/Documents/Notes/journal.md<cr>
nnoremap <leader>nt :tabedit $HOME/Dropbox/Documents/Notes/todo.taskpaper<cr>

" (c) Configuration
nnoremap <leader>cv :tabedit $MYVIMRC<cr>
nnoremap <leader>ca :tabedit ~/.vim/any.vim<cr>
nnoremap <leader>cf :FiletypePlugin<cr>
nnoremap <leader>cs :SyntaxPlugin<cr>
nnoremap <leader>cc :CompilerPlugin<cr>
nnoremap <leader>co :execute 'tabedit $HOME/.vim/after/colors/'.g:colors_name.'.vim'<cr>
nnoremap <leader>ct :tabedit ~/.config/alacritty/alacritty.yml<cr>

" (p) Preview window
nnoremap <leader>pc :pclose<cr>
nnoremap <leader>pe :pedit **/*
nnoremap <leader>pl :ptselect<cr>
nnoremap <leader>pp :exe 'silent! ptjump '.expand('<cword>')<cr>
nnoremap <leader>ps :exe 'silent! psearch '.expand('<cword>')<cr>
nnoremap <leader>pt :exe 'silent! ptag '.expand('<cword>')<cr>

" (d) Differ
nnoremap <leader>dr :Dremote<cr>
nnoremap <leader>dR :Dremote!<cr>
nnoremap <leader>du :Dupdate<cr>
nnoremap <leader>dt :Dthis<cr>
nnoremap <leader>dp :Dpatch<cr>
nnoremap <leader>dP :Dpatch!<cr>
nnoremap <leader>ds :Dstatus<cr>
nnoremap <leader>dc :Dcomment<cr>
nnoremap <leader>dC :DshowComments<cr>
nnoremap <leader>]d :Dnext<cr>
nnoremap <leader>[d :Dprevious<cr>

"}}}


" ---------------------------------- Netrw ------------------------------------{{{
" Hide files that are ignored by git
let  g:netrw_list_hide  =  netrw_gitignore#Hide()
let  g:netrw_preview    =  1
let  g:netrw_altv       =  1
let  g:netrw_alto       =  0
"}}}


" --------------------------------- Plugins ----------------------------------{{{

" Personal plugins
packadd! abbreviations
packadd! providers
packadd! statusline
packadd! pomodoro
packadd! differ

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

    " File Exlorer:
    " call minpac#add('preservim/nerdtree')

    " REPL:
    " Tmux based REPL integration using 'tslime'
    call minpac#add('jgdavey/tslime.vim')

    " Clojure:
    " nRepl integration
    call minpac#add('bhurlow/vim-parinfer')
    call minpac#add('tpope/vim-fireplace')

    " FTPlugings:
    " call minpac#add('sheerun/vim-polyglot')
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')

    " Language Server:
    call minpac#add('neovim/nvim-lsp')

    " Devdocs as helpprg:
    call minpac#add('romainl/vim-devdocs')
endif

" Load all packages in 'start/'
packloadall

" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()


" Plugin Configuration:

" vim-python
let g:python_highlight_all = 1

" tslime
vmap  <C-c><C-c>  <Plug>SendSelectionToTmux
nmap  <C-c><C-c>  <Plug>NormalModeSendToTmux
nmap  <C-c>r      <Plug>SetTmuxVars

"}}}


" vim:foldmethod=marker textwidth=0
