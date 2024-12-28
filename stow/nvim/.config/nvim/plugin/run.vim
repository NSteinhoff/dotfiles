command! -nargs=* -range=% Run call run#interpret(bufnr(), <line1>, <line2>, <f-args>)
command! -bang LiveRunBuf call run#prime(<bang>0, 'buf')
command! -bang LiveRunQf call run#prime(<bang>0, 'qf')
