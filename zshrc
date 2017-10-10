export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

export ZSH=/Users/liyong/.oh-my-zsh
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
# virtualenv
export WORKON_HOME=~/.envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh
# virtualenv end

plugins=(git virtualenvwrapper gpg-agent autojump)
source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/bin:$PATH"

# fzf
export FZF_DEFAULT_COMMAND='ag --ignore="*.pyc" -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# fzf end

# 在 iTerm -> Preferences -> Profiles -> Keys 中，新建一个快捷键
# 例如 ⌥ + a ，Action 选择 Send Hex Code，键值为 0x1 0x70 0x63 0x20 0xd，保存生效。
alias pc="proxychains4"

alias mvn="mvn -Denforcer.skip=true "

export EDITOR="/usr/local/bin/vim"

# ShadowsocsX-NG http代理
export http_proxy="http://127.0.0.1:1087"
export https_proxy="http://127.0.0.1:1087"
