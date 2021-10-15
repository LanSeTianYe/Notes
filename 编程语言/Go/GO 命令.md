时间：2021-10-13 14:22:22

参考:

## GO 命令

```shell
[root@localhost ~]# go version
go version go1.16.2 linux/amd64

[root@localhost ~]# go help
Go is a tool for managing Go source code.

Usage:

        go <command> [arguments]

The commands are:

        # 给官方提bug报告
        bug         start a bug report
        # 编译包 
        build       compile packages and dependencies
        clean       remove object files and cached files
        # 查看文档   go doc github.com/gogo/protobuf/io/io.go
        doc         show documentation for package or symbol
        # 查看go环境变量
        env         print Go environment information
        fix         update packages to use new APIs
        # 格式化go文件
        fmt         gofmt (reformat) package sources
        generate    generate Go files by processing source
        # 下载并安装包和依赖
        get         download and install packages and dependencies
        # 编译并安装包和依赖
        install     compile and install packages and dependencies
        # 查看包列表(mod模式)
        list        list packages or modules
        # 模块管理
        mod         module maintenance
        # 编译并执行共程序
        run         compile and run Go program
        # 执行测试代码
        test        test packages
        tool        run specified go tool
        # version
        version     print Go version
        # 检查代码中存在的错误(mod模式)
        vet         report likely mistakes in packages

Use "go help <command>" for more information about a command.

Additional help topics:

        buildconstraint build constraints
        buildmode       build modes
        c               calling between Go and C
        cache           build and test caching
        environment     environment variables
        filetype        file types
        go.mod          the go.mod file
        gopath          GOPATH environment variable
        gopath-get      legacy GOPATH go get
        goproxy         module proxy protocol
        importpath      import path syntax
        modules         modules, module versions, and more
        module-get      module-aware go get
        module-auth     module authentication using go.sum
        packages        package lists and patterns
        private         configuration for downloading non-public code
        testflag        testing flags
        testfunc        testing functions
        vcs             controlling version control with GOVCS

Use "go help <topic>" for more information about that topic.
```

### GO GET

命令在 `module-aware` 模式和 `GOPATH` 模式有不同的作用。安装包在未来的版本会被废弃。

**GOPATH:** 下载并安装包。源代码放在 `第一个GOPATH的src目录` ，安装文件放在 `GOPATH的pkg目录`（只会安装当前包不安装依赖的包）。

**module-aware:** 下载代码不安装代码。代码放在 `第一个GOPATH的pkg的mod目录`。

**GOPAT模式说明:**

```shell
[root@localhost hello]# go help gopath-get
The 'go get' command changes behavior depending on whether the
go command is running in module-aware mode or legacy GOPATH mode.
This help text, accessible as 'go help gopath-get' even in module-aware mode,
describes 'go get' as it operates in legacy GOPATH mode.

Usage: go get [-d] [-f] [-t] [-u] [-v] [-fix] [-insecure] [build flags] [packages]

Get downloads the packages named by the import paths, along with their
dependencies. It then installs the named packages, like 'go install'.

# 不安装
The -d flag instructs get to stop after downloading the packages; that is,
it instructs get not to install the packages.

# 更新包
The -u flag instructs get to use the network to update the named packages
and their dependencies. By default, get uses the network to check out
missing packages but does not use it to look for updates to existing packages.

# 
The -f flag, valid only when -u is set, forces get -u not to verify that
each package has been checked out from the source control repository
implied by its import path. This can be useful if the source is a local fork
of the original.

The -fix flag instructs get to run the fix tool on the downloaded packages
before resolving dependencies or building the code.

The -insecure flag permits fetching from repositories and resolving
custom domains using insecure schemes such as HTTP. Use with caution.
This flag is deprecated and will be removed in a future version of go.
The GOINSECURE environment variable should be used instead, since it
provides control over which packages may be retrieved using an insecure
scheme. See 'go help environment' for details.

The -t flag instructs get to also download the packages required to build
the tests for the specified packages.

The -v flag enables verbose progress and debug output.

Get also accepts build flags to control the installation. See 'go help build'.

When checking out a new package, get creates the target directory
GOPATH/src/<import-path>. If the GOPATH contains multiple entries,
get uses the first one. For more details see: 'go help gopath'.

When checking out or updating a package, get looks for a branch or tag
that matches the locally installed version of Go. The most important
rule is that if the local installation is running version "go1", get
searches for a branch or tag named "go1". If no such version exists
it retrieves the default branch of the package.

When go get checks out or updates a Git repository,
it also updates any git submodules referenced by the repository.

Get never checks out or updates code stored in vendor directories.

For more about specifying packages, see 'go help packages'.

For more about how 'go get' finds source code to
download, see 'go help importpath'.

This text describes the behavior of get when using GOPATH
to manage source code and dependencies.
If instead the go command is running in module-aware mode,
the details of get's flags and effects change, as does 'go help get'.
See 'go help modules' and 'go help module-get'.

See also: go build, go install, go clean.
```

**module-aware模式说明:**

```shell
[root@localhost hello]# go help get
usage: go get [-d] [-t] [-u] [-v] [-insecure] [build flags] [packages]

Get resolves its command-line arguments to packages at specific module versions,
updates go.mod to require those versions, downloads source code into the
module cache, then builds and installs the named packages.

To add a dependency for a package or upgrade it to its latest version:

        go get example.com/pkg

To upgrade or downgrade a package to a specific version:

        go get example.com/pkg@v1.2.3

To remove a dependency on a module and downgrade modules that require it:

        go get example.com/mod@none

See https://golang.org/ref/mod#go-get for details.

The 'go install' command may be used to build and install packages. When a
version is specified, 'go install' runs in module-aware mode and ignores
the go.mod file in the current directory. For example:

        go install example.com/pkg@v1.2.3
        go install example.com/pkg@latest

See 'go help install' or https://golang.org/ref/mod#go-install for details.

In addition to build flags (listed in 'go help build') 'go get' accepts the
following flags.

The -t flag instructs get to consider modules needed to build tests of
packages specified on the command line.

The -u flag instructs get to update modules providing dependencies
of packages named on the command line to use newer minor or patch
releases when available.

The -u=patch flag (not -u patch) also instructs get to update dependencies,
but changes the default to select patch releases.

When the -t and -u flags are used together, get will update
test dependencies as well.

The -insecure flag permits fetching from repositories and resolving
custom domains using insecure schemes such as HTTP, and also bypassess
module sum validation using the checksum database. Use with caution.
This flag is deprecated and will be removed in a future version of go.
To permit the use of insecure schemes, use the GOINSECURE environment
variable instead. To bypass module sum validation, use GOPRIVATE or
GONOSUMDB. See 'go help environment' for details.

The -d flag instructs get not to build or install packages. get will only
update go.mod and download source code needed to build packages.

# 不会安装
Building and installing packages with get is deprecated. In a future release,
the -d flag will be enabled by default, and 'go get' will be only be used to
adjust dependencies of the current module. To install a package using
dependencies from the current module, use 'go install'. To install a package
ignoring the current module, use 'go install' with an @version suffix like
"@latest" after each argument.

For more about modules, see https://golang.org/ref/mod.

For more about specifying packages, see 'go help packages'.

This text describes the behavior of get using modules to manage source
code and dependencies. If instead the go command is running in GOPATH
mode, the details of get's flags and effects change, as does 'go help get'.
See 'go help gopath-get'.

See also: go build, go install, go clean, go mod.
```

### GO BUILD

编译并生成可执行文件。如果没有`main`文件，则执行编译并丢弃编译结果，类似于执行一遍编译来检查文件是否可以编译。

```shell
usage: go build [-o output] [build flags] [packages]

Build compiles the packages named by the import paths,
along with their dependencies, but it does not install the results.

If the arguments to build are a list of .go files from a single directory,
build treats them as a list of source files specifying a single package.

When compiling packages, build ignores files that end in '_test.go'.

When compiling a single main package, build writes
the resulting executable to an output file named after
the first source file ('go build ed.go rx.go' writes 'ed' or 'ed.exe')
or the source code directory ('go build unix/sam' writes 'sam' or 'sam.exe').
The '.exe' suffix is added when writing a Windows executable.

When compiling multiple packages or a single non-main package,
build compiles the packages but discards the resulting object,
serving only as a check that the packages can be built.

The -o flag forces build to write the resulting executable or object
to the named output file or directory, instead of the default behavior described
in the last two paragraphs. If the named output is an existing directory or
ends with a slash or backslash, then any resulting executables
will be written to that directory.

The -i flag installs the packages that are dependencies of the target.
The -i flag is deprecated. Compiled packages are cached automatically.

The build flags are shared by the build, clean, get, install, list, run,
and test commands:

        -a
                force rebuilding of packages that are already up-to-date.
        -n
                print the commands but do not run them.
        -p n
                the number of programs, such as build commands or
                test binaries, that can be run in parallel.
                The default is the number of CPUs available.
        -race
                enable data race detection.
                Supported only on linux/amd64, freebsd/amd64, darwin/amd64, windows/amd64,
                linux/ppc64le and linux/arm64 (only for 48-bit VMA).
        -msan
                enable interoperation with memory sanitizer.
                Supported only on linux/amd64, linux/arm64
                and only with Clang/LLVM as the host C compiler.
                On linux/arm64, pie build mode will be used.
        -v
                print the names of packages as they are compiled.
        -work
                print the name of the temporary work directory and
                do not delete it when exiting.
        -x
                print the commands.

        -asmflags '[pattern=]arg list'
                arguments to pass on each go tool asm invocation.
        -buildmode mode
                build mode to use. See 'go help buildmode' for more.
        -compiler name
                name of compiler to use, as in runtime.Compiler (gccgo or gc).
        -gccgoflags '[pattern=]arg list'
                arguments to pass on each gccgo compiler/linker invocation.
        -gcflags '[pattern=]arg list'
                arguments to pass on each go tool compile invocation.
        -installsuffix suffix
                a suffix to use in the name of the package installation directory,
                in order to keep output separate from default builds.
                If using the -race flag, the install suffix is automatically set to race
                or, if set explicitly, has _race appended to it. Likewise for the -msan
                flag. Using a -buildmode option that requires non-default compile flags
                has a similar effect.
        -ldflags '[pattern=]arg list'
                arguments to pass on each go tool link invocation.
        -linkshared
                build code that will be linked against shared libraries previously
                created with -buildmode=shared.
        -mod mode
                module download mode to use: readonly, vendor, or mod.
                By default, if a vendor directory is present and the go version in go.mod
                is 1.14 or higher, the go command acts as if -mod=vendor were set.
                Otherwise, the go command acts as if -mod=readonly were set.
                See https://golang.org/ref/mod#build-commands for details.
        -modcacherw
                leave newly-created directories in the module cache read-write
                instead of making them read-only.
        -modfile file
                in module aware mode, read (and possibly write) an alternate go.mod
                file instead of the one in the module root directory. A file named
                "go.mod" must still be present in order to determine the module root
                directory, but it is not accessed. When -modfile is specified, an
                alternate go.sum file is also used: its path is derived from the
                -modfile flag by trimming the ".mod" extension and appending ".sum".
        -overlay file
                read a JSON config file that provides an overlay for build operations.
                The file is a JSON struct with a single field, named 'Replace', that
                maps each disk file path (a string) to its backing file path, so that
                a build will run as if the disk file path exists with the contents
                given by the backing file paths, or as if the disk file path does not
                exist if its backing file path is empty. Support for the -overlay flag
                has some limitations:importantly, cgo files included from outside the
                include path must be  in the same directory as the Go package they are
                included from, and overlays will not appear when binaries and tests are
                run through go run and go test respectively.
        -pkgdir dir
                install and load all packages from dir instead of the usual locations.
                For example, when building with a non-standard configuration,
                use -pkgdir to keep generated packages in a separate location.
        -tags tag,list
                a comma-separated list of build tags to consider satisfied during the
                build. For more information about build tags, see the description of
                build constraints in the documentation for the go/build package.
                (Earlier versions of Go used a space-separated list, and that form
                is deprecated but still recognized.)
        -trimpath
                remove all file system paths from the resulting executable.
                Instead of absolute file system paths, the recorded file names
                will begin with either "go" (for the standard library),
                or a module path@version (when using modules),
                or a plain import path (when using GOPATH).
        -toolexec 'cmd args'
                a program to use to invoke toolchain programs like vet and asm.
                For example, instead of running asm, the go command will run
                'cmd args /path/to/asm <arguments for asm>'.

The -asmflags, -gccgoflags, -gcflags, and -ldflags flags accept a
space-separated list of arguments to pass to an underlying tool
during the build. To embed spaces in an element in the list, surround
it with either single or double quotes. The argument list may be
preceded by a package pattern and an equal sign, which restricts
the use of that argument list to the building of packages matching
that pattern (see 'go help packages' for a description of package
patterns). Without a pattern, the argument list applies only to the
packages named on the command line. The flags may be repeated
with different patterns in order to specify different arguments for
different sets of packages. If a package matches patterns given in
multiple flags, the latest match on the command line wins.
For example, 'go build -gcflags=-S fmt' prints the disassembly
only for package fmt, while 'go build -gcflags=all=-S fmt'
prints the disassembly for fmt and all its dependencies.

For more about specifying packages, see 'go help packages'.
For more about where packages and binaries are installed,
run 'go help gopath'.
For more about calling between Go and C/C++, run 'go help c'.

Note: Build adheres to certain conventions such as those described
by 'go help gopath'. Not all projects can follow these conventions,
however. Installations that have their own conventions or that use
a separate software build system may choose to use lower-level
invocations such as 'go tool compile' and 'go tool link' to avoid
some of the overheads and design decisions of the build tool.

See also: go install, go get, go clean.
```

### GO INSTALL

```shell
[root@localhost hello]# go help install
usage: go install [build flags] [packages]

Install compiles and installs the packages named by the import paths.

Executables are installed in the directory named by the GOBIN environment
variable, which defaults to $GOPATH/bin or $HOME/go/bin if the GOPATH
environment variable is not set. Executables in $GOROOT
are installed in $GOROOT/bin or $GOTOOLDIR instead of $GOBIN.

If the arguments have version suffixes (like @latest or @v1.0.0), "go install"
builds packages in module-aware mode, ignoring the go.mod file in the current
directory or any parent directory, if there is one. This is useful for
installing executables without affecting the dependencies of the main module.
To eliminate ambiguity about which module versions are used in the build, the
arguments must satisfy the following constraints:

- Arguments must be package paths or package patterns (with "..." wildcards).
  They must not be standard packages (like fmt), meta-patterns (std, cmd,
  all), or relative or absolute file paths.
- All arguments must have the same version suffix. Different queries are not
  allowed, even if they refer to the same version.
- All arguments must refer to packages in the same module at the same version.
- No module is considered the "main" module. If the module containing
  packages named on the command line has a go.mod file, it must not contain
  directives (replace and exclude) that would cause it to be interpreted
  differently than if it were the main module. The module must not require
  a higher version of itself.
- Package path arguments must refer to main packages. Pattern arguments
  will only match main packages.

If the arguments don't have version suffixes, "go install" may run in
module-aware mode or GOPATH mode, depending on the GO111MODULE environment
variable and the presence of a go.mod file. See 'go help modules' for details.
If module-aware mode is enabled, "go install" runs in the context of the main
module.

#安装文件
When module-aware mode is disabled, other packages are installed in the directory $GOPATH/pkg/$GOOS_$GOARCH. 

#不安装文件
When module-aware mode is enabled,other packages are built and cached but not installed.

The -i flag installs the dependencies of the named packages as well.
The -i flag is deprecated. Compiled packages are cached automatically.

For more about the build flags, see 'go help build'.
For more about specifying packages, see 'go help packages'.

See also: go build, go get, go clean.
```
