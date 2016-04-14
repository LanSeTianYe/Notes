创建日期:2016-2-29 23:28:25 

## jdk版本的问题：
#### 错误描述：  
导入了一个idea project ，编译运行时候，提示 `Error:java: Compilation failed: internal java compiler error`
#### 解决方法  
设置 `Setting->Compiler->Java Compiler` ,发现有的module不是最新的，选jdk对应版本就行了
## git项目，文件修改之后文件的颜色不改变
#### 错误描述:
不知道为什么打开项目修改文件之后，文件的颜色不会改变。
#### 解决办法:
在工具栏 `VCS` 里面有一个 `enable..` 开头的选项，点击之后就可以了。