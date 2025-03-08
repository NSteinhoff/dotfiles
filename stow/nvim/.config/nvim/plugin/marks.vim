command! NoShowMarks call marks#disable()
command! ShowMarks call marks#enable()
command! ToggleMarks call marks#toggle()

""" Show global marks
command! -nargs=* -complete=customlist,s:complete_marks Marks execute 'marks '..(empty(<q-args>) ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>)
command! -nargs=* -bang -complete=customlist,s:complete_marks Delmarks execute 'delmarks '..(<bang>0 ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>) | echo "Cleared Marks!"

nnoremap <plug>(list-marks) <cmd>Marks<cr>

ShowMarks
