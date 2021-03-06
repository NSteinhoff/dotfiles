augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
    autocmd CmdwinEnter * nnoremap <buffer> <bs> <bs>
    autocmd CmdwinEnter * nnoremap <buffer> <space> <space>
    autocmd CmdwinEnter * nnoremap <buffer> <c-n> <c-n>
    autocmd CmdwinEnter * nnoremap <buffer> <c-p> <c-p>
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


""" <leader> / Wildchar
    " Explicitly map the <leader> key. Otherwise some plugins use their own default.
    let mapleader = '\'
    let maplocalleader = '\'
    set wildcharm=<c-z>


""" Basics / Improving standard mappings
    " Clear search highlights with ESC in normal mode
    nnoremap <silent> <esc> <cmd>nohlsearch<cr>

    " Go home
    " noremap <expr> 0 col('.') == 1 ? '^' : '0'

    " Toggle folds with <space>
    nnoremap <space> za

    " Make Y behave like C and D
    nnoremap Y y$

    " Close all folds but show the cursorline
    nnoremap zV <cmd>normal zMzv<cr>

    " Run 'q' macro
    nnoremap Q @q
    vnoremap Q :normal @q<cr>

    " Move over visual lines unless a count is given
    nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

    " Move over sections
    " Taken from `help section`
    " map [[ ?{<cr>w99[{
    " map ][ /}<cr>b99]}
    " map ]] j0[[%/{<cr>
    " map [] k$][%?}<cr>

    " Do something useful with the arrow keys:
    " Moving selected lines
     vnoremap <left> <gv
     vnoremap <right> >gv
     vmap <up> [egv
     vmap <down> ]egv

     " Change word under cursor and make it repeatable
    nnoremap c* <cmd>let @/ = '\<'..expand('<cword>')..'\>'<cr>cgn
    nnoremap cg* <cmd>let @/ = expand('<cword>')<cr>cgn

    " Escape terminal mode
    tnoremap <c-\><c-\> <c-\><c-n>

""" Viewport
    " Window resizing with the arrow keys
    nnoremap <left>  5<c-w><
    nnoremap <right> 5<c-w>>
    nnoremap <up>    2<c-w>+
    nnoremap <down>  2<c-w>-

    " Scrolling the window with CTRL-HJKL
    nnoremap <c-j> 5<c-e>
    nnoremap <c-k> 5<c-y>
    nnoremap <c-h> 10zh
    nnoremap <c-l> 10zl


""" Search and replace
    nnoremap gs :%s/
    vnoremap gs :s/

    nnoremap <expr> gS ':%s/\V\<'.expand('<cword>').'\>/'
    vnoremap gS y:%s/\V<c-r>=escape(@", '\/')<cr>/

    " Highlight matches
    nnoremap <expr> gm v:count <= 1 ? '<cmd>Match<cr>' : '<cmd>Match'.v:count.'<cr>'
    nnoremap <expr> gM v:count <= 1 ? '<cmd>match<cr>' : '<cmd>'.v:count.'match<cr>'
    vnoremap gm y:<c-u>Match <c-r>"<cr>


""" Format
    " Mnemonic:
    "   < and > change indentation
    "   => 'indent all'
    nnoremap <silent> <> <cmd>Format<cr>

""" Align: <leader>=
    noremap <silent> <leader>== :Align<cr>
    noremap <silent> <leader>=. :center<cr>
    noremap <silent> <leader>=> :right<cr>
    noremap <silent> <leader>=< :left<cr>

"""  Errors: Quickfix / Location Lists
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    nnoremap <silent> <expr> `<space>  qf#qfvisible() ? '<cmd>cclose<bar>lclose<cr>' : '<cmd>copen<cr>'
    nnoremap <silent> <expr> <leader><space>  qf#locvisible() ? '<cmd>cclose<bar>lclose<cr>' : '<cmd>lopen<cr>'

    nnoremap <silent> <leader>qq       <cmd>clist<cr>
    nnoremap <silent> <leader>qo       <cmd>copen<cr>
    nnoremap <silent> <leader>qc       <cmd>cclose<cr>
    nnoremap <silent> <leader>qw       <cmd>cwindow<cr>

    nnoremap <silent> <leader>ll       <cmd>llist<cr>
    nnoremap <silent> <leader>lo       <cmd>lopen<cr>
    nnoremap <silent> <leader>lc       <cmd>lclose<cr>
    nnoremap <silent> <leader>lw       <cmd>lwindow<cr>

    nmap <silent> <leader>qn <plug>(qf-new)
    nmap <silent> <leader>qa <plug>(qf-add)
    vmap <silent> <leader>qa <plug>(qf-add)

    nmap <c-n> <plug>(cycle-loc-forward)
    nmap <c-p> <plug>(cycle-loc-backward)


""" Preview / Hover
    " Preview definition
    nnoremap          <c-space>         <c-w>}
    nnoremap          g<c-space>        <c-w>g}
    vnoremap <silent> <c-space>         y:ptag <c-r>"<cr>
    vnoremap <silent> g<c-space>        y:ptselect <c-r>"<cr>

    " Close the preview window
    nnoremap          <c-w><space>      <c-w>z
    nnoremap          <c-w><c-space>    <c-w>z


""" Completion
    " <c-space> is used for smart completion.
    " By default it completes tags. This could be remapped to omni-completion
    " or LSP completion for supported languages or filetypes.
    inoremap <expr> <c-space> empty(&omnifunc) ? '<c-x><c-]>' : '<c-x><c-o>'
    inoremap <expr> <tab>   pumvisible() ? '<c-n>' : '<tab>'
    inoremap <expr> <s-tab> pumvisible() ? '<c-p>' : '<s-TAB>'

    " Additional ins-completion modes
    " W,R,A,G,H,J,Z,C,B,M
    " Registers:
    " imap <c-x><c-r> <plug>(ins-complete-register)
    " Paths:
    " imap <c-x><c-h> <plug>(ins-complete-path)


""" Running builds with `<key>
    nmap `<leader>   <plug>(maker-sync)
    nmap `<cr>      <plug>(maker-split)
    nmap `<bs>      <plug>(maker-background)

    " List, load, read errorfile contents
    nmap g> <plug>(maker-show-log)
    nmap g! <plug>(maker-load-errors)
    nmap g± <plug>(maker-local-load-errors)
    nmap g? <plug>(maker-edit-errors)


""" Toggle Settings
    " Extending 'vim-unimpaired'
    " _: Statusbar
    nnoremap <silent> [o_ <cmd>set ls=2<cr>
    nnoremap <silent> ]o_ <cmd>set ls=0<cr>
    nnoremap <expr> <silent> yo_ (&laststatus == 2 ? '<cmd>set ls=0<cr>' : '<cmd>set ls=2<cr>')


""" Quality of life
    " Move cursor in command line
    " cnoremap <c-h> <left>
    " cnoremap <c-l> <right>

    " Favorite mark
    nnoremap gz `Z

    " Insert file's directory in command line
    cnoremap %% %:h/
    cnoremap ## #:h/

    " Switch to alternative buffer
    nnoremap <expr> <bs> empty(expand('#:t')) \|\| (expand('#') == expand('%')) ? ':echoerr "No alternate file"<cr>' : '<c-^>'

    " Missing `:tab split` mapping
    " Like <c-w>T, but without removing the window from the current pane.
    " Also works when there is only one window.
    nnoremap <silent> <c-w>t <cmd>tab split<cr>
    nnoremap <silent> <c-w><c-t> <cmd>tab split<cr>

    " Grep, i.e. go-to-reference
    nmap <silent> gr <plug>(search-word)
    vmap <silent> gr <plug>(search-selection)

    " Outline
    nmap gO <plug>(tag-toc)

""" Scoped <leader> mappings
    nnoremap <silent> <leader><bar><bar> <cmd>execute 'vertical resize '..(winwidth(0) > &columns / 4 ? &columns / 4 : &columns / 4 * 3)<cr>

    " Open settings: <leader>;
    nnoremap <silent> <leader>;; <cmd>edit $MYVIMRC<cr>
    nnoremap <silent> <leader>;m <cmd>PackEdit mapper.vim<cr>
    nnoremap <silent> <leader>;c <cmd>PackEdit commander.vim<cr>

    " Bang: <leader>!
    nnoremap <leader>!! <cmd>w !bash<cr>
    vnoremap <leader>!! :w !bash<cr>

    " Shebang: <leader>#!
    nnoremap <leader>#! <cmd>!%:p<cr>

    " Execute: <leader>x
    nnoremap <leader>xx :.w !xargs 
    vnoremap <leader>xx :w !xargs 
    nnoremap <leader>xf :.!xargs 
    vnoremap <leader>xf :!xargs 

    " Split: <leader>s
    nnoremap <leader>ss :sbuffer <c-z>
    nnoremap <leader>sv :vert sbuffer <c-z>
    nnoremap <leader>st :tab sbuffer <c-z>

    " Buffers: <leader>b
    nnoremap <leader>bb :buffer <c-z>
    nmap <leader>be <plug>(buffers-edit-list)
    nmap <leader>bd <plug>(buffers-delete)
    nmap <leader>bw <plug>(buffers-wipe)
    nmap <leader>bs <plug>(buffers-scratch)
    vmap <leader>bs <plug>(buffers-scratch)

    " Explore: <leader>e
    nnoremap <silent> <leader>ee <cmd>Explore<cr>
    nnoremap <silent> <leader>ev <cmd>Vexplore<cr>
    nnoremap <silent> <leader>es <cmd>Sexplore<cr>
    nnoremap <silent> <leader>et <cmd>Texplore<cr>

    " Arguments: <leader>a
    function s:curarg()
        return argv(argidx()) == bufname()
    endfunction
    nnoremap <silent> <leader>a. <cmd>argument<cr>
    nnoremap <silent> <leader>al <cmd>arglocal<cr>
    nnoremap <silent> <leader>ag <cmd>argglobal<cr>
    nnoremap <silent> <leader>aa <cmd>argadd<cr>
    nnoremap <silent> <expr> <leader>ad '<cmd>argdelete'..(<sid>curarg() ? '<bar>argument' : '')..'<cr>'

    " Open: <leader>o
    nnoremap <leader>oo <cmd>silent Open<cr>
    nnoremap <leader>o, <cmd>silent Open %:h<cr>
    nnoremap <leader>o. <cmd>silent Open .<cr>
    vnoremap <leader>oo y:Open "<cr>

    " Find: <leader>f
    nmap <leader>ff <plug>(filefinder-new)

    " Search: <leader>*
    nmap <silent> <leader>*. <plug>(search-word-in-file)
    nmap <silent> <leader>*g. <plug>(search-word-g-in-file)
    vmap <silent> <leader>*. <plug>(search-selection-in-file)

    nmap <silent> <leader>** <plug>(search-word)
    nmap <silent> <leader>*g* <plug>(search-word-g)
    vmap <silent> <leader>** <plug>(search-selection)

    " Livegrep: <leader>g
    nmap <leader>gg <plug>(livegrep-new)
    vmap <leader>gg <plug>(livegrep-selection)
    nmap <leader>gr <plug>(livegrep-resume)


""" (c): Changes / Diffing
    nmap <silent> cs <plug>(git-diff-split)
    nmap <silent> cp <plug>(git-patch-split)
    nmap cS <plug>(git-diff-split-ref)
    nmap cP <plug>(git-patch-split-ref)

""" (gb): Git Blame
    nmap <silent> gb <plug>(git-blame)
    vmap <silent> gb <plug>(git-blame)

""" (?): Inspect
    nnoremap <leader>?c <cmd>Compiler<cr>
    nnoremap <leader>?l <cmd>LspInfo<cr>


""" Potential Ad-hoc mappings or show <leader> mappings
    nnoremap <leader>?? <cmd>echo join(filter(split(execute('map <leader>'), "\n")[1:], {_, v -> v =~ '^\s*n\s*\\\S\S\s' }), "\n")<cr>
    for letter in split('abcdefghijklmnopqrstuvwxyz*;!=?', '\ze')
        if empty(maparg('<leader>'..letter, 'n'))
            " Display all <leader>letter mappings but this one
            execute 'nnoremap <leader>'..letter..' <cmd>echo join(filter(split(execute(''map <leader>'..letter..'''), "\n"), {_, v -> v !~# ''^\s*n\s*\\'..letter..'\s'' }), "\n")<cr>'
        endif
    endfor


""" Theme and Colors
    nnoremap <F7> <cmd>silent !toggle-light-dark<cr>
    nnoremap <F8> <cmd>CycleColorNext<cr>

""" TOC
    nmap gw <plug>(tag-toc)
