#/bin/bash

# 修改系统时间
sudo date 111111112022

# 打开typora
open "/Applications/Typora.app"

# 恢复系统时间

sudo sntp -sS time.apple.com
