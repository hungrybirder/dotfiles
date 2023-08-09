# .zprofile is sourced before .zshrc
if [[ $(uname -m) = "x86_64" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
else # arm64
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="/opt/homebrew/bin:$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Added by OrbStack: command-line tools and integration
if [[ -f ~/.orbstack/shell/init.zsh ]]; then
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi
