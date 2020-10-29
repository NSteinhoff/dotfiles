" remember the base path, so we can start from blank slate
if !exists('g:cwd_paths')
    let g:cwd_paths = {}
endif
if !exists('g:rcfile_paths')
    let g:rcfile_paths = {}
endif

function s:append_path(path)
    let &l:path = &g:path . ',' . a:path
    echom "Adding '".a:path."' to local path."
endfunction

function s:set_path_for_cwd() abort
    let cwd = fnamemodify(getcwd(), ':t')
    if has_key(g:cwd_paths, cwd)
        let project_path = g:cwd_paths[cwd]
        call s:append_path(project_path)
    endif
endfunction

function s:set_path_for_rcfile(rcfile) abort
    for [rcfile, path] in items(g:rcfile_paths)
        if findfile(rcfile, '') != ''
            call s:append_path(path)
        endif
    endfor
endfunction

function s:init() abort
    call s:set_path_for_cwd()
    call s:set_path_for_rcfile('package.json')
endfunction

augroup projects
    autocmd!
    autocmd VimEnter,DirChanged * call s:init()
augroup END
