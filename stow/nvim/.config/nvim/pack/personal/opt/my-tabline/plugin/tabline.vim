function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let bufname = fnamemodify(bufname(buflist[winnr-1]), ':t')
    return empty(bufname) ? '[No Name]' : bufname
endfunction

function! MyTabIndicators(n)
    let buflist = tabpagebuflist(a:n)
    let nbuffers = len(buflist)
    let modified = empty(filter(buflist, {_, v -> getbufinfo(v)[0].changed})) ? '' : '+'
    return nbuffers..modified
endfunction

function! MyTabDiffTarget(n)
    let difftarget = gettabvar(a:n, 'diff_target')
    let difftarget = !empty(difftarget) ? ' ( '..difftarget..')' : ''
    return difftarget
endfunction


function! MyTabLine()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let highlight = i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        if i > 1|let s .= '|'|endif
        let s .= '%'..i..'T '
        let s .= '%#ProudLine#'
        let s .= '%{MyTabIndicators('..i..')}'
        let s .= highlight
        let s .= ' %{MyTabLabel('..i..')}'
        let s .= ' %{MyTabDiffTarget('..i..')}'
        let s .= ' %T'
        let s .= '%#TabLine#'
    endfor
    let s .= '%#TabLineFill#'
    let s .= '%=%#ProudLine#'
    let cwd = substitute(getcwd(), $HOME, '~', '')
    let cwd = cwd == '~' ? '~/' : cwd
    let s .= ' '..cwd

    return s
endfunction

set tabline=%!MyTabLine()
