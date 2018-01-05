时间：2018/1/5 13:51:29 

## 特性  
1. 可以在遍历的时候删除元素
	
	每次添加或者删除元素的时候都会根据原来的数组创建一个快照，然后在快照上进行操作，操作结束之后再把快照赋值给原始数组。

	添加元素：  
	
	    public boolean add(E e) {
	        synchronized (lock) {
	            Object[] elements = getArray();
	            int len = elements.length;
	            Object[] newElements = Arrays.copyOf(elements, len + 1);
	            newElements[len] = e;
	            setArray(newElements);
	            return true;
	        }
	    }
	迭代器遍历：获取数组，由于删除和添加的时候是在快照上进行，因此在foreach的时候删除元素不会出现  `ConcurrentModificationException` 异常。
	
	    public Iterator<E> iterator() {
	        return new COWIterator<E>(getArray(), 0);
	    }
2. 线程安全。
3. 迭代器不能执行remove set和add 方法。

		public void remove() {
            throw new UnsupportedOperationException();
        }
        public void set(E e) {
            throw new UnsupportedOperationException();
        }
        public void add(E e) {
            throw new UnsupportedOperationException();
        }


## CopyOnWriteArrayList 和 CopyOnWriteArraySet

测试代码：

	private static void testList() {
        CopyOnWriteArrayList<Integer> numberList = new CopyOnWriteArrayList<>();
        numberList.addAll(Arrays.asList(1, 2, 3, 4, 4, 5, 6, 7));
        System.out.println("包含4吗？" + numberList.contains(4));
        for (Integer number : numberList) {
            if (number == 4) {
                numberList.remove(number);
            }
        }
        System.out.println("包含4吗？" + numberList.contains(4));
    }

    private static void testSet() {
        CopyOnWriteArraySet<Integer> numberSet = new CopyOnWriteArraySet<>();
        numberSet.addAll(Arrays.asList(1, 2, 3, 4, 4, 4, 54, 5, 56, 6, 7, 9));

        System.out.println("包含4吗？" + numberSet.contains(4));

        for (Integer number : numberSet) {
            if (number == 4) {
                numberSet.remove(number);
            }
        }

        System.out.println("包含4吗？" + numberSet.contains(4));
    }
