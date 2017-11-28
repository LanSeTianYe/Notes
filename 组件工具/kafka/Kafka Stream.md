时间：2017/11/28 23:56:35   
参考：   



##
### 流转换   
#### 无状态转换   

1. branch（KStream -> KStream）: 分支，一个转换为多个。    


		KStream<String, Long> stream = ...;
		KStream<String, Long>[] branches = stream.branch(
		        (key, value) -> key.startsWith("A"), /* first predicate  */
		        (key, value) -> key.startsWith("B"), /* second predicate */
		        (key, value) -> true                 /* third predicate  */
		);
2. Filter（KStream -> KStream/KTable -> KTable） ：过滤，一个转换为一个。  

		KStream<String, Long> onlyPositives = stream.filter((key, value) -> value > 0);
		// A filter on a KTable that materializes the result into a StateStore
		table.filter((key, value) -> value != 0, Materialized.<String, Long, KeyValueStore<Bytes, byte[]>>as("filtered"));

3. Filter（KStream -> KStream/KTable -> KTable） ：逆过滤，一个转换为一个。  

		KStream<String, Long> onlyPositives = stream.filterNot((key, value) -> value <= 0);
4. FlatMap（KStream -> KStream）：把一条记录转换为零个、一个或多个记录，可以改变键和值内容，以及键和值的类型。

	在FlatMAP之后执行group或join会导致重分区，使用 `flatMapValues` 不会导致重分区。

		KStream<String, Integer> transformed = stream.flatMap(
	    // Here, we generate two output records for each input record.
	    // We also change the key and value types.
	    // Example: (345L, "Hello") -> ("HELLO", 1000), ("hello", 9000)
	    (key, value) -> {
	        List<KeyValue<String, Integer>> result = new LinkedList<>();
	        result.add(KeyValue.pair(value.toUpperCase(), 1000));
	        result.add(KeyValue.pair(value.toLowerCase(), 9000));
	        return result;
	    }
		);   
5. FlatMap (values only)（KStream -> KStream）: 只改变值，不改变key。  

		// Split a sentence into words.
		KStream<byte[], String> sentences = ...;
		KStream<byte[], String> words = sentences.flatMapValues(value -> Arrays.asList(value.split("\\s+")));
6. Foreach（KStream -> void）：对每条记录执行无状态操作。   

		// Print the contents of the KStream to the local console.
		// Java 8+ example, using lambda expressions
		stream.foreach((key, value) -> System.out.println(key + " => " + value));
7. GroupByKey（KStream-> KGroupedStream）：根据key进行分组。当且仅当流被标记为重分区的时候才会进行重分区。    

		KStream<byte[], String> stream = ...;
		 
		// Group by the existing key, using the application's configured
		// default serdes for keys and values.
		KGroupedStream<byte[], String> groupedStream = stream.groupByKey();
		 
		// When the key and/or value types do not match the configured
		// default serdes, we must explicitly specify serdes.
		KGroupedStream<byte[], String> groupedStream = stream.groupByKey(
		    Serialized.with(
		         Serdes.ByteArray(), /* key */
		         Serdes.String())     /* value */
		);
8. GroupBy（KStream → KGroupedStream）（KTable → KGroupedTable）：根据新key分组数据，key的类型可能和原来不同， 对table进行分组时，也可以指定一个新的值和值的类型。总是会导致重新分区 。 

		// Group the stream by a new key and key type
		KGroupedStream<String, String> groupedStream = stream.groupBy(
	    (key, value) -> value,
	    Serialize.with(
	         Serdes.String(), /* key (note: type was modified) */
	         Serdes.String())  /* value */
		);

		// Group the table by a new key and key type, and also modify the value and value type.
		KGroupedTable<String, Integer> groupedTable = table.groupBy(
		    (key, value) -> KeyValue.pair(value, value.length()),
		    Serialized.with(
		        Serdes.String(), /* key (note: type was modified) */
		        Serdes.Integer()) /* value (note: type was modified) */
		);
9. Map（KStream → KStream）： 一条记录生成一条新的记录，可以改变key和value，以及他们的类型。  
		
		KStream<byte[], String> stream = ...;
		 
		// Java 8+ example, using lambda expressions
		// Note how we change the key and the key type (similar to `selectKey`)
		// as well as the value and the value type.
		KStream<String, Integer> transformed = stream.map(
	    (key, value) -> KeyValue.pair(value.toLowerCase(), value.length()));
10. Map(values only)（KStream → KStream or KTable → KTable） ： 一条记录生成一条记录，仅仅可以改变值和值的类型。不会导致重分区。  
	
		// Java 8+ example, using lambda expressions
		KStream<byte[], String> uppercased = stream.mapValues(value -> value.toUpperCase()); 
		
		// mapValues on a KTable and also materialize the results into a statestore
		table.mapValue(value -> value.toUpperCase(), Materialized.<String, String, KeyValueStore<Bytes, byte[]>>as("uppercased"));
11. Print（KStream → void）：打印。  

		KStream<byte[], String> stream = ...;
		stream.print();
		                     
		// You can also override how and where the data is printed, i.e, to file:
		stream.print(Printed.toFile("stream.out"));
		 
		// with a custom KeyValueMapper and label
		stream.print(Printed.toSysOut()
		         .withLabel("my-stream")
		         .withKeyValueMapper((key, value) -> key + " -> " + value));
12. SelectKey（KStream → KStream）： 变更key，类型也可以边。标记为重分区时，在group/join的时候会进行重分区。  

		KStream<byte[], String> stream = ...;
 
		// Derive a new record key from the record's value.  Note how the key type changes, too.
		// Java 8+ example, using lambda expressions
		KStream<String, String> rekeyed = stream.selectKey((key, value) -> value.split(" ")[0])
13. Table to Stream（KTable → KStream） ： 把table转换到stream里。  

		KTable<byte[], String> table = ...;
	 	
		// Also, a variant of `toStream` exists that allows you
		// to select a new key for the resulting stream.
		KStream<byte[], String> stream = table.toStream();
14. WriteAsText（KStream → void）：把记录写入文件。  

		KStream<byte[], String> stream = ...;
		stream.writeAsText("/path/to/local/output.txt");
		 
		// Several variants of `writeAsText` exist to e.g. override the
		// default serdes for record keys and record values.
		stream.writeAsText("/path/to/local/output.txt", Serdes.ByteArray(), Serdes.String());

### 有状态转换   