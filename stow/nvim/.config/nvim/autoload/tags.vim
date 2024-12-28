function! tags#toc(index, ...)
    if empty(tagfiles())
        echo 'No tags file.'
        return
    endif
    let l:filter_kinds = a:0 > 0
    let l:exclude_kinds = l:filter_kinds && a:1 == '!'
    let l:kinds = a:000
    let l:fname = expand('%:p')
    let l:items = filter(taglist('.*'), { _, v ->
                \   fnamemodify(v.filename, ':p') == l:fname &&
                \   (
                \     !l:filter_kinds ||
                \     (l:exclude_kinds ? index(l:kinds, v.kind) == -1
                \                      : index(l:kinds, v.kind) != -1)
                \   )
                \ })
    let l:items = map(l:items, {_, v -> s:tag2item(v)})
    if a:index
        let l:items = sort(l:items, {l, r -> char2nr(l.kind) - char2nr(r.kind)})
    else
        let l:items = sort(l:items, {l, r -> l.lnum - r.lnum})
    endif

    let l:title = (a:index ? 'Index' : 'TOC')..(l:filter_kinds ? '|'..join(l:kinds, ',')..'|' : '')..': '..fnamemodify(l:fname, ":.")
    if !empty(l:items)
        call setloclist(0, [], (getloclist(0, {'title': 1}).title == l:title ? 'r' : ' '), {'items': l:items, 'title': l:title})
        botright lopen|wincmd p
    endif
endfunction

function! s:tag2item(tag)
    let l:text = "|"..a:tag.kind.."| "..a:tag.name
    return {
        \'bufnr': bufnr(a:tag.filename),
        \'lnum': split(a:tag.cmd, ';')[0],
        \'text': l:text,
        \'kind': a:tag.kind,
        \}
endfunction
