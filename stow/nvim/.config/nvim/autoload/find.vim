func find#git_files(cmdarg, cmdcomplete)
    let fnames = systemlist('git ls-files')
    return fnames->filter({ i, v -> v =~? glob2regpat(a:cmdarg)..'*' })
endfunc
