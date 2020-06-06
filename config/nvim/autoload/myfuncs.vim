function s:comment_affixes()
    let prefix = matchstr(&commentstring, '\S*\(\s*%s\)\@=')
    let suffix = matchstr(&commentstring, '\(\S*\s*%s\)\@<=\S*')
    return [prefix, suffix]
endfunction

" Comment / uncomment the current line
"
" /* some comment */ -> some comment -> /* some comment */
"
" # some comment -> some comment -> # some comment
"
function myfuncs#toggle_commented()
    let [prefix, suffix] = s:comment_affixes()
    let line = getline('.')
    let is_comment = match(line, '^\s*'.escape(prefix, '\*').'\.*') != -1
    if is_comment
        let startline = matchend(line, '^\s*'.escape(prefix, '\*').'\s\?')
        let endline = match(line, '\s\?'.escape(suffix, '\*').'$')
        if endline != -1
            let uncommented = strcharpart(line, startline, endline-startline)
        else
            let uncommented = strcharpart(line, startline)
        endif
        call setline('.', uncommented)
    else
        let commented = prefix
        let commented.= line != '' ? ' '.line : ''
        let commented.= suffix != '' ? ' '.suffix : ''
        call setline('.', commented)
    endif
endfunction

" Create an 80 column wide section header with lines above
" and below the text wrapped in a comment.
function myfuncs#section(words)
    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? " ".prefix : " ".suffix
    let fillchar = '-'
    let ncols = 79

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
function myfuncs#header(words)
    let [prefix, suffix] = s:comment_affixes()
    let suffix = suffix == "" ? "" : " ".suffix
    let prefix.=' '
    let fillchar = '-'
    let ncols = 79

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


" Filter out all tags that are not from the same filetype as the current buffer.
"
" This is sometimes useful in polyglot repos when you want to avoid jumping
" across languages.
"
" Usage:
"   set tagfunc=myfuncs#fttags
"
function myfuncs#fttags(pattern, flags, info)
    let buf = a:info['buf_ffname']
    let ext = fnamemodify(buf, ':e')
    let result = taglist(a:pattern, buf)
    call filter(result, {idx, val -> fnamemodify(val['filename'], ':e') == ext})
    return result
endfunction
