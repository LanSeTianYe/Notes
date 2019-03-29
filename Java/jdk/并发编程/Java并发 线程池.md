时间：2019/3/29 18:22:50  

参考：

1. [JAVA 并发编程实战（Java Concurrency in Practice）](http://product.dangdang.com/22606835.html)

## 线程池   

## 简介      
 
线程池通过复用线程减少新建线程的开销，在 Java 中线程池基于 `ThreadPoolExecutor` 类实现。可以用过不同的参数配置不同的线程池。

参数： 

* `int corePoolSize`：线程池大小。
* `int maximumPoolSize`：最大线程池大小。
* `long keepAliveTime`：线程执行结束之后保留时间，需要指定时间单位。
* `BlockingQueue workQueue`: 阻塞队列，使用不同的阻塞队列可以实现不同的任务执行策略。
* `ThreadFactory threadFactory`：线程创建工厂。

**线程数量：**

当 `corePoolSize` 等于 `maximumPoolSize` 时可以做固定大小的线程池。

**阻塞队列**

* `LinkedBlockingQueue`：可以做有界和无界队列使用。
* `ArrayBlockingQueue`：有界阻塞队列。
* `PriorityQueue`：优先级队列，无界。
* `SynchronousQueue`：数据转换队列。

使用无界队列时，当新任务创建任务速度，远远大于任务执行速度，会造成任务堆积，随着任务越来越多会造成内存溢出。  

使用数据转换队列，只要有新任务到达，且此时没有空闲线程，就会创建新线程，当任务量过大的时候也会造成内存溢出。  

使用有界队列，当阻塞的任务数量达到队列的容量限制之后，通过执行相应的策略 `RejectedExecutionHandler` ，从而避免内存溢出。

* `ThreadPoolExecutor.AbortPolicy`：拒绝接收任务，并抛出运行时异常 `RejectedExecutionException`。
* `ThreadPoolExecutor.DiscardPolicy`：丢弃新到来的任务。
* `ThreadPoolExecutor.DiscardOldestPolicy`：丢弃旧的未执行的任务。
* `ThreadPoolExecutor.CallerRunsPolicy`：在提交任务的线程上执行任务。

**扩展方法：**

* `beforeExecute`：任务执行前调用。
* `afterExecute`：任务执行结束之后调用。
* `terminated`：线程池终止之后调用。

### 默认线程池    

在Java中　`Executors` 提供了几种线程池的默认实现。

* `Executors.newFixedTheadPoll`：执行任务的线程数量固定，新的任务会被放在阻塞队列中，队列的大小没有限制，当任务到达的速度远远大于执行速度时，阻塞队列存储的任务数量就会不断变大，直至内存溢出。
* `Executors.newCachedTheadPoll`：为每一个任务创建或使用一个线程，内部使用 `AsyncQueue`。
* `Executors.newSingledThreadPool`：每次执行一个线程，

