" Vim compiler file
" Compiler:         Cargo Compiler (adjusted)
" Maintainer:       Niko Steinhoff <niko.steinhoff@gmail.com>
" Latest Revision:  Sat 16 May 2020 11:09:53 AM

if exists('current_compiler') && current_compiler != 'cargo'
	finish
endif

" Ignore additional error details
setlocal errorformat+=%-G%.%#
