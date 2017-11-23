
if v:version >= 703
  " For conceal.
   "set conceallevel=2 concealcursor=niv

   set colorcolumn=79

  " Use builtin function.
  function! s:wcswidth(str) abort
    return strwidth(a:str)
  endfunction
else
  function! s:wcswidth(str) abort
    return len(a:str)
  endfunction
endif

" fzf
set rtp+=~/.fzf 

set noshowmode
set laststatus=2
set t_Co=256
set background=dark
"let g:hybrid_custom_term_colors = 1
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
autocmd ColorScheme * highlight StatusLine ctermbg=none
autocmd ColorScheme * highlight StatusLineNC ctermbg=none
autocmd ColorScheme * highlight Folded ctermbg=none
autocmd ColorScheme * highlight FoldColumn ctermbg=none
autocmd ColorScheme * highlight Cursor ctermbg=blue cterm=bold
autocmd ColorScheme * highlight Comment ctermfg=247
autocmd ColorScheme * highlight Specialkey ctermfg=blue
autocmd ColorScheme * highlight NonText ctermfg=245
autocmd ColorScheme * highlight CursorLine term=underline cterm=underline ctermfg=NONE ctermbg=NONE

colorscheme hybrid

if !has("gui_running")
  let g:hybrid_reduced_contrast = 1
endif

" print settings

set printencoding=utf-8
set printfont=Inconsolata\ Medium\ 10
set printoptions+=paper:A4,number:y
set printoptions=duplex:short
command! -nargs=* Printout !printout -q %

if !has('gui_running')
  set ambiwidth=double
endif

if has('conceal')
  set conceallevel=0 concealcursor=
endif

augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

set modelines=5
set modeline
if !IsWindows()
  set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
endif
" Always display cursor line
set cursorline
"set cmdheight=1
set showtabline=1
set swapfile
set completeopt-=noinsert
set complete=.,w,b,i,t

" rc/gui.rc.vim 
set guifontwide=Noto\ Sans\ CJK\ JP\ DemiLight\ 13
set guifont=Inconsolata\ 13
set linespace=-5

" rc/unix.rc.vim

set mouse=a

" rc/mapping.rc.vim

" http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
"nnoremap <silent> [Window] <Nop>
nnoremap <silent> [Window]j <C-w>j
nnoremap <silent> [Window]k <C-w>k
nnoremap <silent> [Window]l <C-w>l
nnoremap <silent> [Window]h <C-w>h
nnoremap <silent> [Window]J <C-w>J
nnoremap <silent> [Window]K <C-w>K
nnoremap <silent> [Window]L <C-w>L
nnoremap <silent> [Window]H <C-w>H
nnoremap <silent> [Window]n gt
nnoremap <silent> [Window]p gT
nnoremap <silent> [Window]r <C-w>r
nnoremap <silent> [Window]= <C-w>=
nnoremap <silent> [Window]w <C-w>w
"nnoremap so <C-w>_<C-w>|
nnoremap <silent> [Window]o :<C-u>only<CR>
nnoremap <silent> [Window]O <C-w>=
nnoremap <silent> [Window]N :<C-u>bn<CR>
nnoremap <silent> [Window]P :<C-u>bp<CR>
nnoremap <silent> [Window]t :<C-u>tabnew<CR>
nnoremap <silent> [Window]T :<C-u>Unite tab<CR>
nnoremap <silent> [Window]s :<C-u>sp<CR>
nnoremap <silent> [Window]v :<C-u>vs<CR>
nnoremap <silent> [Window]q :<C-u>q<CR>
nnoremap <silent> [Window]Q :<C-u>bd<CR>
nnoremap <silent> [Window]b :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap <silent> [Window]B :<C-u>Unite buffer -buffer-name=file<CR>

noremap [Space]j zj
noremap [Space]k zk
"noremap zu :<C-u>Unite outline:foldings<CR>
nnoremap <silent> ze :<C-u>set foldenable<CR>
nnoremap <silent> zn :<C-u>set nofoldenable<CR>
nnoremap <silent> zu :<C-u>Unite -vertical -no-quit -winwidth=30 outline<CR>

inoremap ; ;
cnoremap ; ;
snoremap ; ;

nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
nnoremap っy yy

nnoremap <s-up> V<up>
nnoremap <s-down> V<down>
nnoremap <s-left> v<left>
nnoremap <s-right> v<right>

" paste on insert mode
inoremap <C-v> <C-r>"

" vimproc

command! MakeVimproc !make -C ~/.cache/dein/repos/github.com/Shougo/vimproc.vim 

" bugfix

set number 
syntax on
set tabstop=4
set shiftwidth=4
set foldlevelstart=7

set helplang=ja,en

" current directory vimrc
if exists(".vimrc")
  source ".vimrc"
endif

