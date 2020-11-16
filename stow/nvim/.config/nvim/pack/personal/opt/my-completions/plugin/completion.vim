lua require('my_completion')

let g:completion_enable_auto_popup = 0
let g:completion_auto_change_source = 1
let g:my_completion_smart_tab = 1

augroup user-completion
    autocmd BufEnter * lua require"my_completion".on_attach()
augroup END

let g:completion_chain_complete_list = [
\    {'complete_items': ['lsp']},
\    {'complete_items': ['ts']},
\    {'complete_items': ['tags']},
\    {'mode': '<c-p>'},
\]
