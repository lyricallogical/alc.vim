if exists("loaded_alc")
  finish
endif
let g:loaded_alc = 1

let s:plugin_dir = expand("<sfile>:p:h:h")

function! s:SearchAlc(words)
  " Open new lines buffer to hold the results
  execute ":below " . (&lines / 2) . "new"
  setlocal buftype=nofile noswapfile wrap ft=

  " Press q to close the results buffer
  nmap <buffer> q :<c-g><c-u>bw!<cr>

  " Load the results into the new buffer
  put! =system('ruby ' . s:plugin_dir . '/ruby/alc.rb ' . a:words)

  " Jump back to the top of the results
  normal gg
endf

function! s:SearchAlcCursor()
  let word = expand("<cword>")
  call s:SearchAlc(word)
endf

command! -nargs=* SearchAlc call s:SearchAlc(<q-args>)
command! -nargs=0 SearchAlcCursor call s:SearchAlcCursor()

nmap <Leader>alc :SearchAlcCursor<CR>
vmap <Leader>alc "oy:SearchAlc <C-R>o<CR>gv

