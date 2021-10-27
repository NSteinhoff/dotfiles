function! s:toc(...)
    if empty(tagfiles())
        echo 'No tags file.'
        return
    endif
    let l:index = a:0 && a:1
    let l:fname = expand('%')
    let l:tags = filter(taglist('.*'), {_, v -> v.filename == l:fname})
    let l:items = map(l:tags, {_, v -> s:tag2item(v)})
    if l:index
        let l:tags = sort(l:items, {l, r -> char2nr(l.kind) - char2nr(r.kind)})
        let l:title = 'Index: '..l:fname
    else
        let l:items = sort(l:items, {l, r -> l.lnum - r.lnum})
        let l:title = 'TOC: '..l:fname
    endif
    if !empty(l:items)
        call setloclist(0, [], (getloclist(0, {'title': 1}).title == l:title ? 'r' : ' '), {'items': l:items, 'title': l:title})
        lopen|wincmd p
    endif
endfunction

function! s:tag2item(tag)
    let l:text = "["..a:tag.kind.."] "..a:tag.name
    return {
        \'bufnr': bufnr(a:tag.filename),
        \'lnum': split(a:tag.cmd, ';')[0],
        \'text': l:text,
        \'kind': a:tag.kind,
        \}
endfunction

command TagToc call s:toc()
command TagIndex call s:toc(1)

nnoremap <plug>(tag-toc) <cmd>TagToc<cr>
