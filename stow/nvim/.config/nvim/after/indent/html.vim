setlocal textwidth=100
setlocal shiftwidth=1   " There is not way to avoid nesting in HTML documents. Accept it!
                        " Using a shiftwidth of 1 means that multi-line
                        " formatted attributes are on the same level as
                        " children.

setlocal formatexpr&
source <sfile>:h/formatter/prettier.vim
