#!/bin/sh
# 2018-05-28
# Author: hungrybirder@gmail.com
# 在centos7上做cpp开发，需要的软件环境等等

# 安装neovim
yum -y install epel-release
curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo
yum -y install neovim

# 安装一些网络工具
yum -y net-tools tcpdump ngrep

# 安装监控工具
yum -y htop 

# 安装编译工具
yum -y cmake3 gyp gdb gcc-c++
