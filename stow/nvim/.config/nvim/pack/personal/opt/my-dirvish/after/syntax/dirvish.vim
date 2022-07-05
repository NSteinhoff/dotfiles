highlight default link DirvishPathHead Normal
syn clear DirvishPathHead
execute 'syn match DirvishPathHead ='..expand('%:p'..(get(g:, 'dirvish_relative_paths') ? ':.' : ''))..'\ze.\+=  conceal'
