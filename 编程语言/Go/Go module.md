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
>7:  `exclude` 排除依赖的版本。
>
>8: `replace`替换依赖。用于替换依赖包的内容，支持本地和仓库。

### Go mod 获取期望的依赖版本

#### 指定部分或完整版本号信息

如果只指定主版本，会找对应主版本号，以及次版本和修订版本最大的版本。
如果指定主版本和次版本，会找对应主版本和次版本，以及修订版本号最大的版本。
如果指定主版本、次版本和修订版本，会找对应主版本、次版本和修订版本的版本。
如果指定主版本、次版本、修订版本和先行版本号，会找主版本、次版本、修订版本和先行版本号对应的版本。

> 注意：如果当前项目依赖的仓库A依赖了B仓库，当前项目也依赖B，此时项目依赖的B版本和A依赖的版本保持一致。

假设 `github.com/xiaotianfork/q-tls-common` 目前有如下版本:

```go
v0.1.1
v0.1.2
v0.1.3-alpha
v0.1.3
```

`go.mod` 文件内容如下：

```go
# 指定主版本
github.com/xiaotianfork/q-tls-common v0
# 指定主版本和次版本
github.com/xiaotianfork/q-tls-common v0.1
# 指定主版本、次版本和修订版本
github.com/xiaotianfork/q-tls-common v0.1.3
# 指定主版本、次版本、修订版本和先行版本号
# github.com/xiaotianfork/q-tls-common v0.1.3-alpha
```

执行 `go mod tidy` 之后上面的内容会被更新成如下内容：

```go
# 指定主版本
github.com/xiaotianfork/q-tls-common v0.1.3
# 指定主版本和次版本
github.com/xiaotianfork/q-tls-common v0.1.3
# 指定主版本、次版本和修订版本
github.com/xiaotianfork/q-tls-common v0.1.3
# 指定主版本、次版本、修订版本和先行版本号
# github.com/xiaotianfork/q-tls-common v0.1.3-alpha
```

对应的 `go get` 命令

```shell
go get github.com/xiaotianfork/q-tls-common@v0
go get github.com/xiaotianfork/q-tls-common@v0.1
go get github.com/xiaotianfork/q-tls-common@v0.1.3
go get github.com/xiaotianfork/q-tls-common@v0.1.3-alpha
```

#### 特殊版本标识

**latest**: 选择最高的 release 版本，如果没有 release 版本，则选择最高的 pre-release 版本，如果根本就没有打过 tag，则选择最高的伪版本号的版本(默认分支的最后的提交版本)。
**upgrade**: 类似 latest，但是如果有比release更高的版本(比如pre-release)，会选择更高的版本。
**patch**: major 和 minor 和当前的版本相同，只把patch升级到最高。当然如果没有当前的版本，则无从比较，则 patch 退化成 latest 语义。

对应的 `go.mod` 文件。

```go
# 指定主版本
github.com/xiaotianfork/q-tls-common latest
github.com/xiaotianfork/q-tls-common upgrade
github.com/xiaotianfork/q-tls-common patch
```

执行 `go mod tidy` 之后上面的内容会被更新成如下内容：

```shell
github.com/xiaotianfork/q-tls-common v0.1.3
github.com/xiaotianfork/q-tls-common v0.1.3
github.com/xiaotianfork/q-tls-common v0.1.3
```

#### 指定特定的 commit id

```shell
# 指定提交 commit id
github.com/xiaotianfork/q-tls-common 7982002
go get github.com/xiaotianfork/q-tls-common@7982002
# 结果
github.com/xiaotianfork/q-tls-common v0.0.11-0.20210723072042-798200281f4a

# 最新代码
github.com/panicthis/H HEAD
go get github.com/xiaotianfork/q-tls-common@HEAD
# 结果
github.com/xiaotianfork/q-tls-common v0.1.3
```

#### 指定分支

```shell
github.com/xiaotianfork/q-tls-common develop
go get github.com/xiaotianfork/q-tls-common@develop
```

#### 数学符号

找符合条件的最大版本号。

```shell
# go module 
github.com/xiaotianfork/q-tls-common >v0.1.2
github.com/xiaotianfork/q-tls-common >=v0.1.2
github.com/xiaotianfork/q-tls-common <v0.1.2
github.com/xiaotianfork/q-tls-common <=v0.1.2
# go get 
go get github.com/xiaotianfork/q-tls-common >v0.1.2
go get github.com/xiaotianfork/q-tls-common >=v0.1.2
go get github.com/xiaotianfork/q-tls-common <v0.1.2
go get github.com/xiaotianfork/q-tls-common <=v0.1.2
```

#### 移除依赖

使用 `none` 关键字可以从 go module 中移除依赖。

```shell
go get github.com/stretchr/testify@none
```
