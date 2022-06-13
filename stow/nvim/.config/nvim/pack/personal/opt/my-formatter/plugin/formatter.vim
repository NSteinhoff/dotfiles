command! -bar Fmt call formatter#fmt()
command! -bar Fix call formatter#fix()

cnoreabbrev <expr> fmt (getcmdtype() ==# ':' && getcmdline() ==# 'fmt') ? 'Fmt' : 'fmt'
cnoreabbrev <expr> fix (getcmdtype() ==# ':' && getcmdline() ==# 'fix') ? 'Fix' : 'fix'
