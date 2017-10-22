" embrace the future!
set nocompatible

" Pathogen
" Must be before 'syntax on'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

let mapleader = "\\"
let maplocalleader = "\\"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Random options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number

" Relative line numbering is quite handy to move around so enable it by
" default and add mapping to revert quickly to absolute numbering.
set relativenumber
nnoremap <leader>r :silent set relativenumber!<cr>

" allow backspacing over ...
set backspace=indent,eol,start

" define amount of stuff saved in .viminfo
set viminfo=@100,/100,:100,'100,f1,<500

" remember last commands
set history=500

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
map <Leader>n :noh<CR>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Resize vim windows from tmux
" from http://usevim.com/2014/08/11/script-roundup/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ttyfast
set ttymouse=xterm2
set mouse=a

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Random mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Leader>m :Make<return>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Les gouts et les couleurs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vintage style
"colorscheme peachpuff

set background=dark
let s:next_bg_idx = 1

function! ToggleBackground()
    let &background = [ 'dark', 'light'][s:next_bg_idx]
    let s:next_bg_idx = 1 - s:next_bg_idx
endfunction

command! ToogleBg :call ToggleBackground()

colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI-specifics
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MacVim registers as "Vim"
if v:progname =~? "gvim" || v:progname ==# "Vim"
    set lines=55
    set columns=84
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default indentation rules
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent
set smartindent

" insert/delete 'shiftwidth' spaces when pressing <Tab>/<BS> at beginning of
" line
set smarttab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" try to recognize file types and load associated plugins and indent files
filetype plugin indent on

syntax on

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
    let l:hit = search('\v^\a', l:flags)

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ack, Ag and co
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if executable("ag") == 1
    let g:ackprg='ag --vimgrep'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FSwitch plugin - switch between header and implementation files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufNewFile,BufRead *.c let b:fswitchdst = 'h' | let b:fswitchlocs = '.'
au BufNewFile,BufRead *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.'
au BufNewFile,BufRead *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.'
au BufNewFile,BufRead *.h let b:fswitchdst = 'c,cpp' | let b:fswitchlocs = '.'
let fsnonewfiles="on"

" Switch to the file and load it into the current window 
nmap <silent> <Leader>of :FSHere<cr>

" Switch to the file and load it into the window on the right 
nmap <silent> <Leader>ol :FSRight<cr>

" Switch to the file and load it into a new window split on the right 
nmap <silent> <Leader>oL :FSSplitRight<cr>

" Switch to the file and load it into the window on the left 
nmap <silent> <Leader>oh :FSLeft<cr>

" Switch to the file and load it into a new window split on the left 
nmap <silent> <Leader>oH :FSSplitLeft<cr>

" Switch to the file and load it into the window above 
nmap <silent> <Leader>ok :FSAbove<cr>

" Switch to the file and load it into a new window split above 
nmap <silent> <Leader>oK :FSSplitAbove<cr>

" Switch to the file and load it into the window below 
nmap <silent> <Leader>oj :FSBelow<cr>

" Switch to the file and load it into a new window split below 
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Todo list helpers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:todoMarkers = [ '_', '*', 'X' ]

function! CycleTodoMarker(lnum)
    " Try to match marker at beginning of line
    let l:cline = getline(a:lnum)
    let l:ml = matchlist(l:cline, '\v^\s*\[(.)\]')

    " No match? insert initial marker.
    if ml == []
        let l:ml = matchlist(l:cline, '\v^(\s*)(.*)')
        call setline(a:lnum, l:ml[1] . '[' . s:todoMarkers[0] . '] ' . l:ml[2])
        return
    endif

    " Unknown marker? do nothing
    let l:i = index(s:todoMarkers, l:ml[1])
    if l:i == -1
        return
    endif

    " Last marker? remove it
    let l:i += 1
    if l:i == len(s:todoMarkers)
        call setline(a:lnum, substitute(l:cline, '\[[^]]\] ', '', ''))
        return
    endif

    " Replace current marker with next one
    call setline(a:lnum, substitute(l:cline, l:ml[1], s:todoMarkers[l:i], ''))
endfunction

function! TodoMode()
    noremap <localleader>t :call CycleTodoMarker('.')<cr>
    vnoremap <localleader>t :call CycleTodoMarker('.')<cr>
    IndentSpace 4
    setlocal autoindent
    setlocal foldmethod=indent
    call SetSteveLoshIndentFolding()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General fold-related customizations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove ugly underline on folds.
highlight Folded term=bold cterm=bold ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey

" Remove trailing '----' on folds.
set fillchars=fold:\   

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Steve Losh's indent folding mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERD Tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <Leader>nt :NERDTree<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:go_fmt_command = "goimports"

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
