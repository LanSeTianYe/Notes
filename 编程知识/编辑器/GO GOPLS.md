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
  api-json : print json describing gopls API
  licenses : print licenses of included software

features:
  call_hierarchy : display selected identifier's call hierarchy
  check : show diagnostic results for the specified file
  definition : show declaration of selected identifier
  folding_ranges : display selected file's folding ranges
  format : format the code according to the go standard
  highlight : display selected identifier's highlights
  implementation : display selected identifier's implementation
  
  # 优化导入的包
  imports : updates import statements
  remote : interact with the gopls daemon
  inspect : interact with the gopls daemon (deprecated: use 'remote')
  links : list links in a file
  prepare_rename : test validity of a rename operation at location
  references : display selected identifier's references
  
  # 重命名变量 gopls rename -w hello1.go:#61 ppp
  rename : rename selected identifier
  
  # 把源文件解析成token
  semtok : show semantic tokens for the specified file
  
  signature : display selected identifier's signature
  
  fix : apply suggested fixes
  
  # 显示文件的符号列表（符号指常量、结构体、方法等）
  # gopls symbols /usr/local/go/src/math/abs.go
  # Abs Function 12:6-12:9
  symbols : display selected file's symbols
  
  # 在工作目录中查找指定符号，返回文件路径和在文件中的位置。（语法提示）
  # gopls workspace_symbol math
  # /usr/local/go/src/math/abs.go:12:6-9 math.Abs Function
  workspace_symbol : search symbols in workspace
  
  workspace : manage the gopls workspace (experimental: under development)
 

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