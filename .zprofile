
# .zprofile is sourced before .zshrc
if [[ $(uname -m) = "x86_64" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
