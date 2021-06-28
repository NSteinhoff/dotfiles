let g:show_buffers_in_tabline = 0

function! MyTabLabel(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd()
        return MyTabCwd(-1, a:n)
    else
        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        let bufname = fnamemodify(bufname(buflist[winnr-1]), ':t')
        return empty(bufname) ? '[No Name]' : bufname
    endif
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

function! MyTabCwd(...)
    let cwd = substitute(call("getcwd", a:000), $HOME, '~', '')
    let cwd = cwd == '~' ? '~/' : cwd
    return '  '..cwd
endfunction

function! MyBuffers()
    let s = &showtabline == 2 && get(g:, 'show_buffers_in_tabline') ? '  ' : ''
    let alt = get(getbufinfo('#'), 0)
    for b in getbufinfo({'buflisted': 1})
        let isactive = bufnr() == b.bufnr
        let isalt = b == alt
        let highlight = isactive ? '%#TabLineSel#'
                    \ : isalt    ? '%#TabLine#'
                    \ :            '%#TabLine#'
        let s .= highlight
        let s .= ' '..b.bufnr
        let s .= isalt ? '#' : ''
        let s .= b.changed ? '+' : ''
        let s .= ' '
        let s .= fnamemodify(b.name, ':t')
        let s .= ' %#TabLine#'
    endfor
    return s
endfunction

function! MyTabs()
    let s = &showtabline == 2 && get(g:, 'show_buffers_in_tabline') ? ' 裡' : ''
    for i in range(1, tabpagenr('$'))
        let highlight = i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        if i > 1|let s .= '|'|endif
        let s .= '%'..i..'T '
        let s .= '%#TablineFocus#'
        let s .= '%{MyTabIndicators('..i..')}'
        let s .= highlight
        let s .= ' %{MyTabLabel('..i..')}'
        let s .= ' %{MyTabDiffTarget('..i..')}'
        let s .= ' %T'
        let s .= '%#TabLine#'
    endfor
    return s
endfunction


function! MyTabLine()
    let s = ''
    let s .= '%#TabLine#'
    if tabpagenr('$') == 1 && get(g:, 'show_buffers_in_tabline')
        let s .= MyBuffers()
    else
        let s .= MyTabs()
        let s .= '%#TabLineFill#'
        let s .= '%=%#TablineFocus#'
        let s .= '%{MyTabCwd()}'
    endif
    return s
endfunction

set tabline=%!MyTabLine()
set showtabline=1
