
nnoremap <leader>ll :<C-u>silent
  \ !make show<CR><C-l>

function! RunShell()
  call quickrun#run({"exec":"zsh -c %c", "command": getline(".")})
endfunction

command! RunShell :call RunShell()

