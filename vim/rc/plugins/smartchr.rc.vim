"---------------------------------------------------------------------------
" smartchr.vim
"

inoremap <expr> , smartchr#one_of(', ', ',')

" Smart =.
augroup MyAutoCmd
  autocmd FileType c,cpp,perl,php,vim,go inoremap <expr> =
      \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ')
  " Substitute .. into -> .
  autocmd FileType c,cpp inoremap <buffer> <expr> .
        \ smartchr#loop('.', '->', '...')
  autocmd FileType perl,php inoremap <buffer> <expr> .
        \ smartchr#loop(' . ', '->', '.')
  autocmd FileType perl,php inoremap <buffer> <expr> -
        \ smartchr#loop('-', '->')
  autocmd FileType vim inoremap <buffer> <expr> .
        \ smartchr#loop('.', ' . ', '..', '...')
  autocmd FileType lisp,scheme,clojure inoremap <buffer> <expr> = =
  autocmd FileType c,cpp,perl,php inoremap <expr> +
        \ smartchr#loop(' + ', '+')
  autocmd FileType go inoremap <expr> : smartchr#loop(': ', ':')
  autocmd FileType go inoremap <expr> ^ smartchr#loop(' := ', '^')
  autocmd FileType go inoremap <expr> ! smartchr#loop(' != ', '!')
  autocmd FileType go inoremap <expr> ; smartchr#loop('; ', ';')

  autocmd FileType haskell,int-ghci
        \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
        \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
        \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
        \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
        \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

  autocmd FileType scala
        \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
        \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
        \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

  autocmd FileType eruby
        \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
        \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
augroup END
