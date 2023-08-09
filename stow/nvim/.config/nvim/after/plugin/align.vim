" Using 'sed' and 'column' external tools
command! -nargs=? -range Align execute
    \ '<line1>,<line2>!sed -E '
    \ .."'s/" .. (expand('<args>') == '' ? '[[:blank:]]+' : '[[:blank:]]*<args>[[:blank:]]*')..'([^$])/~@~<args> \1' .. "/g' "
    \ ..'| '."column -s'~@~' -t"
