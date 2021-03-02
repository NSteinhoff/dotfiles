mapclear <buffer>

nnoremap <buffer> - <CMD>exe 'Dirvish %:h'.repeat(':h',v:count1)<CR>

nnoremap <buffer> <CR> <CMD>call dirvish#open('edit', 0)<CR>
nnoremap <buffer> <SPACE> <CMD>call dirvish#open('edit', 0)<CR>
nnoremap <buffer> <C-SPACE> <CMD>call dirvish#open('p', 1)<CR>
nnoremap <buffer> <C-N> j<CMD>call dirvish#open('p', 1)<CR>
nnoremap <buffer> <C-P> k<CMD>call dirvish#open('p', 1)<CR>

nnoremap <buffer> cd <CMD>cd %<CR>

nnoremap <buffer> R <CMD> e %<CR>
nnoremap <buffer> t <CMD>.!xargs tree<CR>
vnoremap <buffer> t :!xargs tree<CR>
nnoremap <buffer> T <CMD>.!xargs tree -a<CR>
vnoremap <buffer> T :!xargs tree -a<CR>

nnoremap <silent> <leader>o <CMD>!open %<CR>

command -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command -buffer PathRemove execute 'set path-='..expand('%')
