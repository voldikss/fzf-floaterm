" ============================================================================
" FileName: fzf_floaterm.vim
" Author: adigitoleo
" GitHub: https://github.com/adigitoleo
" ============================================================================

" Search for open floaterms.
command! -bang Floaterms
  \ call fzf#run(fzf#wrap(
  \{
  \'source': fzf_floaterm#feed(), 'sink': function('fzf_floaterm#accept'),
  \'window': { 'width': 0.9, 'height': 0.6, 'border': 'sharp', 'highlight': 'FloatermBorder' },
  \'options': [
  \     '--prompt', 'floaterms> '
  \     ]
  \},
  \<bang>0
  \))
