#!/usr/bin/env bash

# `PS1` is prompt string one
# `help :terminal` in vim to show more usage.
if [ "$VIM_TERMINAL" ] && [ "$TERMCWD_LOADED" ]; then
  _synctermcwd_ps1() {
    printf '\e]51;["call","Tapi_termcwd","%s"]\x07' "$PWD"
  }
  PS1="\$(_synctermcwd_ps1)$PS1"
fi
