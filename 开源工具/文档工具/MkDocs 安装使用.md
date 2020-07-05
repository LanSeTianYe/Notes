时间：2020/7/1 9:55:22  

环境: 

1.  CentOS 7
2.  Python 3.6

参考：

1. [mkdocs](https://www.mkdocs.org/)  
2. [主题](https://jamstackthemes.dev/ssg/mkdocs/)
3. [Typora](https://www.typora.io/)

## MkDocs  

### 简介   

MkDocs 是一个基于 MarkDown 的文档构建工具。把一个文件夹下的内容构建成一个以文件夹目录结构为网页菜单结构的静态网页。支持 [主题](https://jamstackthemes.dev/ssg/mkdocs/) 配置。不同的主题支持不同的插件。

我的自己的一个 [配置模板](https://github.com/ProjectTemplate/mkdocs-config-template.git),可以直接使用。但是需要提前安装模板需要的插件。参考: [MkDocs 配置模板使用](./MkDocs 配置模板使用.md)

具体效果: 

1.  [文档内容](https://github.com/LanSeTianYe/Notes.git)
2.  [配置模板](https://github.com/ProjectTemplate/mkdocs-config-template.git)
3.  [效果预览](http://note.sunfeilong.com/)

> MkDocs 使用 `python` 编写。因此需要 `python` 环境,我把操作系统的python升级到3.6之后进行的安装。在 CentOS 上也可以使用 `yum install mkdocs` 安装, 但是为了安装最新版本，推荐使用 ` pip install mkdocs` 安装最新版本。我自己安装的是 `1.1.2版本` , 安装命令 `pip install mkdocs==1.1.2`。

### 使用步骤  

* 最简使用

    1.  安装 `mkdocs`。
    2.  使用 `mkdocs new project_name` 创建新项目。
    3.  使用 `mkdocs serve` 预览。

* 扩展：

    1. 安装主题，配置主题。
    2. 安装插件配置插件。

### 安装及使用  

0. 安装 

     ```shell
     pip install mkdocs==1.1.2
     ```

1. 创建项目

    ```shell
    mkdocs new project_name 
    ```

2. 启动服务(进入项目目录),之后即可访问 [http://127.0.0.1:8000](http://127.0.0.1:8000) 预览效果.

    ```shell
    cd project_name
    mkdocs serve -a 0.0.0.0:8000
    ```
    
3. 构建项目成静态文件 

    ```shell
    mkdocs build
    # 删除已经没有的文件 
    mkdocs build --clean
    ```

4. 帮助信息 

    ```shell
    mkdocs -help
    mkdocs command --help
    ```

### 主题 

主题配置,在 `mkdocs.yml` 文件中加入下面内容。

```yml
theme:
    name: material
```

#### [mkdocs-material](https://github.com/squidfunk/mkdocs-material)

1. 安装: 

    ```shell
    pip install mkdocs-material
    ```
    
3. 配置:  

    ```shell
    theme:
        name: material
    ```
    
3. 预览: [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)

##### Material 插件

1. [修订日期](https://squidfunk.github.io/mkdocs-material/plugins/revision-date/): 基于 git 提交日志生成修订日期。

    * 安装   
    
        ```shell
        pip install mkdocs-git-revision-date-localized-plugin
        ```
        
    * 配置    
    
        ```yml
        plugins:
            - search # necessary for search to work
            - git-revision-date-localized
        ```
    
2. [目录控制](https://squidfunk.github.io/mkdocs-material/plugins/awesome-pages/): 控制目录标题，目录文章的顺序，目录是否展示等。

    * 安装 
    
        ```shell
        pip install mkdocs-awesome-pages-plugin	
        ```
       
    * 配置
    
        ```yml
        plugins:
        - search # necessary for search to work
        - awesome-pages:
            filename: .pages.yml        # 指定配置文件名，默认文件名是 .pages
            collapse_single_pages: true # 当目录只有一个文件时是否收缩目录
            strict: false               # 当 arrange 配置的文件不存在是是否报错
        ```

    * 目录配置模板
    
        ``` yaml
        # 目录显示的标题
        title: Lua 使用

        # 目录顺序
        arrange:
            - Lua 协程.md
            - ... # 其余的文件
            - Lua 基础语法.md
            - Lua 常用函数库.md

        # 是否隐藏
        hide: false

        # 当目录只有一个文件的时候收缩目录
        collapse: true
        ```
### MkDocs 配置    

可参考 [配置模板](https://github.com/ProjectTemplate/mkdocs-config-template.git) 进行配置。

1. 配置模板 

    ```yml
    # 网站名字
    site_name: 蓝田的笔记

    # 主题
    theme:
        name: material

    # 代码高亮
    markdown_extensions:
        - codehilite:
            linenums: true
        - toc:
            permalink: true

    # 插件配置
    plugins:
        - search:
            prebuild_index: true
            lang:
                - en
                - de
                - ru
                - ja
        - git-revision-date-localized:
            type: iso_datetime
        - awesome-pages:
            filename: .pages.yml
            collapse_single_pages: true
            strict: false
    ```