" Options{{{
let s:packdir = expand('~/.vim/pack/personal/')
let s:thispack = s:packdir.'/start/packer/plugin/packer.vim'
"}}}
" Edit personal pack files{{{
function! s:packfiles(arglead, cmdline, cursorpos)
    let paths = glob(s:packdir.a:arglead.'**', 0, 1)
    let Tail = { _, val -> substitute(val, expand(s:packdir), "", "") }
    return map(paths, Tail)
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit
    \ execute 'edit '.s:packdir.<q-args>
"}}}
" Minpac Init{{{
" Install minpac as an optional package if it's not already installed.
let minpac_path = has('nvim') ? '~/.config/nvim/pack/minpac/opt/minpac' : '~/.vim/pack/minpac/opt/minpac'
let minpac_source = 'https://github.com/k-takata/minpac.git'
if empty(glob(minpac_path)) | exe 'silent !git clone '.minpac_source.' '.minpac_path | endif
"}}}
" Managed plugins{{{
if exists('*minpac#init')
    call minpac#init()
    " Minpac is only needed when doing changes to the plugins such as updating
    " or deleting.
    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " ||| ----------------- |||
    " ||| Add plugins below |||
    " ||| ----------------- |||
    " vvv                   vvv

    " Mappings
    call minpac#add('tpope/vim-unimpaired')

    " External Documentation Lookup:
    call minpac#add('romainl/vim-devdocs')

    " FTPlugings:
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')
    call minpac#add('vim-scripts/bats.vim')

    " Lisp
    call minpac#add('bhurlow/vim-parinfer')
endif
"}}}
" Minpac Commands{{{
" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
function! s:make_minpac_cmd(name, expr)
    execute "command! ".a:name." packadd minpac | source ".s:thispack." | ".a:expr
endfunction
call s:make_minpac_cmd("PackUpdate", "call minpac#update('', {'do': 'call minpac#status()'})")
call s:make_minpac_cmd("PackClean",  "call minpac#clean()")
call s:make_minpac_cmd("PackStatus", "call minpac#status()")
"}}}

" vim: foldmethod=marker
