# fzf-floaterm

Fzf support for [vim-floaterm](https://github.com/voldikss/vim-floaterm)

## Install

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'voldikss/fzf-floaterm'
Plug 'voldikss/vim-floaterm'
```

## Usage

### Get Started

```
:Floaterms
```

### Create New Pre-configured Floaterms

Using `:Floaterms` not just for switching to existing terminals but also to
create new ones (with different config).

Define the different terminal types by a global variable
`g:fzf_floaterm_newentries` that we can set in `.vimrc` for a root shell, fish
shell and a powershell terminal.

The key represents a unique identifier which must be non numerical (or at
least outside the buffer number range). The options will be forwarded to
floaterm itself, where cmd defines the command.

```vim
let g:fzf_floaterm_newentries = {
  \ '+root' : {
    \ 'title': 'Root Shell',
    \ 'cmd': 'sudo sh' },
  \ '+fish' : {
    \ 'title': 'Fish Shell',
    \ 'cmd': 'fish' },
  \ '+pwsh' : {
    \ 'title': 'Powershell',
    \ 'cmd': 'pwsh' }
  \ }
```
