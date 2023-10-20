highlight default link DirvishPathHead Normal
syn clear DirvishPathHead
" Only conceal the current buffer's name, i.e. the directory, not expanded
" subdirectories
execute 'syn match DirvishPathHead ='..expand('%:p'..(get(g:, 'dirvish_relative_paths') ? ':.' : ''))..'\ze.\+=  conceal'
