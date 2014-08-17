" embrace the future!
set nocompatible

" Pathogen
" Must be before 'syntax on'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Random options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number

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

" customize non-visible characters showed by 'set list'
" commented out because not supported by most versions I use
"set listchars=tab:▸\ ,eol:¬

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

map <Leader>m :make<return>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Les gouts et les couleurs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vintage style
"colorscheme peachpuff

"set background=dark
set background=light
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

" coding styles
"
command IndentEpoc  set cino={1sf1st0:0g-1s

" tags

set tags=.

set showfulltag


" highlight spaces at end of lines
match Todo /\s\+$/

"
" Jump to beginning/end of epoc c++ functions
"

function GoToPrevBegEpocFn()
    if search('^\(    \|\t\){', "bsWe") == 0
        echo "epoc function beginning not found"
    endif
endfunction

function GoToPrevEndEpocFn()
    if search('^\(    \|\t\)}', "bsWe") == 0
        echo "epoc function end not found"
    endif
endfunction

function GoToNextBegEpocFn()
    if search('^\(    \|\t\){', "sWe") == 0
        echo "epoc function beginning not found"
    endif
endfunction

function GoToNextEndEpocFn()
    if search('^\(    \|\t\)}', "sWe") == 0
        echo "epoc function end not found"
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FSwitch plugin - switch between header and implementation files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufNewFile,BufRead *.{cpp,c} let b:fswitchdst = 'h' | let b:fswitchlocs = '.'
au BufNewFile,BufRead *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs = '.'
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

let s:todoMarkers = [ 'TODO', 'NEXT', 'ONGOING', 'DONE' ]

function! CycleTodoMarker()
    " Try to match marker at beginning of line
    let l:cline = getline('.')
    let l:ml = matchlist(l:cline, '^\s*\([A-Z]\+\): ')

    " No match? insert initial marker.
    if ml == []
        let l:ml = matchlist(l:cline, '^\(\s*\)\(.*\)')
        call setline('.', ml[1] . s:todoMarkers[0] . ': ' . ml[2])
        return
    endif

    " Unknown marker? do nothing
    let l:i = index(s:todoMarkers, ml[1])
    if l:i == -1
        return
    endif

    " Last marker? remove it
    let l:i += 1
    if l:i == len(s:todoMarkers)
        call setline('.', substitute(l:cline, l:ml[1] . ': ', '', ''))
        return
    endif

    " Replace current marker with next one
    call setline('.', substitute(l:cline, l:ml[1], s:todoMarkers[l:i], ''))
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERD Tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <Leader>nt :NERDTree<cr>
