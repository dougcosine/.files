" sources
  exec "source " . expand('<sfile>:p:h') . "/vimrc_example.vim"

" settings
  behave xterm
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
  "use file's location as working directory for shell commands
  set autochdir
  " allow backspacing over everything in insert mode
  set backspace=indent,eol,start
  " backspace, space, h, and l keys wrap to previous/next line
  set whichwrap+=bs

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
function! LineHome(mode)
  let isVisual = a:mode == 'v'
  if isVisual
    execute "normal! \<esc>"
    let colCurr = col('.')
    execute "normal! ^"
    if colCurr == col('.')
      execute "normal! gv0"
    else
      execute "normal! gv^"
    endif
  else
    let colCurr  = col('.')
    execute "normal! ^"
    if colCurr == col('.')
      execute "normal! 0"
    endif
  endif
  return ""
endfunction

" pathogen
execute pathogen#infect()

" EasyMotion
  " Disable default mappings
  " let g:EasyMotion_do_mapping = 0
  nmap m  <Plug>(easymotion-prefix)
  " nmap ms <Plug>(easymotion-s)
  " nmap mj <Plug>(easymotion-j)
  " nmap mk <Plug>(easymotion-k)
  nmap /  <Plug>(easymotion-sn)
  map n  <Plug>(easymotion-next)
  map N  <Plug>(easymotion-prev)

" leaders
  map - <nop>
  let mapleader = "-"
  map \ <localleader>
  let maplocalleader = "\\"

" commands
  " Alt-Space is System menu
  if has("gui")
    noremap  <a-space> :simalt ~<cr>
    inoremap <a-space> <c-o>:simalt ~<cr>
    cnoremap <a-space> <c-c>:simalt ~<cr>
  endif

  " quick edit my vimrc
  nnoremap <leader>ek :tabnew $MYVIMRC<cr>
  " quick source my vimrc
  nnoremap <leader>ok :source $MYVIMRC<cr>

  " map <space> to : in mode so it's easier to input commands
  noremap <space> :
  " map q<space> to q: so we can get to the command editor
  noremap q<space> q:
  noremap : :throw "use space!"<cr>

  " map ctrl+l to remove highlighting
  nnoremap <esc> :noh<cr>
  nnoremap <c-l> :noh<cr>:silent! syntax sync fromstart<cr>
  vnoremap <c-l> <c-c>:noh<cr>:silent! syntax sync fromstart<cr>gv
  inoremap <c-l> <c-o>:noh<cr>:silent! syntax sync fromstart<cr>

  " map forward and backward window switching in normal, visual, command
  " pending, and insert modes
  noremap  <leader>, <c-w>w
  inoremap <leader>, <c-c><c-w>w
  nnoremap <leader>< <c-w>W
  inoremap <leader>< <c-c><c-w>W

" cursor movement
  " move to end of line with L
  noremap  L $
  " move to first non whitespace character of line with H
  " if you were already there, move to first character of line
  noremap  H :call LineHome('n')<cr>:echo<cr>
  vnoremap H :<c-u>call LineHome('v')<cr>
  " make n always search forward and N always search backward
  " nnoremap <silent> <expr> n (v:searchforward ?
  "  \ ':silent! exe "normal nzO<cr>"<cr>' : ':silent! exe "normal NzO<cr>"<cr>')
  "nnoremap <silent> <expr> N (v:searchforward ?
  "  \ ':silent! exe "normal NzO<cr>"<cr>' : ':silent! exe "normal nzO<cr>"<cr>')

" modal operators
  " leave insert and visual modes with hl or HL
  inoremap hl <esc>l:noh<cr>
  inoremap HL <esc>l:noh<cr>
  inoremap <esc> <esc>l:noh<cr>
  inoremap <c-c> <c-o>:throw "use 'hl'"<cr>
  vnoremap hl <esc>:noh<cr>
  vnoremap <esc> <esc>:noh<cr>
  vnoremap <c-c> <c-c>:throw "use 'hl'"<cr>

" text movement
  " move line under cursor down one line
  nnoremap <leader>- ddp
  " move line under cursor up one line
  nnoremap <leader>_ ddkP

" text editing
  " surround word under cursor with various enclosing marks
  nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
  nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
  nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
  nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
  nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel

  " backspace in Visual mode deletes selection
  vnoremap <BS> d

" <nop>
  " Don't use Ex mode
  noremap Q <nop>

  " Don't use arrow keys
  noremap  <Left>  <nop>
  inoremap <Left>  <nop>
  noremap  <Right> <nop>
  inoremap <Right> <nop>
  noremap  <Up>    <nop>
  inoremap <Up>    <nop>
  noremap  <Down>  <nop>
  inoremap <Down>  <nop>

" abbreviations
  iabbrev @@ dougcosine@gmail.com
  iabbrev ssig -- <cr>Doug Coulson<cr>dougcosine@gmail.com

