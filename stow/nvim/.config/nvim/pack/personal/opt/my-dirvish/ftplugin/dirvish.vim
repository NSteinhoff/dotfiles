mapclear <buffer>

nnoremap <buffer> - <cmd>exe 'Dirvish %:h'.repeat(':h',v:count1)<cr>
nnoremap <nowait><buffer><silent> dax  :<C-U>arglocal<Bar>silent! argdelete *<Bar>echo "arglist: cleared"<Bar>Dirvish %<CR>

nmap <nowait> <buffer> X <plug>(dirvish_arg)
xmap <nowait> <buffer> X <plug>(dirvish_arg)

nmap <nowait> <buffer> gh <plug>(dirvish_K)
xmap <nowait> <buffer> gh <plug>(dirvish_K)

nnoremap <buffer> <cr> <cmd>call dirvish#open('edit', 0)<cr>
nnoremap <buffer> <space> <cmd>call dirvish#open('edit', 0)<cr>
nnoremap <buffer> <c-space> <cmd>call dirvish#open('p', 1)<cr>
nnoremap <buffer> <c-j> j<cmd>call dirvish#open("p", 1)<cr>
nnoremap <buffer> <c-k> k<cmd>call dirvish#open("p", 1)<cr>

nnoremap <buffer> o <cmd>call mydirvish#add_line_below()<cr>
nnoremap <buffer> O <cmd>call mydirvish#add_line_above()<cr>

nnoremap <buffer> R <cmd>let b:linesave=line('.')<bar>e %<bar>execute b:linesave<cr>
nnoremap <buffer> K <cmd>Expand<cr>
nnoremap <buffer> zc <cmd>set conceallevel=2<cr>
nnoremap <buffer> zo <cmd>set conceallevel=0<cr>
nnoremap <buffer> <expr> za '<cmd>set conceallevel='..(&conceallevel == 0 ? '2' : '0')..'<cr>'
nnoremap <buffer> <nowait> < $T/D
nnoremap <buffer> <nowait> > <cmd>call mydirvish#add_segment()<cr>$

nnoremap <buffer> <nowait> <expr> . ':<C-u>Shdo'.(v:count?'!':'').' {}<Home><C-Right> '
xnoremap <buffer> <nowait> <expr> . ':Shdo {}<Left><Left><Left> '
nnoremap <buffer> <nowait> <expr> cd ':<C-u>'..(v:count ? 'cd' : 'lcd')..' %<Bar>pwd<CR>'
nnoremap <buffer> <nowait> <expr> g. ':<C-u>! '.shellescape(empty(fnamemodify(getline('.'),':.')) ? '.' : fnamemodify(getline('.'),':.')).'<Home><C-Right> '

onoremap <buffer> i/ <cmd>normal! T/vt/<cr>
onoremap <buffer> a/ <cmd>normal! F/vf/<cr>

inoremap <buffer> <c-space> <c-x><c-f>

" Buffer-local / and ? mappings to skip the concealed path fragment.
nnoremap <buffer> / /\ze[^/]*[/]\=$<Home>
nnoremap <buffer> ? ?\ze[^/]*[/]\=$<Home>

nnoremap <buffer> g? <cmd>map <buffer><cr>

nnoremap <buffer> go <cmd>!open %<cr>
nnoremap <buffer> gO <cmd>!open .<cr>

command! -buffer DotfilesToggle let g:dirvish_hide_dotfiles=!get(g:, 'dirvish_hide_dotfiles', v:false)|edit
command! -buffer -bang PathAdd execute 'set path'..(<bang>0 ? '' : '+')..'='..expand('%')
command! -buffer PathRemove execute 'set path-='..expand('%')
" Tree prints the input path, so we can just filter the lines
command! -buffer -range -bang -nargs=* Expand execute '<line1>,<line2>!xargs tree -afiF'..(<bang>0 ? '' : ' -L 1')..' --noreport <args>'|normal $
call abbrev#cmdline('expand', 'Expand', {'buffer': v:true, 'range': v:true})

call shell#create_commands()

silent normal $
