" vim: foldmethod=marker

" GUARD {{{1
if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1
" }}}1

" without argument, it open a unnamed emtpy buffer.
" with one argument that specifies a file name, it open the named new buffer
" or existing file.
function Qpen(...) " {{{2
  if a:0 > 1
    throw "Invalid argument number,"
          \ . " need 0 or 1 arguments."
  elseif a:0 == 1 && type(a:1) != type('')
    throw "Invalid argument type,"
          \ . " need a path string."
  endif

  if a:0 == 0
    call mudox#query_open_file#new()
  else
    call mudox#query_open_file#new(a:1)
  endif

endfunction "  }}}2
