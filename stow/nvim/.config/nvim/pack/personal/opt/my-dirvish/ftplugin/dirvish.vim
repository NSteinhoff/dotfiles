nmap <buffer> <SPACE> <CR>
nmap <buffer> cd <cmd>cd %<CR>
nmap <buffer> q q
command -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command -buffer PathRemove execute 'set path-='..expand('%')
