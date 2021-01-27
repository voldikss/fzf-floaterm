" ============================================================================
" FileName: fzf_floaterm.vim
" Author: adigitoleo
" GitHub: https://github.com/adigitoleo
" ============================================================================

function! fzf_floaterm#feed()
  " Get a list of floaterms in human-readable format.
  let candidates = []
  let bufs = floaterm#buflist#gather()
  for bufnr in bufs
    let title = getbufvar(bufnr, 'floaterm_title')
    let title = (title != get(g:, 'floaterm_title') ? title : 'untitled')
    let info = [bufnr, title, getbufinfo(bufnr)[0]['name']]
    let line = join(info, ' | ')
    call add(candidates, line)
  endfor
  return candidates
endfunction

function! fzf_floaterm#accept(line) abort
  " Switch to the floaterm identified by a line from fzf_floaterm#feed().
  let nameparts = split(a:line, ' | ')
  call floaterm#terminal#open_existing(str2nr(nameparts[0]))
  " fix can not invoke floaterm#util#startinsert(), the auto command BufEnter
  " might be blocked by noautocmd in fzf
  call timer_start(100, {->execute('doautocmd BufEnter')})
endfunction
