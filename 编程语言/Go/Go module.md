时间：2022-03-17 11:13:13

1. [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)
2. [深入Go Module之go.mod文件解析](https://colobu.com/2021/06/28/dive-into-go-module-1/)
3. [深入Go Module之讨厌的v2](https://colobu.com/2021/06/28/dive-into-go-module-2/)
4. [深入Go Module之未说的秘密](https://colobu.com/2021/07/04/dive-into-go-module-3/)

## 语义化版本管理

版本格式：主版本号.次版本号.修订号，版本号递增规则如下：

主版本号：当你做了不兼容的 `API` 修改。
次版本号：当你做了向下兼容的功能性新增。
修订号：当你做了向下兼容的问题修正。

先行版本号及版本编译信息可以加到  `主版本号.次版本号.修订号` 的后面，作为延伸。

包含先行版本号的格式：`主版本号.次版本号.修订号-先行版本号-版本编译信息`，如 `v1.1.0-alpha` `v1.1.0-fix` 等。

## Go Module

### Go mod 文件介绍

```go
1: module github.com/xiaotian/demo

2: go 1.16

3: require (
    4: github.com/apache/arrow/go/arrow v0.0.0-20210819073141-67c71af79ca2
    5: github.com/bittygarden/lilac v1.1.11
	github.com/fsnotify/fsnotify v1.4.9
	github.com/gogo/protobuf v1.3.2
	github.com/golang/mock v1.5.0
	github.com/hashicorp/mdns v1.0.4
	github.com/kr/pretty v0.1.0
    6: github.com/kr/text v0.2.0 // indirect
	github.com/michaelklishin/rabbit-hole/v2 v2.2.0
	github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e // indirect
	github.com/onsi/ginkgo v1.14.0
	github.com/onsi/gomega v1.10.1
	github.com/pkg/errors v0.9.1
	github.com/spf13/cobra v1.1.3
	github.com/streadway/amqp v1.0.0
	github.com/willf/bitset v1.1.11
	golang.org/x/net v0.0.0-20210614182718-04defd469f4e
	google.golang.org/grpc v1.39.0
	gopkg.in/check.v1 v1.0.0-20200227125254-8fa46927fb4f // indirect
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776 // indirect
)

7: exclude (
	github.com/stretchr/testify v1.7.0
	github.com/syndtr/goleveldb v1.0.0
)

8: google.golang.org/grpc => ../grpc
```

>1 :  `module github.com/xiaotian/demo` 当前项目的 module path，别的项目如果依赖这个项目，在依赖文件中写这个 path 即可。
>
>2: 当前项目支持的最低 Go 版本。
>
>3:  `require` 项目依赖的库和库的版本。
>
>4: `github.com/apache/arrow/go/arrow v0.0.0-20210819073141-67c71af79ca2` 伪版本号。`v0.0.0` 表示依赖的仓库没有发布正式版本，`20210819073141` 表示依赖提交的日期，`67c71af79ca2` 表示依赖的哪一次提交的（git 的提交标识）。
>
>5 ：`github.com/bittygarden/lilac v1.1.11` 依赖确定的版本，仓库的 `v1.1.11` 版本。
>
>6: `github.com/kr/text v0.2.0 // indirect` indirect 标识间接依赖（依赖的其它仓库的依赖）。
>
>7:  `exclude` 排除依赖。
>
>8: `replace`替换依赖。用于替换依赖包的内容，支持本地和仓库。


### Go mod 版本依赖规则