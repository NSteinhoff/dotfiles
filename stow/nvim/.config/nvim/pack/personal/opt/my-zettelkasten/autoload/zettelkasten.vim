let s:add_timestamp_to_file = 1

" Zettel timestamp
function s:timestamp()
    return strftime('%Y%m%d%H%M')
endfunction

" Get the stem of the Zettel name
function s:header(fname)
    let root = fnamemodify(a:fname, ':t:r')
    let Capitalize = { _, v -> toupper(v[0])..v[1:] }
    let pretty = join(map(split(root, '\s\|_'), Capitalize))
    return pretty
endfunction

" List all Zettel in the Zettelkasten
function s:list_zettel()
    let l:files = globpath(g:zettelkasten, '*.md', 1, 1)
    let l:files = map(l:files, { _, v -> substitute(v, g:zettelkasten..'/', '', '') })
    let l:files = filter(l:files, {_, v -> v != 'index.md' })

    return l:files
endfunction

" Find all Zettel that match a pattern
function s:match_zettel(pattern)
    return filter(s:list_zettel(), { _, v -> v =~ a:pattern })
endfunction

" Completion function for Zettel names
function zettelkasten#complete_zettel(arglead, cmdline, cursorpos)
    return s:match_zettel(a:arglead)
endfunction

" Return a list of tags
"
" When a filename is provided, only the tags in that file are listed.
function s:list_tags(...)
    let path = g:zettelkasten..(a:0 ? '/'..a:1 : '')
    return systemlist('rg -I -t md -o --trim '..shellescape('(^|\s)#[a-zA-Z][^ ]*')..' '..path..' | sort | uniq')
endfunction

" Find all tags that match a pattern
function s:match_tags(pattern)
    return filter(s:list_tags(), { _, v -> v =~ a:pattern })
endfunction

" Completion function for tags
function zettelkasten#complete_tags(arglead, cmdline, cursorpos)
    return s:match_tags(a:arglead)
endfunction

" List all Zettel that contain the input tag
function zettelkasten#find_tag(tag)
    return systemlist('rg --vimgrep --smart-case -t md -o '..shellescape(a:tag..'\b')..' '..g:zettelkasten)
endfunction

" List all Zettel that contain any of the input tags
function zettelkasten#find_tags(tags)
    if empty(a:tags)
        return []
    endif
    return systemlist('rg --vimgrep --smart-case -t md -o '..shellescape(join(map(a:tags, {_, v -> v..'\b'}), '|'))..' '..g:zettelkasten)
endfunction

" List all Zettels that contain the same tags as the input Zettel
function zettelkasten#related(fname)
    let fname = empty(a:fname) ? expand('%:t') : a:fname
    let path = g:zettelkasten..'/'..fname

    if empty(findfile(path))
        return []
    endif

    let tags = s:list_tags(fname)
    let related = zettelkasten#find_tags(tags)
    let related = filter(related, { _, v -> v !~ '^'..path})
    return related
endfunction

" Omnicompletion for Zettel
"
" * `#...`: tags
" * `[[...`: Zettel names
function zettelkasten#omnifunc(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        return start
    endif

    if a:base =~ '^#'
        let l:Item = { _, v -> {'word': v}}
        return map(s:match_tags('^'.a:base), l:Item)
    endif

    if a:base =~ '^\[\['
        let l:Create_item = { _, v -> {'word': '['..substitute(substitute(v, '.md$', '', ''), '_', '-', 'g')..']('..v..')', 'menu': join(s:list_tags(v))}}
        return map(s:match_zettel(a:base[2:]), l:Create_item)
    endif

    return []
endfunction

" Open named Zettel or create a new one
function zettelkasten#zettel(zettel)
    let fname = substitute(tolower(a:zettel), ' ', '_', 'g')
    if !empty(findfile(g:zettelkasten..'/'..fname))
        execute 'edit '..g:zettelkasten..'/'..fname
    else
        " Ensure markdown extension
        let fname = fname..(fname =~ '\.md$' ? '' : '.md')

        execute 'edit '..g:zettelkasten..'/'..fname
        if empty(getline(1))
            call setline(1, ['# '..s:header(fname), '', '```', '#untagged', '```', ''])
        endif
    endif
endfunction

" Attach a new Zettel buffer
function zettelkasten#on_attach(fname)
    setl omnifunc=zettelkasten#omnifunc

    execute 'setl path='..g:zettelkasten
    nnoremap <buffer> <leader>zr :Ziblings<cr>
endfunction
