时间：2019/11/28 16:09:48

参考: 

1. [ln](https://man.linuxde.net/ln) 

## ln 命令

## 简介

**硬连接：** 不创建新文件，只能对文件创建硬连接。
**符号链接：** 创建一个特殊的文件，指向链接的目录或文件。

### 实用 

1. 创建符号连接。

    ```shell
    ln -s /home/xiaotian/nodejs/bin/node /usr/local/bin/node
    ```

2. 创硬连接。

    ```shell
    ln /home/xiaotian/nodejs/bin/node /usr/local/bin/node
    ```