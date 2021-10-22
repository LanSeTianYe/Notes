时间：2021-10-22 15:52:52

参考：

1. [language-server-protocol](https://microsoft.github.io/language-server-protocol/)
2. [JSON-RPC](http://wiki.geekdream.com/Specification/json-rpc_2.0.html)

## LSP 简介

**要做的事情**：定义交互规范，减少重复的工作，一套规范适用于各种语言。有了规范之后，开发一个编辑器可以适配到不同的语言服务器，同时同一个服务器也可以被不同的编辑器使用。

LSP（Language Server Protocol） 语言服务器协议。定义编辑器和语言服务器之间的协议，如代码补全、重命名、跳转到定义、找到所用引用，等等。

代码编辑器和语言服务器之间是`C/S`模式，使用`JSON-RPC`交互。代码编辑器把请求发送到语言服务器，语言服务器根据请求做出具体的动作。

如当需要代码补全的时候，编辑器把代码和鼠标光标所在位置发送给服务器，服务器根据请求返回不全的内容。

![](../../img/lsp/lsp.png)

### 