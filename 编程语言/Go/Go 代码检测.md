时间：2021-11-25 15:17:17

参考：

1. [https://github.com/golang/lint](https://github.com/golang/lint)
2. [staticcheck](https://staticcheck.io/docs/)
3. [如果你用Go，不要忘了vet](https://studygolang.com/articles/9619)
4. [golangci-lint](https://golangci-lint.run/)

## GO 代码检测

### GOLINT

检查代码命名规范，行长度，代码长度等问题。

仓库已经不维护，可以使用。

```
# 安装
go get -u golang.org/x/lint/golint
#使用
golint ./...
```

### go vet

检查代码中可能存在的Bug和性能问题。

* Print-format 错误
* Boolean 错误
* Range 循环
* Unreachable的代码
* 混杂的错误
* 误报和漏报

```
go vet ./...
```

### staticcheck

检查代码中可能存在的Bug和性能问题。

提供 [150+](https://staticcheck.io/docs/checks/) 检查选项。支持多种 [输出格式](https://staticcheck.io/docs/running-staticcheck/cli/formatters/)。

```shell
Usage: staticcheck [flags] [packages]

Flags:
  -checks checks
        Comma-separated list of checks to enable. (default "inherit")
  -explain check
        Print description of check
  -f format
        Output format (valid choices are 'stylish', 'text' and 'json') (default text)
  -fail checks
        Comma-separated list of checks that can cause a non-zero exit status. (default "all")
  -go version
        Target Go version in the format '1.x', or the literal 'module' to use the module's Go version (default "module")
  -list-checks
        List all available checks
  -show-ignored
        Don't filter ignored problems
  -tags build tags
        List of build tags
  -tests
        Include tests (default true)
  -version
        Print version and exit
```

**输出格式：**

* Text: 文本格式输出

    ```shell 
    go/src/fmt/print.go:1069:15: this value of afterIndex is never used (SA4006)
    ```

* Stylish：根据文件分组输出信息。

    ```shell
    go/src/fmt/fmt_test.go
    (43, 2)     S1021   should merge variable declaration with assignment on next line
    (1185, 10)  SA9003  empty branch

    go/src/fmt/print.go
    (77, 18)    ST1006  methods on the same type should have the same receiver name (seen 3x "b", 1x "bp")
    (1069, 15)  SA4006  this value of afterIndex is never used

    go/src/fmt/scan.go
    (465, 5)  ST1012  error var complexError should have name of the form errFoo
    (466, 5)  ST1012  error var boolError should have name of the form errFoo

    ✖ 6 problems (6 errors, 0 warnings)
    ```

* JSON：JSON格式输出

    ```json
    {
      "code": "SA4006",
      "severity": "error",
      "location": {
        "file": "/usr/lib/go/src/fmt/print.go",
        "line": 1082,
        "column": 15
      },
      "end": {
        "file": "/usr/lib/go/src/fmt/print.go",
        "line": 1082,
        "column": 25
      },
      "message": "this value of afterIndex is never used"
    }
    ```

**配置选项:**

配置信息写在当前目录的 `staticcheck.conf` 文件中。子目录会继承父目录的配置选项。子目录的相同配置会覆盖继承的配置。

```shell
# 检查哪些选项 `-` 排除
checks = ["all", "-ST1000", "-ST1003", "-ST1016", "-ST1020", "-ST1021", "-ST1022", "-ST1023"]
# 首字母缩写词，这些词需要全部大写（ST1003负责执行这些检测）
initialisms = ["ACL", "API", "ASCII", "CPU", "CSS", "DNS", "EOF", "GUID", "HTML", "HTTP", "HTTPS", "ID", "IP", "JSON", "QPS", "RAM", "RPC", "SLA", "SMTP", "SQL", "SSH", "TCP", "TLS", "TTL", "UDP", "UI", "GID", "UID", "UUID", "URI", "URL", "UTF8", "VM", "XML", "XMPP", "XSRF", "XSS", "SIP", "RTP", "AMQP", "DB", "TS"]
# 可以 . 导入再任何地方 （ST1001 检测.导入）
dot_import_whitelist = ["github.com/mmcloughlin/avo/build", "github.com/mmcloughlin/avo/operand", "github.com/mmcloughlin/avo/reg"]
# 排除检测哪些常量（ST1013 检测没有使用常量的地方）
http_status_code_whitelist = ["200", "400", "404", "500"]
```

**不检查行或者文件：**

忽略单行用法：在行上面加注释 `//lint:ignore Check1[,Check2,...,CheckN] reason`

```go
func TestNewEqual(t *testing.T) {
  //lint:ignore SA4000 we want to make sure that no two results of errors.New are ever the same
  if errors.New("abc") == errors.New("abc") {
    t.Errorf(`New("abc") == New("abc")`)
  }
}
```

忽略整个文件用法：在文件开头加注释 `//lint:file-ignore U1000 Ignore all unused code, it's generated`

**使用手册：**

```shell
# 检测当前包
staticcheck .
# 检测当前包，指定go版本
staticcheck -go 1.16 .
# 检测当前包，排除测试代码
staticcheck -tests=false .
# 检测当前包，指定输出格式 [text jsonsty lish]
staticcheck -f json .
# 检测当前包
staticcheck ./...

# 查看检测规则的说明
staticcheck -explain SA5009

··· 输出内容如下
    Invalid Printf call

    Available since
        2019.2

    Online documentation
        https://staticcheck.io/docs/checks#SA5009
···
```

### golangci-lint

是集成了多个linters（静态分析工具）的框架，支持30多种linters，并且可以同时运行它们。

```shell
➜ $ golangci-lint help linters
Enabled by default linters:
errcheck: Errcheck is a program for checking for unchecked errors in go programs. These unchecked errors can be critical bugs in some cases [fast: false, auto-fix: false]
gosimple (megacheck): Linter for Go source code that specializes in simplifying code [fast: false, auto-fix: false]
govet (vet, vetshadow): Vet examines Go source code and reports suspicious constructs, such as Printf calls whose arguments do not align with the format string [fast: false, auto-fix: false]
ineffassign: Detects when assignments to existing variables are not used [fast: true, auto-fix: false]
staticcheck (megacheck): It's a set of rules from staticcheck. It's not the same thing as the staticcheck binary. The author of staticcheck doesn't support or approve the use of staticcheck as a library inside golangci-lint. [fast: false, auto-fix: false]
typecheck: Like the front-end of a Go compiler, parses and type-checks Go code [fast: false, auto-fix: false]
unused (megacheck): Checks Go code for unused constants, variables, functions and types [fast: false, auto-fix: false]

Disabled by default linters:
asasalint: check for pass []any as any in variadic func(...any) [fast: false, auto-fix: false]
asciicheck: Simple linter to check that your code does not contain non-ASCII identifiers [fast: true, auto-fix: false]
bidichk: Checks for dangerous unicode character sequences [fast: true, auto-fix: false]
bodyclose: checks whether HTTP response body is closed successfully [fast: false, auto-fix: false]
containedctx: containedctx is a linter that detects struct contained context.Context field [fast: true, auto-fix: false]
contextcheck: check whether the function uses a non-inherited context [fast: false, auto-fix: false]
cyclop: checks function and package cyclomatic complexity [fast: false, auto-fix: false]
deadcode [deprecated]: Finds unused code [fast: false, auto-fix: false]
decorder: check declaration order and count of types, constants, variables and functions [fast: true, auto-fix: false]
depguard: Go linter that checks if package imports are in a list of acceptable packages [fast: true, auto-fix: false]
dogsled: Checks assignments with too many blank identifiers (e.g. x, _, _, _, := f()) [fast: true, auto-fix: false]
dupl: Tool for code clone detection [fast: true, auto-fix: false]
dupword: checks for duplicate words in the source code [fast: true, auto-fix: true]
durationcheck: check for two durations multiplied together [fast: false, auto-fix: false]
errchkjson: Checks types passed to the json encoding functions. Reports unsupported types and optionally reports occasions, where the check for the returned error can be omitted. [fast: false, auto-fix: false]
errname: Checks that sentinel errors are prefixed with the `Err` and error types are suffixed with the `Error`. [fast: false, auto-fix: false]
errorlint: errorlint is a linter for that can be used to find code that will cause problems with the error wrapping scheme introduced in Go 1.13. [fast: false, auto-fix: false]
execinquery: execinquery is a linter about query string checker in Query function which reads your Go src files and warning it finds [fast: false, auto-fix: false]
exhaustive: check exhaustiveness of enum switch statements and map literals [fast: false, auto-fix: false]
exhaustivestruct [deprecated]: Checks if all struct's fields are initialized [fast: false, auto-fix: false]
exhaustruct: Checks if all structure fields are initialized [fast: false, auto-fix: false]
exportloopref: checks for pointers to enclosing loop variables [fast: false, auto-fix: false]
forbidigo: Forbids identifiers [fast: true, auto-fix: false]
forcetypeassert: finds forced type assertions [fast: true, auto-fix: false]
funlen: Tool for detection of long functions [fast: true, auto-fix: false]
gci: Gci controls golang package import order and makes it always deterministic. [fast: true, auto-fix: false]
gochecknoglobals: check that no global variables exist [fast: true, auto-fix: false]
gochecknoinits: Checks that no init functions are present in Go code [fast: true, auto-fix: false]
gocognit: Computes and checks the cognitive complexity of functions [fast: true, auto-fix: false]
goconst: Finds repeated strings that could be replaced by a constant [fast: true, auto-fix: false]
gocritic: Provides diagnostics that check for bugs, performance and style issues. [fast: false, auto-fix: false]
gocyclo: Computes and checks the cyclomatic complexity of functions [fast: true, auto-fix: false]
godot: Check if comments end in a period [fast: true, auto-fix: true]
godox: Tool for detection of FIXME, TODO and other comment keywords [fast: true, auto-fix: false]
goerr113: Golang linter to check the errors handling expressions [fast: false, auto-fix: false]
gofmt: Gofmt checks whether code was gofmt-ed. By default this tool runs with -s option to check for code simplification [fast: true, auto-fix: true]
gofumpt: Gofumpt checks whether code was gofumpt-ed. [fast: true, auto-fix: true]
goheader: Checks is file header matches to pattern [fast: true, auto-fix: false]
goimports: In addition to fixing imports, goimports also formats your code in the same style as gofmt. [fast: true, auto-fix: true]
golint [deprecated]: Golint differs from gofmt. Gofmt reformats Go source code, whereas golint prints out style mistakes [fast: false, auto-fix: false]
gomnd: An analyzer to detect magic numbers. [fast: true, auto-fix: false]
gomoddirectives: Manage the use of 'replace', 'retract', and 'excludes' directives in go.mod. [fast: true, auto-fix: false]
gomodguard: Allow and block list linter for direct Go module dependencies. This is different from depguard where there are different block types for example version constraints and module recommendations. [fast: true, auto-fix: false]
goprintffuncname: Checks that printf-like functions are named with `f` at the end [fast: true, auto-fix: false]
gosec (gas): Inspects source code for security problems [fast: false, auto-fix: false]
grouper: An analyzer to analyze expression groups. [fast: true, auto-fix: false]
ifshort [deprecated]: Checks that your code uses short syntax for if-statements whenever possible [fast: true, auto-fix: false]
importas: Enforces consistent import aliases [fast: false, auto-fix: false]
interfacebloat: A linter that checks the number of methods inside an interface. [fast: true, auto-fix: false]
interfacer [deprecated]: Linter that suggests narrower interface types [fast: false, auto-fix: false]
ireturn: Accept Interfaces, Return Concrete Types [fast: false, auto-fix: false]
lll: Reports long lines [fast: true, auto-fix: false]
loggercheck (logrlint): Checks key valur pairs for common logger libraries (kitlog,klog,logr,zap). [fast: false, auto-fix: false]
maintidx: maintidx measures the maintainability index of each function. [fast: true, auto-fix: false]
makezero: Finds slice declarations with non-zero initial length [fast: false, auto-fix: false]
maligned [deprecated]: Tool to detect Go structs that would take less memory if their fields were sorted [fast: false, auto-fix: false]
misspell: Finds commonly misspelled English words in comments [fast: true, auto-fix: true]
nakedret: Finds naked returns in functions greater than a specified function length [fast: true, auto-fix: false]
nestif: Reports deeply nested if statements [fast: true, auto-fix: false]
nilerr: Finds the code that returns nil even if it checks that the error is not nil. [fast: false, auto-fix: false]
nilnil: Checks that there is no simultaneous return of `nil` error and an invalid value. [fast: false, auto-fix: false]
nlreturn: nlreturn checks for a new line before return and branch statements to increase code clarity [fast: true, auto-fix: false]
noctx: noctx finds sending http request without context.Context [fast: false, auto-fix: false]
nolintlint: Reports ill-formed or insufficient nolint directives [fast: true, auto-fix: false]
nonamedreturns: Reports all named returns [fast: false, auto-fix: false]
nosnakecase [deprecated]: nosnakecase is a linter that detects snake case of variable naming and function name. [fast: true, auto-fix: false]
nosprintfhostport: Checks for misuse of Sprintf to construct a host with port in a URL. [fast: true, auto-fix: false]
paralleltest: paralleltest detects missing usage of t.Parallel() method in your Go test [fast: false, auto-fix: false]
prealloc: Finds slice declarations that could potentially be pre-allocated [fast: true, auto-fix: false]
predeclared: find code that shadows one of Go's predeclared identifiers [fast: true, auto-fix: false]
promlinter: Check Prometheus metrics naming via promlint [fast: true, auto-fix: false]
reassign: Checks that package variables are not reassigned [fast: false, auto-fix: false]
revive: Fast, configurable, extensible, flexible, and beautiful linter for Go. Drop-in replacement of golint. [fast: false, auto-fix: false]
rowserrcheck: checks whether Err of rows is checked successfully [fast: false, auto-fix: false]
scopelint [deprecated]: Scopelint checks for unpinned variables in go programs [fast: true, auto-fix: false]
sqlclosecheck: Checks that sql.Rows and sql.Stmt are closed. [fast: false, auto-fix: false]
structcheck [deprecated]: Finds unused struct fields [fast: false, auto-fix: false]
stylecheck: Stylecheck is a replacement for golint [fast: false, auto-fix: false]
tagliatelle: Checks the struct tags. [fast: true, auto-fix: false]
tenv: tenv is analyzer that detects using os.Setenv instead of t.Setenv since Go1.17 [fast: false, auto-fix: false]
testableexamples: linter checks if examples are testable (have an expected output) [fast: true, auto-fix: false]
testpackage: linter that makes you use a separate _test package [fast: true, auto-fix: false]
thelper: thelper detects golang test helpers without t.Helper() call and checks the consistency of test helpers [fast: false, auto-fix: false]
tparallel: tparallel detects inappropriate usage of t.Parallel() method in your Go test codes [fast: false, auto-fix: false]
unconvert: Remove unnecessary type conversions [fast: false, auto-fix: false]
unparam: Reports unused function parameters [fast: false, auto-fix: false]
usestdlibvars: A linter that detect the possibility to use variables/constants from the Go standard library. [fast: true, auto-fix: false]
varcheck [deprecated]: Finds unused global variables and constants [fast: false, auto-fix: false]
varnamelen: checks that the length of a variable's name matches its scope [fast: false, auto-fix: false]
wastedassign: wastedassign finds wasted assignment statements. [fast: false, auto-fix: false]
whitespace: Tool for detection of leading and trailing whitespace [fast: true, auto-fix: true]
wrapcheck: Checks that errors returned from external packages are wrapped [fast: false, auto-fix: false]
wsl: Whitespace Linter - Forces you to use empty lines! [fast: true, auto-fix: false]

Linters presets:
bugs: asasalint, asciicheck, bidichk, bodyclose, contextcheck, durationcheck, errcheck, errchkjson, errorlint, exhaustive, exportloopref, gosec, govet, loggercheck, makezero, nilerr, noctx, reassign, rowserrcheck, scopelint, sqlclosecheck, staticcheck, typecheck
comment: dupword, godot, godox, misspell
complexity: cyclop, funlen, gocognit, gocyclo, maintidx, nestif
error: errcheck, errorlint, goerr113, wrapcheck
format: decorder, gci, gofmt, gofumpt, goimports
import: depguard, gci, goimports, gomodguard
metalinter: gocritic, govet, revive, staticcheck
module: depguard, gomoddirectives, gomodguard
performance: bodyclose, maligned, noctx, prealloc
sql: execinquery, rowserrcheck, sqlclosecheck
style: asciicheck, containedctx, decorder, depguard, dogsled, dupl, errname, exhaustivestruct, exhaustruct, forbidigo, forcetypeassert, gochecknoglobals, gochecknoinits, goconst, gocritic, godot, godox, goerr113, goheader, golint, gomnd, gomoddirectives, gomodguard, goprintffuncname, gosimple, grouper, ifshort, importas, interfacebloat, interfacer, ireturn, lll, loggercheck, makezero, misspell, nakedret, nilnil, nlreturn, nolintlint, nonamedreturns, nosnakecase, nosprintfhostport, paralleltest, predeclared, promlinter, revive, stylecheck, tagliatelle, tenv, testpackage, thelper, tparallel, unconvert, usestdlibvars, varnamelen, wastedassign, whitespace, wrapcheck, wsl
test: exhaustivestruct, exhaustruct, paralleltest, testableexamples, testpackage, tparallel
unused: deadcode, ineffassign, structcheck, unparam, unused, varcheck
```