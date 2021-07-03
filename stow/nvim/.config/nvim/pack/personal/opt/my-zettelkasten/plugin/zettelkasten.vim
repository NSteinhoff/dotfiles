if exists('g:loaded_zettelkasten') && !get(g:, 'debug') | finish | endif
" let g:loaded_zettelkasten = 1

let g:zettelkasten = expand(get(g:, 'zettelkasten', get(environ(), 'ZETTELKASTEN', '~/zettel')))

function s:list_zettel()
    return map(globpath(g:zettelkasten, '*.md', 1, 1), { _, v -> substitute(v, g:zettelkasten..'/', '', '') })
endfunction

function s:match_zettel(pattern)
    return filter(s:list_zettel(), { _, v -> v =~ a:pattern })
endfunction

function s:complete_zettel(arglead, cmdline, cursorpos)
    return s:match_zettel(a:arglead)
endfunction

function s:list_tags()
    return  systemlist('rg -I -o --trim '..shellescape('(^|\s)#[a-zA-Z][^ ]*')..' '..g:zettelkasten..' | sort | uniq')
endfunction

function s:list_zettel_tags(zettel)
    return systemlist('rg -I -o --trim '..shellescape('(^|\s)#[a-zA-Z][^ ]*')..' '..g:zettelkasten..'/'..a:zettel..' | sort | uniq')
endfunction

function s:match_tags(pattern)
    return filter(s:list_tags(), { _, v -> v =~ a:pattern })
endfunction

function s:complete_tags(arglead, cmdline, cursorpos)
    return s:match_tags(a:arglead)
endfunction

function s:find_tag(tag)
    return systemlist('rg --vimgrep --smart-case -o '..shellescape(a:tag..'\b')..' '..g:zettelkasten)
endfunction

function s:find_tags(tags)
    if empty(a:tags)
        return []
    endif
    return systemlist('rg --vimgrep --smart-case -o '..shellescape(join(map(a:tags, {_, v -> v..'\b'}), '|'))..' '..g:zettelkasten)
endfunction

function s:related(zettel)
    let zettel = empty(a:zettel) ? expand('%:t') : a:zettel
    let path = g:zettelkasten..'/'..zettel

    if empty(findfile(path))
        return []
    endif

    let tags = s:list_zettel_tags(zettel)
    let related = s:find_tags(tags)
    let related = filter(related, { _, v -> v !~ '^'..path})
    return related
endfunction

function CompleteZettelkasten(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        return start
    endif

    if a:base =~ '^#'
        let l:Item = { _, v -> {'word': v, 'menu': '('..len(s:find_tag(v))..')'}}
        return map(s:match_tags('^'.a:base), l:Item)
    endif

    if a:base =~ '^\[\['
        " This is too expensive unless cached.
        " let l:Item = { _, v -> {'word': '[['..substitute(v, '.md$', '', '')..']]', 'menu': join(s:list_zettel_tags(v))}}
        let l:Item = { _, v -> {'word': '[['..substitute(v, '.md$', '', '')..']]'}}
        return map(s:match_zettel(a:base[2:]), l:Item)
    endif

    let l:Item = { _, v -> {'word': v, 'menu': join(s:list_zettel_tags(v))}}
    return map(s:match_zettel('^'.a:base), l:Item)
endfunction

function s:timestamp()
    return strftime('%Y%m%d%H%M')
endfunction

function s:zettel_name(zettel)
    let root = substitute(fnamemodify(a:zettel, ':t:r'), '^\d\{12}_', '', '')
    let Capitalize = { _, v -> toupper(v[0])..v[1:] }
    let pretty = join(map(split(root, '\s\|_'), Capitalize))
    return pretty
endfunction

function s:zettel(zettel)
    let fname = substitute(a:zettel, ' ', '_', 'g')
    if !empty(findfile(g:zettelkasten..'/'..fname))
        execute 'edit '..g:zettelkasten..'/'..fname
    else
        let fname = (fname =~ '^\d\{12}_' ? '' : strftime('%Y%m%d%H%M')..'_')..fname
        let fname = fname..(fname =~ '\.md$' ? '' : '.md')
        execute 'edit '..g:zettelkasten..'/'..fname
        if empty(getline(1))|call setline(1, '# '..s:zettel_name(fname))|endif
    endif
endfunction

function s:on_attach(fname)
    setl omnifunc=CompleteZettelkasten

    execute 'setl path='..g:zettelkasten
endfunction

command -nargs=1 -complete=customlist,<sid>complete_zettel Zettel call s:zettel(<q-args>)
command -nargs=1 -complete=customlist,<sid>complete_tags Ztags cgetexpr s:find_tag(<q-args>)|cwindow
command -nargs=? -complete=customlist,<sid>complete_zettel Ziblings cgetexpr s:related(<q-args>)|cwindow

augroup zettelkasten
    autocmd!
    execute 'autocmd BufNewFile,BufRead '..g:zettelkasten..'/* call s:on_attach("<afile>")'
augroup END
