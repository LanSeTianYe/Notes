时间：2024-10-11 14:26:26

参考：

1. [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
2. [如何使用 oh-my-zsh 让使用zsh更高效](https://blog.csdn.net/m0_60511809/article/details/138525435)
2. [https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)


## zsh 安装及使用

zsh 是一个功能强大的 shell，支持配置插件、主题等。

Oh My Zsh 是一个管理 zsh 插件、主题的框架，通过 Oh My Zsh 可以快速配置 zsh。

### 安装

以 CentOS 为例。

**准备：** 安装依赖，

**git：**用 `git --version` 查看是否已经安装 `git`，如果没有需要先安装 `git`。

```shell
yum install git
```

**curl：** 用 `curl --version` ，查看是否已经安装 `curl`，如果没有需要先安装 `curl`

```shell
yum install curl
```

**第一步：** 用 `cat /etc/shells` 查看输出内容有没有，如果没有先安装 `zsh`。

```shell
# 安装 zsh
yum install zsh
```

**第二步：** 安装 Oh My Zsh。（最好根据官方文档安装，地址：https://github.com/ohmyzsh/ohmyzsh）

```shell
# 方法一：使用 GitHub 脚本安装
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 方法二：使用站外脚本安装
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
```

**第三步：** 安装并启用插件。

**安装插件：**

```shell
# zsh-autosuggestions 命令行建议（根据历史输入提供建议）
git clone https://github.com/zsh-users/zsh-autosuggestions.git  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# zsh-syntax-highlighting 语法高亮
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# fast-syntax-highlighting 语法高亮
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git  ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
# zsh-autocomplete 命令自动补全
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git  ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
```

**配置插件：** `vim ~/.zshrc`，找到 `plugins=(git)` 这一行，在括号里面添加插件，插件之间用空格分开。（如果不需要对应插件，删除对应的插件配置即可）

```shell
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)
```

**启用插件：** `source ~/.zshrc `

**第四步：** 修改用户默认 shell。

```shell
# 方法一：
echo $(which zsh) | lchsh

# 方法二：
sudo lchsh $USER
# 然后在交互窗口输入 /bin/zsh

#方法三：
chsh -s $(which zsh)
```

