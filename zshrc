# 测试zsh启动时间的方法
# /usr/bin/time zsh -i -c exit
#
OS_NAME=$(uname -s)

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

export ZSH=/Users/liyong/.oh-my-zsh
ZSH_THEME="agnoster"
# virtualenv
export WORKON_HOME="${HOME}/.envs"
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# plugins 可以激活virtualenvwrapper.sh
# 所以不在这里激活
# virtualenv end

plugins=(git virtualenvwrapper gpg-agent autojump jsontools)
source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# 在 iTerm -> Preferences -> Profiles -> Keys 中，新建一个快捷键
# 例如 ⌥ + a ，Action 选择 Send Hex Code，键值为 0x1 0x70 0x63 0x20 0xd，保存生效。
alias pc="proxychains4"

alias mvn="mvn -Denforcer.skip=true "

export EDITOR="/usr/local/bin/vim"

# ShadowsocsX-NG http代理
export http_proxy="http://127.0.0.1:1087"
export https_proxy="http://127.0.0.1:1087"

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
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!*.pyc"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fs() {
  host=$(cut -d " " -f 1 $HOME/.ssh/known_hosts | egrep -v -e '^[0-9]+\.' | egrep -v '^$' | fzf)
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

