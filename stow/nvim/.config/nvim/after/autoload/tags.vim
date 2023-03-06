function! tags#refresh_buf(filename)
    let tagfiles = tagfiles()
    if len(tagfiles) == 0|return|endif
    let tagfile = tagfiles[0]
    let opt = {'cwd': fnamemodify(tagfile, ":h")}
    let cmd = ["ctags", "--tag-relative=no", a:filename]
    call jobstart(cmd, opt)
endfunction

function! tags#toc(index, ...)
    if empty(tagfiles())
        echo 'No tags file.'
        return
    endif
    let l:kind = a:0 ? a:1 : ''
    let l:fname = expand('%:p')
    let l:items = filter(taglist('.*'), { _, v -> fnamemodify(v.filename, ':p') == l:fname && (l:kind == '' || v.kind == l:kind) })
    let l:items = map(l:items, {_, v -> s:tag2item(v)})
    if a:index
        let l:items = sort(l:items, {l, r -> char2nr(l.kind) - char2nr(r.kind)})
    else
        let l:items = sort(l:items, {l, r -> l.lnum - r.lnum})
    endif

    let l:title = (a:index ? 'Index' : 'TOC')..(l:kind == '' ? '' : '|'..l:kind..'|')..': '..l:fname
    if !empty(l:items)
        call setqflist([], (getqflist({'title': 1}).title == l:title ? 'r' : ' '), {'items': l:items, 'title': l:title})
        botright copen|wincmd p
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
