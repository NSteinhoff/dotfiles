setlocal sw=2

if ftutils#javascript#use_prettier('%')
    source <sfile>:h/formatter/prettier.vim
else
    source <sfile>:h/formatter/biome.vim
endif
