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
    let info = [key, title, cmd == '' ? '' : '!'.cmd]
    let line = join(info, ' | ')
    call add(candidates, line)
  endfor
  return candidates
endfunction

function! fzf_floaterm#feed_buflist()
  " Get a list of floaterms in human-readable format.
  let candidates = []
  if !exists("*floaterm#buflist#gather")
    return candidates
  endif

  let bufs = floaterm#buflist#gather()
  let curr_bufnr = bufnr('%')
  let idx = 0
  for bufnr in bufs
    let title = getbufvar(bufnr, 'floaterm_name')
    let title = (title != "" ? title : 'untitled')
    let dir = getbufvar(bufnr, 'floaterm_dir')
    let dir = (dir != "" ? dir : getbufinfo(bufnr)[0]['name'])
    let idx = idx + 1
    let info = [bufnr, idx, title, dir]
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

function! fzf_floaterm#update() abort
  if !exists("*floaterm#config#set")
    return
  endif

  let curr_dir = exists('b:term_title') ? b:term_title : ''
  let breif_title = fnamemodify(curr_dir, ':t')
  let curr_bufnr = bufnr('%')
  call floaterm#config#set(curr_bufnr, "name", breif_title)
  call floaterm#config#set(curr_bufnr, "dir", curr_dir)
endfunction
