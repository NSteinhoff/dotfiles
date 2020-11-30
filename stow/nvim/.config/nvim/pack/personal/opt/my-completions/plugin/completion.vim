lua require('my_completion')

" Default settings
let g:completion_auto_change_source = 1
let g:completion_enable_auto_popup = 0

" Modes
" 'smarttab' => smart tab as completion trigger
" 'code' => VSCode style completion with auto-popup and tab to confirm
let g:my_completion_mode = 'code'

augroup user-completion
    autocmd!
    "autocmd BufEnter * lua require"my_completion".on_attach()
augroup END

" non ins-complete method should be specified in 'mode'
let g:completion_chain_complete_list = {
\   'default': {
\       'comment': [],
\       'string': [],
\       'default': [
\               {'complete_items': ['lsp']},
\       ],
\   }
\}
