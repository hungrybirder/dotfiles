#!/bin/bash

# set -x

ROOT=$(cd "$(dirname "$1")"; pwd)

# 查看是否有zshrc文件
if [[ ! -e "${ROOT}/zshrc" ]]; then
	echo "Not found zshrc file in directory ${ROOT}"
	echo "Exit..."
	exit 1
fi

# 删除已经配置的.zshrc文件
if [[ -e "${HOME}/.zshrc" ]]; then
	rm -f ${HOME}/.zshrc
fi

# 做zshrc软链接
ln -s ${ROOT}/zshrc ${HOME}/.zshrc



# 查看是否有tmux.conf文件
if [[ ! -e "${ROOT}/tmux.conf" ]]; then
	echo "Not found tmux.conf file in directory ${ROOT}"
	echo "Exit..."
	exit 1
fi

# 删除已经配置的.tmux.conf文件
rm -f ${HOME}/.tmux.conf

# 做tmux.conf软链接
ln -s ${ROOT}/tmux.conf ${HOME}/.tmux.conf

# 查看是否有clang-format文件
if [[ ! -e "${ROOT}/clang-format" ]]; then
	echo "Not found clang-format file in directory ${ROOT}"
	echo "Exit..."
	exit 1
fi

# 删除已经配置的.clang-format文件
rm -f ${HOME}/.clang-format

# 做clang-format软链接
ln -s ${ROOT}/clang-format ${HOME}/.clang-format

# 查看是否有dir_colors文件
if [[ ! -e "${ROOT}/dir_colors" ]]; then
	echo "Not found dir_colors file in directory ${ROOT}"
	echo "Exit..."
	exit 1
fi

# 删除已经配置的.dir_colors文件
rm -f ${HOME}/.dir_colors

# 做dir_colors软链接
ln -s ${ROOT}/dir_colors ${HOME}/.dir_colors

echo "Done"
