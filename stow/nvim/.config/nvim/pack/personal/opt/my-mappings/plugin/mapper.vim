augroup SANITIZER
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
    autocmd CmdwinEnter * nnoremap <buffer> <bs> <bs>
    autocmd CmdwinEnter * nnoremap <buffer> <space> <space>
    autocmd CmdwinEnter * nnoremap <buffer> <c-n> <c-n>
    autocmd CmdwinEnter * nnoremap <buffer> <c-p> <c-p>
augroup END


""" <leader> / Wildchar
    " Explicitly map the <leader> key. Otherwise some plugins use their own default.
    let mapleader = '\'
    let maplocalleader = '\'
    set wildcharm=<c-z>


""" Basics / Improving standard mappings
    " Clear search highlights with ESC in normal mode and update diffs
    nnoremap <silent> <esc> <cmd>nohlsearch<bar>diffupdate<cr>

    " Go home
    " noremap <expr> 0 col('.') == 1 ? '^' : '0'

    " Toggle folds with <space>
    nnoremap <space> za

    " Yank to clipboard with "" (Why would I ever explicitly need to target
    " the unnamed register anyways?)
    noremap "" "+

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
    map [[ ?{<cr>w99[{
    map ][ /}<cr>b99]}
    map ]] j0[[%/{<cr>
    map [] k$][%?}<cr>

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

    nnoremap <expr> gS ':%s/\C\V\<'.expand('<cword>').'\>/'
    vnoremap gS y:%s/\C\V<c-r>=escape(@", '\/')<cr>/

    " Highlight matches
    nnoremap <expr> gm v:count <= 1 ? '<cmd>Match<cr>' : '<cmd>Match'.v:count.'<cr>'
    nnoremap <expr> gM v:count <= 1 ? '<cmd>match<cr>' : '<cmd>'.v:count.'match<cr>'
    vnoremap gm y:<c-u>Match <c-r>"<cr>


""" Format
    " Mnemonic:
    "   < and > change indentation
    "   <> => 'indent all'
    nnoremap <silent> <> <cmd>Format<cr>

""" Fix
    " Mnemonic:
    "   ! change / modify / action
    "   > into file
    nnoremap <silent> !> <cmd>Fix<cr>

""" Align: <leader>=
    noremap <silent> <leader>== :Align<cr>
    noremap <silent> <leader>=. :center<cr>
    noremap <silent> <leader>=> :right<cr>
    noremap <silent> <leader>=< :left<cr>

"""  Errors: Quickfix / Location Lists
    " The idea here is to have one mapping to get a peek at the current list
    " of entries and a second one to browse the list and pick an entry to
    " jump to.
    nnoremap <silent> <expr> `<space>  qf#qfvisible() ? '<cmd>cclose<cr>' : '<cmd>botright copen<cr>'
    nnoremap <silent> <expr> <leader><space>  qf#locvisible() ? '<cmd>lclose<cr>' : '<cmd>botright lopen<cr>'

    nnoremap <silent> <leader>qq       <cmd>clist<cr>
    nnoremap <silent> <leader>qo       <cmd>botright copen<cr>
    nnoremap <silent> <leader>qc       <cmd>cclose<cr>
    nnoremap <silent> <leader>qw       <cmd>botright cwindow<cr>

    nnoremap <silent> <leader>ll       <cmd>llist<cr>
    nnoremap <silent> <leader>lo       <cmd>botright lopen<cr>
    nnoremap <silent> <leader>lc       <cmd>lclose<cr>
    nnoremap <silent> <leader>lw       <cmd>botright lwindow<cr>

    nmap <silent> <leader>qn <plug>(qf-new)
    nmap <silent> <leader>qa <plug>(qf-add)
    vmap <silent> <leader>qa <plug>(qf-add)

    nmap <c-n> <plug>(cycle-visible-forward)
    nmap <c-p> <plug>(cycle-visible-backward)


""" Preview / Hover
    " Preview definition
    nnoremap <expr><silent> <c-space>         !empty(tagfiles()) ? '<c-w>}' : !empty(expand('<cword>')) ? ':psearch <c-r><c-w><cr>' : ''
    nnoremap <expr><silent> g<c-space>        !empty(tagfiles()) ? '<c-w>g}' : !empty(expand('<cword>')) ? ':psearch <c-r><c-w><cr>' : ''
    vnoremap <expr><silent> <c-space>         !empty(tagfiles()) ? 'y:ptag <c-r>"<cr>' !empty(expand('<cword>')) ? : 'y:psearch /.*<c-r>".*/<cr>' : ''
    vnoremap <expr><silent> g<c-space>        !empty(tagfiles()) ? 'y:ptselect <c-r>"<cr>' : !empty(expand('<cword>')) ? 'y:psearch /.*<c-r>".*/<cr>' : ''

    " Signature help via :ptag
    inoremap <expr><silent> <c-h> '<cmd>ptag '.expand('<cword>').'<cr>'

    " Close the preview window
    nnoremap <c-w><space>   <c-w>z
    nnoremap <c-w><c-space> <c-w>z


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
    imap <c-x><c-r> <plug>(ins-complete-register)
    " Paths:
    imap <c-x><c-h> <plug>(ins-complete-local-path)
    imap <c-l> <plug>(ins-complete-local-path)

    " Replace an expression with c<motion> and <c-r><c-v> somewhere to define
    " a variable for it
    "
    " e.g. let <c-v><c-r>
    inoremap <c-r><c-v> <c-r>. = <c-r>"

""" Running builds with `<key>
    nmap m<space>           <plug>(maker-sync)
    nmap m<cr>              <plug>(maker-split)
    nmap m<bs>              <plug>(maker-background)
    nmap m?                 <plug>(compiler-info)

    nmap <leader><leader>   <plug>(compiler-with)
    nmap <leader><cr>       :CompileWith<space>

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

    " Not sure that these work everywhere
    cnoremap <m-b> <s-left>
    cnoremap <m-f> <s-right>

    " Favorite mark
    nnoremap <leader>z mZ
    nnoremap gz `Z

    " Insert file's directory in command line
    " cnoremap %% %:h/
    " cnoremap ## #:h/

    " Switch to alternative buffer
    nmap <bs> <plug>(buffers-alternative)

    " Missing `:tab split` mapping
    " Like <c-w>T, but without removing the window from the current page.
    " Also works when there is only one window.
    nnoremap <silent> <c-w>t <cmd>tab split<cr>
    nnoremap <silent> <c-w><c-t> <cmd>tab split<cr>

    " Search for the currently selected text and set the search register
    vmap <silent> * <plug>(search-selection)
    vmap <silent> # <plug>(search-selection-reverse)

    " Grep, i.e. poor man's 'go-to-reference'
    nmap <silent> gr <plug>(grep-word-silent)<cmd>botright cwindow<cr>
    vmap <silent> gr <plug>(grep-selection-silent)<cmd>botright cwindow<cr>
    nmap gl <plug>(livegrep-new)
    nmap gL <plug>(livegrep-resume)

    " Outline
    nmap gO <plug>(tag-toc)

""" Scoped <leader> mappings
    " Toggle between 3/4 and 1/4 viewport width
    nnoremap <silent> <leader><bar><bar> <cmd>execute 'vertical resize '..(winwidth(0) > &columns / 4 ? &columns / 4 : &columns / 4 * 3)<cr>

    " Open settings: <leader>;
    nnoremap <silent> <leader>;; <cmd>edit $MYVIMRC<cr>
    nnoremap <silent> <leader>;m <cmd>PackFind mapper.vim<cr>
    nnoremap <silent> <leader>;c <cmd>PackFind commander.vim<cr>

    " Bang: <leader>!
    map <silent> <leader>!! :Run<cr>

    " Shebang: <leader>#!
    nnoremap <leader>#! <cmd>!%:p<cr>

    " Execute: <leader>x
    " Run lines with bash
    nnoremap <leader>xb <cmd>.w !bash<cr>
    " Replace lines with results
    nnoremap <leader>xf <cmd>.!bash<cr>
    vnoremap <leader>xf :!bash<cr>
    " Append result of running lines
    nnoremap <leader>xr <cmd>execute 'read !'..getline('.')<cr>
    vnoremap <leader>xr yPgv:!bash<cr>
    " Pass lines as arguments
    nnoremap <leader>xx :.w !xargs 
    vnoremap <leader>xx :w !xargs 

    " Split: <leader>s
    nnoremap <leader>ss :sbuffer <c-z>
    nnoremap <leader>sv :vert sbuffer <c-z>
    nnoremap <leader>st :tab sbuffer <c-z>

    " Buffers: <leader>b
    nmap <leader>bb <plug>(buffers-edit-list)
    nmap <leader>bd <plug>(buffers-delete)
    nmap <leader>bw <plug>(buffers-wipe)
    nmap <leader>bs <plug>(buffers-scratch)
    vmap <leader>bs <plug>(buffers-scratch)
    nmap <leader>bn <plug>(buffers-new)
    nmap <leader>bv <plug>(buffers-vnew)

    " Terminal <leader>t
    nmap <expr> <leader>t !empty(filter(getbufinfo(), {k,v -> v.name =~ '^term'})) ? ':b term<c-z>' : '<cmd>echo "No running terminal buffers."<cr>'

    " Explore: <leader>e
    nnoremap <silent> <leader>ee <cmd>Explore<cr>
    nnoremap <silent> <leader>ev <cmd>Vexplore<cr>
    nnoremap <silent> <leader>es <cmd>Sexplore<cr>
    nnoremap <silent> <leader>et <cmd>Texplore<cr>

    " Arguments: <leader>a
    nnoremap <silent> <leader>a. <cmd>argument<cr>
    nnoremap <silent> <leader>al <cmd>arglocal<cr>
    nnoremap <silent> <leader>ag <cmd>argglobal<cr>
    nnoremap <silent> <leader>aa <cmd>argadd<cr>
    nnoremap <silent> <leader>ad <cmd>execute 'argdelete '..bufname()<bar>if argc()<bar>argument<bar>endif<cr>

    " Open: <leader>o
    nnoremap <leader>oo <cmd>silent Open<cr>
    nnoremap <leader>o, <cmd>silent Open %:h<cr>
    nnoremap <leader>o. <cmd>silent Open .<cr>
    vnoremap <leader>oo y:Open "<cr>

    " Fuzzy Find: <leader>f
    nmap <leader>ff <plug>(filefinder-new)

    " Search: <leader>*
    nmap <silent> <leader>*. <plug>(grep-word-in-file)
    nmap <silent> <leader>*g. <plug>(grep-word-g-in-file)
    vmap <silent> <leader>*. <plug>(grep-selection-in-file)

    nmap <silent> <leader>** <plug>(grep-word)
    nmap <silent> <leader>*g* <plug>(grep-word-g)
    vmap <silent> <leader>** <plug>(grep-selection)


""" (c): Changes / Diffing
    nmap <expr> dp (&diff ? '<cmd>diffput<cr>' : '<plug>(git-diff-split)')
    nmap dP <plug>(git-diff-split-ref)

""" (gb): Git Blame
    nmap <silent> gb <plug>(git-blame)
    vmap <silent> gb <plug>(git-blame)

""" (?): Inspect
    nnoremap <leader>?c <cmd>CompilerInfo<cr>
    nnoremap <leader>?l <cmd>LspInfo<cr>
    nnoremap <leader>?p <cmd>verbose set path?<cr>
    nnoremap <leader>?t <cmd>TagFiles<cr>


""" Show <leader> mappings
    nnoremap <leader>?? <cmd>echo join(filter(split(execute('map <leader>'), "\n"), {_, v -> v =~ '^\s*\(n\\|v\\|\s\)\s*\\\S[^ ?]\s' }), "\n")<cr>
    nnoremap <leader>* <cmd>echo join(filter(split(execute('map <leader>*'), "\n"), {_, v -> v !~# '^\s*n\s*\\*\*\s' }), "\n")<cr>

    " Show scoped mappings when last character is missing after short delay
    for letter in split('abcdefghijklmnopqrstuvwxyz;!=?', '\ze')
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
