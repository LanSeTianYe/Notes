##  
时间：2017/4/6 21:43:49 

## 引用简介
Java里面包含四种引用：引用位于 `java.lang.ref.*` 包中。  
在Java中可以指定对对象的不同类型的引用，不同类型的引用在JVM进行垃圾回收时候有不同的处理策略，通过构建一些弱引用和软引用来引用对象可以有效的防止内存溢出。
  
1. 虚引用：`PhantomReference`  
     
2. 弱引用：`WeakReference`  
   弱引用在系统运行垃圾回收的时候一定会被清理。
3. 软引用：`SoftReference`   
   在系统如果不清理软引用会抛出OutOfJMemoryError异常时，垃圾回收机制清理软引用，优先清除长时间没有使用的引用。
4. 强引用：`FinalReference`  
   默认情况下 `String a = new String("a")` 就定义了一个变量 `a` 对 字符串 `a` 的一个强引用。对象只要存在强引用，在垃圾回收机制运行的时候对象就不会被清除。

一般情况下，A引用B,B引用C，C引用D。此时对象 `D` 的引用强度取决于, `A->B` `B-C` `C-D` 之间最弱的引用。  
一般情况下一个对象会被多个其他对象以不同的方式引用，此时对象的引用强度取决于最强的那条路经的引用。

## 引用测试
初始化引用对象的时候，如果引用内容被垃圾回收机制清理，则对应引用会被放入到引用队列中，此时我们可以根据队列中的内容清除，不存在引用对象的引用。

下面代码：

	public static void main(String[] args) {

        Random random = new Random(47);

        List<SoftReference> softReferences = new ArrayList<>();
        List<WeakReference> weakReferences = new ArrayList<>();
        List<PhantomReference> phantomReferences = new ArrayList<>();

        ReferenceQueue<Integer> softQueue = new ReferenceQueue<>();
        ReferenceQueue<Integer> weakQueue = new ReferenceQueue<>();
        ReferenceQueue<Integer> phantomQueue = new ReferenceQueue<>();

        //初始化引用对象，并添加到列表
        for (int i = 0; i < 2; i++) {
            SoftReference<Integer> softReference = new SoftReference<>(random.nextInt(100), softQueue);
            WeakReference<Integer> weakReference = new WeakReference<>(random.nextInt(1000), weakQueue);
            PhantomReference<Integer> phantomReference = new PhantomReference<>(random.nextInt(10000), phantomQueue);
            System.gc();
            softReferences.add(softReference);
            weakReferences.add(weakReference);
            phantomReferences.add(phantomReference);
        }

        //打印引用列表
        softReferences.forEach(x -> {
            System.out.println("软引用:\t" + x);
        });
        weakReferences.forEach(x -> {
            System.out.println("弱引用:\t" + x);
        });
        phantomReferences.forEach(x -> {
            System.out.println("虚引用:\t" + x);
        });


        //清理不存在引用对象的引用
        Reference<? extends Integer> reference;
        while ((reference = softQueue.poll()) != null){
            softReferences.remove(reference);
            System.out.println("软引用队列:\t" + reference);
        }

        while ((reference = weakQueue.poll()) != null){
            softReferences.remove(reference);
            System.out.println("弱引用队列:\t" + reference);
        }

        while ((reference = phantomQueue.poll()) != null){
            softReferences.remove(reference);
            System.out.println("虚引用队列:\t" + reference);
        }
    }

输出结果（可能是下面的内容，引用队列的顺序没有保证，引用队列的实现是一个栈）：

A：

	软引用:	java.lang.ref.SoftReference@50675690
	软引用:	java.lang.ref.SoftReference@31b7dea0
	弱引用:	java.lang.ref.WeakReference@47d384ee
	弱引用:	java.lang.ref.WeakReference@2d6a9952
	虚引用:	java.lang.ref.PhantomReference@3930015a
	虚引用:	java.lang.ref.PhantomReference@629f0666
	弱引用队列:	java.lang.ref.WeakReference@47d384ee
	弱引用队列:	java.lang.ref.WeakReference@2d6a9952
	虚引用队列:	java.lang.ref.PhantomReference@3930015a
	虚引用队列:	java.lang.ref.PhantomReference@629f0666

B：

	软引用:	java.lang.ref.SoftReference@50cbc42f
	软引用:	java.lang.ref.SoftReference@75412c2f
	弱引用:	java.lang.ref.WeakReference@13b6d03
	弱引用:	java.lang.ref.WeakReference@f5f2bb7
	虚引用:	java.lang.ref.PhantomReference@64c64813
	虚引用:	java.lang.ref.PhantomReference@3ecf72fd
	弱引用队列:	java.lang.ref.WeakReference@f5f2bb7
	弱引用队列:	java.lang.ref.WeakReference@13b6d03
	虚引用队列:	java.lang.ref.PhantomReference@3ecf72fd
	虚引用队列:	java.lang.ref.PhantomReference@64c64813