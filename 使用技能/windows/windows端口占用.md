#### 解决方法
1. 根据端口查找 `pid`

        netstat -aon|findstr "49157"

2. 在任务管理器里面，显示 `pid` ，根据 `pid` 结束对应的进程.