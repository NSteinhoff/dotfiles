" Global
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --glob=!.git/*
    set grepformat=%f:%l:%c:%m
else
    " 'grep' on Ubuntu and MacOS support the '-H' option for showing filenames
    " for single files. This makes the '/dev/null' hack unnecessary.
    set grepprg=grep\ -nH
endif

command! -nargs=+ -complete=file_in_path -bar Grep   silent grep! <args>
command! -nargs=+ -complete=file_in_path -bar Lgrep  silent lgrep! <args>

cnoreabbrev <expr> gr    (getcmdtype() ==# ':' && getcmdline() ==# 'gr')    ? 'Grep'  : 'gr'
cnoreabbrev <expr> lgr   (getcmdtype() ==# ':' && getcmdline() ==# 'lgr')   ? 'Lgrep' : 'lgr'

augroup grep
        au QuickfixCmdPost grep,lgrep botright cwindow
augroup END
