source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave xterm

colorscheme slate         "change colors
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

" map ctrl+l to remove highlighting
nmap <C-L> :noh<CR>
vmap <C-L> <C-C>:noh<CR>v
imap <C-L> <C-C>:noh<CR>a
cmap <C-L> <C-C>:noh<CR>:

" map mt and mT to move tabs left or right respectively
nnoremap mt :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap mT :execute 'silent! tabmove ' . tabpagenr()<CR>

" strip white space from line endings on save
autocmd BufWritePre * call StaticViewCall('%s/\s\+$//e')

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

