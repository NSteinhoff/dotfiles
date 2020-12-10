nnoremap <buffer> <SPACE> <CMD>call commander#git#load_revision_in_split(getline('.'))<CR>
nnoremap <buffer> <CR> <CMD>call commander#git#load_revision(getline('.'))<CR>
