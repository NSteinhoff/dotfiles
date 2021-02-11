augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd CmdwinEnter * nnoremap <buffer> <SPACE> <SPACE>
    autocmd CmdwinEnter * nnoremap <buffer> <C-N> <C-N>
    autocmd CmdwinEnter * nnoremap <buffer> <C-P> <C-P>

    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <BS> <C-W>c
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
    vnoremap Q @q

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

    " Addition window commands
    nnoremap <silent> <C-W>t <CMD>tab split<CR>
    nnoremap <silent> <C-W>N <CMD>vnew<CR>

    " Moving selected lines
    vnoremap  <LEFT>   <gv
    vnoremap  <RIGHt>  >gv
    vmap  <UP>     [egv
    vmap  <DOWN>   ]egv

    " Favorite mark
    nnoremap gz `Z

    " Cycle colorschemes
    nnoremap <F12> <CMD>CycleColorNext<CR>


""" Viewport
    " Window resizing with the arrow keys
    nnoremap  <LEFT>   5<C-W><
    nnoremap  <RIGHt>  5<C-W>>
    nnoremap  <UP>     5<C-W>+
    nnoremap  <DOWN>   5<C-W>-

    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 5<C-E>
    nnoremap <C-K> 5<C-Y>
    nnoremap <C-H> 5zh
    nnoremap <C-L> 5zl


""" Search and replace
    nnoremap gs :%s/
    vnoremap gs :s/

    nnoremap <expr> gS ':%s/\V'.expand('<cword>').'/'
    vnoremap gS y:%s/\V<C-R>=escape(@", '\/')<CR>/

    " Highlight matches
    nnoremap <expr> gm v:count <= 1 ? '<CMD>Match<CR>' : '<CMD>Match'.v:count.'<CR>'
    nnoremap <expr> gM v:count <= 1 ? '<CMD>match<CR>' : '<CMD>'.v:count.'match<CR>'


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
    " Preview definition
    nnoremap <C-SPACE> <C-W>}
    nnoremap g<C-SPACE> <C-W>g}
    vnoremap <silent> <C-SPACE> y:ptag <C-R>"<CR>
    vnoremap <silent> g<C-SPACE> y:ptselect <C-R>"<CR>

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
    nmap <leader>F <Plug>(filefinder-here)


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
    nmap <silent> <leader>* <Plug>(search-word-in-file)
    vmap <silent> <leader>* <Plug>(search-selection-in-file)

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
    " Move cursor in command line
    cnoremap <C-H> <left>
    cnoremap <C-L> <right>

    " Insert file's directory in command line
    cnoremap %% %:h/
    cnoremap ## #:h/

    " Switch to alternative buffer
    nnoremap <expr> <BS> empty(expand('#:t')) \|\| (expand('#') == expand('%')) ? ':echoerr "No alternate file"<cr>' : '<C-^>'

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
    nmap <leader>D <Plug>(buffers-wipe)
    nmap <leader>O <Plug>(buffers-only)

    " Explore
    nnoremap <silent> <leader>E <CMD>Explore<CR>
    nnoremap <silent> <leader>V <CMD>Vexplore<CR>
    nnoremap <silent> <leader>T <CMD>Texplore<CR>


""" (c): Changes / Diffing
    nmap <silent> cs <Plug>(git-diff-split)
    nmap <silent> cp <Plug>(git-patch-split)
    nmap cS <Plug>(git-diff-split-ref)
    nmap cP <Plug>(git-patch-split-ref)

""" (gb): Git Blame
    nmap <silent> gbb <Plug>(git-blame)
    vmap <silent> gb <Plug>(git-blame)


""" Potential Ad-hoc mappings
    if empty(maparg('<leader><leader>', 'n'))
        nnoremap <leader><leader> :nnoremap <leader><leader> 
    endif
