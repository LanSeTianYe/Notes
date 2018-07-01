时间： 2018/6/30 7:47:28
 
参考：

## Java 原子类

通过CompareAndSet的方式实现数据的原子变更，避免多线程情况下出现问题。

###  原子变量

* AtomicInteger
* AtomicLong
* AtomicBoolean
* AtomicReference

代码示例：  

	AtomicReference<TestInteger> reference = new AtomicReference<TestInteger>();
    TestInteger newTest = new TestInteger();
    reference.compareAndSet(testInteger, newTest);

### 原子数组

* AtomicIntegerArray
* AtomicLongArray
* AtomicReferenceArray

代码示例：  

	AtomicIntegerArray integerArray = new AtomicIntegerArray(10);
    integerArray.addAndGet(1, 10);

### 原子字段 
基于反射机制实现

* AtomicIntegerFieldUpdater<T>
* AtomicLongFieldUpdater<T>
* AtomicReferenceFieldUpdater<T,V>

代码示例： 


	public static void main(String[] args) {
        AtomicIntegerFieldUpdater<TestInteger> ageUpdater = AtomicIntegerFieldUpdater.newUpdater(TestInteger.class, "age");
        TestInteger testInteger = new TestInteger();
        ageUpdater.addAndGet(testInteger, 100);
        System.out.println(ageUpdater.get(testInteger));
    }
    
    private static class TestInteger {
        volatile int age = 100;
    }