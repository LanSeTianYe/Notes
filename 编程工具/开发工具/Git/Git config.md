时间：2019-04-01 21:13:46 

## git 配置

1. 查看配置信息。

    ```shell
    # 产看当前项目
    git config --list
    # 查看全局配置
    git config --list --global
    ```
2. 编辑配置信息。

    ```shell
    git config -e [--global]
    ```
3. 配置局部或全局用户名。

    ```shell
    git config [--global] user.name "sunfeilong1993"
    git config [--global] user.email "1498282352@qq.com"
    ```
4. 配置支持长路径文件。  

    ```shell
    git config --global core.longpaths true
    ```
6. Linux 命令行显示颜色。 

    ```shell
    git config --global color.ui auto
    ```
7. 配置别名，类似于Linux的别名。

    ```shell
    git config --global alias.co checkout
    ```
7. 配置缓存，之后会缓存输入的用户名和密码。

    ```shell
    # 存储到磁盘
    git config --global credential.helper store
    # 存储到内存
    git config --global credential.helper cache
    ```
8. git bash 显示中文

    ```shell
    git config --global core.quotepath false
    ```
9. git bash 禁止制动转换换行符

    ```shell
    git config core.autocrlf false
    ```
