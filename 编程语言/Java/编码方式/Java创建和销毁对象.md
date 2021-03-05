时间： 2017/12/21 10:25:41

参考： 

1. 《Effective Java》第二版 


## 创建和销毁对象

### 1. 静态工厂方法，通过静态方法创建对象。

例如： 
	
	import java.util.*;
	
	public class Human {
	
	    //控制缓存的大小
	    private final static int cacheSize = 100;
	    private final static Map<String, Human> humanCache = Collections.synchronizedMap(new LinkedHashMap<>(cacheSize));
	
	    private final String firstName;
	    private final String secondName;
	
	    private Human(String firstName, String secondName) {
	        this.firstName = firstName;
	        this.secondName = secondName;
	    }
	
	    public static Human valueOf(String firstName, String secondName) {
	        String key = firstName + "_" + secondName;
	//        showElements(humanCache);
	        if (humanCache.containsKey(key)) {
	            return humanCache.get(key);
	        }
	
	        Human human = new Human(firstName, secondName);
	        if (humanCache.size() > cacheSize) {
	            //超过缓存大小，删除最早放入的元素
	            Iterator<String> iterator = humanCache.keySet().iterator();
	            iterator.next();
	            iterator.remove();
	        }
	
	        humanCache.put(key, human);
	        return human;
	    }
	
	    private static void showElements(Map<String, Human> humanCache) {
	        humanCache.keySet().forEach(key -> {
	            System.out.println(humanCache.get(key));
	        });
	        System.out.println();
	    }
	
	    @Override
	    public String toString() {
	        return "Human{" +
	                "firstName='" + firstName + '\'' +
	                ", secondName='" + secondName + '\'' +
	                '}';
	    }
	}

### 2. 当构造函数有多个参数的时候，考虑使用一个 `Builder` 来构建对象。

实现： 

Builder接口： 

	public interface Builder<T> {
	    public T build();
	}
具体实现： 

	public class Person {
	
	    enum Sex {
	        MAN(true), WOMAN(false);
	
	        public boolean value;
	
	        Sex(boolean value) {
	            this.value = value;
	        }
	    }
	    
	    private final String name;
	    private final int age;
	    private final Sex sex;
	    private final String telPhone;
	    private final String country;
	    private final String address;
	
	    public static class PersonBuilder implements Builder<Person> {
	        //必填参数,通过构造函数指定
	        private final String name;
	        private final int age;
	        private final Sex sex;
	
	        //可选参数，通过方法设置
	        private String telPhone;
	        private String country;
	        private String address;
	
	        public PersonBuilder(String name, int age, Sex sex) {
	            this.name = name;
	            this.age = age;
	            this.sex = sex;
	        }
	
	        public PersonBuilder telPhone(String telPhone) {
	            this.telPhone = telPhone;
	            return this;
	        }
	
	        public PersonBuilder country(String country) {
	            this.country = country;
	            return this;
	        }
	
	        public PersonBuilder address(String address) {
	            this.address = address;
	            return this;
	        }
	
	        @Override
	        public Person build() {
	            return new Person(this);
	        }
	    }
	
	    public Person(PersonBuilder personBuilder) {
	        this.name = personBuilder.name;
	        this.age = personBuilder.age;
	        this.sex = personBuilder.sex;
	        this.telPhone = personBuilder.telPhone;
	        this.country = personBuilder.country;
	        this.address = personBuilder.address;
	    }
	
	    @Override
	    public String toString() {
	        return "Person{" +
	                "name='" + name + '\'' +
	                ", age=" + age +
	                ", sex=" + sex +
	                ", telPhone='" + telPhone + '\'' +
	                ", country='" + country + '\'' +
	                ", address='" + address + '\'' +
	                '}';
	    }
	}

