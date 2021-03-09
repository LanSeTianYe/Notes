时间：2019/7/16 15:36:38 

## Java Stream 使用

流式处理框架  

`stream`：单线程执行。 
`parallelStream`：并行执行，使用时注意线程问题。

### 常用方法  

#### map()  

类型转换，`stream` 中的数据转换为任意其他类型。

	List<String> list = Arrays.asList("1", "2", "3");
	Stream<StringBuilder> stringBuilderStream = list.stream().map(StringBuilder::new);
	Stream<String> stringStream = list.stream().map(String::valueOf);

#### flatMap() 

类型转换，把 `stream` 中的每一个元素转成换一个 `stream`，然后把所有的 `stream` 合并成一个 `stream`。

	List<String> strings = Arrays.asList("hello world", "where are you", "i am fine");
	Stream<String> unionStream = strings.stream().map(s -> s.split(" +")).flatMap(Stream::of);

#### reduce 

根据 `stream` 中的数据进行计算。


 		List<String> strings = Arrays.asList("hello world", "where are you", "i am fine");
        Stream<String> unionStream = strings.stream().map(s -> s.split(" +")).flatMap(Stream::of);

		# 连接流中的元素，第一个元素是 ""
	    String unionStr = unionStream.reduce("", (identity, first) -> identity + "_" + first);
	    System.out.println(unionStr);
	
		# 连接流中的元素，第一个元素是流的第一个元素
	    unionStream = strings.stream().map(s -> s.split(" +")).flatMap(Stream::of);
	    unionStr = unionStream.reduce((first, second) -> first + "_" + second).orElse("");
	    System.out.println(unionStr);
	
		# 比较复杂的实现
	    unionStream = strings.stream().map(s -> s.split(" +")).flatMap(Stream::of);
	    List<String> result = new ArrayList<>();
	    List<String> reduce = unionStream.reduce(result, (r, element) -> {
	        r.add(element);
	        return r;
	    }, (first, second) -> {
	        List<String> temp = new ArrayList<>();
	        temp.addAll(first);
	        temp.addAll(second);
	        return temp;
	    });
	
	    System.out.println(result);
	    System.out.println(reduce);

#### peek 

访问流中的元素，返回原来的流。当 `peek` 的下一流程执行的时候 `peek` 方法才会执行。

#### skip(long n) 

跳过 `n` 流中的前 n 个元素。当 `n` 大于流长度时，返回空流。

#### limit(long maxSize)  

返回流的前 `maxSize` 个元素。

 