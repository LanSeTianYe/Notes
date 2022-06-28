时间：2016-11-23 10:48:36 

### 问题分析

不同的文件，在IDEA里面会设置对应的打开方式，把想要用系统默认软件打开的文件类型关联的IDEA打开方式删除。

### 方法(以Markdown文件为例， `.md` 结尾)

1. 打开 `File -> Settings -> Editor -> File Types` 在右侧列表里面找到 `.md` 关联的打开方式（Recognized File Types）,然后在下面的(Registered Patterns)里面把 `.md` 删除。

2. 两种打开方式设置（任意选择一种即可）

    1. 双击要打开的 `.md` 文件，选中 `Files opened in associated applications` 。
    2. 右键要打开的 `.md` 文件，选择 `Associate with file type`， 在里面选择 `Files opened in associated applications`。