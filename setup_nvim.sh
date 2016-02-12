#!/bin/bash

CONFIG_DIR="${HOME}/.config"
if [ ! -d "${CONFIG_DIR}" ]; then
	mkdir ${CONFIG_DIR}
fi

NVIM_DIR="$(cd "$(dirname "$1")"; pwd)/nvimrc"

cd ${HOME}

if [ ! -d "${NVIM_DIR}" ]; then
	echo -e "Not found nvim_dir"
	exit 1
else
	unlink ${CONFIG_DIR}/nvim
	ln -s ${NVIM_DIR} ${CONFIG_DIR}/nvim
fi

cd -

echo "neovim setup done!"
