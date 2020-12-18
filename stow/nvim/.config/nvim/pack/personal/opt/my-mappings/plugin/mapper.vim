augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd CmdwinEnter * nnoremap <buffer> <SPACE> <SPACE>
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <BS>
    autocmd BufReadPost quickfix nnoremap <buffer> <SPACE> <SPACE>
augroup END


" Return the text selected by the operator motion
"
" This function can be called in operator functions to get the
" selected text.
"
" :map-operator
function s:opselect(type)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@
    try
        if a:type ==# 'v' || a:type ==# 'V'
            silent execute "normal! gvy"
        elseif a:type == 'line'
            silent execute "normal! '[V']y"
        else
            silent execute "normal! `[v`]y"
        endif
        let text = @@
        return text
    finally
        let @@ = reg_save
    endtry
endfunction


""" <LEADER> / Wildchar
    " Explicitly map the <Leader> key. Otherwise some plugins use their own default.
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


""" Windows
    " Quickly close a window
    nnoremap Q :close<CR>
    " Close all other buffers
    nnoremap <C-W>O :BufOnly<CR>


""" Comment / Uncomment
    " Mnemonic:
    "   "       -> Vim's comment string
    "   <CR>    -> line
    "   "<CR>   => 'comment line'
    noremap <silent> "<CR> :ToggleCommented<CR>


"""  Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    if maparg('<>', 'n') == ''
        nnoremap <silent> <> :Format<CR>
    endif


"""  Clear search highlights
    nnoremap <silent> <ESC> :nohlsearch<CR>


"""  Errors: Quickfix / Location Lists
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    "
    " <key>                     Mnemonic key for the list
    " <Leader><key>             Peek at list
    " <Leader><KEY>             Go to list and pick entry
    "
    " Quickfix list: global error
    " Mnemonic: (Q)uickfix
    nnoremap <silent> <Leader>q :clist<CR>
    nnoremap <silent> <expr> <Leader>Q exists(':Quickfix') ? ':Quickfix<CR>' : ':cwindow<CR>'

    " Location list: local errors
    " Mnemoic: (L)ocation
    nnoremap <silent> <Leader>l :llist<CR>
    nnoremap <silent> <expr> <Leader>L exists(':Loclist') ? ':Loclist<CR>' : ':lwindow<CR>'


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
    nnoremap <Leader><SPACE> <C-W>z


""" Completion
    " <C-Space> is used for smart completion.
    " By default it completes tags. This could be remapped to omni-completion
    " or LSP completion for supported languages or filetypes.
    if maparg('<C-SPACE>', 'i') == ''
        inoremap <C-SPACE> <C-X><C-]>
    endif
    inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'


""" Quickopen
    " nnoremap <C-P> :Find <C-Z>
    nnoremap <C-P> <cmd>FindFiles<CR>i


""" Running builds
    nnoremap `<Leader> <cmd>make<CR>
    nnoremap `<CR> <cmd>vert TMake<CR>
    nnoremap `<BS> <cmd>TMake!<CR>

    " List, load, read errorfile contents
    nnoremap g> <cmd>execute '!cat '.&errorfile<CR>
    nnoremap <expr> g! &ft == 'qf' ? '<cmd>cclose<CR>' : '<cmd>Cfile<CR>'
    nnoremap g? <cmd>execute 'tab view '.&errorfile<CR>


""" Searching
    " Local search
    nnoremap <silent> <Leader>* :execute 'Vimgrep '.expand('<cword>')<CR>
    vnoremap <silent> <Leader>* y:execute 'Vimgrep '.shellescape(@")<CR>

    " Live grep
    nnoremap <c-g> <cmd>LiveGrep<CR>i
    nnoremap <silent> <expr> <Leader>g ':LiveGrep '.expand('<cword>').'<CR>'
    vnoremap <silent> <expr> <Leader>g 'y:LiveGrep <c-r>"<CR>'


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
    vnoremap <Leader>= :Align<CR>
    nnoremap <Leader>! :!%:p<CR>
    nnoremap <Leader>x :Run<CR>
    vnoremap <Leader>x :Run<CR>
    nnoremap <Leader>X :%Run<CR>
    nnoremap <expr> <Leader>o exists(':Oldfiles') ? ':Oldfiles <C-Z>' : ':browse oldfiles<CR>'

    " Switch buffers
    nnoremap <Leader>b :buffer <C-Z>
    if exists(':Buffers') | nnoremap <leader>B <cmd>Buffers<CR> | endif
    nnoremap <Leader>v :vert sbuffer <C-Z>
    nnoremap <Leader>t :tab sbuffer <C-Z>

    " Edit Settings files
    nnoremap <Leader>ee :edit $MYVIMRC<CR>
    nnoremap <Leader>ef :EditFtplugin<CR>
    nnoremap <Leader>ed :EditFtdetect<CR>
    nnoremap <Leader>ec :EditCompiler<CR>
    nnoremap <Leader>es :EditSyntax<CR>
    nnoremap <Leader>ei :EditIndent<CR>
    nnoremap <Leader>eo :EditColorscheme<CR>

    " File Explorer
    nnoremap <Leader>E :Explore<CR>
    nnoremap <Leader>V :Vexplore<CR>
    nnoremap <Leader>T :Texplore<CR>

    " (c): Changes / Diffing
    nnoremap cs :ChangeSplit<CR>
    nnoremap cS :ChangeSplit <C-Z>
    nnoremap cp :ChangePatch<CR>
    nnoremap cP :ChangePatch <C-Z>


""" Potential Ad-hoc mappings
    if maparg('<Leader><Leader>', 'n') == ''
        nnoremap <Leader><Leader> :nnoremap <leader><leader> 
    endif
