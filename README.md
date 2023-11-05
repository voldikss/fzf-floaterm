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

### Get current working directory in vim

The plugin use indices and terminal working directory as fzf entries.

Neovim has `b:buffer` variable for getting working directory of terminal, but vim must use `Tapi_` to notify the information.

So you should add `source /path/fzf-floaterm/macros/termcwd.sh` to your `.bashrc` or `.zshrc` file in vim only.

### Floaterm Fzf layout options

Define fzf layout by `g:floatterm_fzf_layout`, exmaple is bellow.

```vim

    let g:floatterm_fzf_layout = {
         \ 'window': {
            \ 'width': 0.9,
            \ 'height': 0.6,
            \ 'border': 'sharp',
            \ 'highlight': 'FloatermBorder'
         \ } 
     \}

```

