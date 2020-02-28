function! myfuncs#header(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=').' '
    let fillchar = '-'
    let ncols = 79

    " Set the text that goes in-between the separators
    if a:words != ''
        let text = ' '.a:words
    elseif expand('<cword>') != ''
        let text = ' '.expand('<cword>')
    else
        let text = ''
    endif

    " Build the rulers line
    let ruler = prefix.repeat(fillchar, ncols - strlen(prefix))

    " Build the title line
    let title = prefix.text

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), title)
    call append(line('.')-1, ruler)
    call append(line('.'), ruler)

    call cursor(line('.')+1, col('$'))
endfunction

" Create an 80 column wide header starting at the current cursor
" position. The header text can be passed as an arguments or left blank
" to use the word under the cursor. With no argument or word under
" cursor, will simply draw the separator line.
function! myfuncs#center(words)
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=').' '
    let fillchar = '-'
    let ncols = 79
    "
    " Set the text that goes in-between the separators
    if a:words != ''
        let text = ' '.a:words.' '
    elseif expand('<cword>') != ''
        let text = ' '.expand('<cword>').' '
    else
        let text = ''
    endif

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
    let fill_after = repeat(fillchar, ncols - strlen(header))

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), header.fill_after)
    call cursor(line('.'), col('$'))
endfunction
