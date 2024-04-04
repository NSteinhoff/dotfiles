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
                \->filter('v:val !~ "^#.*$"')
                \->map('trim(v:val)')
                \->join(" ")
    let request = substitute(request, '\s\([&?=]\)', '\1', 'g')

    if request !~ '^curl'
        let request = 'curl --silent --fail --show-error '..request
    endif

    " Wrap URL in single quotes
    let request = substitute(request, '\s\(http.\{-}\)\(\s\|$\)', ' ''\1'' ', '')

    echo 'Request: '..request

    call deletebufline(buf, req_end + 1, '$')
    call append(req_end, ["", "# RESPONSE"])
    let response_start = req_end + 2

    let response = systemlist(request)
    if v:shell_error || getbufvar(buf, "&ft") != 'json'
        call append(response_start, response)
    else
        echo "Formatting Response"
        let formatted = systemlist("jq '.'", response)
        call append(response_start, formatted)
    endif
endfunction
