let g:show_buffers_in_tabline = 0

function MyTabLabel(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        let cwd = substitute(fnamemodify(getcwd(-1, a:n), ":."), $HOME, '~', '')
        let cwd = cwd == '~' ? '~/' : cwd
        return '  '..pathshorten(cwd)
    else
        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        let name = bufname(buflist[winnr-1])
        if empty(name)
            return '[No Name]'
        endif

        if name =~ '^term:'
            let [term, process, cmd] = split(name, ':')
            let [directory, pid] = split(process, '//')
            let procdir = fnamemodify(directory, ':p')
            let windir = fnamemodify(getcwd(), ':p')
            return '>_ '..(procdir == windir ? '' : directory..':')..fnamemodify(cmd, ':t')
        else
            return fnamemodify(name, ':t')
        endif
    endif
endfunction

function MyTabIndicators(n)
    let buflist = tabpagebuflist(a:n)
    let nbuffers = len(buflist)
    let modified = empty(filter(buflist, {_, v -> getbufinfo(v)[0].changed})) ? '' : '+'
    return nbuffers..modified
endfunction

function MyTabDiffTarget(n)
    let difftarget = gettabvar(a:n, 'diff_target')
    let difftarget = !empty(difftarget) ? ' ( '..difftarget..')' : ''
    return difftarget
endfunction

function MyTabCwd()
    let win = fnamemodify(getcwd(), ":p")
    let tab = fnamemodify(getcwd(-1, tabpagenr()), ":p")

    let cwd = substitute(tab, $HOME, '~', '')
    let cwd = cwd == '~' ? '~/' : cwd

    if win != tab
        let cwd .= '%#TabLineNotice#'
        let cwd .= '['..substitute(substitute(win, tab, '', ''), $HOME, '~', '')..']'
    endif

    return '  '..cwd
endfunction

function MyBuffers()
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

function MyTabHighlights(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        return '%#TablineDirectory#'
    else
        return a:n == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    endif
endfunction

function MyTabs()
    let s = &showtabline == 2 && get(g:, 'show_buffers_in_tabline') ? ' 裡' : ''
    for i in range(1, tabpagenr('$'))
        if i > 1|let s .= '|'|endif
        let s .= '%'..i..'T '
        let s .= '%#TablineFocus#'
        let s .= MyTabIndicators(i)
        let s .= MyTabHighlights(i)
        let s .= ' '..MyTabLabel(i)
        let s .= ' '..MyTabDiffTarget(i)
        let s .= ' %T'
        let s .= '%#TabLine#'
    endfor
    return s
endfunction

function MyTabLine()
    let s = ''
    let s .= '%#TabLine#'
    if tabpagenr('$') == 1 && get(g:, 'show_buffers_in_tabline')
        let s .= MyBuffers()
    else
        let s .= MyTabs()
        let s .= '%#TabLineFill#'
        let s .= '%='
        let s .= '%#TablineFocus#'
        let s .= MyTabCwd()
    endif
    return s
endfunction

set tabline=%!MyTabLine()
set showtabline=2
