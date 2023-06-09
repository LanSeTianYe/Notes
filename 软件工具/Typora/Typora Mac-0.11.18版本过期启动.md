时间：2023-06-09 11:36:36

参考：



## Typora 0.11.18 版本启动

**问题**：启动 Typora 时报错：`当前测试版版本过低，请下载较新版本`。

**解决方案**：可以通过调系统时间。然后再启动的方法启动。

脚本：[typora.sh](./typora.sh)

脚本内容：

```shell
#/bin/bash

# 修改系统时间
sudo date 111111112022

# 打开typora
open "/Applications/Typora.app"

# 恢复系统时间
sudo sntp -sS time.apple.com
```

### 手动启动

* 第一步：下载脚本 [typora.sh](./typora.sh)。

* 第二步：把脚本移动到 `/usr/local/bin` 目录。

  ```shell
  mv ./typora.sh /usr/local/bin/typora
  ```

* 第三步：执行脚本。

  ```shell
  typora
  ```