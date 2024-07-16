setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=0
setlocal formatexpr&

if ftutils#javascript#use_prettier('%')
    source <sfile>:h/formatter/prettier.vim
    source <sfile>:h/fixer/eslint.vim
else
    source <sfile>:h/formatter/biome.vim
    source <sfile>:h/fixer/biome.vim
endif
