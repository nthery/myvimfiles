if exists("did_load_filetypes")
    finish
endif

function! GuessHeaderType()
    if search('\m^\s*\(class\|namespace\)\>', 'nW') != 0
        setfiletype cpp
    else
        setfiletype c
    endif
endfunction

augroup filetypedetect
    autocmd! BufRead,BufNewFile *.go setfiletype go
    autocmd! BufRead *.h call GuessHeaderType()
augroup END

