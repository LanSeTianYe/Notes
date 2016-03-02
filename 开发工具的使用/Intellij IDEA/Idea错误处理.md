创建日期:2016-2-29 23:28:25 

### jdk版本的问题：
#### 错误描述：  
导入了一个idea project ，编译运行时候，提示 `Error:java: Compilation failed: internal java compiler error`
#### 解决方法  
设置 `Setting->Compiler->Java Compiler` ,发现有的module不是最新的，选jdk对应版本就行了