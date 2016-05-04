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
set -gx NVIM_PYTHON_LOG_FILE "$HOME/.nvim.log"

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
eval (python -m virtualfish compat_aliases projects auto_activation)
if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
end

# 初始化fuck
eval (thefuck --alias | tr '\n' ';')
