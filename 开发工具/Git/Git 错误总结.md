时间： 2018/1/1 9:22:00 

参考：  


## 问题以及解决方案

## Win32 error
### 问题描述：  
 
Git Extensions: Win32 error 487: Couldn't reserve space for cygwin's heap, Win32 error 0**

### 解决方法:
进入 `Git` 的 `bin` 目录执行下面的命令

    rebase.exe -b 0x50000000 msys-1.0.dll

## 文件名字太长  
#### 问题描述：

	node_modules/grunt-contrib-imagemin/node_modules/pngquant-bin/node_modules/bin-wrapper/node_modules/download/node_modules/request/node_modules/form-data/node_modules/combined-stream/node_modules/delayed-stream/test/integration/test-handle-source-errors.js: Filename too long
#### 解决方案：
运行下面命令：

	git config --system core.longpaths true
