mapclear <buffer>

nnoremap <buffer> - <cmd>exe 'Dirvish %:h'.repeat(':h',v:count1)<cr>
vmap <buffer> x <Plug>(dirvish_arg)
nnoremap <nowait><buffer><silent> dax  :<C-U>arglocal<Bar>silent! argdelete *<Bar>echo "arglist: cleared"<Bar>Dirvish %<CR>

nnoremap <buffer> <cr> <cmd>call dirvish#open('edit', 0)<cr>
nnoremap <buffer> <space> <cmd>call dirvish#open('edit', 0)<cr>
nnoremap <buffer> <c-space> <cmd>call dirvish#open('p', 1)<cr>
nnoremap <buffer> <c-j> j<cmd>call dirvish#open("p", 1)<cr>
nnoremap <buffer> <c-k> k<cmd>call dirvish#open("p", 1)<cr>

nnoremap <buffer> R <cmd>let b:linesave=line('.')<bar>e %<bar>execute b:linesave<cr>
nnoremap <buffer> cd <cmd>lcd %<cr>
nnoremap <buffer> K <cmd>Tree<cr>
nnoremap <buffer> zc <cmd>set conceallevel=2<cr>
nnoremap <buffer> zo <cmd>set conceallevel=0<cr>
nnoremap <buffer> <expr> za '<cmd>set conceallevel='..(&conceallevel == 0 ? '2' : '0')..'<cr>'
nnoremap <buffer> <nowait> < $T/D
nnoremap <buffer> <nowait> > <cmd>call <sid>add_segment()<cr>$

onoremap <buffer> i/ <cmd>normal! T/vt/<cr>
onoremap <buffer> a/ <cmd>normal! F/vf/<cr>

" Buffer-local / and ? mappings to skip the concealed path fragment.
nnoremap <buffer> / /\ze[^/]*[/]\=$<Home>
nnoremap <buffer> ? ?\ze[^/]*[/]\=$<Home>

command -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command -buffer PathRemove execute 'set path-='..expand('%')
" Tree prints the input path, so we can just filter the lines
command -buffer -range -nargs=* -bang Tree execute '<line1>,<line2>!xargs tree -afiF -L 1'..(<bang>0 ? 'a' : '')..' --noreport <args>'|normal $
command -buffer -range -nargs=* -bang Mv if <range> < 2| echo ":Mv command needs a range." | else | execute '<line1>,<line2>w !xargs '..(<bang>0 ? 'echo ' : '')..'mv <args>' | endif
command -buffer -range -nargs=* -bang Cp if <range> < 2| echo ":Cp command needs a range." | else | execute '<line1>,<line2>w !xargs '..(<bang>0 ? 'echo ' : '')..'cp <args>' | endif
command -buffer -range -nargs=* -bang Rm execute '<line1>,<line2>w !xargs '..(<bang>0 ? 'echo ' : '')..'rm <args>'

function! s:add_segment()
    let lnum = line('.')
    let head = getline(lnum)
    let path = expand('%:p'..(get(g:, 'dirvish_relative_paths') ? ':.' : ''))
    if path =~# '^'..escape(head, '/.')
        let tail = substitute(path, escape(head, '/.'), '', '')
        let segment = matchstr(tail, '^.\{-}/')
        call setline(lnum, head..segment)
    endif
endfunction

autocmd! dirvish_buflocal TextChanged,TextChangedI

silent normal $
