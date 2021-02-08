" ============================================================================
" FileName: fzf_floaterm.vim
" Author: adigitoleo
" GitHub: https://github.com/adigitoleo
" Contributors: Grueslayer
" ============================================================================

function! fzf_floaterm#feed()
  let candidates = []
  let candidates += fzf_floaterm#feed_buflist()
  let candidates += fzf_floaterm#feed_newentries()
  return candidates
endfunction

function! fzf_floaterm#feed_newentries()
  " Get a list of actions to create new Floaterms
  let candidates = []
  let cmdlist = get(g:, 'fzf_floaterm_newentries', {})
  for [key, value] in items(cmdlist)
    let cmd = get(value, 'cmd', '')
    let title = get(value, 'title', cmd)
    let info = [key, title, cmd == '' ? '' : '!'+cmd]
    let line = join(info, ' | ')
    call add(candidates, line)
  endfor
  return candidates
endfunction

function! fzf_floaterm#feed_buflist()
  " Get a list of floaterms in human-readable format.
  let candidates = []
  let bufs = floaterm#buflist#gather()
  let curr_bufnr = floaterm#buflist#curr()
  for bufnr in bufs
    let title = getbufvar(bufnr, 'floaterm_title')
    let title = (title != get(g:, 'floaterm_title') ? title : 'untitled')
    let info = [bufnr, title, getbufinfo(bufnr)[0]['name']]
    let line = join(info, ' | ')
    if bufnr == curr_bufnr && get(g:, 'fzf_floaterm_current_first', 1) == 1
      let candidates = [line] + candidates
    else
      call add(candidates, line)
    endif
  endfor
  return candidates
endfunction

function! fzf_floaterm#accept(line) abort
  " Switch to the floaterm identified by a line from fzf_floaterm#feed().
  let nameparts = split(a:line, ' | ')
  let bufnr = str2nr(nameparts[0])
  if bufnr == 0
    let cmdlist = get(g:, 'fzf_floaterm_newentries', {})
    let config = copy(cmdlist[nameparts[0]])
    let cmd = remove(config,'cmd')
    call floaterm#new(0, cmd, {}, config)
  else
    call floaterm#terminal#open_existing(bufnr)
  endif
  " fix can not invoke floaterm#util#startinsert(), the auto command BufEnter
  " might be blocked by noautocmd in fzf
  call timer_start(100, {->execute('doautocmd BufEnter')})
endfunction
