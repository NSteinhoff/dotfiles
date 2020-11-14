augroup CR_BS_SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <BS>
augroup END


""" Potential Ad-hoc mappings
    if maparg('`<BS>', 'n') == ''
        nnoremap `<BS> <cmd>echo "Map me to run stuff!"<CR>
    endif
    if maparg('<Leader><Leader>', 'n') == ''
        nnoremap <Leader><Leader> <cmd>echo "Map me to something cool!"<CR>
    endif


""" <LEADER> / Wildchar
    " Explicitly map the <leader> key. Otherwise some plugins use their own default.
    let mapleader = '\'
    let maplocalleader = '\'
    set wildcharm=<C-Z>


""" Basics / Improving standard mappings
    " Move over visual lines unless a count is given
    nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

    " Move over sections
    map [[ ?{<CR>w99[{
    map ][ /}<CR>b99]}
    map ]] j0[[%/{<CR>
    map [] k$][%?}<CR>

    " Window resizing with the arrow keys
    map  <left>   5<C-W><
    map  <right>  5<C-W>>
    map  <up>     5<C-W>+
    map  <down>   5<C-W>-


""" Scrolling
    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 3<C-E>
    nnoremap <C-K> 3<C-Y>
    nnoremap <C-H> 3zh
    nnoremap <C-L> 3zl


""" Command line
    " Be more like Bash
    cnoremap <C-B> <Left>
    cnoremap <C-F> <Right>
    cnoremap <C-A> <Home>
    cnoremap <C-E> <End>

""" Quickly close a window
    nnoremap Q :close<CR>


""" Comment / Uncomment
    " Mnemonic:
    "   "       -> Vim's comment string
    "   <CR>    -> line
    "   "<CR>   => 'comment line'
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
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    "
    " <key>                     Mnemonic key for the list
    " <leader><key>             Peek at list
    " <leader><KEY>             Go to list and pick entry
    "
    " Quickfix list: global error
    " Mnemonic: (Q)uickfix
    nnoremap <silent> <leader>q :clist<CR>
    nnoremap <silent> <expr> <leader>Q exists(':Quickfix') ? ':Quickfix<CR>' : ':cwindow<CR>'

    " Location list: local errors
    " Mnemoic: (L)ocation
    nnoremap <silent> <leader>l :llist<CR>
    nnoremap <silent> <expr> <leader>L exists(':oclist') ? ':Loclist<CR>' : ':lwindow<CR>'


""" Preview / Hover
    " Preview information about a symbol.
    " This is replaced with 'Hover' by LSP.
    if maparg('<SPACE>', 'n') == ''
        nnoremap <expr> <silent> <Space> ':psearch '.expand('<cword>').'<CR>'
    endif
    if maparg('<SPACE>', 'v') == ''
        vnoremap <expr> <silent> <Space> 'y:psearch <C-R>"<CR>'
    endif

    " Preview definition
    if maparg('<C-SPACE>', 'n') == ''
        nnoremap <C-SPACE> <C-W>}
    endif
    if maparg('g<C-SPACE>', 'n') == ''
        nnoremap g<C-SPACE> <C-W>g}
    endif
    if maparg('<C-SPACE>', 'v') == ''
        vnoremap <silent> <C-SPACE> y:ptag <C-R>"<CR>
    endif
    if maparg('g<C-SPACE>', 'v') == ''
        vnoremap <silent> g<C-SPACE> y:ptselect <C-R>"<CR>
    endif

    " Close the preview window
    nnoremap <leader><SPACE> <C-W>z


""" Completion
    " <C-Space> is used for smart completion.
    " By default it completes tags. This could be remapped to omni-completion
    " or LSP completion for supported languages or filetypes.
    if maparg('<C-SPACE>', 'i') == ''
        inoremap <C-SPACE> <C-X><C-]>
    endif


""" Quickopen
    if maparg('<C-P>', 'n') == ''
        nnoremap <C-P> <cmd>find <C-Z>
    endif


""" Running builds with :make or :Dispatch (if installed)
    if maparg('`<CR>', 'n') == ''
        nnoremap `<CR> <cmd>make<CR>
    endif
    if maparg('`<SPACE>', 'n') == ''
        nnoremap `<SPACE> <cmd>make!<CR>
    endif


""" Searching
    " Local search
    nnoremap <silent> <leader>* :execute 'Vimgrep '.expand('<cword>')<CR>
    vnoremap <silent> <leader>* y:execute 'Vimgrep '.shellescape(@")<CR>

    " Global search
    " nnoremap <silent> <leader>g :execute 'GitGrep '.expand('<cword>')<CR>
    nnoremap <silent> <expr> <leader>g
        \ (finddir('.git', ';') != '' ? ':GitGrep' :
        \           (executable('rg') ? ':RipGrep' :
        \                               ':Grep'))
        \ .' '. expand('<cword>').' <CR>'
    vnoremap <silent> <expr> <leader>g
        \ 'y'.
        \ (finddir('.git', ';') != '' ? ':GitGrep' :
        \           (executable('rg') ? ':RipGrep' :
        \                               ':Grep'))
        \ .' <c-r>"<CR>'


""" Toggle Settings
    " Extending 'vim-unimpaired'
    " _: Statusbar
    nnoremap <silent> [o_ :set ls=2<CR>
    nnoremap <silent> ]o_ :set ls=0<CR>
    nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')


""" Quality of life
    " Switch to alternative buffer
    nnoremap <BS> <C-^>

    " Quick Keys
    vnoremap <leader>= :Align<CR>
    nnoremap <leader>! :!%:p<CR>
    nnoremap <leader>x :Run<CR>
    vnoremap <leader>x :Run<CR>
    nnoremap <leader>X :%Run<CR>
    nnoremap <expr> <leader>o exists(':Oldfiles') ? ':Oldfiles<CR>' : ':oldfiles<CR>'
    nnoremap <leader>O :BufOnly<CR>
    nnoremap <leader>f :Format<CR>

    " Switch buffers
    nnoremap <leader>b :buffer <C-Z>
    nnoremap <leader>v :vert sbuffer <C-Z>
    nnoremap <leader>t :tab sbuffer <C-Z>

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
