api.json时间：2021-10-22 15:52:52

参考：

1. [language-server-protocol](https://microsoft.github.io/language-server-protocol/)
2. [JSON-RPC](http://wiki.geekdream.com/Specification/json-rpc_2.0.html)
3. [语言服务器协议](https://docs.microsoft.com/zh-cn/visualstudio/extensibility/language-server-protocol?view=vs-2019)

## LSP 简介

**要做的事情**：定义交互规范，减少重复的工作，一套规范适用于各种语言。有了规范之后，开发一个编辑器可以适配到不同的语言服务器，同时同一个服务器也可以被不同的编辑器使用。

LSP（Language Server Protocol） 语言服务器协议。定义编辑器和语言服务器之间的协议，如代码补全、重命名、跳转到定义、找到所用引用，等等。

代码编辑器和语言服务器之间是`C/S`模式，使用`JSON-RPC`交互。代码编辑器把请求发送到语言服务器，语言服务器根据请求做出具体的动作。

如当需要代码补全的时候，编辑器把代码和鼠标光标所在位置发送给服务器，服务器根据请求返回不全的内容。

![](../../img/lsp/lsp.png)

### LSP 接口请求和响应

####  initialize

```json
# 请求
InitializeParams{
    ProcessID:             2233,
    ClientInfo:            struct { Name string "json:\"name\""; Version string "json:\"version,omitempty\"" }
								  { Name:"test",                 Version:"v1.0.0"},
    Locale:                "",
    RootPath:              "",
    RootURI:               "",
    Capabilities:          main.ClientCapabilities{},
    InitializationOptions: nil,
    Trace:                 "",
    WorkspaceFolders:      {
        {URI:"file://test", Name:"test"},
    },
}

# 响应
InitializeResult{
    Capabilities: main.ServerCapabilities{
        TextDocumentSync: map[string]interface {}{
            "openClose": bool(true),
            "change":    float64(2),
            "save":      map[string]interface {}{
            },
        },
        CompletionProvider: main.CompletionOptions{
            TriggerCharacters:       {"."},
            AllCommitCharacters:     nil,
            ResolveProvider:         false,
            CompletionItem:          struct { LabelDetailsSupport bool "json:\"labelDetailsSupport,omitempty\"" }{},
            WorkDoneProgressOptions: main.WorkDoneProgressOptions{},
        },
        HoverProvider:         true,
        SignatureHelpProvider: main.SignatureHelpOptions{
            TriggerCharacters:       {"(", ","},
            RetriggerCharacters:     nil,
            WorkDoneProgressOptions: main.WorkDoneProgressOptions{},
        },
        DeclarationProvider:              nil,
        DefinitionProvider:               true,
        TypeDefinitionProvider:           bool(true),
        ImplementationProvider:           bool(true),
        ReferencesProvider:               true,
        DocumentHighlightProvider:        true,
        DocumentSymbolProvider:           true,
        CodeActionProvider:               bool(true),
        CodeLensProvider:                 main.CodeLensOptions{},
        DocumentLinkProvider:             main.DocumentLinkOptions{},
        ColorProvider:                    nil,
        WorkspaceSymbolProvider:          true,
        DocumentFormattingProvider:       true,
        DocumentRangeFormattingProvider:  false,
        DocumentOnTypeFormattingProvider: main.DocumentOnTypeFormattingOptions{},
        RenameProvider:                   bool(true),
        FoldingRangeProvider:             bool(true),
        SelectionRangeProvider:           nil,
        ExecuteCommandProvider:           main.ExecuteCommandOptions{
            Commands:                {
                "gopls.add_dependency", 
                "gopls.add_import", 
                "gopls.apply_fix", 
                "gopls.check_upgrades", 
                "gopls.gc_details", 
                "gopls.generate", 
                "gopls.generate_gopls_mod", 
                "gopls.go_get_package", 
                "gopls.list_known_packages", 
                "gopls.regenerate_cgo", 
                "gopls.remove_dependency", 
                "gopls.run_tests", 
                "gopls.start_debugging", 
                "gopls.test", 
                "gopls.tidy", 
                "gopls.toggle_gc_details", 
                "gopls.update_go_sum", 
                "gopls.upgrade_dependency", 
                "gopls.vendor", 
                "gopls.workspace_metadata"
            },
            WorkDoneProgressOptions: main.WorkDoneProgressOptions{},
        },
        CallHierarchyProvider:      bool(true),
        LinkedEditingRangeProvider: nil,
        SemanticTokensProvider:     nil,
        Workspace:                  main.Workspace5Gn{
            FileOperations:   (*main.FileOperationOptions)(nil),
            WorkspaceFolders: main.WorkspaceFolders4Gn{
                Supported:true, 
                ChangeNotifications:"workspace/didChangeWorkspaceFolders"
            },
        },
        MonikerProvider: nil,
        Experimental:    nil,
    },
    ServerInfo: struct { Name string "json:\"name\""; Version string "json:\"version,omitempty\"" }
                       { Name:"gopls",                Version:"{\"path\":\"golang.org/x/tools/gopls\",\"version\":\"(devel)\",\"deps\":[{\"path\":\"github.com/BurntSushi/toml\",\"version\":\"v0.4.1\""}]}"},
}
```

#### initialized

响应收到初始化结果响应。服务端收到请求后开始监听工作目录文件的变化。

```json
# 请求参数
{}
# 响应数据
无
```

#### textDocument/completion 自动完成

```json
# 请求参数
{
    Context:                    main.CompletionContext{},
    TextDocumentPositionParams: main.TextDocumentPositionParams{
        TextDocument: main.TextDocumentIdentifier{URI:"file://test//hello.go"},
        Position:     main.Position{Line:0x1, Character:0x4},
    },
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "333333333333333333333",
    },
    PartialResultParams: main.PartialResultParams{},
}
# 响应数据
{
    "items": []interface {}{
        map[string]interface {}{
            "sortText":         "00000",
            "filterText":       "const",
            "insertTextFormat": float64(1),
            "textEdit":         map[string]interface {}{
                "range": map[string]interface {}{
                    "start": map[string]interface {}{
                        "line":      float64(1),
                        "character": float64(1),
                    },
                    "end": map[string]interface {}{
                        "line":      float64(1),
                        "character": float64(1),
                    },
                },
                "newText": "const",
            },
            "label":        "const",
            "labelDetails": map[string]interface {}{
            },
            "kind":      float64(14),
            "preselect": bool(true),
        },
        ... ...
        map[string]interface {}{
            "insertTextFormat": float64(1),
            "textEdit":         map[string]interface {}{
                "range": map[string]interface {}{
                    "end": map[string]interface {}{
                        "line":      float64(1),
                        "character": float64(1),
                    },
                    "start": map[string]interface {}{
                        "line":      float64(1),
                        "character": float64(1),
                    },
                },
                "newText": "var",
            },
            "label":        "var",
            "labelDetails": map[string]interface {}{
            },
            "kind":       float64(14),
            "sortText":   "00004",
            "filterText": "var",
        },
    },
    "isIncomplete": bool(true),
}
```

#### textDocument/hover 鼠标悬停信息

```json
# 请求
HoverParams{
    TextDocumentPositionParams: main.TextDocumentPositionParams{
        TextDocument: main.TextDocumentIdentifier{URI:"file://test//hello.go"},
        Position:     main.Position{Line:0x8, Character:0xa},
    },
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "44444444444444",
    },
}
# 响应
{
    "contents": map[string]interface {}{
        "kind":  "markdown",
        "value": "```go\nfunc fmt.Println(a ...interface{}) (n int, err error)\n```\n\n[`fmt.Println` on pkg.go.dev](https://pkg.go.dev/fmt?utm_source=gopls#Println)\n\nPrintln formats using the default formats for its operands and writes to standard output\\.\nSpaces are always added between operands and a newline is appended\\.\nIt returns the number of bytes written and any write error encountered\\.\n",
    },
    "range": map[string]interface {}{
        "start": map[string]interface {}{
            "character": float64(5),
            "line":      float64(8),
        },
        "end": map[string]interface {}{
            "line":      float64(8),
            "character": float64(12),
        },
    },
}
```

#### textDocument/signatureHelp 签名帮助

```json
#请求
SignatureHelpParams{
    Context: main.SignatureHelpContext{
        TriggerKind:         0,
        TriggerCharacter:    "(",
        IsRetrigger:         true,
        ActiveSignatureHelp: main.SignatureHelp{},
    },
    TextDocumentPositionParams: main.TextDocumentPositionParams{
        TextDocument: main.TextDocumentIdentifier{URI:"file://test//hello.go"},
        Position:     main.Position{Line:0x8, Character:0x19},
    },
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "5555555555555",
    },
}
# 响应
{
    "activeParameter": float64(0),
    "signatures":      []interface {}{
        map[string]interface {}{
            "documentation": "Println formats using the default formats for its operands and writes to standard output.\nSpaces are always added between operands and a newline is appended.\nIt returns the number of bytes written and any write error encountered.\n",
            "parameters":    []interface {}{
                map[string]interface {}{
                    "label": "a ...interface{}",
                },
            },
            "label": "Println(a ...interface{}) (n int, err error)",
        },
    },
    "activeSignature": float64(0),
}
```

#### textDocument/references 变量、方法

```json
# 请求
{
    Context:                    main.ReferenceContext{},
    TextDocumentPositionParams: main.TextDocumentPositionParams{
        TextDocument: main.TextDocumentIdentifier{URI:"file://test//hello.go"},
        Position:     main.Position{Line:0x7, Character:0x5},
    },
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "77777777777777777777",
    },
    PartialResultParams: main.PartialResultParams{},
}
# 响应
{
    {
        URI:   "file:///C:/test/hello.go",
        Range: main.Range{
            Start: main.Position{Line:0x7, Character:0x5},
            End:   main.Position{Line:0x7, Character:0xc},
        },
    },
    {
        URI:   "file:///C:/test/hello.go",
        Range: main.Range{
            Start: main.Position{Line:0x8, Character:0x5},
            End:   main.Position{Line:0x8, Character:0xc},
        },
    },
}
```

#### textDocument/documentHighlight 代码高亮

```json
# 请求
{
    TextDocumentPositionParams: main.TextDocumentPositionParams{
        TextDocument: main.TextDocumentIdentifier{URI:"file://test//hello.go"},
        Position:     main.Position{Line:0x7, Character:0x5},
    },
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "77777777777777777777",
    },
    PartialResultParams: main.PartialResultParams{},
}
# 响应
{
    {
        Range: main.Range{
            Start: main.Position{Line:0x7, Character:0x5},
            End:   main.Position{Line:0x7, Character:0xc},
        },
        Kind: 1,
    },
    {
        Range: main.Range{
            Start: main.Position{Line:0x8, Character:0x5},
            End:   main.Position{Line:0x8, Character:0xc},
        },
        Kind: 1,
    },
}
```

#### textDocument/documentSymbol 文档符号信息

```json
# 请求
{
    TextDocument:           main.TextDocumentIdentifier{URI:"file://test//hello.go"},
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "77777777777777777777",
    },
    PartialResultParams: main.PartialResultParams{},
}
# 响应
{
    {
        Name:           "main",
        Detail:         "",
        Kind:           12,
        Tags:           nil,
        Deprecated:     false,
        Range:          main.Range{},
        SelectionRange: main.Range{},
        Children:       nil,
    },
}
```

#### textDocument/codeAction 

```json
# 请求
{
    TextDocument:           main.TextDocumentIdentifier{URI:"file://test//hello.go"},
    Range:                  main.Range{},
    Context:                main.CodeActionContext{},
    WorkDoneProgressParams: main.WorkDoneProgressParams{
        WorkDoneToken: "1010101010101010",
    },
    PartialResultParams: main.PartialResultParams{},
}
# 响应
{
    {
        Title:       "Organize Imports",
        Kind:        "source.organizeImports",
        Diagnostics: nil,
        IsPreferred: false,
        Disabled:    (*struct { Reason string "json:\"reason\"" })(nil),
        Edit:        main.WorkspaceEdit{
            Changes:         {},
            DocumentChanges: {
                {
                    TextDocument: main.OptionalVersionedTextDocumentIdentifier{
                        Version:                0,
                        TextDocumentIdentifier: main.TextDocumentIdentifier{URI:"file:///C:/test/hello.go"},
                    },
                    Edits: {
                        {
                            Range: main.Range{
                                Start: main.Position{Line:0x2, Character:0x7},
                                End:   main.Position{Line:0x2, Character:0x7},
                            },
                            NewText: "(\n\t",
                        },
                        {
                            Range: main.Range{
                                Start: main.Position{Line:0x2, Character:0xc},
                                End:   main.Position{Line:0x2, Character:0xc},
                            },
                            NewText: "\n",
                        },
                        {
                            Range: main.Range{
                                Start: main.Position{Line:0x3, Character:0x0},
                                End:   main.Position{Line:0x3, Character:0x7},
                            },
                            NewText: "",
                        },
                        {
                            Range: main.Range{
                                Start: main.Position{Line:0x3, Character:0x7},
                                End:   main.Position{Line:0x3, Character:0x7},
                            },
                            NewText: "\t",
                        },
                        {
                            Range: main.Range{
                                Start: main.Position{Line:0x4, Character:0x0},
                                End:   main.Position{Line:0x4, Character:0x0},
                            },
                            NewText: ")\n",
                        },
                    },
                },
            },
            ChangeAnnotations: {},
        },
        Command: (*main.Command)(nil),
        Data:    nil,
    },
}
```

#### workspace/executeCommand 执行命令

##### gopls.list_known_packages 查看已知的包

```json
# 请求参数
{"command":"gopls.list_known_packages","arguments":[{"URI":"file://test/hello.go"}]}
# 响应参数
{
    "Packages": []interface {}{
        "archive/tar",
        "archive/zip",
        ... ...
        "unicode",
        "unicode/utf16",
        "unicode/utf8",
        "unsafe",
    }
}
```

##### gopls.tidy 执行 `go mod tidy`

```json
# 请求参数
{"command":"gopls.tidy","arguments":[{"URI":"file://test/go.mod"}]}
# 响应数据
无
```

##### gopls.vendor 执行 `go mod vendor`

```json
# 请求参数
{"command":"gopls.vendor","arguments":[{"URI":"file://test/go.mod"}]}
# 响应数据
无
```

##### gopls.add_dependency
##### gopls.add_import
##### gopls.apply_fix
##### gopls.check_upgrades
##### gopls.gc_details
##### gopls.generate
##### gopls.generate_gopls_mod
##### gopls.go_get_package
##### gopls.regenerate_cgo
##### gopls.remove_dependency
##### gopls.run_tests
##### gopls.start_debugging
##### gopls.test
##### gopls.toggle_gc_details
##### gopls.update_go_sum
##### gopls.upgrade_dependency
##### gopls.workspace_metadata