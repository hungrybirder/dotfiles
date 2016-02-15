export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
source $ZSH/oh-my-zsh.sh
#
if [ -f ${HOME}/.bashrc ]; then
	source ${HOME}/.bashrc
fi

if [ -f ${HOME}/.bash_profile ]; then
	source ${HOME}/.bash_profile
fi

export EDITOR="vim"
alias vim="nvim"
alias god="/opt/vim74/bin/vim"
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
alias mvn="mvn -Denforcer.skip=true "
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias FUCK="fuck"

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh  ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

plugins=(git autojump osx command-not-found python tmux virtualenvwrapper virtualenv)

PROMPT_COMMAND='prompt'
precmd() { eval "$PROMPT_COMMAND" }

function prompt()
{
    if [ "$PWD" != "$MYOLDPWD" ]; then
        MYOLDPWD="$PWD"
        # test -e .venv && workon `cat .venv`
	if [[ -e .venv ]]; then
		target_env=$(cat .venv)
		# 如果已经激活target_env，则不需要再次激活
		if [[ "${VIRTUAL_ENV}" != *"${target_env}" ]]; then 
			workon ${target_env}
		fi
	fi
    fi
}
