function s:comment_affixes()
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=')
    let suffix = matchstr(&commentstring, '\(\S*\s*%s\)\@<=\S*')
    if empty(prefix)
        let prefix = '/'
    endif
    return [prefix, suffix]
endfunction

function s:help_header(words, sub = v:false)
    let fillchar = a:sub ? '-' : '='
    let ncols = 79
    let text = a:words == '' ? trim(s:getline(prefix)) : a:words
    let link = tolower(text)
    let link = substitute(link, '\s', '-', 'g')
    let link = '*'..link..'*'

    let ruler = repeat(fillchar, ncols)
    let title = text..repeat(' ', ncols - strlen(text) - strlen(link) - 5)..link
    call setline(line('.'), title)
    call append(line('.')-1, ruler)
endfunction

function s:getline(prefix)
    return substitute(getline('.'), '^'..escape(a:prefix, '/'), '', '')
endfunction

" Create an 80 column wide section header with lines above
" and below the text wrapped in a comment.
function section#header(words)
    if &ft == 'help'
        call s:help_header(a:words)
        return
    endif

    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? " ".prefix : " ".suffix
    let prefix = prefix..' '
    let fillchar = '-'
    let ncols = &tw ? &tw : 79

    " Set the section header text
    let text = a:words == '' ? trim(s:getline(prefix)) : a:words

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
function section#subheader(words)
    if &ft == 'help'
        call s:help_header(a:words, v:true)
        return
    endif
    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? "" : " ".suffix
    let prefix = prefix..' '
    let fillchar = '-'
    let ncols = &tw ? &tw : 79

    " Set the text that goes in-between the separators
    let text = a:words == '' ? trim(s:getline(prefix)) : a:words
    let text = text == "" ? "" : ' '.text.' '

    " TODO: This does not play nice with tab indentation!
    " We start at the current cursor column, divide the rule into two
    " parts and fit the text in-between
    let cstart = 0 " col('.')
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
