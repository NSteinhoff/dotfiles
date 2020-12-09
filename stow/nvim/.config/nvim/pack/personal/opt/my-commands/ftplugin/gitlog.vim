nnoremap <buffer> <SPACE> <CMD>echo join(commander#git#file_revision(getline('.')), "\n")<CR>
nnoremap <buffer> <CR> <CMD>call commander#git#load_revision_in_split(getline('.'))<CR>
