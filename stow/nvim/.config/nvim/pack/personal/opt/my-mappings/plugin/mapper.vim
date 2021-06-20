augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <BS> <BS>
    autocmd CmdwinEnter * nnoremap <buffer> <SPACE> <SPACE>
    autocmd CmdwinEnter * nnoremap <buffer> <C-N> <C-N>
    autocmd CmdwinEnter * nnoremap <buffer> <C-P> <C-P>
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

    " Go home
    " noremap <expr> 0 col('.') == 1 ? '^' : '0'

    " Toggle folds with <SPACE>
    nnoremap <SPACE> za

    " Make Y behave like C and D
    nnoremap Y y$

    " Close all folds but show the cursorline
    nnoremap zV <CMD>normal zMzv<CR>

    " Run 'q' macro
    nnoremap Q @q
    vnoremap Q :normal @q<CR>

    " Move over visual lines unless a count is given
    nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

    " Move over sections
    " Taken from `help section`
    " map [[ ?{<CR>w99[{
    " map ][ /}<CR>b99]}
    " map ]] j0[[%/{<CR>
    " map [] k$][%?}<CR>

    " Do something useful with the arrow keys:
    " Moving selected lines
     vnoremap <LEFT> <gv
     vnoremap <RIGHt> >gv
     vmap <UP> [egv
     vmap <DOWN> ]egv


""" Viewport
    " Window resizing with the arrow keys
    nnoremap <LEFT>  5<C-W><
    nnoremap <RIGHt> 5<C-W>>
    nnoremap <UP>    2<C-W>+
    nnoremap <DOWN>  2<C-W>-

    " Scrolling the window with CTRL-HJKL
    nnoremap <C-J> 5<C-E>
    nnoremap <C-K> 5<C-Y>
    nnoremap <C-H> 10zh
    nnoremap <C-L> 10zl


""" Search and replace
    nnoremap gs :%s/
    vnoremap gs :s/

    nnoremap <expr> gS ':%s/\V\<'.expand('<cword>').'\>/'
    vnoremap gS y:%s/\V<C-R>=escape(@", '\/')<CR>/

    " Highlight matches
    nnoremap <expr> gm v:count <= 1 ? '<CMD>Match<CR>' : '<CMD>Match'.v:count.'<CR>'
    nnoremap <expr> gM v:count <= 1 ? '<CMD>match<CR>' : '<CMD>'.v:count.'match<CR>'
    vnoremap gm y:<C-U>Match <c-r>"<CR>


""" Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    nnoremap <silent> <> <CMD>Format<CR>

""" Align: <leader>=
    noremap <silent> <leader>== :Align<CR>
    noremap <silent> <leader>=. :center<CR>
    noremap <silent> <leader>=> :right<CR>
    noremap <silent> <leader>=< :left<CR>

"""  Errors: Quickfix / Location Lists
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    nnoremap <silent> <leader><SPACE>  <CMD>cclose<bar>lclose<CR>

    nnoremap <silent> <leader>qq       <CMD>clist<CR>
    nnoremap <silent> <leader>qo       <CMD>copen<CR>
    nnoremap <silent> <leader>qc       <CMD>cclose<CR>
    nnoremap <silent> <leader>qw       <CMD>cwindow<CR>

    nnoremap <silent> <leader>ll       <CMD>llist<CR>
    nnoremap <silent> <leader>lo       <CMD>lopen<CR>
    nnoremap <silent> <leader>lc       <CMD>lclose<CR>
    nnoremap <silent> <leader>lw       <CMD>lwindow<CR>

    nmap <silent> <leader>qn <Plug>(qf-new)
    nmap <silent> <leader>qa <Plug>(qf-add)
    vmap <silent> <leader>qa <Plug>(qf-add)

    nmap <C-N> <Plug>(cycle-loc-forward)
    nmap <C-P> <Plug>(cycle-loc-backward)


""" Preview / Hover
    " Preview definition
    nnoremap          <C-SPACE>         <C-W>}
    nnoremap          g<C-SPACE>        <C-W>g}
    vnoremap <silent> <C-SPACE>         y:ptag <C-R>"<CR>
    vnoremap <silent> g<C-SPACE>        y:ptselect <C-R>"<CR>

    " Close the preview window
    nnoremap          <C-W><SPACE>      <C-W>z
    nnoremap          <C-W><C-SPACE>    <C-W>z


""" Completion
    " <C-Space> is used for smart completion.
    " By default it completes tags. This could be remapped to omni-completion
    " or LSP completion for supported languages or filetypes.
    inoremap <expr> <C-SPACE> empty(&omnifunc) ? '<C-X><C-]>' : '<C-X><C-O>'
    inoremap <expr> <Tab>   pumvisible() ? '<C-N>' : '<TAB>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-P>' : '<S-TAB>'

    " Additional ins-completion modes
    " W,R,A,G,H,J,Z,C,B,M
    " Registers:
    " imap <C-X><C-R> <Plug>(ins-complete-register)
    " Paths:
    " imap <C-X><C-H> <Plug>(ins-complete-path)


""" Running builds with `<key>
    nmap `<SPACE>   <Plug>(maker-sync)
    nmap `<CR>      <Plug>(maker-split)
    nmap `<BS>      <Plug>(maker-background)

    " List, load, read errorfile contents
    nmap g> <Plug>(maker-show-log)
    nmap g! <Plug>(maker-load-errors)
    nmap g± <Plug>(maker-local-load-errors)
    nmap g? <Plug>(maker-edit-errors)


""" Toggle Settings
    " Extending 'vim-unimpaired'
    " _: Statusbar
    nnoremap <silent> [o_ <CMD>set ls=2<CR>
    nnoremap <silent> ]o_ <CMD>set ls=0<CR>
    nnoremap <expr> <silent> yo_ (&laststatus == 2 ? '<CMD>set ls=0<CR>' : '<CMD>set ls=2<CR>')


""" Quality of life
    " Move cursor in command line
    " cnoremap <C-H> <left>
    " cnoremap <C-L> <right>

    " Favorite mark
    nnoremap gz `Z

    " Insert file's directory in command line
    cnoremap %% %:h/
    cnoremap ## #:h/

    " Switch to alternative buffer
    nnoremap <expr> <BS> empty(expand('#:t')) \|\| (expand('#') == expand('%')) ? ':echoerr "No alternate file"<cr>' : '<C-^>'

    " Missing `:tab split` mapping
    " Like <C-W>T, but without removing the window from the current pane.
    " Also works when there is only one window.
    nnoremap <silent> <C-W>t <CMD>tab split<CR>
    nnoremap <silent> <C-W><C-t> <CMD>tab split<CR>

    " Grep, i.e. go-to-reference
    nmap <silent> gr <Plug>(search-word)
    vmap <silent> gr <Plug>(search-selection)

    " Outline
    nmap gO <Plug>(tag-toc)

""" Scoped <leader> mappings
    " Open settings: <leader>;
    nnoremap <silent> <leader>;; <CMD>edit $MYVIMRC<CR>
    nnoremap <silent> <leader>;m <CMD>PackEdit mapper.vim<CR>
    nnoremap <silent> <leader>;c <CMD>PackEdit commander.vim<CR>

    " Bang: <leader>!
    nnoremap <leader>!! <CMD>!%:p<CR>
    vnoremap <leader>!! :w !bash<CR>

    " Execute: <leader>x
    nnoremap <leader>xx :.w !xargs 
    vnoremap <leader>xx :w !xargs 
    nnoremap <leader>xf :.!xargs 
    vnoremap <leader>xf :!xargs 

    " Split: <leader>s
    nnoremap <leader>ss :sbuffer <C-Z>
    nnoremap <leader>sv :vert sbuffer <C-Z>
    nnoremap <leader>st :tab sbuffer <C-Z>

    " Buffers: <leader>b
    nnoremap <leader>bb :buffer <C-Z>
    nmap <leader>be <Plug>(buffers-edit-list)
    nmap <leader>bd <Plug>(buffers-delete)
    nmap <leader>bw <Plug>(buffers-wipe)
    nmap <leader>bs <Plug>(buffers-scratch)
    vmap <leader>bs <Plug>(buffers-scratch)

    " Explore: <leader>e
    nnoremap <silent> <leader>ee <CMD>Explore<CR>
    nnoremap <silent> <leader>ev <CMD>Vexplore<CR>
    nnoremap <silent> <leader>es <CMD>Sexplore<CR>
    nnoremap <silent> <leader>et <CMD>Texplore<CR>

    " Arguments: <leader>a
    function s:curarg()
        return argv(argidx()) == bufname()
    endfunction
    nnoremap <silent> <leader>a. <CMD>argument<CR>
    nnoremap <silent> <leader>al <CMD>arglocal<CR>
    nnoremap <silent> <leader>ag <CMD>argglobal<CR>
    nnoremap <silent> <leader>aa <CMD>argadd<CR>
    nnoremap <silent> <expr> <leader>ad '<CMD>argdelete'..(<SID>curarg() ? '<BAR>argument' : '')..'<CR>'

    " Open: <leader>o
    nnoremap <leader>oo <CMD>silent Open<CR>
    nnoremap <leader>o, <CMD>silent Open %:h<CR>
    nnoremap <leader>o. <CMD>silent execute 'Open '..getcwd()<CR>
    vnoremap <leader>oo y:Open "<CR>

    " Find: <leader>f
    nmap <leader>ff <Plug>(filefinder-new)

    " Search: <leader>*
    nmap <silent> <leader>*. <Plug>(search-word-in-file)
    nmap <silent> <leader>*g. <Plug>(search-word-g-in-file)
    vmap <silent> <leader>*. <Plug>(search-selection-in-file)

    nmap <silent> <leader>** <Plug>(search-word)
    nmap <silent> <leader>*g* <Plug>(search-word-g)
    vmap <silent> <leader>** <Plug>(search-selection)

    " Livegrep: <leader>g
    nmap <leader>gg <Plug>(livegrep-new)
    vmap <leader>gg <Plug>(livegrep-selection)
    nmap <leader>gr <Plug>(livegrep-resume)


""" (c): Changes / Diffing
    nmap <silent> cs <Plug>(git-diff-split)
    nmap <silent> cp <Plug>(git-patch-split)
    nmap cS <Plug>(git-diff-split-ref)
    nmap cP <Plug>(git-patch-split-ref)

""" (gb): Git Blame
    nmap <silent> gb <Plug>(git-blame)
    vmap <silent> gb <Plug>(git-blame)


""" Potential Ad-hoc mappings or show <leader> mappings
    for letter in split('abcdefghijklmnopqrstuvwxyz*;!=', '\ze')
        if empty(maparg('<leader>'..letter, 'n'))
            " Display all <leader>letter mappings but this one
            execute 'nnoremap <leader>'..letter..' <CMD>echo join(filter(split(execute(''map <leader>'..letter..'''), "\n"), {_, v -> v !~# ''^\s*n\s*\\'..letter..'\s'' }), "\n")<CR>'
        endif
    endfor
    if empty(maparg('<leader><leader>', 'n'))
        " Display all <leader> mappings but this one
        nnoremap <leader><leader> <CMD>echo join(filter(split(execute('map <leader>'), "\n")[1:], {_, v -> v !~# '^\s*n\s*\\\\\s' }), "\n")<CR>
    endif


""" Theme and Colors
    nnoremap <F7> <CMD>silent !toggle-light-dark<CR>
    nnoremap <F8> <CMD>CycleColorNext<CR>

""" TOC
    nmap gw <PLUG>(tag-toc)
