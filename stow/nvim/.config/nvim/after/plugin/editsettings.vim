function s:edit_settings(type, selected, mods)
    let defaults = {
    \   'compiler': compiler#which(),
    \   'colors': g:colors_name,
    \}
    let selected = empty(a:selected) ? get(defaults, a:type, &ft) : a:selected

    exe 'keepj '..a:mods..(a:mods =~ 'vert\|tab' ? ' split' : ' edit')..' $HOME/.config/nvim/after/'.a:type.'/'.selected.'.vim'
endfunction

command! -nargs=? -complete=compiler EditCompiler call s:edit_settings('compiler', <q-args>, <q-mods>)
command! -nargs=? -complete=filetype EditFtplugin call s:edit_settings('ftplugin', <q-args>, <q-mods>)
command! -nargs=? -complete=filetype EditFtdetect call s:edit_settings('ftdetect', <q-args>, <q-mods>)
command! -nargs=? -complete=filetype EditSyntax call s:edit_settings('syntax', <q-args>, <q-mods>)
command! -nargs=? -complete=filetype EditIndent call s:edit_settings('indent', <q-args>, <q-mods>)
command! -nargs=? -complete=color EditColorscheme call s:edit_settings('colors', <q-args>, <q-mods>)
