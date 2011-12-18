" embrace the future!
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Random options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" allow backspacing over ...
set backspace=indent,eol,start

" define amount of stuff saved in .viminfo
set viminfo=@100,/100,:100,'100,f1,<500

" remember last commands
set history=500

" search are case-insensitive except when pattern contains uppercase chars
set ignorecase smartcase

" remove toolbar
set guioptions=gm

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Random mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F4> :cn<return>
map <S-F4> :cp<return>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI-specifics
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MacVim registers as "Vim"
if v:progname =~? "gvim" || v:progname ==# "Vim"
    colorscheme peachpuff
    set lines=70
    set columns=80
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default indentation rules
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent
set smartindent

" insert/delete 'shiftwidth' spaces when pressing <Tab>/<BS> at beginning of
" line
set smarttab

set shiftwidth=4
set softtabstop=4

" always insert spaces
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=syntax

" unfold when ...
set foldopen=mark,percent,quickfix,search,tag

" start editing without folds
set foldlevelstart=99


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" try to recognize file types and load associated plugins and indent files
filetype plugin indent on

syntax on

autocmd BufRead,BufNewFile *.go set filetype=go

autocmd BufRead,BufNewFile *.{cpp,h,inl,c} set colorcolumn=80

" coding styles
"
command IndentEpoc  set cino={1sf1st0:0g-1s

command IndentNth set cino=g0:0

IndentNth

" tags

set tags=.

set showfulltag


" remove trailing whitespaces when saving source files
" autocmd BufWritePre *.{cpp,h,inl,mmp,inf,def} :%s/\s\+$//e

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

nmap <silent> [e :call GoToPrevBegEpocFn()<CR>
nmap <silent> [E :call GoToPrevEndEpocFn()<CR>
nmap <silent> ]e :call GoToNextBegEpocFn()<CR>
nmap <silent> ]E :call GoToNextEndEpocFn()<CR>

"
" FSwitch plugin - switch between header and implementation files
"

au BufEnter *.{cpp,c} let b:fswitchdst = 'h' | let b:fswitchlocs = '.'
au BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs = '.'
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


"
" Do not indent namespace
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

au BufNewFile,BufEnter *.{cpp,h} set indentexpr=IndentNamespace()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LustyJuggler plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This plugin allows to switch quickly between buffers.
" Start it with <Leader>lj

" ... or this
map <Leader>g :LustyJuggler<CR>

" This plugin requires ruby.  Simply ignore it if ruby support to compiled in.
let g:LustyJugglerSuppressRubyWarning = 1


