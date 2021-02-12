nmap <buffer> <SPACE> <CR>
nmap <buffer> cd <cmd>cd %<CR>
nmap <buffer> q q
nnoremap <buffer> t <CMD>.!xargs tree<CR>
vnoremap <buffer> t :!xargs tree<CR>
nnoremap <buffer> T <CMD>.!xargs tree -a<CR>
vnoremap <buffer> T :!xargs tree -a<CR>

command -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command -buffer PathRemove execute 'set path-='..expand('%')
