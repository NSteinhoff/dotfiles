" Vim compiler file
" Compiler:         Cargo Compiler (extended)
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" Latest Revision:  Mon 25 May 2020 08:31:47 AM

if exists('current_compiler') && current_compiler == 'cargo'
    " Parse test output failures
    " Ignore additional error details
    CompilerSet errorformat+=
                \test\ %f\ -\ %m\ (line\ %l)\ ...\ FAILED,
                \%-G%.%#,
endif
