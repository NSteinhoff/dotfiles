setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=0

function s:style()
    let indend_width = &shiftwidth ? &shiftwidth : &tabstop
    let use_tab = &expandtab ? 'Never' : 'AlignWithSpaces'
    let column_limit = &textwidth ? &textwidth : 100
    let tab_width = &tabstop

    " There is also a .clang-format with the same settings, but this allows
    " changing the indentation settings on the fly.
    let l:style = '"{'
    let l:style.= 'BasedOnStyle: llvm'
    let l:style.= ', ColumnLimit: '..column_limit
    let l:style.= ', UseTab: '..use_tab
    let l:style.= ', TabWidth: '..tab_width
    let l:style.= ', IndentWidth: '..indend_width
    let l:style.= ', ContinuationIndentWidth: '..indend_width
    let l:style.= ', AlwaysBreakBeforeMultilineStrings: true'
    let l:style.= ', BreakBeforeTernaryOperators: true'
    let l:style.= ', IndentGotoLabels: true'
    let l:style.= ', ReflowComments: false'
    let l:style.= ', BreakStringLiterals: false'
    let l:style.= ', AlignArrayOfStructures: Left'
    let l:style.= ', AlignOperands: AlignAfterOperator'
    let l:style.= ', AllowShortBlocksOnASingleLine: Never'
    let l:style.= ', AllowShortFunctionsOnASingleLine: false'
    let l:style.= ', AllowShortCaseLabelsOnASingleLine: true'
    let l:style.= ', AllowShortIfStatementsOnASingleLine: WithoutElse'
    let l:style.= ', AllowShortLoopsOnASingleLine: true'
    let l:style.= ', AllowShortEnumsOnASingleLine: true'
    " let l:style.= ', AlignConsecutiveDeclarations: Consecutive'
    " let l:style.= ', AlignConsecutiveAssignments: Consecutive'
    " let l:style.= ', AlignAfterOpenBracket: AlwaysBreak'
    let l:style.= '}"'

    return l:style
endfunction

function s:create_fmt()
    return 'clang-format --assume-filename=file.c --style='..s:style()
endfunction

function s:create_fix()
    return 'clang-tidy --fix --format-style='..s:style()..' '..expand('%')
endfunction

if executable('clang-format')
    let b:formatprgfunc = function('s:create_fmt')
endif

if executable('clang-tidy')
    let b:fixprgfunc = function('s:create_fix')
endif
