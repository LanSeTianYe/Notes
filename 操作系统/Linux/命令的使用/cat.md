##  
时间：2017/8/14 19:48:40   

参考： 

1. Linux `man cat`

## cat 命令  
串联文件并输出到标准输出流,串联文件，或标注输入流到标准输出流。

## 语法  
> cat [optation]... [file]... 

## 选项  

> -A: 等价与 -vET  
> -b: 非空行编号不  
> -n: 所有行编号，包含空行    
> -e: 等价于 -vE  
> -E: 在行尾追加 `$` 符号  
> -s: 合并空行  
> -t: 等价与 -vT  
> -u: (ignore)  
> -v: 显示不可打印字符    
> 当后面没有文件参数或者文件是 `-`， 读取标准输入流（控制台）  

## 参数  
一个或多个文件  

## 列子  

1. 先输出 `all.txt` 的内容，再输出 `-`（标准输入流， CTRL +D 结束） 的内容，再输出 `redis.conf` 的内容。

		cat all.txt - redis.conf
2. 输出到文件 

		cat data.txt > all.txt

## 原说明文档

	
	Usage: cat [OPTION]... [FILE]...
	Concatenate FILE(s), or standard input, to standard output.
	
	  -A, --show-all           equivalent to -vET
	  -b, --number-nonblank    number nonempty output lines, overrides -n
	  -e                       equivalent to -vE
	  -E, --show-ends          display $ at end of each line
	  -n, --number             number all output lines
	  -s, --squeeze-blank      suppress repeated empty output lines
	  -t                       equivalent to -vT
	  -T, --show-tabs          display TAB characters as ^I
	  -u                       (ignored)
	  -v, --show-nonprinting   use ^ and M- notation, except for LFD and TAB
	      --help     display this help and exit
	      --version  output version information and exit
	
	With no FILE, or when FILE is -, read standard input.
	
	Examples:
	  cat f - g  Output f's contents, then standard input, then g's contents.
	  cat        Copy standard input to standard output.
