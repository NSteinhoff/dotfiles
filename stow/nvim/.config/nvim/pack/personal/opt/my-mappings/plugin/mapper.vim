augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd CmdwinEnter * nnoremap <buffer> <SPACE> <SPACE>
    autocmd CmdwinEnter * nnoremap <buffer> <C-N> <C-N>
    autocmd CmdwinEnter * nnoremap <buffer> <C-P> <C-P>

    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <BS>
    autocmd BufReadPost quickfix nnoremap <buffer> <SPACE> <SPACE>
    autocmd BufReadPost quickfix nnoremap <buffer> <C-N> <C-N>
    autocmd BufReadPost quickfix nnoremap <buffer> <C-P> <C-P>
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
    " Clear search highlights with ESC in normal mode
    nnoremap <silent> <ESC> <CMD>nohlsearch<CR>

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

    " Switch off diff mode when closing all other windows
    nnoremap <silent> <C-W>o :diffoff!<BAR>only<CR>
    nnoremap <silent> <C-W><C-O> :diffoff!<BAR>only<CR>


""" Viewport
    " Window resizing with the arrow keys
    map  <LEFT>   5<C-W><
    map  <RIGHt>  5<C-W>>
    map  <UP>     5<C-W>+
    map  <DOWN>   5<C-W>-

    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 5<C-E>
    nnoremap <C-K> 5<C-Y>
    nnoremap <C-H> 5zh
    nnoremap <C-L> 5zl


""" Search and replace
    nnoremap gs :%s/
    xnoremap gs :s/
    nnoremap <expr> gS ':%s/\V'.expand('<cword>').'/'
    vnoremap gS y:%s/\V<C-R>=escape(@", '\/')<CR>/

    " Highlight matches
    nnoremap gm <CMD>Match<CR>
    nnoremap gM <CMD>match<CR>


"""  Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    nnoremap <silent> <> <CMD>Format<CR>


"""  Errors: Quickfix / Location Lists
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    "
    " <key>                     Mnemonic key for the list
    " <leader><key>             Peek at list
    " <leader><KEY>             Go to list and pick entry
    nnoremap <silent> <leader>q <CMD>clist<CR>
    nnoremap <silent> <leader>Q <CMD>cwindow<CR>
    nnoremap <silent> <leader>l <CMD>llist<CR>
    nnoremap <silent> <leader>L <CMD>lwindow<CR>


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
    inoremap <expr> <C-SPACE> empty(&omnifunc) ? '<C-X><C-]>' : '<C-X><C-O>'
    inoremap <expr> <Tab>   pumvisible() ? '<C-N>' : '<TAB>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-P>' : '<S-TAB>'


""" Quickopen
    nmap <leader>f <Plug>(filefinder-new)


""" Running builds with `<key>
    nmap `<leader> <Plug>(maker-sync)
    nmap `<CR> <Plug>(maker-split)
    nmap `<BS> <Plug>(maker-background)

    " List, load, read errorfile contents
    nmap g> <Plug>(maker-show-log)
    nmap g! <Plug>(maker-load-errors)
    nmap g? <Plug>(maker-edit-errors)


""" Searching
    " Local search
    nnoremap <silent> <leader>* :execute 'Vimgrep '.expand('<cword>')<CR>
    vnoremap <silent> <leader>* y:execute 'Vimgrep '.escape(@", '\/')<CR>

    " Live grep
    nmap <leader>g <Plug>(livegrep-new)
    nmap <leader>G <Plug>(livegrep-resume)
    vmap <leader>g <Plug>(livegrep-selection)


""" Toggle Settings
    " Extending 'vim-unimpaired'
    " _: Statusbar
    nnoremap <silent> [o_ :set ls=2<CR>
    nnoremap <silent> ]o_ :set ls=0<CR>
    nnoremap <expr> <silent> yo_ (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')


""" Quality of life
    " Insert file's directory in command line
    cnoremap %% %:h/<C-Z>
    cnoremap ## #:h/<C-Z>

    " Switch to alternative buffer
    nnoremap <BS> <C-^>

    " Open settings
    nnoremap <silent> <leader>; <CMD>edit $MYVIMRC<CR>

    " Quick Keys
    vnoremap <silent> <leader>= <CMD>'<,'>Align<CR>
    nnoremap <silent> <leader>! <CMD>!%:p<CR>
    nnoremap <silent> <leader>x <CMD>.Run<CR>
    vnoremap <silent> <leader>x <CMD>'<,'>Run<CR>
    nnoremap <silent> <leader>X <CMD>Run<CR>

    " Buffers
    nnoremap <leader>s :sbuffer <C-Z>
    nnoremap <leader>v :vert sbuffer <C-Z>
    nnoremap <leader>t :tab sbuffer <C-Z>
    nmap <leader>b <Plug>(buffers-edit-list)
    nmap <leader>d <Plug>(buffers-delete)
    nmap <leader>O <Plug>(buffers-only)

    " Explore
    nnoremap <silent> <leader>E <CMD>Explore<CR>
    nnoremap <silent> <leader>V <CMD>Vexplore<CR>
    nnoremap <silent> <leader>T <CMD>Texplore<CR>


""" (c): Changes / Diffing
    nnoremap <silent> cs <CMD>ChangeSplit<CR>
    nnoremap <silent> cp <CMD>ChangePatch<CR>
    nnoremap cS :ChangeSplit <C-Z>
    nnoremap cP :ChangePatch <C-Z>

""" (gb): Git Blame
    nnoremap <silent> gbb <CMD>Blame<CR>
    vnoremap <silent> gb <CMD>'<,'>Blame<CR>


""" Potential Ad-hoc mappings
    if empty(maparg('<leader><leader>', 'n'))
        nnoremap <leader><leader> :nnoremap <leader><leader> 
    endif
