时间：2019/6/3 17:37:37  

参考：

1. 《Java 并发编程实战》

## Java 锁  

Java 提供两种锁，默认的加锁机制 `synchronized` 和 jdk1.5 增加的更灵活的 `ReentrantLock`。目前两种锁在性能上没有太大差距。因此应优先选择使用 `synchronized`，当需要更加灵活的加锁机制，如等待一段时间、可中断等机制时可以使用 `ReentrantLock`。

### synchronized  
   
虚拟机内置属性，虚拟机可以进行优化，虚拟机更可能会基于 `synchronized` 进行性能优化。

使用 `Object` 对象的 `wait()` `notify()` `notifyAll()` 进行线程间信号传递。

### ReentrantLock  

`ReentrantLock` 实现 `Lock` 接口，接口定义如下：
	
	public interface Lock {
		//等待直到成功获取锁
		void lock();
		//等待直到成功获取锁，等待过程可以响应线程中断 
		void lockInterruptibly() throws InterruptedException;
		//尝试获取锁，获取不到立即返回
		boolean tryLock();
		//尝试获取锁，在指定时间内获取不到返回，同时等待过程可以响应线程中断
		boolean tryLock(long time, TimeUnit unit) throws InterruptedException;
		//释放锁，在 finally 块中执行，一定要记住释放锁
		void unlock();
		//用于线程之间通信 `await()` `signal()` `signalAll()`  
		Condition newCondition();
	}

`ReentrantLock` 通过使用 `Condition` 进行线程间信号传递。  
