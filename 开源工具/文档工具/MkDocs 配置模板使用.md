时间：2020/7/1 9:55:22  

参考：

1. [mkdocs](https://www.mkdocs.org/)  
2. [主题](https://jamstackthemes.dev/ssg/mkdocs/)
3. [Typora](https://www.typora.io/)

# 项目
## 项目简介
mkdocs 模板项目，使用 `mkdocs new` 初始化项目之后对修改了一些配置信息，方便配置使用

mkdocs 安装和插件安装可参考 [软件安装](./软件安装.md) 章节内容。

模板地址: [配置模板](https://github.com/ProjectTemplate/mkdocs-config-template.git)

模板效果可参考:  [蓝田的笔记](http://note.sunfeilong.com/)

配置修改的点：

* 主题：使用 `material` 主题。

* 文件构建日期。（基于 git 提交记录，因此要求 `docs` 目录里面的内容是一个 `git项目` ）。

* 代码高亮、代码行数，高亮语法如下,：

    ```go
    func hello(){
        fmt.Println("Hello MkDocs")
    }
    ```
    
* 搜索。

* 目录显示内容精确控制。

需要提前安装的主题和插件:

* `pip install mkdocs-material`
* `pip install mkdocs-git-revision-date-localized-plugin`
* `pip install mkdocs-awesome-pages-plugin`

## 怎么使用

修改 [build.sh](./build.sh) 脚本中的 `git_repository` 变量内容，然后执行 `build.sh` 脚本,脚本执行结束之后会在当前目录生成 `site` 文件夹，里面是构建好的静态网站,把该目录发布到服务器(nginx,tomcat等)即可访问。

## 自动更新  
提供一个接口当 `git 仓库` 内容发生变化的时候，调用该接口执行 `build.sh` 脚本，实现自动构建。当然也可以手动调用接口，服务端基于 `python` 实现。服务启动脚本`run_server.sh`。

### 服务配置

修改 [run_server.sh](./run_server.sh) 里面的三个参数为自己需要的参数。

* 绑定的IP: `host="127.0.0.1"`
* 绑定的端口: `port=34251`
* 认证 key (用于校验请求是否合法): `auth_key="72e0013883cbc8333575c250bc0d14cd"`


请求示例: `http://127.0.0.1:34251?auth_key=72e0013883cbc8333575c250bc0d14cd`

### 参考 
使用 nginx 的时可以把对应的请求路径映射到该接口，配置如下:

```nginx
server {
     listen       80;
     server_name  note.sunfeilong.com;
     
     location / {
         root /home/.../site/;
         index index.html;
     }

     location /rebuild {
         proxy_pass   http://127.0.0.1:34251;
     }
```
