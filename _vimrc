set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave xterm

" customization starts here
colorscheme slate         "change colors
set gfn=Consolas:h9:cANSI "change font
set expandtab             "convert \t characters to spaces
set tabstop=2             "this and the following two lines
set shiftwidth=2          "set the size of 'tabs' to 2 spaces
set softtabstop=2         "
set cindent               "enable C style indentation
set cinkeys-=0#           "don't reset '#' comment lines to 0 indentation
set indentkeys-=0#        "don't reset '#' comment lines to 0 indentation
set mouse=                "disable crutch interaction
set fdm=indent            "fold method (how folds are recognized
set foldignore=           "was '#' allow comment folding
set clipboard=unnamed     "use windows' clipboard???
set guioptions-=m         "remove menu bar
set guioptions-=T         "remove toolbar

" map ctrl+w to tab close
nnoremap <C-W> :tabclose<CR>
vnoremap <C-W> <C-C>:tabclose<CR>
inoremap <C-W> <C-C>:tabclose<CR>
cnoremap <C-W> <C-C>:tabclose<CR>

" map ctrl+l to remove highlighting
nmap <C-L> :noh<CR>
vmap <C-L> <C-C>:noh<CR>v
imap <C-L> <C-C>:noh<CR>a
cmap <C-L> <C-C>:noh<CR>:

" map mt and mT to move tabs left or right respectively
nnoremap mt :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap mT :execute 'silent! tabmove ' . tabpagenr()<CR>
" customization ends here

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

