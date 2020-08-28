setlocal sw=2
setlocal fo=croqlj

let b:repl = 'sbcl'
let b:interpreter = 'sbcl'

" Go all in!
nmap <buffer> <Plug>SendAtom  m`<Plug>ReplSendSelectioniw``
nmap <buffer> <Plug>SendForm  m`<Plug>ReplSendSelectiona(``
nmap <buffer> , <Plug>SendAtom
nmap <buffer> <SPACE> <Plug>SendForm
nmap <buffer> <CR> <Plug>ReplSendBlock

" Debugging and Documentation
command -buffer -nargs=1 Apropos ReplSend (apropos <q-args>)
command -buffer -nargs=1 Describe ReplSend (describe '<args>)
command -buffer -nargs=1 Inspect ReplSend (inspect <args>)
nnoremap <buffer> sA :execute 'Apropos '.expand("<cword>")<CR>
nnoremap <buffer> sD :execute 'Describe '.expand("<cword>")<CR>
nnoremap <buffer> sI :execute 'Inspect '.expand("<cword>")<CR>
setlocal keywordprg=:Describe

" Macro Expansion
command -buffer -nargs=1 Macroexpand ReplSend (macroexpand '<args>)
command -buffer -nargs=1 Macroexpand1 ReplSend (macroexpand-1 '<args>)
nnoremap <silent> <buffer> sM ya(:Macroexpand "<CR>
nnoremap <silent> <buffer> sm ya(:Macroexpand1 "<CR>

" Debugger
command DebuggerAbort ReplSend ABORT
execute 'command DebuggerExit ReplSend '.(b:repl == 'sbcl' ? 'TOPLEVEL' : 'QUIT')
nnoremap <silent> <buffer> s<BS> :DebuggerAbort<CR>
nnoremap <silent> <buffer> s<ESC> :DebuggerExit<CR>
