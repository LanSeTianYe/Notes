时间：2019/1/25 12:25:04  
参考：

1. [https://www.cnblogs.com/wangqiguo/p/8905081.html](https://www.cnblogs.com/wangqiguo/p/8905081.html)   

## tmux   

用 putty（全屏模式用起来很爽）连接的Linux，有几台虚拟机，虚拟机之间可以相互登陆，但是在全屏的窗口下每次只能进入一台虚拟机，如果要连接多台的话，就需要打开多个出窗口，就想找一个在一个中端命打开多个终端的工具，刚开始找到的是 `screen`，感觉不是很满意，后来又找到 `tmux`，感觉很好，用起来很方便。

###  简介  

tmux 通过 `seesion`、`window`（窗口）、`pane`（窗格） 来区分窗口。

在终端命令行可以创建多个 `session`，每个 `session` 里可以创建多个 `window` ，每个 `windos` 可以分割出多个 `pane`。

### 命令

### 命令行命令  
1. 创建 session ：`tmux new -s session_name`
2. 查看 session ：`tmux ls`
2. 关闭 session ：`tmux kill-session -t session_name`
3. 进入 session ：`tmux a -t session_name`
4. 重命名session： `tmux rname -t old_session_name new_session_name`

### 窗口内命令

窗口内命令需要先按 `ctrl + b` 然后输入命令，按 `CTRL + B` 之后使用 `PageUp/PageDowm` 可以上下翻页。

1. `?` ：查看帮助。
1. `d` ：退出session。
2. `s` ：查看session列表，通过上下左右切换。
3. `$` ：重命名会话。
4. `c` ：创建窗口。 
4. `p` ：上一个窗口。
5. `n` ：下一个窗口。
6. `number` ：第 number 个窗口。
7. `l` ：相邻的窗口。
7. `w` ：列出所有窗口，通过上下左右切换。
8. `&` ：关闭窗口。
9. `%` ：左右分割出窗口。
10. `"` ：上下分割出窗口。
11. `o` ：依次切换pane。
12. `上/下/左/右` ：切换到对应方向的pane。
13. `Space(空格)` ：对当前的pane重新布局。
14. `z` ：最大化当前 pane。
15. `x` ：关闭当前 pane。
16. `t` ：显示时钟。