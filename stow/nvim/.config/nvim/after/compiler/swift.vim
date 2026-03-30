if exists("current_compiler") | finish | endif
let current_compiler = "swift"
 
let s:save_cpo = &cpoptions
set cpoptions-=C
 
CompilerSet makeprg=swiftc\ -typecheck\ %
 
CompilerSet errorformat=
    \%f:%l:%c:\ %trror:\ %m,
    \%f:%l:%c:\ %tarning:\ %m,
    \%f:%l:%c:\ %tote:\ %m,
    \%-G%.%#
 
let &cpoptions = s:save_cpo
unlet s:save_cpo
