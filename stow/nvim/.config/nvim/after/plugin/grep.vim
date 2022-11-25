if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --glob=!.git/*
    set grepformat=%f:%l:%c:%m
else
    " 'grep' on Ubuntu and MacOS support the '-H' option for showing filenames
    " for single files. This makes the '/dev/null' hack unnecessary.
    set grepprg=grep\ -nH
endif

cnoreabbrev <expr> gg (getcmdtype() ==# ':' && getcmdline() ==# 'gg') ? 'silent grep!' : 'gg'
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'silent grep!' : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'silent lgrep!' : 'lgrep'

function s:lastqf()
    return getwininfo(win_getid())[0].quickfix == 1 && len(getwininfo()) <= 1
endfunction

function s:lastloc()
    return getwininfo(win_getid())[0].loclist == 1 && len(getwininfo()) <= 1
endfunction

augroup grep
    autocmd!
    autocmd QuickfixCmdPost grep if !s:lastqf() | botright cwindow | endif
    autocmd QuickfixCmdPost lgrep if !s:lastloc() | botright lwindow | endif
augroup END
