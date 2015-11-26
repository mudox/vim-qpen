if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1

" it only return a vim's open way command, according to user's keypress.
" it will handle <Esc> & <C-C> key pressing properly, by throwing an exception
" 'Qpen: Canceled'
function! mudox#qpen#main()
  let prompt_short = 'Where to open? [EhHlLjJkKt] and ? for help: '

  let openways = {}

  " WARNING: keep the trailing space.
  let openways['k'] = 'aboveleft  new'  . "\x20"
  let openways['j'] = 'belowright new'  . "\x20"
  let openways['K'] = 'topleft    new'  . "\x20"
  let openways['J'] = 'botright   new'  . "\x20"
  let openways['h'] = 'aboveleft  vnew' . "\x20"
  let openways['l'] = 'belowright vnew' . "\x20"
  let openways['H'] = 'topleft    vnew' . "\x20"
  let openways['L'] = 'botright   vnew' . "\x20"
  let openways['t'] = 'tabnew'          . "\x20"
  let openways['E'] = 'edit!'           . "\x20"
  let openways['e'] = 'edit'            . "\x20"

  while 1
    echohl Special | echon prompt_short | echohl None
    let key = getchar()

    if key == 13 || key == char2nr('e') " Enter or 'e' pressed.
      return openways['e']
    elseif key == 27 || key == 3 " <Esc> or <C-C> pressed.
      throw 'Qpen: Canceled'
    elseif index(keys(openways), nr2char(key)) != -1 " other valid key pressed.
      return openways[nr2char(key)]
    else
      echohl ErrorMsg
      echo "Invalid input need [kjKJhlHLt? or enter]\n"
      echohl None
      continue
    endif
  endwhile
endfunction

" without argument, it open a unnamed emtpy buffer.
" with one argument that specifies a file name, it open a named new buffer
" or existing file.
" reutrn the open way command.
function mudox#qpen#new(...)   " {{{2
  let open_cmd = mudox#qpen#main()

  if a:0 == 1 " with a path.
    execute open_cmd . "\x20" . a:1
  else " open an unnamed buffer.
    if (open_cmd =~ 'edit') && empty(bufname('%'))
      return ''
    endif
    execute open_cmd
  endif

  return open_cmd
endfunction " }}}2
