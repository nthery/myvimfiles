" embrace the future!
set nocompatible

" Pathogen
" Must be before 'syntax on'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Try to recognize file types and load associated plugins and indent files.
filetype plugin indent on

syntax on

let mapleader = "\\"
let maplocalleader = "\\"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimscript {{{

" Manipulating this file easily
" (Courtesy of Steve Losh's "Learn Vimscript the hard way")
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global options {{{

set number

" Relative line numbering is quite handy to move around so enable it by
" default (unimpaired yor mapping toggles it).
set relativenumber

" allow backspacing over ...
set backspace=indent,eol,start

" define amount of stuff saved in .viminfo
set viminfo=@100,/100,:100,'100,f1,<500

" search are case-insensitive except when pattern contains uppercase chars
set ignorecase smartcase

" remove toolbar
set guioptions=gmc

" display possible completions above command line
set wildmenu

" show line and column numbers
set ruler

" do not disturb others when screwing up
set visualbell

" can switch to another window without saving
set hidden

" break lines longer than window width and prefix them with marker (visually
" only)
set linebreak

" prefix broken down lines with marker
"let &showbreak= '> '

" directories to search with gf and co
set path=.

" don't sprinkle backups everywhere, we've got source control!
set nobackup

" Enable to save original files when patching code
"set patchmode=.orig
set backupdir=.

" display command being entered in bottom-right corner
set showcmd

" incremental search is cool
set incsearch

" highlight occurences found during last search
 set hlsearch
 
" suppress current highlighting
nnoremap <leader>n :nohlsearch<cr>

" show matching brace
set showmatch

"save current file on various commands such as :make
set autowrite

" automagically reload files modified outside vim
set autoread

" customize non-visible characters showed by 'set list'
" commented out because not supported by most versions I use
"set listchars=tab:▸\ ,eol:¬

" increase command history
set history=1000

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux {{{

" Resize vim windows from tmux
" from http://usevim.com/2014/08/11/script-roundup/
set ttyfast
if !has('nvim')
    set ttymouse=xterm2
endif
set mouse=a

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Les gouts et les couleurs {{{

" vintage style
"colorscheme peachpuff

colorscheme solarized

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI-specifics {{{

" MacVim registers as "Vim"
if v:progname =~? "gvim" || v:progname ==# "Vim"
    set lines=55
    set columns=84
endif

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default indentation rules {{{

set autoindent
set smartindent

" insert/delete 'shiftwidth' spaces when pressing <Tab>/<BS> at beginning of
" line
set smarttab

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming {{{

nnoremap <leader>m :Make<cr>

function! EnableSyntaxFolding()
    setl foldmethod=syntax

    " unfold when ...
    setl foldopen=mark,percent,quickfix,search,tag

    " start editing without folds
    setl foldlevelstart=99
endfunction

" tags
set tags=.
set showfulltag

" Quickly change indentation style
command! -nargs=1 IndentTab setlocal sts=<args> ts=<args> sw=<args> noet
command! -nargs=1 IndentSpace setlocal sts=<args> sw=<args> et

" Populate args with all C/C++ files in given directory trees
command! -nargs=+ -complete=dir ArgsC args `find <args> -name '*.[ch]' -o -name '*.[ch]pp'`

" Beautify multi-line C macros
command! -range -nargs=1 AlignTrailingBackslash let atslash=@/ | <line1>,<line2> s!\s*\\!\=repeat(' ', <args> - col('.') - 2).' \'! | let @/=atslash

" highlight spaces at end of lines
match Todo /\s\+$/

" Alternative [[ and ]] implementation for styles where '{' is not at
" beginning of line.  Match alphabetic character in first column.
function! GoToTopLevelDecl(backward)
    "  Disable search highlighting
    let l:hl = &hlsearch
    let &hlsearch=0

    " Search for next/previous top-level declaration.
    " n: do not move the cursor because we want to update the jump list.
    " W: Do not wrap around beginning/end.
    let l:flags = 'nW'
    if a:backward
        let l:flags .= 'b'
    endif
    " Match following flavors of function definitions:
    " void f(int n) {
    " void f(int n)
    " void f(
    "   int n) {
    " void f(int n,
    "        double d) {
    let l:hit = search('\v^\i.*(\{|,|\(|\))\s*$', l:flags)

    " Jump to hit if any or beginning/end of file.
    if l:hit !=# 0
        execute "normal " . l:hit . "G"
    else
        if a:backward
            normal gg
        else
            normal G
        endif
    endif

    "  Restore search highlighting.
    let &hlsearch=l:hl
endfunction

nnoremap [[ :call GoToTopLevelDecl(1)<cr>
nnoremap ]] :call GoToTopLevelDecl(0)<cr>

" Skip comment token when joining lines.
"
" // toto  ---> // toto titi
" // titi
if v:version > 703 || v:version == 703 && has('patch541')
    set formatoptions+=j
endif

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ack, Ag and co {{{

if executable("ag") == 1
    let g:ackprg='ag --vimgrep'
endif

nnoremap <leader>a :Ack!<space>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FSwitch plugin - switch between header and implementation files {{{

augroup fswitch
    autocmd!
    autocmd BufNewFile,BufRead *.c let b:fswitchdst = 'h' | let b:fswitchlocs = '.'
    autocmd BufNewFile,BufRead *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.'
    autocmd BufNewFile,BufRead *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.'
    autocmd BufNewFile,BufRead *.h let b:fswitchdst = 'c,cpp' | let b:fswitchlocs = '.'
augroup END

let fsnonewfiles="on"

" Switch to the file and load it into the current window 
nnoremap <silent> <leader>of :FSHere<cr>

" Switch to the file and load it into the window on the right 
nnoremap <silent> <leader>ol :FSRight<cr>

" Switch to the file and load it into a new window split on the right 
nnoremap <silent> <leader>oL :FSSplitRight<cr>

" Switch to the file and load it into the window on the left 
nnoremap <silent> <leader>oh :FSLeft<cr>

" Switch to the file and load it into a new window split on the left 
nnoremap <silent> <leader>oH :FSSplitLeft<cr>

" Switch to the file and load it into the window above 
nnoremap <silent> <leader>ok :FSAbove<cr>

" Switch to the file and load it into a new window split above 
nnoremap <silent> <leader>oK :FSSplitAbove<cr>

" Switch to the file and load it into the window below 
nnoremap <silent> <leader>oj :FSBelow<cr>

" Switch to the file and load it into a new window split below 
nnoremap <silent> <leader>oJ :FSSplitBelow<cr>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Todo list helpers {{{

let g:todoMarkers = [ '_', '*', 'X' ]

function! CycleTodoMarker(lnum)
    let l:todoMarkers = g:todoMarkers
    if exists("b:todoMarkers")
        let l:todoMarkers = b:todoMarkers
    endif

    " Try to match marker at beginning of line or markdown list item
    let l:cline = getline(a:lnum)
    let l:ml = matchlist(l:cline, '\v^(#* |\s*(- )?)\[([^]]+)\]')
    let l:marker = ""
    if ml != []
        let l:marker = l:ml[3]
    endif

    " No match? insert initial marker.
    if marker == ""
        let l:ml = matchlist(l:cline, '\v^(#* |\s*(- )?)(\S.*)')
        call setline(a:lnum, l:ml[1] . '[' . l:todoMarkers[0] . '] ' . l:ml[3])
        return
    endif

    " Unknown marker? do nothing
    let l:i = index(l:todoMarkers, l:marker)
    if l:i == -1
        return
    endif

    " Last marker? remove it
    let l:i += 1
    if l:i == len(l:todoMarkers)
        call setline(a:lnum, substitute(l:cline, '\v\[[^]]+\] ', '', ''))
        return
    endif

    " Replace current marker with next one
    call setline(a:lnum, substitute(l:cline, l:marker, l:todoMarkers[l:i], ''))
endfunction

function! TodoMode()
    noremap <localleader>t :call CycleTodoMarker('.')<cr>
    vnoremap <localleader>t :call CycleTodoMarker('.')<cr>
    IndentSpace 4
    setlocal autoindent
    setlocal foldmethod=indent
    call SetSteveLoshIndentFolding()
endfunction

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding {{{

" Remove ugly underline on folds.
highlight Folded term=bold cterm=bold ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey

" Remove trailing '----' on folds.
set fillchars=fold:\   

" Change way folds look like courtesy of
" http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual search mappings from Scrooloose and Steve Losh {{{

function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Steve Losh's indent folding mode {{{
" Copied from "Learn vimscript the hard way" (c) Steve Losh

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! SteveLoshIndentFoldExpr(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = IndentLevel(a:lnum)
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction

function! SetSteveLoshIndentFolding()
    setlocal foldexpr=SteveLoshIndentFoldExpr(v:lnum)
    setlocal foldmethod=expr
endfunction

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine plugin {{{

let g:indentLine_enabled = 0
nnoremap <leader>I :IndentLinesToggle<cr>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go {{{

let g:go_fmt_command = "goimports"

augroup filetype_go
    autocmd!
    autocmd FileType go nnoremap <leader>r <Plug>(go-run)
    autocmd FileType go nnoremap <leader>b <Plug>(go-build)
    autocmd FileType go nnoremap <leader>t <Plug>(go-test)
    autocmd FileType go nnoremap <leader>c <Plug>(go-coverage)
augroup END

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimwiki {{{

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzy finder {{{

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>t :Tags<cr>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use builtin man plugin {{{

if filereadable(expand("$VIMRUNTIME/ftplugin/man.vim"))
    source $VIMRUNTIME/ftplugin/man.vim
    nnoremap K :Man <cword><cr>
endif

" }}}
