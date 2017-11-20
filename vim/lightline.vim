set guicursor=

set laststatus=2
set t_Co=256
set nocompatible
set rtp+=/home/noyuno/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('/tmp/dein')
  call dein#begin('/tmp/dein')
  call dein#add('itchyny/lightline.vim')
  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
syntax enable