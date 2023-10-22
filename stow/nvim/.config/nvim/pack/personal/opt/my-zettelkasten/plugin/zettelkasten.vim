if exists('g:loaded_zettelkasten') | finish | endif
let g:loaded_zettelkasten = 1

let g:zettelkasten = resolve(expand(get(g:, 'zettelkasten', get(environ(), 'ZETTELKASTEN', '~/zettel'))))

command -nargs=1 -complete=customlist,zettelkasten#complete_zettel Zettel call zettelkasten#zettel(<q-args>)
command -nargs=1 -complete=customlist,zettelkasten#complete_tags Ztag cgetexpr zettelkasten#find_tag(<q-args>) | cwindow
command -nargs=1 -complete=customlist,zettelkasten#complete_tags Ztagadd caddexpr zettelkasten#find_tag(<q-args>)
command -nargs=? -complete=customlist,zettelkasten#complete_zettel Ziblings cgetexpr zettelkasten#related(<q-args>) | cwindow
command -nargs=? Zgrep execute 'silent grep! '..expand("<args>")..' '..g:zettelkasten
command -nargs=? Zgrepadd execute 'silent grepadd! '..expand("<args>")..' '..g:zettelkasten

nnoremap <leader>zt :Ztag <c-z>
nnoremap <leader>zz :Zettel <c-z>

augroup zettelkasten
    autocmd!
    execute 'autocmd BufNewFile,BufReadPost '..g:zettelkasten..'/* call zettelkasten#on_attach("<afile>")'
augroup END
