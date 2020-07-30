" Minpac Init{{{

augroup minpac
    autocmd!
    autocmd BufWritePost external.vim source <sfile>
augroup END

let s:packdir = expand('~/.local/share/vim/site')
execute 'set packpath+='.s:packdir
if empty(glob(s:packdir)) | exe 'silent !mkdir -p '.s:packdir | endif

" Install minpac as an optional package if it's not already installed.
let minpac_path = s:packdir.'/pack/minpac/opt/minpac'
let minpac_source = 'https://github.com/k-takata/minpac.git'
if empty(glob(minpac_path)) | exe 'silent !git clone '.minpac_source.' '.minpac_path | endif

"}}}

" Managed plugins{{{
function! s:minpac_init() abort
    packadd minpac
    if !exists('*minpac#init') | echom "minpac not installed" | return | endif

    call minpac#init({'dir': s:packdir})
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " ||| ----------------- |||
    " ||| Add plugins below |||
    " ||| ----------------- |||
    " vvv                   vvv

    " Mappings
    call minpac#add('tpope/vim-unimpaired')

    " FTPlugings:
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')
    call minpac#add('vim-scripts/bats.vim')

    " Lisp
    call minpac#add('bhurlow/vim-parinfer')

    " ^^^                   ^^^
    " ||| ----------------- |||
    " ||| Add plugins above |||
    " ||| ----------------- |||

    return 1
endfunction

function! s:minpac_status()
    if <SID>minpac_init() | call minpac#status() | endif
endfunction

function! s:minpac_update()
    if <SID>minpac_init() | call minpac#update('', {'do': 'call minpac#status()'}) | endif
endfunction

function! s:minpac_clean()
    if <SID>minpac_init() | call minpac#clean() | endif
endfunction
"}}}

" Minpac Commands{{{
command! PackStatus call <SID>minpac_status()
command! PackUpdate call <SID>minpac_update()
command! PackClean  call <SID>minpac_clean()
"}}}

" Configuration{{{
" netrw:
let  g:netrw_list_hide  =  netrw_gitignore#Hide()
let  g:netrw_preview    =  1
let  g:netrw_altv       =  1
let  g:netrw_alto       =  0

" vim-python:
let g:python_highlight_all = 1

" parinfer:
let g:vim_parinfer_globs = []
let g:vim_parinfer_filetypes = []
let g:vim_parinfer_mode = 'indent'

"}}}

" vim: foldmethod=marker
