setlocal keywordprg=:Search\ devdocs\ lua

let b:interpreter='lua'
setlocal omnifunc=v:lua.vim.lua_omnifunc
