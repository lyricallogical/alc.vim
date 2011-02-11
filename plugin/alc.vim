if exists("loaded_alc")
  finish
endif
let g:loaded_alc = 1

let s:plugin_dir = expand("<sfile>:p:h:h")

fun! s:SearchAlc(words)
  echo system("ruby " . s:plugin_dir . "/ruby/alc.rb " . a:words)
endf

fun! s:SearchAlcCursor()
  let word = expand("<cword>")
  call s:SearchAlc(word)
endf

command! -nargs=* SearchAlc call s:SearchAlc(<q-args>)
command! -nargs=0 SearchAlcCursor call s:SearchAlcCursor()
