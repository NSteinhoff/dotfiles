compiler go

nnoremap <buffer> <cr> <cmd>w<bar>make %<bar>!./%:r<cr>
iabbrev <buffer> :pr: fmt.Println()<left>
iabbrev <buffer> :prn: fmt.Printf("\n")<c-o>F\

let b:interpreter = 'go build -o /tmp/'..expand('%:t:r')..' % && /tmp/'..expand('%:t:r')
