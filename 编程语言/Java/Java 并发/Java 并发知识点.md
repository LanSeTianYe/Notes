## Executors  
CachedThreadPool 在程序执行过程中通常会创建与所需数量相同的线程，然后在它回收旧线程时停止创建新线程，因此它是合理的Executor的首选。另外还有 FixedThreadPool 和 SingleThreadPool。

## 从任务中返回值

	public class TaskWithResult implements Callable<String>{
	
	    private int id;
	
	    public TaskWithResult(int id) {
	        this.id = id;
	    }
	
	
	    @Override
	    public String call() throws Exception {
	        Thread.yield();
	        return "TaskWithResult id is:" + id;
	    }
	
	    public static void main(String[] args) throws ExecutionException, InterruptedException {
	        ExecutorService executorService = Executors.newCachedThreadPool();
	
	        Future<String> result = null;
	        for (int i = 0; i < 5; i++ ) {
	            result = executorService.submit(new TaskWithResult(i));
	            while (!result.isDone()) {
	                System.out.println("doing ....");
	            }
	            System.out.println(result.get());
	        }
	
	    }
	}

## 任务的优先级
任务的优先级会影响任务的执行频率，高优先级的任务并不一定限于低优先级的任务完成。

## daemon 后台线程
当所有的非后台线程结束时，程序就停止了，同时会杀死进程中的所有后台线程。

## yield 让步
让出所占的资源，让其他的线程先执行

## synchronized 资源同步
为了防止多线程使用同一个资源，产生资源竞争问题，在使用该资源的方法上添加  `synchronized` 关键字。然后调用对象的同步方法的线程在调用方法之前会先判断方法是否正在被调用，如果是的话就等待，发达调用完成之后再调用。

## Lock 对象实现同步
显示的加锁机制，使用起来更加灵活，可以控制获取锁的时间等，如果方法有返回值，需要在 `try` 块里面返回，在finally里面释放锁,代码如下:

	boolean captured = lock.tryLock();
    try {
        System.out.println("tryLock()" + captured);
    } finally {
        if(captured) {
            lock.unlock();
        }
    }
## 尽量不用 volatile

## 同步块控制(this代表当前对象)

	public void test(){
		//不需要同步控制的代码
		synchronized(this){
			//需要同步控制的代码
		}
		//不需要同步控制的代码
	}

## 终结任务
1. 在线程里面增加结束标记，当标记为true的时候结束线程。  

		@Override
		    public void run() {
		        while (!canceled) {
		            synchronized (this) {
		                ++ number;
		            }
		            System.out.println(this + " Total:" + count.increment());
		            try {
		                TimeUnit.MILLISECONDS.sleep(100);
		            } catch (InterruptedException e) {
		                e.printStackTrace();
		            }
		        }
		    }
2. 调用Thread.interrupt()方法。
## 线程进入阻塞状态的原因
1. 调用sleep() 方法。
2. 调用wait()方法，当调用notify()/notifyAll()或signal()/signalAll()的时候，线程会返回到就绪状态。
3. 等待输入/输出完成。
4. 访问某个对象的同步方法，但是对象锁不可用。

##中断

1. sleep()方法，造成的阻塞可以中断。
2. IO或调用同步方法造成的阻塞不可中断。

可以中断：调用中断线程的方法之后会抛出InterruptedException，可以通过捕获这个异常来处理中断状态。  
不可中断：调用中断线程的方法之后不会抛出任何异常，线程直接终止运行。
  
中断方法：   
  
1. 调用Future<?>的caccel方法。
  
		static void test(Runnable runnable) throws InterruptedException {
		    Future<?> f = executorService.submit(runnable);
		    TimeUnit.MILLISECONDS.sleep(100);
		    System.out.println("准备中断" + runnable.getClass().getName());
		    f.cancel(true);
		    System.out.println("发送中断消息到"+runnable.getClass().getName());
		
		}
2. 调用

		Thread.currentThread().interrupt();

## 线程之间协作
* 线程之间的协作通过 wait() 和 notifyAll()来实现，wait()方法会一直等待,知道被notifyAll() 通知。  
* wait() , notify() 和 notifyAll() 的调用必须在同步块里面，如果不是的话执行的时候会抛出异常。  
* wait() 不同于 sleep()方法， wait()  调用的时候会释放对象锁，让其它同步的方法可以执行。
* notifyAll 只会通知所属对象的 wait 方法。
* notify、notifyAll 只会通知所属对象的await,相应的await也只会接收所属对象的通知。

## Lock和Condition实现线程之间的通信

    public class Pig {
    
        private Lock lock = new ReentrantLock();
    
        private Condition condition = lock.newCondition();
    
        private boolean isSleep = false;
    
    
        public void sleep() {
            lock.lock();
            try {
                isSleep = true;
                System.out.println("猪开始睡觉了");
                condition.signalAll();
            } finally {
                lock.unlock();
            }
        }
    
        public void awake() {
            lock.lock();
            try {
                isSleep = false;
                System.out.println("猪已经醒来");
                condition.signalAll();
            } finally {
                lock.unlock();
            }
        }
    
        public void waitSleep() throws InterruptedException {
            lock.lock();
            try {
                while (!isSleep) {
                    System.out.println("等待睡觉...");
                    condition.await();
                }
            } finally {
                lock.unlock();
            }
        }
    
        public void waitAwake() throws InterruptedException {
            lock.lock();
    
            try {
                while (isSleep) {
                    System.out.println("等待醒来...");
                    condition.await();
                }
            } finally {
                lock.unlock();
            }
    
        }
    }


## 同步队列（BlockingQueue）
同步队列内部使用了同步控制，使得放入和取出是同步的，使用同步队列可以减少我们编写代码的逻辑，更快的实现我们想要的功能。
## 管道通信
PipeWriter PipeReader

## 死锁的情况

1. 两个资源，两个用户，用户同时持有两种资源的时候才能执行下一步操作，用户一已经持有了第一种资源，用二持有了第二种资源，用户一因为等待资源二而阻塞，用户二因为等待资源一而阻塞，用户一和二谁也不释放自己所持有的资源，用户一和用户二只能无限的阻塞下去，这就造成了死锁。
比如哲学家就餐问题。
2. 在同步代码块里面，创建一个新的线程去获取该同步对象的锁，获取不到锁就阻塞执行，此时会出现死锁现象。

		public class Test {
		
		    private Object lock = new Object();
		
		    public void methodA() {
		        synchronized (lock) {
		            System.out.println("methodA");
		            Test test = this;
		            ExecutorService executorService = Executors.newSingleThreadExecutor();
		            try {
		                executorService.submit(new Runnable() {
		                    @Override
		                    public void run() {
		                        test.methodA();
		                    }
		                }).get();
		            } catch (Exception e) {
		                //eat
		            }
		            System.out.println("A end");
		        }
		    }
		    public static void main(String[] args) {
		        Test test = new Test();
		        test.methodA();
		    }
		}