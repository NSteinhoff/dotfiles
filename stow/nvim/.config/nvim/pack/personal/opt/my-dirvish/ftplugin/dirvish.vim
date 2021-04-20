mapclear <buffer>

nnoremap <buffer> - <CMD>exe 'Dirvish %:h'.repeat(':h',v:count1)<CR>

nnoremap <buffer> <CR> <CMD>call dirvish#open('edit', 0)<CR>
nnoremap <buffer> <SPACE> <CMD>call dirvish#open('edit', 0)<CR>
nnoremap <buffer> <C-SPACE> <CMD>call dirvish#open('p', 1)<CR>
nnoremap <buffer> <expr> <C-N> pumvisible() ? '<C-N>' : 'j<CMD>call dirvish#open("p", 1)<CR>'
nnoremap <buffer> <expr> <C-P> pumvisible() ? '<C-P>' : 'k<CMD>call dirvish#open("p", 1)<CR>'

nnoremap <buffer> R <CMD>e %<CR>
nnoremap <buffer> cd <CMD>cd %<CR>
nnoremap <buffer> K <CMD>Tree<CR>
nnoremap <buffer> <expr> zc '<CMD>set conceallevel='..(&conceallevel == 0 ? '2' : '0')..'<CR>'
nnoremap <buffer> <nowait> < $T/D
nnoremap <buffer> <nowait> > 0df/

command -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command -buffer PathRemove execute 'set path-='..expand('%')
" Tree prints the input path, so we can just filter the lines
command -buffer -range -nargs=* -bang Tree execute '<line1>,<line2>!xargs tree -fi'..(<bang>0 ? 'a' : '')..' --noreport <args>'

autocmd! dirvish_buflocal TextChanged,TextChangedI

augroup my-dirvish
    autocmd!
    autocmd TextChanged,InsertLeave <buffer> syn clear DirvishPathHead | execute 'syn match DirvishPathHead ='..expand("%:p:.")..'\ze.\+=  conceal'
augroup END
