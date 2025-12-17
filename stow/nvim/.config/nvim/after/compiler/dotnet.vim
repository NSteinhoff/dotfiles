" Vim compiler file
" Compiler:         Dotnet Compiler
" Maintainer:       Niko Steinhoff <niko.steinhoff@pm.me>
" Latest Revision   Sun Nov 16 11:08:38 2025

if exists('current_compiler') && current_compiler != 'dotnet'
    finish
endif

" Base this compiler on the builtin 'dotnet'
runtime compiler/dotnet.vim

if glob('*.csproj') == ""
     CompilerSet makeprg=dotnet\ build\ --nologo\ $*
endif
