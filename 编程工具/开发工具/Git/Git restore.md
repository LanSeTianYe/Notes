时间: 2021-09-09 15:46:46

## git restore

### 列子

1. 把文件从暂存区移动到工作区。

    ```shell
    git restore --staged file1 file2 file3
    ```
    
2. 把所有文件从暂存区移动到工作区。

    ```shell
    git reset HEAD
    ```
    
3. 将工作去的修改撤销。

    ```shell
    git restore
    ```
    
4. 撤销文件

    ```shell
    git checkout file1 file2
    ```

5. 撤销所有文件的修改

    ```shell
    git checkout HEAD .
    ```