function post#post()
    let buf = bufname()
    echo "Posting from buffer "..buf

    let cursave = getcurpos()
    call cursor(1, 1)
    let req_end  = search('^$', 'W')
    call setpos('.', cursave)

    if req_end == 0
        let req_end = line('$')
    else
        let req_end += -1
    endif

    if (req_end == 0)
        echo "No request found in "..buf
        return
    endif

    let request = getline(1, req_end)
    let request = join(request, " ")
    " Remove whitespace before joined URL params
    let request = substitute(request, '\s\([&?=]\)', '\1', 'g')
    " Wrap URL in single quotes
    let request = substitute(request, '\s\(http.\+\)\(\s\|$\)', ' ''\1'' ', '')
    echo 'Request: '..request

    call deletebufline(buf, req_end + 1, '$')
    call append(req_end, [""])

    let response = systemlist(request)
    if v:shell_error || getbufvar(buf, "&ft") != 'json'
        call append(req_end + 1, response)
    else
        echo "Formatting Response"
        let formatted = systemlist("jq '.'", response)
        call append(req_end + 1, formatted)
    endif
endfunction
