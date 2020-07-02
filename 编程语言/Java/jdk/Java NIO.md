时间：2018/1/20 19:03:05  
参考 ：  

1.  Java网络编程 [Elliotte Rusty Harold 著 李帅 荆涛 译]
2.  [Java NIO：Buffer、Channel 和 Selector](https://www.javadoop.com/post/java-nio)
3.  [聊聊同步、异步、阻塞与非阻塞](https://www.jianshu.com/p/aed6067eeac9)
4.  [聊聊Linux 五种IO模型](https://www.jianshu.com/p/486b0965c296)

## JAVA NIO 

IO

阻塞IO：当有IO操作时，系统一致等待直到IO操作完成。

NIO：非阻塞IO，使用选择器监听通道上的事件，当获取到通道上对应事件时再进行相应的操作。可以避免创建大量线程。

AIO：异步IO，通过 `Future` 或回调函数的方式进行IO操作执行完成之后的后续业务逻辑。

**同步异步和阻塞非阻塞：**

* 同步：关心调用结果。
* 异步：不关心调用结果。
* 阻塞：程序等待任务执行的时候不能执行其他任务。
* 非阻塞：程序等待任务执行的时候可以执行其他任务。

### 核心类  

#### Buffer 

IO操作数据读取和写入时的数据缓冲区。用于暂时存放数据。Buffer 有三个字段分别是：

* `capacity`：缓冲区容量大小。
* `position`：当前读写位置。
* `limit`：最大读写位置，当达到。
* `mark`：做一个标记。

通过上面三个字段控制实际有效数据的区域 `[position-limit]`

常用的几个方法，以 `IntBuffer` 为例：      

* `allocate(int size)`：申请容量。调用之后 `position = 0, capacity = limit = size`。
* `remaining()`：返回剩余元素的个数 `limit - positin`。
* `mark()`：设置 `mark` 为当前 `position`。调用之后 `mark=position`。
* `reset()`：重置到标记位置。调用之后 `position=mark`。
* `put(int value)`：写入数据，写入到 `position`指定的位置。调用之后 `position = position + 1`。
* `rewind()`：重置缓冲区。调用之后 `position=0, marked=-1`。
* `flip ()`：翻转，常用于切换读写模式。调用之后 `limit=position, position = 0, marked=-1`。
* `get()`：读取数据，读取 `position` 对应的数据。调用之后 `position = postion + 1`。
* `clear()`：清空缓冲区。调用之后 `position = 0, limit = capacity, mark = -1 `。
* `slice()`：创建一个新 `Buffer`，新 `Buffer` 和旧 `Buffer` 数据共享，但是坐标不共享，新 `BUffer` 的坐标 `position=0;limit=capacity=old_buffer.position, mark=-1`。

#### Channel   

数据通道，数据的来源和数据写入的地方。

* `FileChannel`：文件。
* `DatagramChannel`：UDP。
* `SocketChannel`：Socket客户端。
* `ServerSocketChannel`：Socket服务端。

#### Selector 

选择器。通过把 `Channel` 注册到 `Selector` 上，然后监听 `Channel` 对应的状态变化事件，实现非阻塞IO。

事件类型：

* `SelectionKey.OP_READ`：通道中有数据可以进行读取。
* `SelectionKey.OP_WRITE`：可以往通道中写入数据。
* `SelectionKey.OP_CONNECT`：成功建立 TCP 连接。
* `SelectionKey.OP_ACCEPT`：接受 TCP 连接。

常用方法：

* `open()`：打开一个选择器。
* `select()`：从注册的 `Channel` 中选择可以执行IO操作的，会一直阻塞直到至少有一个 `Channel` 被选择出来或者 selector 的wakeup 方法被调用或者当前线程被中断。
* `selectNow()`：不阻塞没有可用的 `Channel` 时返回0。
* `wakeup()`：唤醒等待的 `select` 方法。
* `selectedKeys()`：返回选择器追踪被选择出来的 `SelectKey` 集合。