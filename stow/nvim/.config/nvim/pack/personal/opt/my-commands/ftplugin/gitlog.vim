setlocal cursorline

command -buffer PeekCommit call b:peek_commit()
command -buffer OpenCommit call b:open_commit()
command -range -buffer PeekPatch call b:peek_patch(<line1>, <line2>)
command -buffer ReviewCommit execute 'Review '..getline('.')
nnoremap <buffer> <space>   <cmd>PeekCommit<cr>
nnoremap <buffer> <cr>      <cmd>OpenCommit<cr>
nnoremap <buffer> p         <cmd>PeekPatch<cr>
vnoremap <buffer> p         :PeekPatch<cr>
nnoremap <buffer> R         <cmd>ReviewCommit<cr>

let s:help_msg = 'Usage:'
if bufname() =~ '^TIMELINE: '
    let s:help_msg .= ' p(i)eek/(o)pen/(p)atch file; <c-space> add to diff; '
    command -buffer PeekFile call b:peek_file()
    command -buffer OpenFile call b:open_file()
    command -buffer AddToDiff if b:peek_file() != -1 | diffthis | wincmd p | endif

    nnoremap <buffer> i         <cmd>PeekFile<cr>
    nnoremap <buffer> o         <cmd>OpenFile<cr>
    nnoremap <buffer> <c-space> <cmd>AddToDiff<cr>
else
    nnoremap <buffer> i <NOP>
    nnoremap <buffer> o <NOP>
    nnoremap <buffer> <c-space> <NOP>
endif

let s:help_msg .= ' <space>/<cr> peek/open commit'
if getline(1) != s:help_msg
    call append(0, s:help_msg)
endif
