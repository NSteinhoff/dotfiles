augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <BS>
augroup END

""" Basics
    " Move over visual lines unless a count is given
    nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
    if maparg('<C-P>', 'n') == ''
        nnoremap <C-P> :find <C-Z>
    endif

    " Move over sections
    map [[ ?{<CR>w99[{
    map ][ /}<CR>b99]}
    map ]] j0[[%/{<CR>
    map [] k$][%?}<CR>

    " Switch to alternative buffer
    nnoremap <BS> <C-^>

    " Make
    nnoremap `<CR> :make<CR>
    nnoremap <F5> :make!<CR>
    nnoremap <leader><leader> :make!<CR>

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


""" Scrolling
    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 3<C-E>
    nnoremap <C-K> 3<C-Y>
    nnoremap <C-H> 3zh
    nnoremap <C-L> 3zl

""" Command line
    cnoremap <C-A> <Home>
    cnoremap <C-E> <End>


""" Comment / Uncomment
    " Mnemonic:
    "   " -> Vim's comment string
    "   <CR> -> line
    "   => 'comment line'
    nnoremap <silent> "<CR> :ToggleCommented<CR>
    vnoremap <silent> "<CR> :ToggleCommented<CR>


"""  Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    nnoremap <silent> <> :Format<CR>


"""  Clear search highlights
    nnoremap <silent> <ESC> :nohlsearch<CR>


"""  Errors: Quickfix / Location Lists
    " Mnemonic:
    "   (Q)uickfix
    nnoremap <silent> Q :clist<CR>

"""  Preview
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
    nnoremap <leader><SPACE> <C-W>z

    " Complete tag
    inoremap <C-SPACE> <C-X><C-]>

""" Cycling Errors
    nnoremap [G :llist<CR>
    nnoremap [g :lprevious<CR>
    nnoremap ]g :lnext<CR>


""" Toggle Settings
    " Exetending 'vim-unimpaired'
    " T: s(T)atusbar
    nnoremap <silent> [o_ :set ls=2<CR>
    nnoremap <silent> ]o_ :set ls=0<CR>
    nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')


""" <LEADER>
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
    " Search for <cword> or selection in current buffer
    nnoremap <silent> <leader>* :execute 'Vimgrep '.expand('<cword>')<CR>
    vnoremap <silent> <leader>* y:execute 'Vimgrep '.shellescape(@")<CR>
    " Grep for <cword or selection> in files with the same extension as the current buffer
    nnoremap <silent> <leader>gg :execute 'grep -r --include=*.'.expand('%:e').' '.expand('<cword>').' .'<CR>
    vnoremap <silent> <leader>gg y:execute 'grep -r --include=*.'.expand('%:e').' '.shellescape(@").' .'<CR>
    " Grep for <cword or selection> in all files
    nnoremap <silent> <leader>gG :execute 'grep -r '.expand('<cword>').' .'<CR>
    vnoremap <silent> <leader>gG y:execute 'grep -r '.shellescape(@").' .'<CR>
    " RipGrep for <cword or selection> in all files
    nnoremap <silent> <leader>rg :execute 'RipGrep '.expand('<cword>')<CR>
    vnoremap <silent> <leader>rg y:execute 'RipGrep '.shellescape(@")<CR>

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

    " (c): Changes / Diffing
    nnoremap cs :ChangeSplit<CR>
    nnoremap cp :ChangePatch<CR>
