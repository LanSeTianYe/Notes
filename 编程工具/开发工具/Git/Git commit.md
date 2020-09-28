时间：2019-04-02 10:06:12 

## git commit 

git commit 提交缓存区的变更到本地仓库。

## 常用操作

1. 提交缓存区文件。

    ```
    git commit -m "message"
    ```

2. 提交缓存区指定文件。

    ```
    git commit <file>... -m "message"
    ```

3. 显示文件内容变更信息，如 `1 file changed, 4 insertions(+)`。

    ```
    git commit -v -m "message" <file>... 	
    ```

4. 把缓冲区的内容和上次提交合并为一个提交，提交历史中只有一个记录。同时也可以更改提交信息。

    ```
    git commit --amend
    ```