" ============================================================================
" FileName: fzf_floaterm.vim
" Author: adigitoleo
" GitHub: https://github.com/adigitoleo
" ============================================================================

let s:floatterm_fzf_layout = get(g:, "floatterm_fzf_layout", {})
if empty(s:floatterm_fzf_layout)
   if has('nvim')
      let s:floatterm_fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'relative': v:true, 'xoffset': 0, 'yoffset': 1 } }
   else
      " Vim disallow more than one popup, so use tmux window.
      if exists('$TMUX')
         " See `fzf-tmux --help` for available options
         let s:floatterm_fzf_layout = { 'tmux': '-p99%,40% -y 60%' }
      endif
   endif
endif

" Search for open floaterms.
command! -bang Floaterms
  \ call fzf#run(fzf#wrap(
  \ extend({
     \ 'source': fzf_floaterm#feed(),
     \ 'sink': function('fzf_floaterm#accept'),
     \ 'options': [
        \ '--prompt',
        \ 'floaterms> ',
        \ '--delimiter',
        \ '\|',
        \ '--with-nth',
        \ '2..'
     \ ],
  \ }, s:floatterm_fzf_layout),
  \ <bang>0
  \ ))

" Fetch terminal woking directory.
if has("nvim")
   autocmd TermLeave * if bufname('%') =~ 'term://' | call fzf_floaterm#update() | endif 
else
   let $TERMCWD_LOADED = 1
   function! Tapi_termcwd(_, curr_dir) abort
      let b:term_title = a:curr_dir
      call fzf_floaterm#update()
   endfunction
endif
