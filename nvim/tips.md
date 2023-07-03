# Ubuntu 手动编译 neovim

```bash
sudo apt install -y cmake ninja-build gettext unzip automake

git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```
