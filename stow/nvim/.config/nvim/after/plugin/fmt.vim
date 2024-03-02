command! -bar -bang Fmt call fmt#fmt(<bang>0)
command! -bar -bang Fix call fmt#fix(<bang>0)

call abbrev#cmdline('fmt', 'Fmt')
call abbrev#cmdline('fix', 'Fix')
