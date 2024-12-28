if exists('$GIT_INDEX_FILE') | finish | endif

set packpath+=~/Develop/Dotfiles/3rd

command -bang PackList call packer#printpacks(<bang>0)
command -nargs=1 -complete=customlist,packer#completenames PackOpen call packer#openpack(<f-args>)

"{{{ Personal
packadd my-livegrep                            " Start grepping live with :lg
packadd my-filefinder                          " Start simple file finder with :ff
packadd my-statusline
packadd my-tabline
packadd my-git                                 " Git utilities (bloated): Show diff with :dd
packadd my-quickfix                            " Quickfix niceties, mostly limited to quickfix windows
"}}}

"{{{ Third Party
packadd my-lsp                                 " Language Server configurations
packadd my-dirvish                             " Minimalist file browser (customized)

" Treesitter
let disable_treesitter = v:true
if disable_treesitter
    lua vim.treesitter.start = function() end
else
    packadd my-treesitter                          " Language aware highlighting
endif
"}}}

" vim: foldmethod=marker
