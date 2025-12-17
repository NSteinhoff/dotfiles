setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=0
setlocal formatexpr&

if ftutils#javascript#use_biome('%')
    source <sfile>:h/formatter/biome.vim
elseif ftutils#javascript#use_prettier('%')
    source <sfile>:h/formatter/prettier.vim
else
    source <sfile>:h/formatter/biome.vim
endif
