if exists('g:loaded_zettelkasten') | finish | endif
let g:loaded_zettelkasten = 1

let g:zettelkasten = expand(get(g:, 'zettelkasten', get(environ(), 'ZETTELKASTEN', '~/zettel')))

command -nargs=1 -complete=customlist,zettelkasten#complete_zettel Zettel call zettelkasten#zettel(<q-args>)
command -nargs=1 -complete=customlist,zettelkasten#complete_tags Ztag cgetexpr zettelkasten#find_tag(<q-args>)
command -nargs=1 -complete=customlist,zettelkasten#complete_tags Ztagadd caddexpr zettelkasten#find_tag(<q-args>)
command -nargs=? -complete=customlist,zettelkasten#complete_zettel Ziblings cgetexpr zettelkasten#related(<q-args>)

augroup zettelkasten
    autocmd!
    execute 'autocmd BufNewFile,BufRead '..g:zettelkasten..'/* call zettelkasten#on_attach("<afile>")'
augroup END
