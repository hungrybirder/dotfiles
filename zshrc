# 测试zsh启动时间的方法
# /usr/bin/time zsh -i -c exit
#
OS_NAME=$(uname -s)

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

export ZSH=/Users/liyong/.oh-my-zsh
ZSH_THEME="agnoster"


# zsh history setting
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
# zsh history setting end

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# virtualenv
export WORKON_HOME="${HOME}/.envs"
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# plugins 可以激活virtualenvwrapper.sh
# 所以不在这里激活
# virtualenv end

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# 使用pyenv来管理多个版本的py py3
# 运行workon命令之前，需要先运行: pyenv virtualenvwrapper
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
plugins=(pyenv git gpg-agent autojump jsontools vagrant docker osx pip)
# plugins=(pyenv git virtualenvwrapper gpg-agent autojump jsontools vagrant docker)
source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

export PYENV_ROOT=$HOME/.pyenv
eval "pyenv virtualenvwrapper"

# 在 iTerm -> Preferences -> Profiles -> Keys 中，新建一个快捷键
# 例如 ⌥ + a ，Action 选择 Send Hex Code，键值为 0x1 0x70 0x63 0x20 0xd，保存生效。
alias pc="proxychains4"

alias mvn="mvn -Denforcer.skip=true -DdownloadSources=true "

export EDITOR="/usr/local/bin/vim"

# ShadowsocsX-NG http代理
# export http_proxy="http://127.0.0.1:1087"
# export https_proxy="http://127.0.0.1:1087"

disable_http_proxy() {
  unset http_proxy
  unset https_proxy
}

enable_http_proxy() {
  export http_proxy="http://127.0.0.1:1087"
  export https_proxy="http://127.0.0.1:1087"
}

# colors 设置
#Generic Colouriser
if [[ "x${OS_NAME}" = "xDarwin" ]]; then
  # 为了减少session启动时间
  # 将coreutils目录写死了
  if [ -d /usr/local/Cellar/coreutils ]; then
    # PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    alias ls='/usr/local/opt/coreutils/libexec/gnubin/ls --show-control-chars --color=auto'
    eval `/usr/local/bin/gdircolors -b $HOME/.dir_colors`
  fi

fi

# fzf
# fzf的配置有些多，所有放在最后
# 依赖ag，Mac安装方法: brew install the_silver_searcher
# export FZF_DEFAULT_COMMAND='ag --ignore="*.pyc" -g ""'
# 依赖rg，Mac安装方法: brew install riggrep
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!*.pyc" --glob "!*.swp"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fs() {
  host=$(awk '{print $1}' $HOME/.ssh/known_hosts | gsed "s/^\[//;s/\].*$//;s/,.*//" | fzf)
  if [ "x$host" != "x" ]
  then
    ssh $host
  fi
}

ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

# file open
fo() {
  local out file key
  out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    dirs+=("$1")
    if [[ ${1} == '/' ]]; then
      for _dir in ${dirs[@]}; do
        echo $_dir
      done
    else
      get_parent_dirs $(dirname $1)
    fi
  }
  DIR=$(get_parent_dirs ${1:-$(pwd)} | fzf-tmux --tac) && cd "$DIR"
}
# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
# fzf end
#
# ##########################################
#
#         My Useful Functions
#
##########################################
# translate unix timestamp to readable str
mytime() {
  python -c "from time import ctime; print ctime($1)"
}

show_docker_containers() {
  dockviz images --dot | dot -Tpng -o /tmp/containers.png && open /tmp/containers.png
}

dev() {
  today=$(date +%Y%m)
  target_dir=$HOME/tmp/${today}
  if [[ -d ${target_dir} ]]; then
    cd ${target_dir}
  else
    mkdir -p ${target_dir} && cd ${target_dir}
  fi
}

today() {
  month=$(date +%Y%m)
  day=$(date +%d)
  if [ ${day} -ge 3 ]; then
    day="${day}th"
  elif [ ${day} -eq 2 ]; then
    day="2nd"
  elif [ ${day} -eq 1 ]; then
    day="1st"
  fi 
  target_dir=$HOME/tmp/${month}/${day}
  if [[ -d ${target_dir} ]]; then
    cd ${target_dir}
  else
    mkdir -p ${target_dir} && cd ${target_dir}
  fi
}

get_public_ip() {
  nc ns1.dnspod.net 6666 | egrep -o "[0-9.]+"
}

# 一些特殊的设置
# zsh <c-u> 默认是kill-whole-line(删除整行) 与bash的<c-u>不同
# 改成与bash <c-u>一样，从光标处删除至行首
bindkey \^U backward-kill-line

if [[ "Darwin" = ${OS_NAME} ]]; then
  alias bubu="brew update && brew upgrade"
fi

# 一些特殊的配置，或function
SPECIAL_SH="${HOME}/Dropbox/snippet/special.sh"
test -f ${SPECIAL_SH} && source ${SPECIAL_SH}

# go
# eval "$(goenv init -)"
# go end


export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1
