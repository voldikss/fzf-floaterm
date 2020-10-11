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
    let opts = getbufvar(bufnr, 'floaterm_opts')
    let nameparts = [
          \bufnr,
          \(has_key(opts, 'name') ? opts['name'] : 'unnamed'),
          \getbufinfo(bufnr)[0]['name'],
          \]
    let name = join(nameparts, ' | ')
    call add(candidates, name)
  endfor
  return candidates
endfunction

function! fzf_floaterm#accept(line) abort
  " Switch to the floaterm identified by a line from fzf_floaterm#feed().
  let nameparts = split(a:line, ' | ')
  call floaterm#terminal#open_existing(str2nr(nameparts[0]))
  " doautocmd BufEnter,WinEnter
endfunction
