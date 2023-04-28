# vim: ts=2 sts=2 sw=2 et

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

export PATH="/opt/homebrew/bin:$PATH"
# 测试zsh启动时间的方法
# /usr/bin/time zsh -i -c exit
OS_NAME=$(uname -s)
BREW_PREFIX=$(brew --prefix)
export HOMEBREW_NO_INSTALL_CLEANUP=1

# use antigen manage zsh plugin, theme ...
source $BREW_PREFIX/share/antigen/antigen.zsh
antigen use oh-my-zsh

# zsh rc files, load order:
# 1 .zprofile
# 2 .zshrc
# 3 .zlogin
#
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


POWERLEVEL9K_INSTANT_PROMPT=off
antigen theme romkatv/powerlevel10k

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

antigen bundle pyenv
antigen bundle git
antigen bundle autojump
antigen bundle jsontools
antigen bundle docker
antigen bundle macos
antigen bundle pip
antigen bundle golang
antigen bundle z
antigen bundle thefuck
# https://github.com/python-poetry/poetry#enable-tab-completion-for-bash-fish-or-zsh
antigen bundle darvid/zsh-poetry
# antigen bundle kubectl # TODO
antigen bundle httpie
antigen bundle python
antigen bundle copybuffer # ctrl-o, copy cli to clipboard
antigen bundle mvn
antigen bundle autojump

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# !! APPLY ANTIGEN !!
antigen apply

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
bindkey '^ ' autosuggest-accept

# colors 设置
#Generic Colouriser
if [[ "x${OS_NAME}" = "xDarwin" ]]; then
  # 为了减少session启动时间
  if [ -d ${BREW_PREFIX}/Cellar/coreutils ]; then
    alias ls="${BREW_PREFIX}/opt/coreutils/libexec/gnubin/ls --show-control-chars --color=auto"
    if [[ -f $HOME/.dir_colors ]]; then
        eval `${BREW_PREFIX}/bin/gdircolors -b $HOME/.dir_colors`
    fi
  fi
fi

# fzf
# fzf的配置有些多，所有放在最后
# 依赖ag，Mac安装方法: brew install the_silver_searcher
# export FZF_DEFAULT_COMMAND='ag --ignore="*.pyc" -g ""'
# 依赖rg，Mac安装方法: brew install riggrep
export FZF_DEFAULT_OPTS='--color fg+:italic,hl:#a0c980:underline,hl+:#a0c980:reverse:underline'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!*.pyc" --glob "!*.swp"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fs() {
  host=$(awk '{print $1}' $HOME/.ssh/known_hosts | gsed "s/^\[//;s/\].*$//;s/,.*//" | sort | uniq | fzf)
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

# From https://unix.stackexchange.com/questions/58870/ctrl-left-right-arrow-keys-issue
# Turns out ctrl+Left and ctrl+Right are set as Keyboard shortcuts for mission control.
# ctrl+left go back one word
# ctrl+right go next one word
bindkey -e
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word

# 一些特殊的配置，或function
SPECIAL_SH="${HOME}/Dropbox/snippet/special.sh"
test -f ${SPECIAL_SH} && source ${SPECIAL_SH}

export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

# added by travis gem
[ -f /Users/liyong/.travis/travis.sh ] && source /Users/liyong/.travis/travis.sh

# golang
export PATH="$(go env GOPATH)/bin:${PATH}"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export SSLKEYLOGFILE="${HOME}/tmp/ssl_key.log"

# 使用nvim打开手册
export MANPAGER='nvim +Man!'
export EDITOR="nvim"

reddit() {
  local json
  local url
  json=$(curl -s -A 'Reddit CLI' "https://www.reddit.com/r/$1/new.json?limit=15" | jq -r '.data.children| .[] | "\(.data.title)\t\(.data.permalink)"')
  url=$(echo "$json" | fzf --delimiter='\t' --with-nth=1 | cut -f2)
  if [[ -n $url ]]; then
    open "https://www.reddit.com$url"
  fi
}

# rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# direnv
eval "$(direnv hook zsh)"

# pyenv settings
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# 运行workon, mkvirtualenv 命令之前，需要先运行: pyenv virtualenvwrapper
 eval "pyenv virtualenvwrapper"

# 增加 MacOS open files
[[ "${OS_NAME}" = "Darwin" ]] && ulimit -S -n 200048

# alias
alias nn="nvim"
alias vn="nvim"
alias nv="nvim"
alias g="git"
alias cl="clear"
alias zrc="[[ -f ~/.zshrc ]] && (source ~/.zshrc && echo 'Reloaded ~/.zshrc') || (echo 'not found ~/.zshrc' && exit 1)"

if [[ "Darwin" = ${OS_NAME} ]]; then
  alias bu="brew upgrade"
  alias bubu="brew upgrade && brew upgrade --cask"
fi
# alias end

alias luamake=/Users/liyong/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/3rd/luamake/luamake
