" Using 'sed' and 'column' external tools
command! -nargs=? -range Align execute
    \ '<line1>,<line2>!sed -E '
    \ ."'s/".(expand('<args>') == '' ? '[[:blank:]]+' : '\s*<args>\s*').'/ ~<args> '."/g' "
    \ .'| '."column -s'~' -t"
