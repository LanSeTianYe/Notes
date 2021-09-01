时间：2021-09-01 15:40:40

参考：

1. [C Primer Plus](https://weread.qq.com/web/reader/a99327c071d07b0da996784)

******************

这是自己工作中用到的第三种编程语言，JAVA、Go和C语言。其它的还接触过 Perl、C++、C#、Lua和Python，Python算是写过一些代码，其它语言的了解成都比知道多一点点。

多年之后拿起C语言，之前的指针、文件操作都清晰了。

第一次接触C语言应该是大一时（2011年），课堂上学的C语言，那时候刚接触电脑，对编程语言、操作系统是一头雾水，很难学会也很难应用，毕业之后一直用JAVA做Web项目开发。今年三月底开始用Go语言和最近一周开始用C语言。

## C 摘要

### 关于指针

指针指向一块内存地址。指针在内存中也有自己的内存地址。

int类型的指针指向内存中存储int数据的位置。int值在内存中占用四个字节，因此int类型指针的加一操作会把指针的地址移动四个字节，即地址加四。其它类型加一操作，如 short 移动两个字节，double移动8个字节。

字符串在C中用 `char * name` 表示，即字符指针，或者数组 `char name[100]` 表示。当用字符指针表示的时候需要手动申请空间，在C中使用 `\0` 做数组结束的标志，因此申请的长度需要比实际长度加一，多出一个字节存储 `\0`表示字符串结束。用数组表示字符串会存在空间浪费的问题，但是使用起来方便。

数组在C语言中等价于一个指针。如 int 类型的数组等价于一个int类型的指针，指针指向数组第一个元素的位置。数组指针加一就是第二个元素的位置，加二就是第三个元素的位置，依次类推。

### 关于作用域

### 关于宏定义

可以定义字面量，在程序编译的时候会替换对应的字面量。

```C
#include "stdio.h"

/**
 * define 定义字面量，就是一个文本
 * 程序会把对应的地方替换成字面量的值。
 * 比如: int x = TWO; 等价于 int x = 2;
 */

#define TWO 2

#define FOUR TWO*TWO
#define PX printf("X is %d\n", x)
#define FMT "X is %d\n"

int main(void) {  
    int x = TWO;    // int x = 2;
    PX;             // printf("X is %d\n", x);
    x = FOUR;       // x = TWO * TWo = 2 * 2;
    printf(FMT, x); // printf("X is %d\n", x);
    return 0;
}
```

### 关于导入文件

`<stdio.h>` 会从系统库查找对应的文件。
`"test.h"` 会从当前项目目录查找对应的文件。 

为了避免重复导入文件，需要在要导入的文件中使用宏定义定义字面量，在导入的文件中通过判断字面量是否定义决定是否导入。

`test.h` 内容如下：

```C
#define TEST_H

struct test {
   char name[10];
};

```


`main.c` 引入 `test.h`

```C
#include <stdio.h>


#ifndef TEST_H
#include "test.h"
#endif

int main(){
    printf("Hello C!");
    return 0;
}
```