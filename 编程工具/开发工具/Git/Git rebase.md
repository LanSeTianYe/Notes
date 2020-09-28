时间：2019-04-02 11:41:06 

参考：

1. [Git-分支-变基](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%8F%98%E5%9F%BA)

## git rebase 

变基，将提交到某一分支上的所有修改都移至另一分支上，使提交历史更加整洁。

## 常用操作 

1. 把指定分支上的提交，重放到当前分支。

    ```
    git rebase other_branch 
    ```

2. 把 `master` 分支的提交重放到 `server` 分支。

    ```
    git rebase master server
    ```

2. 重放在 `client` 分支，但不在 `server` 分支的信息到 `master` 分支。

    ```
    git rebase --onto master server client
    ```