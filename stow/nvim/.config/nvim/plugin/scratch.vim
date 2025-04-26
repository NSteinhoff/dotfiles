command! -bar Scratch call scratch#toggle('<mods>')

"augroup scratch
"    autocmd!
"    autocmd InsertLeave,TextChanged scratch://SCRATCH call scratch#write()
"    autocmd BufCreate scratch://SCRATCH call scratch#init()
"augroup END
