setlocal sw=2
setlocal fo=croqlj

let b:repl = 'sbcl'
let b:interpreter = 'sbcl'

" Go all in!
nmap <buffer> <CR> <Plug>ReplSendBlockGoToNext

" Panic!
nmap <buffer> s<c-c> <Plug>ReplInterrupt
nmap <buffer> s<c-d> <Plug>ReplEOF

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

" Navigating menus
let keys = '0123456789'  " General
let keys += '?qeruhpl'   " Inspector / Debugger
for k in split(keys, '\zs')
    execute 'nnoremap <buffer> s'.k.' :ReplSend '.k.'<CR>'
endfor

command DebuggerAbort ReplSend ABORT
execute 'command DebuggerExit ReplSend '.(b:repl == 'sbcl' ? 'TOPLEVEL' : 'QUIT')
nnoremap <silent> <buffer> s<BS> :DebuggerAbort<CR>
nnoremap <silent> <buffer> s<ESC> :DebuggerExit<CR>
