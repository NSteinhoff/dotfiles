function s:can_be_alt(bufname)
    return !empty(a:bufname) && buflisted(a:bufname)
endfunction

function commander#lib#temp_buffer(lines, name, filetype, ...)
    let options = a:0 ? a:1 : {}

    let bufnr = bufnr('^'..a:name..'$')
    if bufnr > 0
        " execute 'buffer '..bufnr
        return bufnr
    endif

    let create = get(options, 'cmd', 'enew')

    let undosteps = []
    if !empty(@%)
        call add(undosteps, "buffer '"..@%.."'")
    endif
    if s:can_be_alt(@#)
        call add(undosteps, "let @# = '"..@#.."'")
    endif

    let initsteps = []
    if s:can_be_alt(@#)
        call add(initsteps, "let @# = '"..@#.."'")
    endif
    call add(initsteps, "file "..a:name) 
    call add(initsteps, "set ft="..a:filetype) 

    try
        execute create
        set buftype=nofile bufhidden=wipe nobuflisted noswapfile
    catch
        echom 'Unable to create buffer: '.v:exception
        for step in undosteps|execute step|endfor
    endtry

    try
        call append(0, a:lines) | $delete
    catch
        echom 'Unable to load lines: '.v:exception
        for step in undosteps|execute step|endfor

        return -1
    endtry

    for step in initsteps
        try
            execute step
        catch
            echom "Error executing init step '"..step.."'"
            for step in undosteps|execute step|endfor
            return -1
        endtry
    endfor

    1 " Got to the first line
    return bufnr()
endfunction

function s:comment_affixes()
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=')
    let suffix = matchstr(&commentstring, '\(\S*\s*%s\)\@<=\S*')
    return [prefix, suffix]
endfunction

" Create an 80 column wide section header with lines above
" and below the text wrapped in a comment.
function commander#lib#section(words)
    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? " ".prefix : " ".suffix
    let prefix = prefix..' '
    let fillchar = '-'
    let ncols = &tw ? &tw : 79

    " Set the section header text
    let text = a:words == '' ? trim(getline('.')) : a:words

    " Build the rulers line
    let ruler = prefix.repeat(fillchar, ncols - strlen(prefix) - strlen(suffix)).suffix

    " Build the title line
    let titleline = prefix
    let titleline.= repeat(' ', (ncols - strlen(titleline) - strlen(text) - strlen(suffix)) / 2)
    let titleline.= text
    let titleline.= repeat(' ', ncols - strlen(titleline) - strlen(suffix))
    let titleline.= suffix

    " Set the current line to the section header and position the cursor at the end.
    call setline(line('.'), titleline)
    call append(line('.')-1, ruler)
    call append(line('.'), ruler)

    call cursor(line('.')+1, col('$'))
endfunction

" Create an 80 column wide header starting at the current cursor position. The
" header text can be passed as an arguments or left blank to use the entire
" line. With no argument and an empty line, will simply draw the separator
" line.
function commander#lib#header(words)
    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? "" : " ".suffix
    let prefix = prefix..' '
    let fillchar = '-'
    let ncols = &tw ? &tw : 79

    " Set the text that goes in-between the separators
    let text = a:words == '' ? trim(getline('.')) : a:words
    let text = text == "" ? "" : ' '.text.' '

    " We start at the current cursor column, divide the rule into two
    " parts and fit the text in-between
    let cstart = col('.')
    let width = ncols - cstart
    let sepwidth = (width - strlen(text) - strlen(prefix)) / 2

    " Build the header line
    let header =
        \ repeat(' ', cstart-1)
        \ .prefix
        \ .repeat(fillchar, sepwidth)
        \ .text

    " Because of odd column numbers, this might not be the same width as the
    " fill before the header text. This ensures that we always hit the desired
    " total width
    let fill_after = repeat(fillchar, ncols - strlen(header) - strlen(suffix)).suffix

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), header.fill_after)
    call cursor(line('.'), col('$'))
endfunction
