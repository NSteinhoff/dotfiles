packadd coc.nvim

augroup coc-lsp
    autocmd!

    " Disable by default
    " autocmd BufAdd * let b:coc_enabled=0

    " Enable for some filetypes
    autocmd FileType typescript,javascript,javascriptreact,typescriptreact call s:on_attach()

    " Enable for Coc's settings file
    autocmd BufAdd coc-settings.json call s:on_attach()
    autocmd BufAdd package.json call s:on_attach()

    " Highlight the symbol and its references when holding the cursor.
    " autocmd CursorHold * silent call CocActionAsync('highlight')

    " Setup formatexpr specified filetype(s).
    " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

command CocAttach call s:on_attach()
function s:on_attach()
    " CocEnable
    call s:setup_options()
    call s:setup_commands()
    call s:setup_mappings()
    call s:setup_completion()
    call s:setup_autocommands()
endfunction

"---------------------------------------------------------------------------- "
"                                   Options                                   "
"---------------------------------------------------------------------------- "
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=200

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

function s:setup_options()
    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      setlocal signcolumn=number
    else
      setlocal signcolumn=yes
    endif
endfunction

"---------------------------------------------------------------------------- "
"                                 Completion                                  "
"---------------------------------------------------------------------------- "
function s:setup_completion()
    " Map <tab> to trigger completion and navigate to the next item: >
    " inoremap <buffer> <silent><expr> <TAB>
    "               \ pumvisible() ? "\<C-n>" :
    "               \ <SID>check_back_space() ? "\<TAB>" :
    "               \ coc#refresh()
    inoremap <buffer> <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    " Map <c-space> to trigger completion: >
    inoremap <buffer> <silent><expr> <c-space> coc#refresh()

    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <buffer> <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use K to show documentation in preview window.
    nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
    nnoremap <buffer> <silent> <space> :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Used for the format on type and improvement of brackets, ex: >
    inoremap <buffer> <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endfunction

"---------------------------------------------------------------------------- "
"                                  Commands                                   "
"---------------------------------------------------------------------------- "
function s:setup_commands()
    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)
endfunction

"---------------------------------------------------------------------------- "
"                                Autocommands                                 "
"---------------------------------------------------------------------------- "
function s:setup_autocommands()
endfunction

"---------------------------------------------------------------------------- "
"                                  Mappings                                   "
"---------------------------------------------------------------------------- "
function s:setup_mappings()
    nmap <buffer> gh <Plug>(coc-diagnostic-info)

    "       Show diagnostic message of current position by invoke |coc-action-diagnosticInfo|

    nmap <buffer> ]g <Plug>(coc-diagnostic-next)

    "       Jump to next diagnostic position.

    nmap <buffer> [g <Plug>(coc-diagnostic-prev)

    "       Jump to previous diagnostic position.

    " <Plug>(coc-diagnostic-next-error)

    "       Jump to next diagnostic error position.

    " <Plug>(coc-diagnostic-prev-error)

    "       Jump to previous diagnostic error position.

    nmap <buffer> gd <Plug>(coc-definition)
    nmap <buffer> <C-SPACE> <Plug>(coc-definition)

    "       Jump to definition(s) of current symbol by invoke
    "       |coc-action-jumpDefinition|

    nmap <buffer> <C-W>d <C-W>s<Plug>(coc-definition)
    nmap <buffer> <C-W><C-D> <C-W>s<Plug>(coc-definition)

    nmap <buffer> gD <Plug>(coc-declaration)

    "       Jump to declaration(s) of current symbol by invoke
    "       ||coc-action-jumpDeclaration||

    nmap <buffer> gi <Plug>(coc-implementation)

    "       Jump to implementation(s) of current symbol by invoke
    "       ||coc-action-jumpImplementation||

    nmap <buffer> gy <Plug>(coc-type-definition)

    "       Jump to type definition(s) of current symbol by invoke
    "       ||coc-action-jumpTypeDefinition||

    nmap <buffer> gR " <Plug>(coc-references)

    "       Jump to references of current symbol by invoke
    "       |coc-action-jumpReferences|

    nmap <buffer> gr <Plug>(coc-references-used)

    "       Jump to references of current symbol exclude declarations.

    " <Plug>(coc-format-selected)
    "                                                       *v_coc-format-selected*

    "       Format selected range, would work in both visual mode and normal mode,
    "       when used in normal mode, the selection works on the motion object.

    "       For example: >

    "       vmap <leader>p  <Plug>(coc-format-selected)
    "       nmap <leader>p  <Plug>(coc-format-selected)

    "       makes `<leader>p` format the visually selected range, and you can use
    "       `<leader>pap` to format a paragraph.

    nmap <buffer> dcF <Plug>(coc-format)

    "       Format the whole buffer by invoke |coc-action-format|, normally you
    "       would like to use a command like: >

    "       command! -nargs=0 Format :call CocAction('format')

    "       to format the current buffer.

    nmap <buffer> dcr <Plug>(coc-rename)

    "       Rename symbol under cursor to a new word by invoke |coc-action-rename|

    nmap <buffer> dcA <Plug>(coc-codeaction)

    "       Get and run code action(s) for current file.

    nmap <buffer> dca <Plug>(coc-codeaction-line)

    "       Get and run code action(s) for current line.

    " <Plug>(coc-codeaction-selected)
    "                                                       *v_coc-codeaction-selected*

    "       Get and run code action(s) with the selected region.
    "       Works with both normal and visual mode.

    " <Plug>(coc-openlink)

    "       Open link under cursor.

    " <Plug>(coc-codelens-action)

    "       Do command from codeLens of current line.

    nmap <buffer> dcf <Plug>(coc-fix-current)

    "       Try first quickfix action for diagnostics on the current line.

    nmap <buffer> dch <Plug>(coc-float-hide)

    "       Hide all float windows.

    " <Plug>(coc-float-jump)

    "       Jump to first float window, works on neovim only since vim's popup
    "       doesn't have support for focus.

    " <Plug>(coc-refactor)

    "       Open refactor window for refactor of current symbol.

    " <Plug>(coc-range-select)
    " <Plug>(coc-range-select)

    "       Select next selection range.

    "       Note: requires selection ranges feature of language server, like:
    "       coc-tsserver, coc-python

    " <Plug>(coc-range-select-backward)

    "       Select previous selection range.

    "       Note: requires selection ranges feature of language server, like:
    "       coc-tsserver, coc-python

    " <Plug>(coc-funcobj-i)
    "                                                       *v_coc-funcobj-i*

    "     Select inside function. Recommend mapping:

    "     xmap if <Plug>(coc-funcobj-i)
    "     omap if <Plug>(coc-funcobj-i)

    "     Note: Requires 'textDocument.documentSymbol' support from the language
    "     server.

    " <Plug>(coc-funcobj-a)
    "                                                       *v_coc-funcobj-a*

    "       Select around function. Recommended mapping:

    "       xmap af <Plug>(coc-funcobj-a)
    "       omap af <Plug>(coc-funcobj-a)

    "       Note: Requires 'textDocument.documentSymbol' support from the language
    "       server.

    " <Plug>(coc-classobj-i)
    "                                                       *v_coc-classobj-i*

    "       Select inside class/struct/interface. Recommended mapping:

    "       xmap ic <Plug>(coc-classobj-i)
    "       omap ic <Plug>(coc-classobj-i)

    "       Note: Requires 'textDocument.documentSymbol' support from the language
    "       server.


    " <Plug>(coc-classobj-a)
    "                                                       *v_coc-classobj-a*

    "       Select around class/struct/interface. Recommended mapping:

    "       xmap ac <Plug>(coc-classobj-a)
    "       omap ac <Plug>(coc-classobj-a)

    "       Note: Requires 'textDocument.documentSymbol' support from the language
    "       server.

    " Scroll floting window
    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <buffer> <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <buffer> <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <buffer> <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <buffer> <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <buffer> <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <buffer> <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif


    " --------------------------- Mappings for CoCList ----------------------------

    " Show all diagnostics.
    nnoremap <buffer> <silent><nowait> gH  :<C-u>CocList diagnostics<cr>

    " Manage extensions.
    " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>

    " Show commands.
    " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>

    " Find symbol of current document.
    nnoremap <buffer> <silent><nowait> gw  :<C-u>CocList outline<cr>

    " Search workspace symbols.
    nnoremap <buffer> <silent><nowait> gW :<C-u>CocList -I symbols<cr>

    " Do default action for next item.
    " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>

    " Do default action for previous item.
    " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>

    " Resume latest coc list.
    " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
endfunction
