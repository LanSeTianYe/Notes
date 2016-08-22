## Semaphore  
初始化：

	Semaphore available = new Semaphore(size, true);

核心方法：

	release()；		//可用数量+1
	acquire()；		//可用数量-1

作用：  
计数信号量。通常用于固定数量资源的访问限制，用于对象池等。初始化的时候指定池的大小。  

用法：

	public class Pool<T> {
	
	    private List<T> pool = new ArrayList<>();
	
	    private volatile boolean[] checkout;
	
	    private Semaphore available;
	
	    //初始化
	    public Pool(Class<T> tClass, int size) {
	        checkout = new boolean[size];
	        available = new Semaphore(size, true);
	
	        //初始化池里面的对象
	        for(int i = 0; i < size; i++) {
	            try {
	                pool.add(tClass.newInstance());
	            } catch (InstantiationException e) {
	                throw new RuntimeException(e);
	            } catch (IllegalAccessException e) {
	                throw new RuntimeException(e);
	            }
	        }
	    }
	
	
	    public T checkOut() throws InterruptedException {
	        available.acquire();
	        return getItem();
	    }
	
	    public void checkIn(T item){
	        if(releaseItem(item)) {
	            available.release();
	        }
	    }
	
	    //取出元素
	    private synchronized T getItem() {
	        for(int i = 0; i < pool.size(); i++) {
	            if(!checkout[i]) {
	                checkout[i] = true;
	                return pool.get(i);
	            }
	        }
	        return null;
	    }
	
	    //释放元素
	    public synchronized boolean releaseItem(T item) {
	        int index = pool.indexOf(item);
	        if(index == -1) {
	            return false;
	        }
	
	        if(checkout[index]) {
	            checkout[index] = false;
	            return true;
	        }
	
	        return false;
	    }
	}
	
