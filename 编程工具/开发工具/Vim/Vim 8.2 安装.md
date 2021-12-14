时间: 2021-12-13 19:32:32

参考：

1. [**How to Install Vim 8.2 on CentOS 7**](https://phoenixnap.com/kb/how-to-install-vim-centos-7)
2. [vim-plug](https://github.com/junegunn/vim-plug)
3. [vimawesome](https://vimawesome.com/)

## Vim 8.2 安装

### 安装 Vim
```
# 安装编译工具
yum install gcc make ncurses ncurses-devel


# 安装需要依赖的工具
yum install ctags git tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel python python-devel perl perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-XSpp perl-ExtUtils-CBuilder perl-ExtUtils-Embed


# 删除已经安装的版本
yum list installed | grep -i vim
yum remove vim-a vim-b ...


# 下载源代码
git clone https://github.com/vim/vim.git


# 安装
cd vim

# 修改配置
./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python3-command=python3.4 \
        --with-python3-config-dir=$(python3.4-config --configdir) \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr/local

# 安装
make && make install
```

### 管理插件

1. 安装 [vim-plug](https://github.com/junegunn/vim-plug)，管理插件。

    ```shell
    # 安装vim-go插件
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      
    ```
    配置：在 `~/.vimrc` 添加如下内容：
    ```shell
    " Specify a directory for plugins
    " - For Neovim: stdpath('data') . '/plugged'
    " - Avoid using standard Vim directory names like 'plugin'
    call plug#begin('~/.vim/plugged')
    
    " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    Plug 'junegunn/vim-easy-align'
    
    " vim-go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    
    " code color
    Plug 'itchyny/landscape.vim'
    
    " Initialize plugin system
    call plug#end()
    ```

    配置完成之后 刷新并安装插件
    ```shell
    :source %
    :PlugInstall
    ```

2. 修改 vim-go 配置，支持gopls，修改 vim-go 的配置文件(`/root/.vim/plugged/vim-go/plugin/go.vim`)，添加如下内容。

    ```lua
    let g:go_def_mode='gopls'
	let g:go_info_mode='gopls'
    ```
