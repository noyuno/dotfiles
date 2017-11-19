" rc/options.rc.vim

set modelines=5
set modeline
if !IsWindows()
  set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
endif
" Always display cursor line
set cursorline
" Disable cursor shape
set guicursor=
"set cmdheight=1
set showtabline=1
set swapfile
set completeopt-=noinsert
set complete=.,w,b,i,t

" rc/gui.rc.vim 
set guifontwide=Noto\ Sans\ CJK\ JP\ DemiLight:h12
set guifont=Inconsolata\ for\ Powerline:h12
set linespace=-6

" rc/unix.rc.vim

set mouse=a

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

if !has("gui_running")
  let g:hybrid_reduced_contrast = 1
endif
colorscheme hybrid

" print settings

set printencoding=utf-8
set printfont=Inconsolata\ for\ Powerline\ Medium\ 10
set printoptions+=paper:A4,number:y
set printoptions=duplex:short
command! -nargs=* Printout !printout -q %

set ambiwidth=double

if has('conceal')
  set conceallevel=0 concealcursor=
endif

" bugfix

set number 
syntax on
set tabstop=4
set shiftwidth=4

" current directory vimrc
if exists(".vimrc")
  source ".vimrc"
endif

