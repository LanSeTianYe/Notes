## 问题描述  
Git Extensions: Win32 error 487: Couldn't reserve space for cygwin's heap, Win32 error 0**

## 解决方法:
进入 `Git` 的 `bin` 目录执行下面的命令

    rebase.exe -b 0x50000000 msys-1.0.dll

