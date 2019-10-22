source ~/.vimrc

augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost .vimrc,vimrc,init.vim source % "
augroup END

set inccommand=split

"-------------------------------- Providers ---------------------------------{{{
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
    let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
"}}}
