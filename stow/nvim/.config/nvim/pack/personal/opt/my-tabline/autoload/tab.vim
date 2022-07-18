function! tab#label(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        " Inactive tabs
        let cwd = substitute(fnamemodify(getcwd(-1, a:n), ":."), $HOME, '~', '')
        let cwd = cwd == '~' ? '~' : cwd
        return pathshorten(cwd)..'/'
    else
        " Active tab
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
            if name =~ '/$'
                return fnamemodify(name, ':h:t')..'/'
            else
                return fnamemodify(name, ':t')
            end
        endif
    endif
endfunction

function! tab#indicator(n)
    let buflist = tabpagebuflist(a:n)
    let nbuffers = len(buflist)
    let modified = empty(filter(buflist, {_, v -> getbufinfo(v)[0].changed})) ? '' : '+'
    return nbuffers..modified
endfunction

function! tab#diff(n)
    let difftarget = gettabvar(a:n, 'diff_target')
    let difftarget = !empty(difftarget) ? ' (<> '..difftarget..')' : ''
    return difftarget
endfunction

function! tab#cwd()
    let win = fnamemodify(getcwd(), ":p")
    let tab = fnamemodify(getcwd(-1, tabpagenr()), ":p")

    let cwd = substitute(tab, $HOME, '~', '')
    let cwd = cwd == '~' ? '~/' : cwd

    if win != tab
        let cwd .= '%#TabLineNotice#'
        let cwd .= '['..substitute(substitute(win, tab, '', ''), $HOME, '~', '')..']'
    endif

    return cwd
endfunction

function! tab#highlights(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        return '%#TablineDirectory#'
    else
        return a:n == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    endif
endfunction

function! tab#tabs()
    let s = ''
    for i in range(1, tabpagenr('$'))
        if i > 1|let s .= '|'|endif
        let s .= '%'..i..'T '
        let s .= '%#TablineFocus#'
        let s .= tab#indicator(i)
        let s .= tab#highlights(i)
        let s .= ' '..tab#label(i)
        let s .= ' '..tab#diff(i)
        let s .= ' %T'
        let s .= '%#TabLine#'
    endfor
    return s
endfunction

function! tab#line()
    let s = ''
    let s .= '%#TabLine#'
    let s .= tab#tabs()
    let s .= '%#TabLineFill#'
    let s .= '%='
    let s .= '%#TablineFocus#'
    let s .= tab#cwd()
    return s
endfunction
