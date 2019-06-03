时间：2018/6/5 10:05:45   
参考：  


##  简介及用法  

#### CompletionStage 方法作用简介

核心词汇 `when then accept both either run handle compose combine`

* 转变执行结果  

		public <U> CompletionStage<U> thenApply(Function<? super T,? extends U> fn);

* 消费执行结果 

		public CompletionStage<Void> thenAccept(Consumer<? super T> action);
* 直接执行下一个步骤

		public CompletionStage<Void> thenRunAsync(Runnable action);
* 连接上一步和下一步的执行结果 

 		public <U,V> CompletionStage<V> thenCombine(CompletionStage<? extends U> other, BiFunction<? super T,? super U,? extends V> fn);
* 消耗上一步和下一步的结果

		public <U> CompletionStage<Void> thenAcceptBoth(CompletionStage<? extends U> other,BiConsumer<? super T, ? super U> action);
* 两个 都执行完成，关心结果 

		public CompletionStage<Void> runAfterBoth(CompletionStage<?> other, Runnable action);
* 两个 任意一个执行完成 

 		public <U> CompletionStage<U> applyToEither(CompletionStage<? extends T> other, Function<? super T, U> fn);
* 两个 任意一个执行完成执行下一步 

		public CompletionStage<Void> runAfterEither(CompletionStage<?> other, Runnable action);

* 捕获异常 

		public CompletionStage<T> exceptionally(Function<Throwable, ? extends T> fn);
* 执行完成时

		public CompletionStage<T> whenComplete(BiConsumer<? super T, ? super Throwable> action);
* 对结果进行处理 

		public <U> CompletionStage<U> handle(BiFunction<? super T, Throwable, ? extends U> fn);

	代码：

		CompletableFuture.supplyAsync(() -> {
	            Pig pig = new Pig("pig_1");
	            pig.sleep();
	            if(1 == 1) {
	                throw new RuntimeException("");
	            }
	            return pig;
	        }).handle((pig, throwable) -> {
	            if (throwable != null) {
	                return new Pig("error_pig");
	            }
	            return pig;
	        }).thenAccept(System.err::println).join();
* thenCompose: 穿行执行两个任务，任务2依赖任务1。

		public <U> CompletionStage<U> thenCompose(Function<? super T, ? extends CompletionStage<U>> fn);
* thenCombine: 并行执行两个任务，同时完成之后执行 Function。

		public <U,V> CompletionStage<V> thenCombine(CompletionStage<? extends U> other, BiFunction<? super T,? super U,? extends V> fn);

#### CompletableFuture 方法作用简介

* 执行所有

 		public static CompletableFuture<Void> allOf(CompletableFuture<?>... cfs)

* 任意一个执行完成则停止执行

		public static CompletableFuture<Object> anyOf(CompletableFuture<?>... cfs)