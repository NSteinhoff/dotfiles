if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax case match
syntax sync minlines=100

syntax keyword loxStatement     print else for if return while var
syntax keyword loxOperator      and or
syntax keyword loxType          class fun
syntax keyword loxSpecial       super this

syntax match loxComment         "//.*$" contains=loxTodo,@spell

syntax keyword loxBoolean       true false
syntax keyword loxNil           nil

syntax match loxNumber          "\w\@1<!\d\+\(\.\d*\)\?"
syntax match loxOperator        "[+*-/]"
syntax match loxDelimiter       ";"
syntax match loxString          '"[^"]*"'

syntax region loxParen          transparent start='(' end=')' contains=ALLBUT,loxTodo,loxPrint,loxParenError
syntax match  loxParenError     ")"

syntax keyword loxTodo          contained TODO FIXME XXX
highlight link loxComment       Comment

highlight link loxStatement     Statement
highlight link loxNil           Constant
highlight link loxBoolean       Boolean
highlight link loxNumber        Number
highlight link loxString        String
highlight link loxOperator      Operator
highlight link loxType          Type
highlight link loxSpecial       Special

highlight link loxDelimiter     Delimiter
highlight link loxParenError    Error
highlight link loxParenError    Error
highlight link loxTodo          Todo

let b:current_syntax = "lox"

let &cpo = s:cpo_save
unlet s:cpo_save
