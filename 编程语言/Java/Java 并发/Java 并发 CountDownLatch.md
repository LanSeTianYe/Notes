## 使用

初始化

	CountDownLatch countDownLatch = new CountDownLatch(100);
核心方法

	countDownLatch.countDown();
	countDownLatch.await();

## 用法说明
为 `CountDownLatch` 指定一个初始的计数值， 每次调用 `countDown()` 方法，计数器的值会减一， `await()` 方法会一直等待直到计数器的值变为零。

## 应用范围

当一些业务需要等到另外的多个任务执行完成之后才能执行，此时可以设置一个计数器，然后在业务代码里面调用  `await()` 方法，当每个任务完成的时候调用 `countDown()` 方法，就可以达到在多个任务完成之后再执行业务代码的需求。  