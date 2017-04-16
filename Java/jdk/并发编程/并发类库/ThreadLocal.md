##
时间：2017/4/7 9:33:10   
说明：  

1. 第一次接触到是在 `tomcat-embebd-core` 里面看到。
2. 在 `Shrio` 的 `ThreadContext` 中也有使用。

		private static final ThreadLocal<Map<Object, Object>> resources = new InheritableThreadLocalMap<Map<Object, Object>>();


## ThreaLocal（线程本地变量）
说明：在 `jdk1.2` 版本引入的， 位于 `java.lang`  包，jdk1.8增加了一些函数函数式接口的新特性。  
作用：提供一种变量存储方法，在多线程情况下，每个变量从中取出变量，都会取出与当前线程相关的变量，当前线程对变量的操作不会影响其它线程的变量，在当前线程环境下可以随时取出当前线程相关的变量，当前线程结束后对应的资源由于弱引用的原因会在垃圾回收机制运行的时候被及时清理。

ThreadLocal的个体方法

 	public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null) {
                @SuppressWarnings("unchecked")
                T result = (T)e.value;
                return result;
            }
        }
        return setInitialValue();
    }

Thread中对ThreadLocal的引用

	/* ThreadLocal values pertaining to this thread. This map is maintained
     * by the ThreadLocal class. */
	ThreadLocal.ThreadLocalMap threadLocals = null;

 	/*
     * InheritableThreadLocal values pertaining to this thread. This map is
     * maintained by the InheritableThreadLocal class.
     */
	ThreadLocal.ThreadLocalMap inheritableThreadLocals = null;


弱引用(ThreadLocal 的内部类)

 	static class ThreadLocalMap {
		static class Entry extends WeakReference<ThreadLocal<?>> {
	        /** The value associated with this ThreadLocal. */
	        Object value;
	
	        Entry(ThreadLocal<?> k, Object v) {
	            super(k);
	            value = v;
	        }
	    }
		........
	}

## InheritableThreadLocalMap

说明：可以从父线程传递到子线程的本地线程变量，继承ThreadLocal，可以通过重写 `childValue()` 方法对父线程的变量进行本地变量进行处理。

	/**
     * Computes the child's initial value for this inheritable thread-local
     * variable as a function of the parent's value at the time the child
     * thread is created.  This method is called from within the parent
     * thread before the child is started.
     * <p>
     * This method merely returns its input argument, and should be overridden
     * if a different behavior is desired.
     *
     * @param parentValue the parent thread's value
     * @return the child thread's initial value
     */
    protected T childValue(T parentValue) {
        return parentValue;
    }
