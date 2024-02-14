function! tab#label(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        " Inactive tabs

        let gcwd = fnamemodify(getcwd(-1, -1), ":.")
        let tcwd = fnamemodify(getcwd(-1, a:n), ":.")
        " Make tab paths relative to global working directory
        let cwd = substitute(tcwd, gcwd, gcwd == $HOME ? '~' : '.', '')
        " If it's outside the global working directory, just abbreviate $HOME
        let cwd = substitute(cwd, $HOME, '~', '')

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
            let [prefix; args] = split(name)
            let [term, process, cmd] = split(prefix, ':')
            let [directory, pid] = split(process, '//')
            let procdir = fnamemodify(directory, ':p')
            let windir = fnamemodify(getcwd(), ':p')
            if len(args) > 0
                let cmd .= ' ' .. join(args)
            endif
            return '>_ '..(procdir == windir ? '' : directory..':')..fnamemodify(cmd, ':t')
        else
            let label = name =~ '/$'
                \ ? fnamemodify(name, ':h:t')..'/'
                \ : fnamemodify(name, ':t')
            return a:n != tabpagenr() ? label : '[' .. label .. ']'
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

    if empty(difftarget) | return "" | endif

    return printf(' (<> %s)', difftarget)
endfunction

function! tab#cwd()
    let win = fnamemodify(getcwd(), ":p")
    let tab = fnamemodify(getcwd(-1, tabpagenr()), ":p")

    let cwd = substitute(tab, $HOME, '~', '')
    let cwd = cwd == '~' ? '~/' : cwd

    if win != tab
        let relative_path = substitute(substitute(win, tab, '', ''), $HOME, '~', '')
        let cwd .= '%#TabLineNotice#'
        let cwd .= printf('[%s]', relative_path)
    endif

    return cwd
endfunction

function! tab#highlights(n)
    if a:n != tabpagenr() && getcwd(-1, a:n) != getcwd(-1, 0)
        return '%#TabLineDirectory#'
    else
        return a:n == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    endif
endfunction

function! tab#tabs()
    let s = ''
    for i in range(1, tabpagenr('$'))
        if i > 1|let s .= '|'|endif
        let s .= '%'..i..'T '
        let s .= '%#TabLineFocus#'
        let s .= tab#indicator(i)
        let s .= tab#highlights(i)
        let s .= ' '..tab#label(i)
        let s .= ' '..tab#diff(i)
        let s .= '%T'
        let s .= '%#TabLine#'
    endfor
    return s
endfunction

function! tab#tmux_choose_tree(...)
    echo system("tmux choose-tree")
endfunction

function! tab#tmux_session()
    if !exists('$TMUX') | return "" | endif
    if system('tmux show-options -g status') !~ 'status off' | return "" | endif

    let windowinfo = systemlist("tmux list-windows -F '#S:#I:#P #{window_active}'")
    for info in windowinfo
        let [window, active] = split(info, ' ')
        if active == '0' | continue | endif
        let [session, window, pane] = split(window, ':')
        return printf("%%@tab#tmux_choose_tree@[%s:%d:%d]%%T", session, window, pane)
    endfor

    return ""
endfunction

function! tab#line()
    let s = ''
    let s .= '%#TabLineContext#'
    let s .= tab#tmux_session()
    let s .= '%#TabLine#'
    let s .= tab#tabs()
    let s .= '%#TabLineFill#'
    let s .= '%='
    let s .= '%S '
    let s .= '%#TabLineFocus#'
    let s .= tab#cwd()
    return s
endfunction
