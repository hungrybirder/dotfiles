# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/liyong/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/liyong/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

set os (uname)

switch $os
case Darwin
  [ -f /usr/local/share/autojump/autojump.fish ]; and . /usr/local/share/autojump/autojump.fish
end

# 使用neovim
set -gx EDITOR "nvim"
abbr -a vim "nvim"
set -gx NVIM_PYTHON_LOG_FILE "/tmp/nvim.log"

# 设置java
set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home"
set PATH $JAVA_HOME/bin $PATH
abbr -a mvn "mvn -Denforcer.skip=true"

# 设置fzf，默认用ag搜索
set -x FZF_DEFAULT_COMMAND "ag --ignore=\"*.pyc\" -g \"\"" 
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# 将timestamp(seconds)转成可读的日期格式
function mytime
  command date -r $argv[1]
end

# 设置pyenv
# set -x PYENV_ROOT "/usr/local/var/pyenv"
# if which pyenv > /dev/null
#   . (pyenv init - | psub)
# end

# 设置virtualfish， fish中的virtualwrapper
set -x PROJECT_HOME "$HOME/.project_home"
eval (python -m virtualfish auto_activation)
# if set -q VIRTUAL_ENV
#     echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
# end

# 初始化fuck
eval (thefuck --alias | tr '\n' ';')

########################################
#                                      #
#         fzf functions starts         #
#                                      #
########################################

# file open
function fo
  set cmd "fzf-tmux --query=$argv[1] --exit-0 --expect=ctrl-o,ctrl-e"
  eval $cmd >/tmp/fo.tmp
  set key (cat /tmp/fo.tmp | head -1)
  set file (cat /tmp/fo.tmp | tail -1)
  if test -n $file
    command vim $file
  end
end

# 进入目录
function fd 
  set cmd "find . -path '*/\.*' -prune -o -type d -print 2>/dev/null | fzf +m"
  eval $cmd >/tmp/fd.tmp
  set dir (cat /tmp/fd.tmp | tail -1)
  if test -d $dir
    cd $dir
  end
end

# 进入任何目录，包括隐藏目录
function fda
  set cmd "find . -type d -print 2>/dev/null | fzf +m"
  eval $cmd >/tmp/fda.tmp
  set dir (cat /tmp/fda.tmp | tail -1)
  if test -d $dir
    cd $dir
  end
end

function cdf
  set cmd "ag --ignore-dir=\".git\" -g \"\" | fzf +m"
  eval $cmd >/tmp/cdf.tmp
  set file (cat /tmp/cdf.tmp | tail -1)
  if test -f $file
    set dir (dirname $file)
    cd $dir
  end
end

function fkill
  set cmd "ps -ef | sed 1d | fzf -m"
  eval $cmd >/tmp/fkill.tmp
  set pid (cat /tmp/fkill.tmp | awk '{print $2}')
  if [ "x$pid" != "x" ]
    kill -9 $pid
  end
end

# git commit browser
function fshow
  set cmd "git log --graph --color=always --format=\"%C(auto)%h%d %s %C(black)%C(bold)%cr\" | fzf --ansi --no-sort --reverse --tiebreak=index --bind \"ctrl-m:execute: echo {} | grep -o '[a-z0-9]\{7\}' | xargs -I file git show --color=always file | less -R \""
  eval $cmd
end

# fssh， 从known_hosts中选择一个，登陆
function fssh 
  set cmd "cut -d ' ' -f 1 $HOME/.ssh/known_hosts | egrep -v '^[0-9]' | fzf "
  eval $cmd >/tmp/fssh.tmp
  set host (cat /tmp/fssh.tmp | tail -1)
  if [ "x$host" != "x" ]
    ssh $host
  end
end

########################################
#                                      #
#         fzf functions ends           #
#                                      #
########################################

function get_public_ip
  set cmd "python -c 'import socket; sock=socket.create_connection((\'ns1.dnspod.net\',6666)); print sock.recv(16); sock.close()'"
  eval $cmd 2>/dev/null
  if [ ! $status -eq 0 ]
    echo "无法获取公网IP，请检查联网情况！"
  end
end
