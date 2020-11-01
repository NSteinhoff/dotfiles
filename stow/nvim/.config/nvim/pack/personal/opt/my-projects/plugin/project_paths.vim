let g:cwd_paths = {
            \ fnamemodify($HOME, ':t'): '~/dev/dotfiles/,~/dev/dotfiles/stow/',
            \ 's2': '*/src/**,*/packages/*/src/**',
            \}

let g:rcfile_paths = {
            \ 'package.json': 'src/**,packages/*/src/**',
            \ 'setup.py': 'src,test',
            \}
