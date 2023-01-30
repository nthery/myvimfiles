if exists("&colorcolumn")
    setl colorcolumn=80
endif
setl textwidth=80

call EnableSyntaxFolding()

setl shiftwidth=4
setl softtabstop=4
setl expandtab

"
" Do not indent namespaces.
"
" Copied from vimscript#2636.
"

function! IndentNamespace()
	let l:cline_num = line('.')
	let l:pline_num = prevnonblank(l:cline_num - 1)
	let l:pline = getline(l:pline_num)
	let l:retv = cindent('.')
	while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
		let l:pline_num = prevnonblank(l:pline_num - 1)
		let l:pline = getline(l:pline_num)
	endwhile
	if l:pline =~# '^\s*namespace.*'
		let l:retv = 0
	endif
	return l:retv
endfunction

setl indentexpr=IndentNamespace()

"
" Indentation options
"

setl cindent
setl cino=:0g0(0

" Support Doxygen-style comments
setl comments-=://
setl comments+=:///,://
