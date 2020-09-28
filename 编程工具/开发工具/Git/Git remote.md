时间： 2019-04-01 22:37:04 

## git remote 

git remote 远程仓库管理。

## 常用命令 

1. 添加或删除远程。 

    ```	
    # 删除
    git remote add remote_name https://github.com/longlongxiao/abc.git
    # 添加
    git remote remove remote_name
    ```

2. 查看所有远程仓库。

    ```
    git remote -v
    ```

3. 查看远程仓库信息。

    ```
    git remote show origin
    ```

4. 更新本地分支列表。

    ```
    git remote update origin -p
    ```