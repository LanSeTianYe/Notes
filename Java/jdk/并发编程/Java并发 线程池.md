时间：2019/3/29 18:22:50  

参考：

1. [JAVA 并发编程实战（Java Concurrency in Practice）](http://product.dangdang.com/22606835.html)
2. [Java 并发编程笔记：如何使用 ForkJoinPool 以及原理](http://blog.dyngr.com/blog/2016/09/15/java-forkjoinpool-internals/)

## 线程池   

线程池是为了重用线程，减少线程创建的开销，从而提高任务执行效率。

![CompletableFuture 继承结构图](https://raw.githubusercontent.com/LanSeTianYe/Notes/master/images/java/concurrent/ExecutorService.png) 

Jdk1.5 提供了 `ThreadPoolExecutor`，是一个直观的线程池模型。

Jdk1.7 引入了 `ForkJoinPool`，核心方法是 `fork` 分解 和 `join` 合并，简化 `分解/合并` 模型的任务的执行方式。用于任务需要拆分成子任务，或任务依赖多个子任务的场景。

### 简介      
 
线程池通过复用线程减少新建线程的开销，在 Java 中线程池基于 `ThreadPoolExecutor` 类实现。可以用过不同的参数配置不同的线程池。

参数： 

* `int corePoolSize`：线程池大小。
* `int maximumPoolSize`：最大线程池大小。
* `long keepAliveTime`：线程执行结束之后保留时间，需要指定时间单位。
* `BlockingQueue workQueue`: 阻塞队列，使用不同的阻塞队列可以实现不同的任务执行策略。
* `ThreadFactory threadFactory`：线程创建工厂。

`corePoolSize` 用于指定线程中保留线程的数量，即空闲时线程池中保留的线程数量。`maximumPoolSize` 用于指定线程池最大线程数量。在 `(corePoolSize,maximumPoolSize]` 之间的线程用完之后会被丢弃，在 `[1,corePoolSize]` 之间的线程用完之后被放进线程池。线程池中的线程空闲时间超过 `keepAliveTime` 会从线程池中移除。 阻塞队列用于控制线程池执行任务的策略，不同的阻塞队列可以达到不同的效果。线程工厂用于创建线程。

**线程数量：**

当 `corePoolSize` 等于 `maximumPoolSize` 时可以做固定大小的线程池。

**阻塞队列**

* `LinkedBlockingQueue`：可以做有界和无界队列使用。
* `ArrayBlockingQueue`：可以做有界和无界队列使用。
* `PriorityQueue`：优先级队列，无界。
* `SynchronousQueue`：数据转换队列，本身不缓存数据，消息入队之后保持阻塞直到有消费者消费，因此中间并不缓存数据。

**内存溢出问题：**  

使用无界队列时，当新任务创建任务速度，远远大于任务执行速度，会造成任务堆积，随着任务越来越多会造成内存溢出。  

使用数据转换队列，只要有新任务到达，且此时没有空闲线程，就会创建新线程，当创建线程数量过多时也会造成内存溢出。   

**内存溢出问题解决方案：** 

使用有界队列，当阻塞的任务数量达到队列的容量限制之后，通过执行相应的策略 `RejectedExecutionHandler` ，从而避免内存溢出。

* `ThreadPoolExecutor.AbortPolicy`：拒绝接收任务，并抛出运行时异常 `RejectedExecutionException`。
* `ThreadPoolExecutor.DiscardPolicy`：丢弃新到来的任务。
* `ThreadPoolExecutor.DiscardOldestPolicy`：丢弃旧的未执行的任务。
* `ThreadPoolExecutor.CallerRunsPolicy`：在提交任务的线程上执行任务。可达到阻塞主线程的效果，当任务量过大时阻塞主线程，使得主线程可以据此来丢弃或者暂存其它任务。

**扩展方法：**

可以用于任务及线程池的数据统计，以及日志记录等。  

* `beforeExecute`：任务执行前调用。
* `afterExecute`：任务执行结束之后调用。
* `terminated`：线程池终止之后调用。

### 默认线程池    

在Java中　`Executors` 提供了几种线程池的默认实现。

* `Executors.newFixedTheadPoll`：执行任务的线程数量固定，新的任务会被放在阻塞队列中，队列的大小没有限制，当任务到达的速度远远大于执行速度时，阻塞队列存储的任务数量就会不断变大，直至内存溢出。
* `Executors.newCachedTheadPoll`：为每一个任务创建或使用一个线程，内部使用 `SynchronousQueue`。
* `Executors.newSingledThreadPool`：每次执行一个任务，当新任务到达时会阻塞。

### Jdk1.7 ForkJoinPool

### Jdk1.8异步执行器  

![CompletableFuture 继承结构图](https://raw.githubusercontent.com/LanSeTianYe/Notes/master/images/java/concurrent/CompletableFuture.png) 

`CompletableFuture` 是Jdk1.8新提供的异步执行器，提供 `combine` 和 `compose`

具体Demo可参考：[c_future](https://github.com/LanSeTianYe/DemoContainer/blob/master/test/src/main/java/com/xiaotian/demo/test/concurrent/c_future/)