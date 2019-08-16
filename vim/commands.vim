" vim:foldmethod=marker
"

" Activate :Man command
runtime ftplugin/man.vim

" CUSTOM COMMANDS
" ---------------

"--- General ---{{{
" Escaping modes
" inoremap jk <c-\><c-n>
" tnoremap jk <c-\><c-n>
" vnoremap jk <c-\><c-n>

" Show buffer list and ask for number
nnoremap <leader>b :ls<cr>:b<Space>

" Closing parenthesis
inoremap {{<cr> {<cr>}<esc>O
inoremap [[<cr> [<cr>]<esc>O
inoremap ((<cr> (<cr>)<esc>O

" Navigate splits
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
tnoremap <c-j> <c-w><c-j>
tnoremap <c-k> <c-w><c-k>
tnoremap <c-l> <c-w><c-l>
tnoremap <c-h> <c-w><c-h>

" Remove highlights of last search results
nnoremap <silent> <space> :nohlsearch<Bar>:echo<CR>

" Make arrow keys do something useful -- resizing windows
nnoremap <silent> <Left> :vertical resize -1<CR>
nnoremap <silent> <Right> :vertical resize +1<CR>
nnoremap <silent> <Up> :resize +1<CR>
nnoremap <silent> <Down> :resize -1<CR>

" Execute current file
nnoremap <silent> <leader>ef :!%:p<cr>

" Execute current line
nnoremap <silent> <leader>el :y x<cr>:@x<cr>

" Insert directory of current file in command mode
cnoremap %% <c-r>=fnameescape(expand('%:h')).'/'<cr>
"}}}

"--- Searching ---{{{
" Search for the name under the cursor in all files with the same extension
nnoremap <leader>* *:vimgrep //j **/*%:e \| bo copen<CR>

" Search for the last search pattern in all files with the same extension
nnoremap <leader>/ :vimgrep //j **/*%:e \| bo copen<CR>
"}}}

"--- List item navigation{{{
" Argument list
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

" Buffer list
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>

" Quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>

" Tag match list
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [T :tfirst<CR>
nnoremap ]T :tlast<CR>
"}}}

"--- Filetype specific commands{{{
augroup filetype_commands
    autocmd!
    au BufEnter *vimrc,*.vim nnoremap <buffer> <cr> :silent source %<cr>
    au FileType scala command! -buffer Format execute '!scalafmt % -c ' . expand('~') . '/.scalafmt.conf' | e
    au FileType python command! -buffer Format execute '!black %' | e
    au FileType python,scala nnoremap <leader>f :Format<cr>
augroup END
"}}}

"--- Diffing files{{{
function! RefOrHead(refname)
  if a:refname != ""
    return a:refname
  else
    return "HEAD"
  endif
endfun

function! LoadDiff(fname,refname,ft)
  let ref = RefOrHead(a:refname)
  execute 'vnew ' . a:fname . '_DIFF_' . ref
  execute 'r !git show ' . ref . ':' . a:fname | 1delete
  setlocal buftype=nofile bufhidden=wipe noswapfile | let &l:ft = a:ft
  diffthis | wincmd p | diffthis
endfun

function! LoadPatch(fname,refname)
  let ref = RefOrHead(a:refname)
  execute 'new ' . a:fname . '_PATCH_' . ref
  execute 'r !git diff ' . ref . ' -- ' . a:fname
  setlocal buftype=nofile bufhidden=wipe noswapfile ft=diff
  wincmd K | resize 9 | wincmd p
endfun

function! LoadDiffPatch(fname,refname,ft)
  call LoadPatch(a:fname, a:refname)
  call LoadDiff(a:fname, a:refname, a:ft)
endfun

function! ToggleDiff()
    if &diff == 0
        Diff
    else
        Diffoff
    endif
endfun

function! ListRefs(A,L,P)
    return system("git branch -a --format '%(refname:short)'")
endfun

command! -complete=custom,ListRefs -nargs=? Diff call LoadDiff(expand('%'), <q-args>, &ft)
command! -complete=custom,ListRefs -nargs=? Patch call LoadPatch(expand('%'), <q-args>)
command! -complete=custom,ListRefs -nargs=? DDiff call LoadDiffPatch(expand('%'), <q-args>, &ft)
command! Diffoff wincmd o | diffoff
nnoremap <leader>d :call ToggleDiff()<cr>
"}}}

"--- Show syntax highlight groups{{{
command! Highlights :so $VIMRUNTIME/syntax/hitest.vim
"}}}

"--- Populate/extend arg / buffer lists from external command{{{
command! -nargs=1 -complete=shellcmd Args args `=systemlist(<q-args>)`
command! -nargs=1 -complete=shellcmd Argadd argadd `=systemlist(<q-args>)`
command! -nargs=1 -complete=shellcmd Argl argl `=systemlist(<q-args>)`
command! -nargs=1 -complete=shellcmd Badd badd `=systemlist(<q-args>)`
"}}}

"--- Snippets ---{{{
" Insert current date and time as 'ctime'
iabbrev ddc <C-R>=strftime("%c")<CR>
" Insert current date ctime 'YYYY-MM-DD'
iabbrev ddd <C-R>=strftime("%Y-%m-%d")<CR>
" Insert current date with weekday 'Weekday, YYYY-MM-DD'
iabbrev ddw <C-R>=strftime("%a, %Y-%m-%d")<CR>
"}}}

"--- Make / Compile ---{{{
nnoremap <F5> :make<cr>
nnoremap <F6> :make 
"}}}
