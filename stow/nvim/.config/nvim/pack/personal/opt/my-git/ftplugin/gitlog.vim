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

let s:banner = []

" let s:help_msg = 'Usage:'
if bufname() =~ '^my-git://TIMELINE: '
    call add(s:banner, '"============================== TIMELINE ======================================')
    call add(s:banner, '" --- File')
    call add(s:banner, '"  i         Split view file at revision')
    call add(s:banner, '"  o         Open file at revision')
    call add(s:banner, '"  <c-space> Add file revision to diff view')

    command -buffer PeekFile call b:peek_file()
    command -buffer OpenFile call b:open_file()
    command -buffer AddToDiff if b:peek_file() != -1 | diffthis | wincmd p | endif
    nnoremap <buffer> i         <cmd>PeekFile<cr>
    nnoremap <buffer> o         <cmd>OpenFile<cr>
    nnoremap <buffer> <c-space> <cmd>AddToDiff<cr>

    call add(s:banner, '" --- Log')
else
    call add(s:banner, '"=============================== GITLOG =======================================')
    nnoremap <buffer> i <NOP>
    nnoremap <buffer> o <NOP>
    nnoremap <buffer> <c-space> <NOP>
endif

call add(s:banner, '"  <space>   Open commit in split')
call add(s:banner, '"  <cr>      Open commit')
call add(s:banner, '"  p         Show (p)atch / diff for a range of commits')
call add(s:banner, '"  R         Start review against commit')
call add(s:banner, '"==============================================================================')

let s:show_banner = 1
if s:show_banner
    call append(0, s:banner)
endif
