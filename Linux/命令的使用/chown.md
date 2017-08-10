##  
时间：2017/3/16 23:13:46   
参考：  
1.  man chown

## 命令介绍
改变文件的拥有者或所属文件组。

## 语法

    chown [OPTION]... [OWNER][:[GROUP]] FILE...
    chown [OPTION]... --reference=RFILE FILE...

**选项**:    

* `-R` : 递归处理子文件或文件夹
* `-f` : 不显示错误信息
* `-v` : 显示指令执行过程
* `-c` : 只显示改变的内容  

**参数**：
   
 * 选项：
 * 用户或用户组：
 	* `user` : 只改变所属用户
 	* `user:group` : 改变所属用户和用户组
 	* `user:` : 改变所属用户，并改变用户组为 `user` 用户登录的用户组
 	* `:group` : 只改变用户组
 	* `:` 所属用户和用户组都不改变
 * 文件、文件夹

## 具体使用
1. 只改变文件夹 `/u` 的拥有者

		chown root /u
2. 改变文件的拥有者和用户组

		chown root:staff /u
3. 改变文件和子文件的拥有者

		chown -hR root /u