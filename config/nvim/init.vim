source ~/.vimrc


" --------------------------------- UI -----------------------------------{{{
set laststatus=2
set number
set inccommand=split
set scrolloff=3
set sidescrolloff=3
set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
"}}}


" --------------------------------- Editing -----------------------------------{{{
set nowrap
set linebreak
set breakindent
let &showbreak = '... '
set showmatch
" }}}


" -------------------------------- Searching ----------------------------------{{{
set wildignore+=*/target/*

if executable('rg')
    command! -nargs=+ Rg cexpr system('rg --vimgrep --smart-case '.<q-args>)
    nnoremap <leader>rg :execute 'Rg '.expand('<cword>')<CR>
endif
if executable('ag')
    command! -nargs=+ Ag cexpr system('ag --vimgrep --smart-case '.<q-args>)
    nnoremap <leader>ag :execute 'Ag '.expand('<cword>')<CR>
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
    " FileType specific tags
    " autocmd FileType scala,rust,python if exists('&tagfunc') | set tagfunc=myfuncs#fttags  | endif
augroup END


"}}}


" ---------------------------------- Commands --------------------------------{{{
" Format range
function! Format(start, end)
    if &formatprg == ""
        echo "abort: 'formatprg' unset"
        return
    endif
    let l:view = winsaveview()
    execute "normal! ".a:start."Ggq".a:end."G"
    if v:shell_error > 0
        silent undo
        redraw
        echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    endif
    call winrestview(l:view)
endfunction
command! -bar -range=% Format call Format(<line1>, <line2>)

function! Make(bang)
    execute 'silent make'.a:bang
    cwindow
endfunction
command! -bar -bang Make call Make("<bang>")

" Align text
" Using 'sed' and 'column' external tools
command! -range Align <line1>,<line2>!sed 's/\s\+/~/g' | column -s'~' -t
command! -nargs=1 -range AlignOn <line1>,<line2>!sed 's/\s\+<args>/ ~<args>/g' | column -s'~' -t

" Headers
command! -nargs=? Section call myfuncs#section(<q-args>)
command! -nargs=? Header call myfuncs#header(<q-args>)

" Commenting lines
command! -range ToggleCommented <line1>,<line2> call myfuncs#toggle_commented()

" Compiler
command! Compiler call compiler#describe()
command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)

" Edit my filetype/syntax plugin files for current filetype.
command! -nargs=? -complete=compiler EditCompiler
            \ exe 'keepj edit $HOME/.config/nvim/after/compiler/' . (empty(<q-args>) ? compiler#which() : <q-args>) . '.vim'

command! -nargs=? -complete=filetype EditFiletype
            \ exe 'keepj edit $HOME/.config/nvim/after/ftplugin/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'

command! -nargs=? -complete=filetype EditSyntax
            \ exe 'keepj edit $HOME/.config/nvim/after/syntax/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'

command! -nargs=? -complete=color EditColorscheme
            \ execute 'keepj edit $HOME/.config/nvim/after/colors/' . (empty(<q-args>) ? g:colors_name : <q-args>) . '.vim'

" Run lines as shell commands
command! -range Run echo join(map(getline(<line1>, <line2>), { k, v -> trim(system(v)) }), "\n")

" ---------------------------------- Git ------------------------------------
function! ButWhy(bang, start, end)
    let oneline = a:bang != '!' ? ' --no-patch --oneline' : ''
    echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " log -L " . a:start . "," . a:end . ":" . expand('%:t') . oneline), "\n")
endfunction
command! -range -bang ButWhy call ButWhy(<q-bang>, <q-line1>, <q-line2>)
command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")
command! -bar -nargs=+ Jump cexpr system('git jump ' . expand(<q-args>))
"}}}


" ------------------------------- Autocommands --------------------------------{{{
augroup user-settings
    autocmd!
    " Source this file on write
    autocmd BufWritePost .vimrc,vimrc,init.vim source <sfile>
augroup END
augroup user-errorfiles
    autocmd!
    " Set the compiler to the root of an errorfile
    " sbt.err -> :compiler sbt
    " flake8.err -> :compiler flake8
    autocmd BufReadPost *.err execute "compiler " . expand("<afile>:r") | cgetbuffer
augroup END
augroup user-automake
    autocmd!
    autocmd BufWritePre * if exists('b:format_on_write') && b:format_on_write | Format | endif
    autocmd BufWritePost * if exists('b:make_on_write') && b:make_on_write | Make | endif
augroup END
" }}}


" --------------------------------- Mappings ---------------------------------{{{
" Free:
" <BACKSPACE>
" <> (formatting?)
" >< (formatting?)
" \"\" (commenting?)
"
" <C-J> (forward, down)
" <C-K> (back, up, keyword)
" <C-L> (forward, right)
" <C-H> (forward, left, home)
"
" z<SPACE> (folding?, scrolling?)

" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Scrolling the window with CTRL-HJKL
nnoremap <C-J> 3<C-E>
nnoremap <C-K> 3<C-Y>
nnoremap <C-H> 3zh
nnoremap <C-L> 3zl

" Window resizing with the arrow keys
map  <left>   5<C-W><  "  decrease  width
map  <right>  5<C-W>>  "  increase  width
map  <up>     5<C-W>+  "  increase  height
map  <down>   5<C-W>-  "  decrease  height

" Faster scrolling
nnoremap <C-E> 3<C-E>
nnoremap <C-Y> 3<C-Y>

nnoremap "" :ToggleCommented<CR>
vnoremap "" :ToggleCommented<CR>

" --- Clear search highlights ---
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<CR>
endif
if maparg('<SPACE>', 'n') ==# ''
    nnoremap <silent> <SPACE> :nohlsearch<CR>
endif

" --- :make ---
" m<SPACE> and <F5> make the project
nnoremap <F5> :make!<CR>
nnoremap m<SPACE> :Make<CR>

" --- Errors: Quickfix / Location Lists ---
" Display
nnoremap Q :clist<CR>
nnoremap <C-Q> :cwindow<CR>

" --- Preview ---
" Preview word under cursor
nnoremap <C-SPACE> <C-W>}
" Preview selection
vnoremap <C-SPACE> y:ptag<C-R>"<CR>
" Close the preview window
nnoremap <C-W><SPACE> <C-W>z
nnoremap <C-W><C-SPACE> <C-W>z
" Complete tag
inoremap <C-SPACE> <C-X><C-]>


" --- Cycling ---
" Quickly cycling a list
" (currently Buffers)
nnoremap <C-P> :bprevious<CR>
nnoremap <C-N> :bnext<CR>

" --- Toggle Settings ---
" Exetending 'vim-unimpaired'
" T: s(T)atusbar
nnoremap <silent> [o_ :set ls=2<CR>
nnoremap <silent> ]o_ :set ls=0<CR>
nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')

" --------------------------------- <LEADER> ----------------------------------
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
set wildcharm=<C-Z>

" Quick Keys
vnoremap <leader>= :Align<CR>
nnoremap <leader>! :!%:p<CR>
nnoremap <leader>x :Run<CR>
vnoremap <leader>x :Run<CR>
nnoremap <leader>m :Make<CR>
nnoremap <leader>f :Format<CR>

" Switch buffers
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>

" Edit Settings files
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <leader>ef :EditFiletype<CR>
nnoremap <leader>ec :EditCompiler<CR>
nnoremap <leader>es :EditSyntax<CR>
nnoremap <leader>eo :EditColorscheme<CR>

" File Explorer
nnoremap <leader>E :Explore<CR>
nnoremap <leader>V :Vexplore<CR>
nnoremap <leader>T :Texplore<CR>

" ---------------------------------- Unused -----------------------------------
" Hard Mode
" nnoremap h <NOP>
" nnoremap j <NOP>
" nnoremap k <NOP>
" nnoremap l <NOP>
" vnoremap h <NOP>
" vnoremap j <NOP>
" vnoremap k <NOP>
" vnoremap l <NOP>
" nnoremap <BS> <NOP>
" vnoremap <BS> <NOP>
" inoremap <BS> <NOP>

" Navigate Windows
" nnoremap <C-J> <C-W>j
" nnoremap <C-K> <C-W>k
" nnoremap <C-H> <C-W>h
" nnoremap <C-L> <C-W>l
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
packadd! statusline
packadd! differ
packadd! pomodoro

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
    " Mappings
    call minpac#add('tpope/vim-unimpaired')

    " External Documentation Lookup:
    call minpac#add('romainl/vim-devdocs')

    " FTPlugings:
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')
    call minpac#add('vim-scripts/bats.vim')
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

"}}}


" ------------------------------ Abbreviations -------------------------------- {{{
" Last modification date of the current file
iabbrev <expr> ddf strftime("%c", getftime(expand('%')))
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")
"}}}


" vim:foldmethod=marker textwidth=0
