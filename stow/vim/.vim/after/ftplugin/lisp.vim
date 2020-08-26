set sw=2
set fo=croqlj

let b:repl = 'sbcl'
let b:interpreter = 'sbcl'

command -nargs=1 Apropos ReplSend (apropos <q-args>)
command -nargs=1 Describe ReplSend (describe '<args>)
command Interrupt ReplSend 
command BackToTopLevel ReplSend ABORT
nnoremap <silent> <buffer> s<BS> :BackToTopLevel<CR>
command -nargs=1 Macroexpand ReplSend (macroexpand '<args>)
command -nargs=1 Macroexpand1 ReplSend (macroexpand-1 '<args>)
nnoremap <silent> <buffer> sM ya(:Macroexpand "<CR>
nnoremap <silent> <buffer> sm ya(:Macroexpand1 "<CR>
nnoremap <buffer> sc :Interrupt<CR>

set keywordprg=:Describe
