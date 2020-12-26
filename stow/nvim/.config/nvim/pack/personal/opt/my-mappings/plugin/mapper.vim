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
    " Explicitly map the <leader> key. Otherwise some plugins use their own default.
    let mapleader = '\'
    let maplocalleader = '\'
    set wildcharm=<C-Z>


""" Basics / Improving standard mappings
    " Make Y behave like C and D
    nnoremap Y y$

    " Run 'q' macro
    nnoremap Q @q

    " Move over visual lines unless a count is given
    nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

    " Move over sections
    map [[ ?{<CR>w99[{
    map ][ /}<CR>b99]}
    map ]] j0[[%/{<CR>
    map [] k$][%?}<CR>

    " Window resizing with the arrow keys
    map  <LEFT>   5<C-W><
    map  <RIGHt>  5<C-W>>
    map  <UP>     5<C-W>+
    map  <DOWN>   5<C-W>-


""" Scrolling
    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 5<C-E>
    nnoremap <C-K> 5<C-Y>
    nnoremap <C-H> 5zh
    nnoremap <C-L> 5zl


""" Search and replace
    nnoremap gs :%s/
    xnoremap gs :s/
    nnoremap <expr> gS ':%s/\V'.expand('<cword>').'/'
    vnoremap gS y:%s/\V<C-R>=escape(@", '\/')<CR><BS>/


""" Windows
    nnoremap <silent> <C-W>o :diffoff!<BAR>only<CR>
    nnoremap <silent> <C-W><C-O> :diffoff!<BAR>only<CR>

"""  Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    if empty(maparg('<>', 'n'))
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
    nnoremap <silent> <expr> <leader>L exists(':Loclist') ? ':Loclist<CR>' : ':lwindow<CR>'


""" Preview / Hover
    " Preview information about a symbol.
    " This is replaced with 'Hover' by LSP.
    if empty(maparg('<SPACE>', 'n'))
        nnoremap <expr> <silent> <SPACE> ':psearch '.expand('<cword>').'<CR>'
    endif
    if empty(maparg('<SPACE>', 'v'))
        vnoremap <expr> <silent> <SPACE> 'y:psearch <C-R>"<CR>'
    endif

    " Preview definition
    if empty(maparg('<C-SPACE>', 'n'))
        nnoremap <C-SPACE> <C-W>}
    endif
    if empty(maparg('g<C-SPACE>', 'n'))
        nnoremap g<C-SPACE> <C-W>g}
    endif
    if empty(maparg('<C-SPACE>', 'v'))
        vnoremap <silent> <C-SPACE> y:ptag <C-R>"<CR>
    endif
    if empty(maparg('g<C-SPACE>', 'v'))
        vnoremap <silent> g<C-SPACE> y:ptselect <C-R>"<CR>
    endif

    " Close the preview window
    nnoremap <leader><SPACE> <C-W>z


""" Completion
    " <C-Space> is used for smart completion.
    " By default it completes tags. This could be remapped to omni-completion
    " or LSP completion for supported languages or filetypes.
    inoremap <C-SPACE> <C-X><C-]>
    inoremap <expr> <Tab>   pumvisible() ? '<C-N>' : '<TAB>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-P>' : '<S-TAB>'


""" Quickopen
    nnoremap <expr> <C-P> exists(':TelescopeFiles') ? '<CMD>TelescopeFiles<CR>'
                \ : exists(':FindFiles') ? '<cmd>FindFiles<CR>i'
                \ : exists(':Find') ? ':Find <C-Z>'
                \ : ':find **<C-Z>'


""" Running builds with `<key>
    nnoremap `<leader> <cmd>make<CR>
    nnoremap `<CR> <cmd>vert TMake<CR>
    nnoremap `<BS> <cmd>TMake!<CR>

    " List, load, read errorfile contents
    nnoremap g> <cmd>execute '!cat '.&errorfile<CR>
    nnoremap <expr> g! &ft == 'qf' ? '<cmd>cclose<CR>' : '<cmd>Cfile<CR>'
    nnoremap g? <cmd>execute 'tab view '.&errorfile<CR>


""" Searching
    " Local search
    nnoremap <silent> <leader>* :execute 'Vimgrep '.expand('<cword>')<CR>
    vnoremap <silent> <leader>* y:execute 'Vimgrep '.shellescape(@")<CR>

    " Live grep
    nnoremap <expr> <c-g> exists(':TelescopeGrep')
                \? '<cmd>TelescopeGrep<CR>'
                \: '<cmd>LiveGrep<CR>i'
    nnoremap <silent> <expr> <leader>g ':LiveGrep '.expand('<cword>').'<CR>'
    vnoremap <silent> <expr> <leader>g 'y:LiveGrep <C-R>"<CR>'


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
    nnoremap <leader>o :Oldfiles <C-Z>

    " (b)uffers
    nnoremap <leader>b :buffer <C-Z>
    nnoremap <leader>s :vert sbuffer <C-Z>
    nnoremap <leader>t :tab sbuffer <C-Z>
    nnoremap <leader>d :Bdelete<CR>
    nnoremap <leader>O :BufOnly<CR>

    " Explore
    nnoremap <leader>E :Explore<CR>
    nnoremap <leader>V :Vexplore<CR>
    nnoremap <leader>T :Texplore<CR>


""" (c): Changes / Diffing
    nnoremap cs :ChangeSplit<CR>
    nnoremap cS :ChangeSplit <C-Z>
    nnoremap cp :ChangePatch<CR>
    nnoremap cP :ChangePatch <C-Z>


""" Potential Ad-hoc mappings
    if empty(maparg('<leader><leader>', 'n'))
        nnoremap <leader><leader> :nnoremap <leader><leader> 
    endif
