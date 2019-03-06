时间：2019/3/5 17:45:19  

参考：

## GDB 调试工具

Unix 及 Unix Like 系统下命令行调试工具。

### 常用命令  

* `CTRL+X A`：显示文本UI界面。
* `CTRL+X 2`：显示指令执行地址。
* `l 1,n`：显示 第一行至第n行代码。
* `b`：设置断点。
	* `b n`：第 n 行添加断点。
	* `b function_name`：在函数定义出添加断点。
	* `b 17 if i == 8`：条件断点。
* `d n`：删除第n个断点。
* `clear line/name`：删除第几行的断点/删除指定名字的断点。
* `run`：执行程序，可以使用 `r` 代替。
* `n`：执行下一步。
* `c`：执行到下一个断点。
* `s`：下一步，进入子函数。
* `info`
	* `info locals`：查看局部变量。
	* `info args`：查看方法参数。
	* `info registers`：查看寄存器值。
* `p var`：输出变量内容。
* `x`：查看内存信息，格式为 `x /nfu ptr`。
	* `n` 表示显示多少个内存单元。
	* `f`：表示显示方式。
		* x 按十六进制格式显示变量。
		* d 按十进制格式显示变量。
		* u 按十进制格式显示无符号整型。
		* o 按八进制格式显示变量。
		* t 按二进制格式显示变量。
		* a 按十六进制格式显示变量。
		* i 指令地址格式
		* c 按字符格式显示变量。
		* f 按浮点数格式显示变量。
	* `u`：显示单元的长度。
		* b表示单字节。
		* h表示双字节。
		* w表示四字节。
		* g表示八字节。
	* `ptr`：开始地址。
* `q`：结束调试。

### C 语言调试 

程序代码 `hello.c`：

	#include <stdio.h>
	
	int g_var = 0;
	
	static int _add(int a, int b) {
	    printf("_add callad, a:%d, b:%d\n", a, b);
	    return a+b;
	}
	
	int main(void) {
	    int n = 1;
	    
	    printf("one n=%d, g_var=%d\n", n, g_var);
	    ++n;
	    --n;
	    
	    g_var += 20;
	    g_var -= 10;
	    n = _add(1, g_var);
	    printf("two n=%d, g_var=%d\n", n, g_var);
	    
	    return 0;
	}

1. 编译程序：`gcc -g -Wall -o hello hello.c`  
2. 进入调试命令行：`gdb hello`

