**源文件：**

```go
package main

func main() {
    aaa := 10
    fmt.Println(aaa)
}
```

```shell
[root@localhost ~]# gopls --help

The Go Language source tools.

Usage: gopls [flags] <command> [command-flags] [command-args]

gopls is a Go language server. It is typically used with an editor to provide
language features. When no command is specified, gopls will default to the 'serve'
command. The language features can also be accessed via the gopls command-line interface.

Available commands are:

main:
  serve : run a server for Go code using the Language Server Protocol
  version : print the gopls version information
  bug : report a bug in gopls
  # 显示API文档
  api-json : print json describing gopls API
  licenses : print licenses of included software

features:

  # 方法在哪里被调用(不能查看变量在哪里被使用)
  # gopls call_hierarchy /usr/local/go/src/io/io.go:626:6
  # identifier: function ReadAll in /usr/local/go/src/io/io.go:626:6-13
  # callee[0]: ranges 633:15-19 in /usr/local/go/src/io/io.go from/to function Read in /usr/local/go/src/io/io.go:84:2-6
  call_hierarchy : display selected identifier's call hierarchy
  
  # 检查语法错误，不会检查格式
  # gopls check /usr/local/go/src/io/io.go
  check : show diagnostic results for the specified file
  
  # 方法定义
  # gopls definition /usr/local/go/src/math/bits/bits.go:19:6
  # LeadingZeros returns the number of leading zero bits in x; the result is UintSize for x == 0.
  definition : show declaration of selected identifier
  
  # 代码折叠范围（括号配对）
  # gopls folding_ranges /usr/local/go/src/errors/errors.go
  # 1:55-3:49
  # 5:61-53:65
  # 56:56-57:81
  # 58:10-58:20
  # 58:30-60:0
  # 59:22-59:25
  # 63:26-65:0
  # 67:7-67:20
  # 67:29-67:28
  # 67:39-69:0
  folding_ranges : display selected file's folding ranges
  
  # gopls format -l -w tt.go
  format : format the code according to the go standard
  
  # 高亮代码
  # gopls highlight /usr/local/go/src/errors/errors.go:67:7
  # /usr/local/go/src/errors/errors.go:67:7-8
  # /usr/local/go/src/errors/errors.go:68:9-10
  highlight : display selected identifier's highlights
  
  # 方法实现
  # gopls implementation /usr/local/go/src/io/io.go:96:6
  # /usr/local/go/src/internal/poll/fd_unix.go:17:6-8
  # /usr/local/go/src/io/io.go:573:6-13
  # /usr/local/go/src/io/pipe.go:153:6-16
  # /usr/local/go/src/os/types.go:16:6-10
  implementation : display selected identifier's implementation
  
  # 优化导入的包
  imports : updates import statements
  
  # 显示文件引用的包的说明文档地址
  links : list links in a file
  
 
  # 查看变量、结构体、方法在哪里被使用
  # gopls references -d /usr/local/go/src/io/io.go:626:6
  # /home/wide/src/tt/tt.go:16:5-12
  # /usr/local/go/src/io/io.go:626:6-13
  # gopls workspace_symbol os.PathS
  # /usr/local/go/src/os/path_unix.go:10:2-15 os.PathSeparator Constant
  # gopls references /usr/local/go/src/os/path_unix.go:10:2
  # /usr/local/go/src/os/path_unix.go:16:9-22
  # /usr/local/go/src/os/removeall_at.go:124:36-49
  # /usr/local/go/src/os/removeall_at.go:50:38-51
  # /usr/local/go/src/os/tempfile.go:114:22-35
  # /usr/local/go/src/os/tempfile.go:46:64-77
  # /usr/local/go/src/os/tempfile.go:99:62-75
  references : display selected identifier's references
 
  # 检查重命名操作参数是否正确
  # 正确：
  # gopls prepare_rename /usr/local/go/src/errors/errors.go:67:7
  # /usr/local/go/src/errors/errors.go:67:7-8
  # 错误：
  # gopls prepare_rename /usr/local/go/src/errors/errors.go:67:6
  # gopls: request is not valid at the given position
  prepare_rename : test validity of a rename operation at location
  # 重命名变量 gopls rename -w hello1.go:#61 ppp
  rename : rename selected identifier
  
  # 把源文件解析成token（词法解析）
  semtok : show semantic tokens for the specified file
    
  # 显示文件的符号列表（符号指常量、结构体、方法等）
  # gopls symbols /usr/local/go/src/math/abs.go
  # Abs Function 12:6-12:9
  symbols : display selected file's symbols
  
  # 在工作目录中查找指定符号，返回文件路径和在文件中的位置。（语法提示）
  # gopls workspace_symbol math
  # /usr/local/go/src/math/abs.go:12:6-9 math.Abs Function
  workspace_symbol : search symbols in workspace
  
  workspace : manage the gopls workspace (experimental: under development)
  signature : display selected identifier's signature
  # 链接远程服务
  # 启动服务：gopls -vv serve -listen "192.168.88.130:9877" -logfile /tmp/gopls.log -rpc.trace
  # 连接服务：gopls -remote 192.168.88.130:9877 remote debug
  # 查看session：gopls -remote 192.168.88.130:9877 remote sessions
  remote : interact with the gopls daemon
  inspect : interact with the gopls daemon (deprecated: use 'remote')
  fix : apply suggested fixes
 
gopls flags are:
  -debug string
        serve debug information on the supplied address
  -listen string
        address on which to listen for remote connections. If prefixed by 'unix;', the subsequent address is assumed to be a unix domain socket. Otherwise, TCP is used.
  -listen.timeout duration
        when used with -listen, shut down the server when there are no connected clients for this duration
  -logfile string
        filename to log to. if value is "auto", then logging to a default output file is enabled
  -mode string
        no effect
  -ocagent string
        the address of the ocagent (e.g. http://localhost:55678), or off (default "off")
  -port int
        port on which to run gopls for debugging purposes
  -profile.cpu string
        write CPU profile to this file
  -profile.mem string
        write memory profile to this file
  -profile.trace string
        write trace log to this file
  -remote string
        forward all commands to a remote lsp specified by this flag. With no special prefix, this is assumed to be a TCP address. If prefixed by 'unix;', the subsequent address is assumed to be a unix domain socket. If 'auto', or prefixed by 'auto;', the remote address is automatically resolved based on the executing environment.
  -remote.debug string
        when used with -remote=auto, the -debug value used to start the daemon
  -remote.listen.timeout duration
        when used with -remote=auto, the -listen.timeout value used to start the daemon (default 1m0s)
  -remote.logfile string
        when used with -remote=auto, the -logfile value used to start the daemon
  -rpc.trace
        print the full rpc trace in lsp inspector format
  -v    verbose output
  -vv
        very verbose output
```