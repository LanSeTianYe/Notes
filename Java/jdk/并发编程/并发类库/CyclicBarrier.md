## CyclicBarrier
	
初始化

	CyclicBarrier cyclicBarrier = new CyclicBarrier(int count， Runnable runnable);
等待

	cyclicBarrier.await();

作用：循环重复执行一个 `Runnable`。 每一次调用 `await` 方法，计数器（初始值为  `count` ）会减一,当 `count` 为零的时候，就会执行 `runnable` 任务, 然后初始化计时器的值，当计数器再次为零的时候，就会再一次执行 `runnable` 任务，由此而循环执行。

应用场景：当一个任务需要多个循环任务完成之后才能执行，则可以在多个任务的每一次循环结束前调用 `await()`  ，这样就能控制多个任务都完成的时候，再执行指定的任务。

**等待执行：**

	@Override
    public void run() {
        try {
            while (!Thread.interrupted()) {
                synchronized (this) {
                    strides = strides + random.nextInt(3);
                }
                cyclicBarrier.await();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (BrokenBarrierException e) {
            e.printStackTrace();
        }
    }
**初始化**

	cyclicBarrier = new CyclicBarrier(nHorse, new Runnable() {
	
        @Override
        public void run() {

            StringBuilder stringBuilder = new StringBuilder();
            for (int i = 0; i < FINISH_LINE; i++) {
                stringBuilder.append("=");
            }
            System.out.println(stringBuilder);

            for (Horse horse : horses) {
                System.out.println(horse.tracks());
            }

            for (Horse horse : horses) {
                if (horse.getStrides() >= FINISH_LINE) {
                    System.out.println(horse + "won");
                    executorService.shutdownNow();
                    return;
                }
            }

            try {
                TimeUnit.MILLISECONDS.sleep(pause);
            } catch (InterruptedException e) {
                System.out.println("sleep 产生中断");
            }
        }
    });