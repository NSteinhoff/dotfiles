if exists('g:loaded_journal') && !get(g:, 'debug') | finish | endif
let g:loaded_journal = 1

let g:journal_root_dir = get(g:, 'journal_root_dir', get(environ(), 'JOURNAL_ROOT', '~/journal'))
let g:journal_filename = get(g:, 'journal_filename', 'journal.md')


function s:journal(mods) abort
    let path = g:journal_root_dir..'/'..g:journal_filename
    let header = '# '..strftime("%Y %b %d %X")
    execute 'split '..a:mods..' '..path
    call append(0, [header, '', ''])
    call cursor(2, 1)
    startinsert
endfunction
command Journal call s:journal(<q-mods>)


function s:about(topic, mods) abort
    let path = simplify(g:journal_root_dir..'/'..a:topic..'.md')
    let dir = fnamemodify(path, ':h')
    let fname = fnamemodify(path, ':t')
    if empty(finddir(dir))
        let mkdir_result = system('mkdir -p '..dir)
        if v:shell_error | throw mkdir_result | return | endif
    endif
    execute 'split '..a:mods..' '..path
endfunction
command -nargs=? About call s:about(<q-args>, <q-mods>)


function s:apropos(query) abort
    let grep = executable('rg') ? 'rg --vimgrep' : 'grep -n -r'
    let cmd = grep..' '..a:query..' .'
    let Loclist = {d -> setloclist(0, [], ' ', {
        \'lines': map(filter(d, {_, v -> !empty(v)}), {_, v -> g:journal_root_dir..'/'..v}),
        \'efm': &grepformat,
        \'title': 'Apropos: '..a:query
        \})}
    let jobid = jobstart(cmd, {
        \'cwd': fnamemodify(g:journal_root_dir, ':p'),
        \'stdout_buffered': 1,
        \'on_stdout': {c,d,n -> Loclist(d)},
        \'on_exit': {j,c,e -> execute('lwindow')},
        \})
endfunction
command -nargs=1 Apropos call s:apropos(shellescape(<q-args>))
