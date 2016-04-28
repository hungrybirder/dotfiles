# export ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="robbyrussell"
# COMPLETION_WAITING_DOTS="true"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
# fpath=(/usr/local/share/zsh-completions $fpath)
#
# plugins=(git autojump osx command-not-found python tmux virtualenvwrapper jsontools pip zsh-autosuggestions zsh-syntax-highlighting)
#
# source $ZSH/oh-my-zsh.sh


# 测试zsh启动时间的方法
# /usr/bin/time zsh -i -c exit

# .zsh_history文件最大行数
export SAVEHIST=400
OS_NAME=$(uname -s)
# antigen
export ANTIGEN_DEFAULT_REPO_URL=https://github.com/robbyrussell/oh-my-zsh.git
source ${HOME}/cs/dotfiles/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
# antigen bundle autojump
antigen bundle command-not-found
# antigen bundle pip
# antigen bundle tmux
# antigen bundle virtualenvwrapper
# antigen bundle jsontools
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme agnoster
antigen apply

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home

if [ -f ${HOME}/.bash_profile ]; then
	source ${HOME}/.bash_profile
fi

if [ -f ~/cs/hhighlighter/h.sh ]; then
        . ~/cs/hhighlighter/h.sh
fi

#Generic Colouriser
if [[ "x${OS_NAME}" = "xDarwin" ]]; then
  source "`brew --prefix`/etc/grc.bashrc"
  #GNU Coreutils
  if brew list | grep coreutils > /dev/null ; then
    PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    #alias ls='ls -F --show-control-chars --color=auto'
    alias ls='ls --show-control-chars --color=auto'
    eval `gdircolors -b $HOME/.dir_colors`
  fi

fi

export CSCOPE_DB=${HOME}/.cscope.vim
export EDITOR="nvim"
alias vim="nvim"
export NVIM_PYTHON_LOG_FILE=${HOME}/.nvim.log
alias god="/opt/vim74/bin/vim"
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
alias mvn="mvn -Denforcer.skip=true "
eval "$(thefuck --alias)"


if [[ "x${OS_NAME}" = "xDarwin" ]]; then
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh  ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
fi


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

# fzf init
export FZF_DEFAULT_COMMAND='ag --ignore="*.pyc" -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
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

# fzf git start
# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}
# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}
# fzf git done

# Tags
# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# utility function used to write the command in the shell
writecmd() {
  perl -e '$TIOCSTI = 0x5412; $l = <STDIN>; $lc = $ARGV[0] eq "-run" ? "\n" : ""; $l =~ s/\s*$/$lc/; map { ioctl STDOUT, $TIOCSTI, $_; } split "", $l;' -- $1
}
# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

##########################################
#
#         My Useful Functions
#
##########################################
# translate unix timestamp to readable str
mytime() {
  python -c "from time import ctime; print ctime($1)"
}

export PYENV_ROOT=/usr/local/var/pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
