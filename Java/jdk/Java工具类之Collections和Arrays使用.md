时间：2017/12/11 14:46:47   
参考：    
 
1. Jdk 源码 

##   
#### Collections 和 Arrays
##### Collections

1. 排序

		public static <T extends Comparable<? super T>> void sort(List<T> list)
		public static <T> void sort(List<T> list, Comparator<? super T> c)
2. 二分查找，应用于已经排序的List，如果有重复之，不保证每一次查找到的是同一个元素。

		public static <T extends Comparable<? super T>> void sort(List<T> list)
		public static <T> int binarySearch(List<? extends T> list, T key, Comparator<? super T> c)
3. 逆转 List

		public static void reverse(List<?> list)
4. 打乱数组顺序

		public static void shuffle(List<?> list)
		public static void shuffle(List<?> list, Random rnd)
5. 交换List指定位置的元素

		public static void swap(List<?> list, int i, int j) {
	        final List l = list;
	        l.set(i, l.set(j, l.get(i)));
	    }
6. 用指定元素替换List里面的所有元素

		public static <T> void fill(List<? super T> list, T obj)
7. 把数组拷贝到指定数组

		public static <T> void copy(List<? super T> dest, List<? extends T> src)
8. 查找最小值 

		public static <T extends Object & Comparable<? super T>> T min(Collection<? extends T> coll)
 		public static <T> T min(Collection<? extends T> coll, Comparator<? super T> comp)
9. 查找最大值

		public static <T extends Object & Comparable<? super T>> T max(Collection<? extends T> coll)
		public static <T> T max(Collection<? extends T> coll, Comparator<? super T> comp) 
10. 循环移动数据
		
		//数组[t, a, n, k, s]  rotate(list, 1) 或者 rotate(list, -4) ==>[s, t, a, n, k]
		public static void rotate(List<?> list, int distance)
11. 替换所有的指定元素为指定值

		public static <T> boolean replaceAll(List<T> list, T oldVal, T newVal)
13. 查看指定List是否包含另外一个List

		//返回第一个位置的坐标或-1
		public static int indexOfSubList(List<?> source, List<?> target)
		//获取最后一个位置的坐标或-1
		public static int lastIndexOfSubList(List<?> source, List<?> target)
14. 不可变集合。返回指定集合的不可变视图，只能在集合上面执行只读操作，任何改变操作都会抛出 `UnmodifiableCollection` 异常。

		public static <T> Collection<T> unmodifiableCollection(Collection<? extends T> c)
		public static <T> Set<T> unmodifiableSet(Set<? extends T> s)
		public static <T> SortedSet<T> unmodifiableSortedSet(SortedSet<T> s)
		public static <T> NavigableSet<T> unmodifiableNavigableSet(NavigableSet<T> s)
		public static <T> List<T> unmodifiableList(List<? extends T> list)
		public static <K,V> Map<K,V> unmodifiableMap(Map<? extends K, ? extends V> m)
		public static <K,V> SortedMap<K,V> unmodifiableSortedMap(SortedMap<K, ? extends V> m)
		public static <K,V> NavigableMap<K,V> unmodifiableNavigableMap(NavigableMap<K, ? extends V> m)
		
15. 同步集合，所有的操作增加同步锁，效率不高。

		public static <T> Collection<T> synchronizedCollection(Collection<T> c)
		public static <T> Set<T> synchronizedSet(Set<T> s)
 		public static <T> SortedSet<T> synchronizedSortedSet(SortedSet<T> s)
		public static <T> NavigableSet<T> synchronizedNavigableSet(NavigableSet<T> s)
		public static <T> List<T> synchronizedList(List<T> list)
		public static <K,V> Map<K,V> synchronizedMap(Map<K,V> m) 
		public static <K,V> SortedMap<K,V> synchronizedSortedMap(SortedMap<K,V> m) 
		public static <K,V> NavigableMap<K,V> synchronizedNavigableMap(NavigableMap<K,V> m)
	
	

	源代码：

		static class SynchronizedCollection<E> implements Collection<E>, Serializable {
	        private static final long serialVersionUID = 3053995032091335093L;
	
	        final Collection<E> c;  // Backing Collection
	        final Object mutex;     // Object on which to synchronize
	
	        SynchronizedCollection(Collection<E> c) {
	            this.c = Objects.requireNonNull(c);
	            mutex = this;
	        }
	
	        SynchronizedCollection(Collection<E> c, Object mutex) {
	            this.c = Objects.requireNonNull(c);
	            this.mutex = Objects.requireNonNull(mutex);
	        }
	
	        public int size() {
	            synchronized (mutex) {return c.size();}
	        }
	       	... ...
	        private void writeObject(ObjectOutputStream s) throws IOException {
	            synchronized (mutex) {s.defaultWriteObject();}
	        }
	    }
16. 固化无类型集合的类型，插入其他类型数据会抛出异常。

		public static <E> Collection<E> checkedCollection(Collection<E> c,Class<E> type)
		public static <E> Queue<E> checkedQueue(Queue<E> queue, Class<E> type)
		public static <E> Set<E> checkedSet(Set<E> s, Class<E> type)
		public static <E> SortedSet<E> checkedSortedSet(SortedSet<E> s,Class<E> type)
		public static <E> NavigableSet<E> checkedNavigableSet(NavigableSet<E> s,Class<E> type)
		public static <E> List<E> checkedList(List<E> list, Class<E> type)
		public static <K, V> Map<K, V> checkedMap(Map<K, V> m,Class<K> keyType,Class<V> valueType)
		public static <K,V> SortedMap<K,V> checkedSortedMap(SortedMap<K, V> m,Class<K> keyType,Class<V> valueType)
		public static <K,V> NavigableMap<K,V> checkedNavigableMap(NavigableMap<K, V> m,Class<K> keyType,Class<V> valueType) 
		
		
      固化无类型集合的类型，当你获得一个无类型的集合，你可以通过该方法指定集合的类型。

		//无类型
		List objectArrayList = new ArrayList<>();
		//固化类型
        Collection<String> checkedCollection = Collections.checkedCollection(objectArrayList, String.class);
17. 空集合，静态内部类，单例模式。

		public static <T> Iterator<T> emptyIterator()
		public static <T> ListIterator<T> emptyListIterator()
		public static <T> Enumeration<T> emptyEnumeration()
		public static final <T> Set<T> emptySet()
		public static <E> SortedSet<E> emptySortedSet()
		public static <E> NavigableSet<E> emptyNavigableSet()
		public static final <T> List<T> emptyList()
		public static final <K,V> Map<K,V> emptyMap()
		public static final <K,V> SortedMap<K,V> emptySortedMap() 
		public static final <K,V> NavigableMap<K,V> emptyNavigableMap() 
		

	源码：

		class Collections {

			public static <T> Iterator<T> emptyIterator() {
		        return (Iterator<T>) EmptyIterator.EMPTY_ITERATOR;
		    }
		
			private static class EmptyIterator<E> implements Iterator<E> {
		        static final EmptyIterator<Object> EMPTY_ITERATOR
		            = new EmptyIterator<>();
		
		        public boolean hasNext() { return false; }
		        public E next() { throw new NoSuchElementException(); }
		        public void remove() { throw new IllegalStateException(); }
		        @Override
		        public void forEachRemaining(Consumer<? super E> action) {
		            Objects.requireNonNull(action);
		        }
		    }
		}
18. 不可变对象，单一元素。返回一个不可变的集合，且只包含指定的元素。

		public static <T> Set<T> singleton(T o)
		public static <T> List<T> singletonList(T o)
		public static <K,V> Map<K,V> singletonMap(K key, V value)
19. 返回一个n个指定元素的不可变集合

		public static <T> List<T> nCopies(int n, T o)
20. 逆排序

		public static <T> Comparator<T> reverseOrder()
		public static <T> Comparator<T> reverseOrder(Comparator<T> cmp) 

	例如：

		Arrays.sort(a, Collections.reverseOrder());
21. 返回枚举

		public static <T> Enumeration<T> enumeration(final Collection<T> c) 
22. 枚举转换为List

		public static <T> ArrayList<T> list(Enumeration<T> e)
23. 返回元素出现的次数

		public static int frequency(Collection<?> c, Object o) {
	        int result = 0;
	        if (o == null) {
	            for (Object e : c)
	                if (e == null)
	                    result++;
	        } else {
	            for (Object e : c)
	                if (o.equals(e))
	                    result++;
	        }
	        return result;
	    }
		

24. 判断两个集合是否有交集，（代码可以优化）

		public static boolean disjoint(Collection<?> c1, Collection<?> c2) {
	       
	        Collection<?> contains = c2;
	        Collection<?> iterate = c1;
	
	        if (c1 instanceof Set) {
	            iterate = c2;
	            contains = c1;
	        } else if (!(c2 instanceof Set)) {
	            int c1size = c1.size();
	            int c2size = c2.size();
	            if (c1size == 0 || c2size == 0) {
	                return true;
	            }
	            if (c1size > c2size) {
	                iterate = c2;
	                contains = c1;
	            }
	        }
	
	        for (Object e : iterate) {
	            if (contains.contains(e)) {
	                return false;
	            }
	        }
	        return true;
	    }
25. 添加元素到集合。
	
		public static <T> boolean addAll(Collection<? super T> c, T... elements) {
	        boolean result = false;
	        for (T element : elements){
				// result = result | c.add(element);
	            result |= c.add(element);
			}
	        return result;
	    }
26. 返回指定Map实现的Set。HasMap和TreeMap已经有对应的HastSet和TreeSet。

		public static <E> Set<E> newSetFromMap(Map<E, Boolean> map)

27. 后进先出队列

		public static <T> Queue<T> asLifoQueue(Deque<T> deque)
	
##### Arrays 数组相关操作

1. 排序 `sort(...)`， 快速排序实现。 
2. 并行排序 `parallelSort(...)`
3. 排序 `sort(Object[] a)` 归并排序。
4. 实现左右元素相加 `parallelPrefix(int[] array, IntBinaryOperator op)`

		int[] arr = new int[20];
        arr[0] = 1;
        arr[1] = 1;
        
        Arrays.parallelPrefix(arr, (left, right) -> left + right);

	输出结果：

		1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
5. 二分搜索 `int binarySearch(long[] a, long key)`
6. 数组比较 `equals(long[] a， long[] b)`
7. 数组填充 `fill(long[] a, long val)`
8. 复制一个数组 `copyOf(T[] original, int newLength)`
9. `asList(T ...a)`
10. 转换成流 `stream(T[] array)`
11. 比较 `compare(boolean[] a, boolean[] b)` 的大小
12. 找到两个数组第一个不一样的地方  `mismatch(boolean[] a, boolean[] b)`

	