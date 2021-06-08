# zsh rc files, load order:
# 1 .zprofile
# 2 .zshrc
# 3 .zlogin
#
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
#
# vim: ts=2 sts=2 sw=2 et
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 测试zsh启动时间的方法
# /usr/bin/time zsh -i -c exit
#
OS_NAME=$(uname -s)
BREW_PREFIX="/usr/local"
if [[ $(uname -m) = "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
fi

[ -f ${BREW_PREFIX}/etc/profile.d/autojump.sh ] && . ${BREW_PREFIX}/etc/profile.d/autojump.sh

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

export ZSH=/Users/liyong/.oh-my-zsh
# ZSH_THEME="agnoster"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
POWERLEVEL9K_INSTANT_PROMPT=off
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
(( ! ${+functions[p10k]} )) || p10k finalize

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

bindkey '^ ' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 启用的插件
if [[ $(uname -m) = "arm64" ]]; then
  plugins=(pyenv git jsontools vagrant docker osx pip golang z)
else
  plugins=(pyenv git gpg-agent autojump jsontools vagrant docker osx pip golang z)
fi
source $ZSH/oh-my-zsh.sh
export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/sbin:/usr/local/bin:$PATH"

if [[ $(uname -m) = "x86_64" ]]; then
# 使用pyenv来管理多个版本的py py3
 export WORKON_HOME="${HOME}/.virtualenvs"
 export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
 export PYENV_VIRTUALENV_DISABLE_PROMPT=1
 export PYENV_ROOT=$HOME/.pyenv
# 运行workon, mkvirtualenv 命令之前，需要先运行: pyenv virtualenvwrapper
 eval "pyenv virtualenvwrapper"
fi

# 在 iTerm -> Preferences -> Profiles -> Keys 中，新建一个快捷键
# 例如 ⌥ + a ，Action 选择 Send Hex Code，键值为 0x1 0x70 0x63 0x20 0xd，保存生效。
alias pc="proxychains4"

alias mvn="mvn -Denforcer.skip=true -DdownloadSources=true "

export EDITOR="nvim"

disable_http_proxy() {
  unset http_proxy
  unset https_proxy
}

enable_http_proxy() {
  export http_proxy="http://127.0.0.1:7890"
  export https_proxy="http://127.0.0.1:7890"
}

# colors 设置
#Generic Colouriser
if [[ "x${OS_NAME}" = "xDarwin" ]]; then
  # 为了减少session启动时间
  if [ -d ${BREW_PREFIX}/Cellar/coreutils ]; then
    alias ls="${BREW_PREFIX}/opt/coreutils/libexec/gnubin/ls --show-control-chars --color=auto"
    eval `${BREW_PREFIX}/bin/gdircolors -b $HOME/.dir_colors`
  fi

fi

# fzf
# fzf的配置有些多，所有放在最后
# 依赖ag，Mac安装方法: brew install the_silver_searcher
# export FZF_DEFAULT_COMMAND='ag --ignore="*.pyc" -g ""'
# 依赖rg，Mac安装方法: brew install riggrep
export FZF_DEFAULT_OPTS='--color fg+:italic,hl:-1:underline,hl+:-1:reverse:underline'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!*.pyc" --glob "!*.swp"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fs() {
  host=$(awk '{print $1}' $HOME/.ssh/known_hosts | gsed "s/^\[//;s/\].*$//;s/,.*//" | fzf)
  if [ "x$host" != "x" ]
  then
    echo "ssh $host"
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
ffd() {
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

link_vimspector() {
  local fname=".vimspector.json"
  test -f ${fname} && unlink ${fname}
  ln -s ${HOME}/codes/dotfiles/${fname} ${fname}
}

# 一些特殊的设置
# zsh <c-u> 默认是kill-whole-line(删除整行) 与bash的<c-u>不同
# 改成与bash <c-u>一样，从光标处删除至行首
bindkey \^U backward-kill-line

if [[ "Darwin" = ${OS_NAME} ]]; then
  alias bu="all_proxy=socks5://localhost:7890 brew upgrade"
  alias bubu="all_proxy=socks5://localhost:7890  brew upgrade --cask --greedy"
fi

# 一些特殊的配置，或function
SPECIAL_SH="${HOME}/Dropbox/snippet/special.sh"
test -f ${SPECIAL_SH} && source ${SPECIAL_SH}

# go
# eval "$(goenv init -)"
# go end


export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

# added by travis gem
[ -f /Users/liyong/.travis/travis.sh ] && source /Users/liyong/.travis/travis.sh

# golang
export PATH="$(go env GOPATH)/bin:${PATH}"
# export GOPATH=$(go env GOPATH)

# if [[ -d ${GOPATH}/bin ]]; then
#     export GOBIN="${GOPATH}/bin"
#     export PATH="${GOBIN}:${PATH}"
#     export GO111MODULE=auto
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# LESS
# export LESS="-C -M -I -j 10 -# 4"

alias nn="nvim"
alias vn="nvim"
alias nv="nvim"

export SSLKEYLOGFILE="${HOME}/tmp/ssl_key.log"


[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# 使用nvim打开手册
export MANPAGER='nvim +Man!'

# if [[ "${OS_NAME}" = "Darwin" ]]; then
#   alias clangd="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clangd"
# fi

alias luamake=/Users/liyong/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/3rd/luamake/luamake

reddit() {
  local json
  local url
  json=$(curl -s -A 'Reddit CLI' "https://www.reddit.com/r/$1/new.json?limit=15" | jq -r '.data.children| .[] | "\(.data.title)\t\(.data.permalink)"')
  url=$(echo "$json" | fzf --delimiter='\t' --with-nth=1 | cut -f2)
  if [[ -n $url ]]; then
    open "https://www.reddit.com$url"
  fi
}
