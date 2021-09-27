时间：2021-09-27 20:32:32

参考：

1. [Ubuntu10.04目录颜色设置](https://blog.csdn.net/Q1302182594/article/details/40918591)

## Linux 修改命令行颜色

### 修改命令行目录颜色

1. 进入当前用户目录，生成文件。

    ```shell
    # 进入用户目录 
    cd ~
    # 生成文件
    dircolors -p > .dircolors
    ```

2. 修改如下内容。

    ```shell
    OTHER_WRITABLE 34 # dir that is other-writable (o+w) and not sticky
    ```