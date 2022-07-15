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

augroup grep
    autocmd!
    autocmd QuickfixCmdPost grep botright cwindow
    autocmd QuickfixCmdPost lgrep botright lwindow
augroup END
