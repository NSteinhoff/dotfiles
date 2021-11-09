let s:debug = 1
" TODO: make operator that converts the text that is moved over

function caseconvert#detect_case(text)
    return  a:text =~# '^\([A-Z][a-z]\+\)\+$'           ? 'p'
        \ : a:text =~# '^\([a-z]\+\)\([A-Z][a-z]\+\)*$' ? 'c'
        \ : a:text =~# '^\([a-z\+\)\(_[a-z]\+\)*$'      ? 's'
        \ : a:text =~# '^\([A-Z\+\)\(_[A-Z]\+\)*$'      ? 'S'
        \ : a:text =~# '^\([a-z]\+\)\(-[a-z]\+\)*$'     ? 'k'
        \ : ''
endfunction

function caseconvert#to_p(text)
    let case = caseconvert#detect_case(a:text)
    return case ==# 'p' ? a:text
       \ : case ==# 'c' ? substitute(a:text, '^\w', '\u&', '')
       \ : case ==# 'k' ? substitute(substitute(a:text, '^\w', '\u&', ''), '\(-\)\(\w\)', '\u\2', 'g')
       \ : case ==# 's' ? substitute(substitute(a:text, '^\w', '\u&', ''), '\(_\)\(\w\)', '\u\2', 'g')
       \ : case ==# 'S' ? substitute(substitute(caseconvert#to_s(a:text), '^\w', '\u&', ''), '\(_\)\(\w\)', '\u\2', 'g')
       \ : a:text
endfunction

function caseconvert#to_c(text)
    let case = caseconvert#detect_case(a:text)
    return case ==# 'c' ? a:text
       \ : case ==# 'p' ? substitute(a:text, '^\w', '\l&', '')
       \ : case ==# 'k' ? substitute(a:text, '\(-\)\(\w\)', '\u\2', 'g')
       \ : case ==# 's' ? substitute(a:text, '\(_\)\(\w\)', '\u\2', 'g')
       \ : case ==# 'S' ? substitute(caseconvert#to_s(a:text), '\(_\)\(\w\)', '\u\2', 'g')
       \ : a:text
endfunction

function caseconvert#to_s(text)
    let case = caseconvert#detect_case(a:text)
    return case ==# 's' ? a:text
       \ : case ==# 'p' ? substitute(substitute(a:text, '^\w', '\l&', ''), '\(\u\)\(\w\)', '_\l\1\2', 'g')
       \ : case ==# 'c' ? substitute(a:text, '\(\u\)\(\w\)', '_\l\1\2', 'g')
       \ : case ==# 'k' ? substitute(a:text, '\(-\)', '_', 'g')
       \ : case ==# 'S' ? substitute(a:text, '\w', '\l&', 'g')
       \ : a:text
endfunction

function caseconvert#to_k(text)
    let case = caseconvert#detect_case(a:text)
    return case ==# 'k' ? a:text
            \ : case ==# 'p' ? substitute(substitute(a:text, '^\w', '\l&', ''), '\(\u\)\(\w\)', '-\l\1\2', 'g')
            \ : case ==# 'c' ? substitute(a:text, '\(\u\)\(\w\)', '-\l\1\2', 'g')
            \ : case ==# 's' ? substitute(a:text, '\(_\)', '-', 'g')
            \ : case ==# 'S' ? substitute(caseconvert#to_s(a:text), '\(_\)', '-', 'g')
            \ : a:text
endfunction

function s:test()
    let v:errors = []
    try
        call assert_equal('p', caseconvert#detect_case('PascalCase'))
        call assert_equal('p', caseconvert#detect_case('PascalCaseIsUgly'))

        call assert_equal('c', caseconvert#detect_case('camelCase'))
        call assert_equal('c', caseconvert#detect_case('camelCaseIsUgly'))

        call assert_equal('s', caseconvert#detect_case('snake_case'))
        call assert_equal('s', caseconvert#detect_case('snake_case_is_nice'))

        call assert_equal('S', caseconvert#detect_case('SNAKE_CASE'))
        call assert_equal('S', caseconvert#detect_case('SNAKE_CASE_IS_NICE'))

        call assert_equal('k', caseconvert#detect_case('kebab-case'))
        call assert_equal('k', caseconvert#detect_case('kebab-case-is-meh'))

        call assert_equal('', caseconvert#detect_case('random_case-isNotAllowed'))

        call assert_equal('PascalCase', caseconvert#to_p('PascalCase'))
        call assert_equal('CamelCase',  caseconvert#to_p('camelCase'))
        call assert_equal('SnakeCase',  caseconvert#to_p('snake_case'))
        call assert_equal('SnakeCase',  caseconvert#to_p('SNAKE_CASE'))
        call assert_equal('KebabCase',  caseconvert#to_p('kebab-case'))

        call assert_equal('pascalCase', caseconvert#to_c('PascalCase'))
        call assert_equal('camelCase',  caseconvert#to_c('camelCase'))
        call assert_equal('snakeCase',  caseconvert#to_c('snake_case'))
        call assert_equal('snakeCase',  caseconvert#to_c('SNAKE_CASE'))
        call assert_equal('kebabCase',  caseconvert#to_c('kebab-case'))

        call assert_equal('camel_case',  caseconvert#to_s('camelCase'))
        call assert_equal('pascal_case', caseconvert#to_s('PascalCase'))
        call assert_equal('snake_case',  caseconvert#to_s('snake_case'))
        call assert_equal('snake_case',  caseconvert#to_s('SNAKE_CASE'))
        call assert_equal('kebab_case',  caseconvert#to_s('kebab-case'))

        call assert_equal('camel-case',  caseconvert#to_k('camelCase'))
        call assert_equal('pascal-case', caseconvert#to_k('PascalCase'))
        call assert_equal('snake-case',  caseconvert#to_k('snake_case'))
        call assert_equal('snake-case',  caseconvert#to_k('SNAKE_CASE'))
        call assert_equal('kebab-case',  caseconvert#to_k('kebab-case'))

        for error in v:errors
            echo error
        endfor
    finally
        let v:errors = []
    endtry
endfunction


if s:debug
    call s:test()
endif
