lua require('my_completion')

let g:completion_enable_auto_popup = 1
let g:completion_auto_change_source = 1
let g:my_completion_smart_tab = 1

" non ins-complete method should be specified in 'mode'
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp']},
    \{'complete_items': ['ts']},
    \{'complete_items': ['tags']},
\]
