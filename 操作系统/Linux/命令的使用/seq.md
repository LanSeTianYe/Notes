时间：201902-11 17:41:58 

## seq 

生成序列数

### 语法

```shell
seq last
seq first last
seq first increment last
```

### 选项 

* `w`：保持数字宽度一致，不一致填充零。如 `001 002 ... 100`
* `s str`：用 `str` 分割数字，默认使用换行 `\n`。

### 用法 

1. 生成1到100递增数字。

    ```shell
    seq 1 100
    ```

2. 生成1到100，递增间隔为2的序列。

    ```shell
    seq 1 2 100 
    ```