source $VIM/vimrc_example.vim
behave xterm

map - <leader>
let mapleader = "-"
map \ <localleader>
let maplocalleader = "\\"
colorscheme slate         "change colors
" for some reason PreProc(essing) gets highlighted red on white by default.
" this makes it orange on gray
hi PreProc guifg=orange guibg=#505050
set gfn=Consolas:h9:cANSI "change font
set expandtab             "convert \t characters to spaces
set tabstop=2             "this and the following two lines
set shiftwidth=2          "set the size of 'tabs' to 2 spaces
set softtabstop=2
set cindent               "enable C style indentation
set cinkeys-=0#           "don't reset '#' comment lines to 0 indentation
set indentkeys-=0#        "don't reset '#' comment lines to 0 indentation
set mouse=                "disable crutch interaction
set fdm=indent            "fold method (how folds are recognized
set foldignore=           "was '#' allow comment folding
set clipboard=unnamed     "use windows' clipboard???
set guioptions-=m         "remove menu bar
set guioptions-=T         "remove toolbar
set guioptions-=R         "remove scroll bars (next 4 lines)
set guioptions-=r
set guioptions-=L
set guioptions-=l
set guioptions-=e         "remove gui tab labels
set relativenumber        "show how distant from the cursor each line is
set numberwidth=2         "minimum number of columns to display line numbers
set shellslash            "use as separator for file paths
set backup                "keep a backup file
set history=10000         "keep 50 lines of command line history
set ruler                 "show the cursor position all the time
set showcmd               "display incomplete commands
set incsearch             "do incremental searching
syntax on                 "switch syntax highlighting on
set hlsearch              "highlight the last used search pattern
" use git bash for shell operations, external commands, etc
set shell=C:/GitBash/sh.exe.lnk\ --login\ -i
"use file's location as working directory for shell commands
set autochdir
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" backspace, space, h, and l keys wrap to previous/next line
set whichwrap+=bs
" Don't use Ex mode
noremap Q <nop>
" backspace in Visual mode deletes selection
vnoremap <BS> d
" Alt-Space is System menu
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" map ctrl+l to remove highlighting
nnoremap <C-L> :noh<CR>
vnoremap <C-L> <C-C>:noh<CR>gv
inoremap <C-L> <C-O>:noh<CR>a

" map forward and backward window switching in normal, visual, command
" pending, and insert modes
noremap  <leader>, <c-w>w
inoremap <leader>, <c-c><c-w>w
nnoremap <leader>< <c-w>W
inoremap <leader>< <c-c><c-w>W

" map mt and mT to move tabs left or right respectively
"nnoremap mt :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
"nnoremap mT :execute 'silent! tabmove ' . tabpagenr()<CR>

" strip white space from line endings on save
autocmd BufWritePre * call StaticViewCall('%s/\s\+$//e')
noh "turn of highlighting after the substitute command is run

" if you want to run some command that moves the screen or unfolds folds
" but you want the screen and cursor in their original positions when
" you're done, then you can use this?
" cmd is a string that gets passed to execute
" StacicViewCall(":0")
" this would bring you to the first line... and then send you right back
" hopefully we can think of some better uses of this function /:
function! StaticViewCall(cmd)
  let screen = winsaveview() " save current screen/cursor state
  set nofoldenable           " disable folding so folds aren't opened
  execute a:cmd            | " run the supplied command
  set foldenable             " reenable folding
  call winrestview(screen)   " restore screen/cursor state
endfunction

" moves you to the first non whitespace character of the line
" if you were already there, moves you to the first character if the line
function! LineHome()
  let x = col('.')
  execute "normal! ^"
  if x == col('.')
    execute "normal! 0"
  endif
  return ""
endfunction

" pathogen
execute pathogen#infect()

" mappings from Learn Vimscript the Hard Way
" move line under cursor down one line
nnoremap <leader>- ddp
" move line under cursor up one line
nnoremap <leader>_ ddkP
inoremap <leader><c-u> <esc>viwUea
nnoremap <leader><c-u> viwUe
" quick edit my vimrc
nnoremap <leader>ek :vsplit $MYVIMRC<cr>
" quick source my vimrc
nnoremap <leader>ok :source $MYVIMRC<cr>
" surround word under cursor with various enclosing marks
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel
" move to end of line with L
noremap  L $
noremap  $ :throw "use L"<cr>
" move to first non whitespace character of line with H
" if you were already there, move to first character of line
noremap  H :call LineHome()<cr>:echo<cr>
noremap  ^ :throw "use H"<cr>
noremap  0 :throw "use H"<cr>
" leave insert and visual modes with <leader>c
inoremap hc <esc>l
inoremap <esc> <c-o>:throw "use 'hc'"<cr>
inoremap <c-c> <c-o>:throw "use 'hc'"<cr>
vnoremap hc <esc>l
vnoremap <esc> <c-c>:throw "use 'hc'"<cr>
vnoremap <c-c> <c-c>:throw "use 'hc'"<cr>

" remap <space> to : in mode so it's easier to input commands
noremap <space> :
noremap : :throw "use space!"<cr>

iabbrev @@ dougcosine@gmail.com
iabbrev ssig -- <cr>Doug Coulson<cr>dougcosine@gmail.com

