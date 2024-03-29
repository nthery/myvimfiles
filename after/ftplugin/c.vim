if exists("&colorcolumn")
    setl colorcolumn=80
endif
setl textwidth=80

call EnableSyntaxFolding()

setl shiftwidth=8
setl softtabstop=8
setl noexpandtab

setl cindent
setl cino=:0+2s(0

" Support Doxygen-style comments
setl comments-=://
setl comments+=:///,://
