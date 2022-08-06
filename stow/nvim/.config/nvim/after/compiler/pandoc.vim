" Vim compiler file
" Compiler:         Pandoc
" Maintainer:       Niko Steinhoff <niko.steinhoff@pm.me>
" Latest Revision:  Fri Aug  5 2022 08:47:15 AM

if exists('current_compiler')
    finish
endif

let current_compiler = "pandoc"
execute 'CompilerSet makeprg=pandoc\ $*\ --to\ html5+smart\ --standalone\ --metadata\ title=%:t:r\ --output\ %:r.html\ --css='..expand("$PANDOC_CSS")..'\ %'
