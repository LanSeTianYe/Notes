##  
时间 ： 2017/2/26 14:48:20   
内容来源：  

1. Java编程思想第四版

## 堆栈和堆
1. 堆栈  
	堆栈用来存放基本类型变量和对象的引用（对象在堆中存储的位置）。编译器需要知道，存储的数据需要在堆栈里面存活多长时间。  
	* 基本变量初始化的时候，虚拟机会从堆栈中寻找对应的值，比如`int a = 3`，会先在堆栈中查询有没有 `3` 存在，有的话变量直接指向这个地址，没有的话在堆栈分配一块空间存储变量，然后返回该空间的地址，基本变量会在程序运行出作用域之后被删除。
	* 创建对象的时候，先在堆中创建一个对象，然后把对象的引用放在堆栈中，然后把引用返回给对象对应变量名。


2. 堆  
堆用于存放对象，对象所占的存储空间大小是动态的，Java的垃圾回收也是发生在堆上进行的。

## 垃圾回收机制

#### 1. 其他垃圾回收机制

**引用计数**  
  
* 特点：简单但是速度慢。  
* 原理：每个对象有一个引用计数器，对象每被引用一次引计数加一，当对象的引用计数器为零的时候，对象就不被任何对象引用了，然后进行清理。
* 存在的问题：循环引用，当量个对象相互应用之后，离开这两个对象的作用于的时候，对象的引用计数器不为零，因此无法的到清理。

#### 2. Java的垃圾回收机制
堆栈中存储对象的引用，当离开对象的作用于或者变量被赋值为空之后，对象的引用会从堆栈中及时清除，因此只要堆栈中存在的引用，那么该引用对应的对象包含的对象，以及包含的对象包含的对象等等，都是 `存活的对象`，通过这个过程就能找出所有存活的对象。
Java的垃圾回收机制，会根据合适的策略在 `停止-复制` 和 `标记-清扫` 之间切换。

**停止-复制（需要暂停程序）**
  
* 特点：
* 原理：先找出所有存活的对象，然后停止运行程序，把存活的对象从当前堆复制到另外的堆，没有复制的就进行清理。复制对象到新地址不仅需要改变堆栈中的引用，也需要修改其他对象的引用地址。
* 存在的问题：
	* 复制的时候需要另外的存储空间，解决，按需从堆中分配几块较大的内存，对象的复制发生在这些较大的内存之间。
	* 程序运行稳定之后，需要清理的对象很少，此时复制会产生大量的开销。

**标记-清扫（需要暂停程序）**

* 特点：
* 原理：从堆栈和静态存储区域开始，找出所有或者的对象，每找到一个对其进行标记，等待查询结束之后清理那些没有被标记的对象，清理不会发生复制，只是清除没有存活对象所占的空间，此时的堆是不连续的。
* 存在的问题：