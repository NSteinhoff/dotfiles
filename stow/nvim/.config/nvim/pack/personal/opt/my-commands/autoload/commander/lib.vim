function commander#lib#peek_lines(lines)
    echo join(a:lines, "\n")
endfunction

function commander#lib#load_lines(lines, ...) abort
    let b:alt_save = expand('#')
    let l:exit_to = get(b:, 'exit_to', expand('%'))
    try
        enew | call append(0, a:lines) | $delete
    catch /.*/
        buffer # | bd # | let @# = b:alt_save
        echoerr 'Unable to load lines: '.v:exception
    endtry
    let b:exit_to = l:exit_to
    set buftype=nofile bufhidden=wipe nobuflisted noswapfile
    0
    nnoremap <buffer> <silent> q :execute 'buffer '.b:exit_to.' \| let @# = b:alt_save'<CR>
    return bufnr()
endfunction

function commander#lib#load_lines_in_split(lines, ...) abort
    let l:splitcmd = a:0 ? a:1.' new' : 'new'
    mark Z
    execute 'topleft '.l:splitcmd
    try
        call append(0, a:lines) | $delete
    catch /.*/
        close
        echoerr 'Unable to load lines in split: '.v:exception
    endtry
    set buftype=nofile bufhidden=wipe nobuflisted noswapfile
    0
    nnoremap <buffer> q :close<CR>`Z
endfunction
command Test call commander#lib#load_lines_in_split(['a', 'b'])

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
    let fillchar = '-'
    let ncols = &tw ? &tw : 79

    " Set the section header text
    let text = a:words == '' ? trim(getline('.')) : a:words

    " Build the rulers line
    let ruler = prefix.repeat(fillchar, ncols - strlen(prefix) - strlen(suffix)).suffix

    " Build the title line
    let titleline = prefix.' '
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
    let prefix.=' '
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

function commander#lib#load_buflist()
    let buffers = getbufinfo({'buflisted': 1})
    let lines = []
    for buffer in buffers
        if buffer.name != ''
            call add(lines, buffer.name)
        endif
    endfor
    call append(0, lines)
    $delete
endfunction
