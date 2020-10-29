时间：2017-07-18 09:59:53 

参考：

1.  [https://waylau.gitbooks.io/essential-java/docs/concurrency-Immutable%20Objects.html](https://waylau.gitbooks.io/essential-java/docs/concurrency-Immutable%20Objects.html)

##  可以做什么？

 * 线程安全： 不可变对象限制了程序在运行过程中改变对象属性的方法，从而能避免在并发的环境下出现读写不一致的问题。

## 存在的问题

频繁创建对象耗费时间，创建对象占用内存增多，垃圾回收执行更频繁。

## 具体代码

### 不可变对象：

**代码：**

```java
public class Immutable {

    public static void main(String[] args) throws InterruptedException {

        Entity entity = new Entity("name1", 1);

        new Thread(() -> {
            try {
                TimeUnit.SECONDS.sleep(1);
                Entity entity2 = new Entity("name3", 2);
                System.out.println("改变之后" + entity2);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();

        new Thread(() -> {
            System.out.println("线程2 name:" + entity.getName());
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("线程2 age:" + entity.getAge());
        }).start();

        TimeUnit.SECONDS.sleep(2);
    }

    static class Entity {

        public final String name;

        public final int age;

        public Entity(String name, int age) {
            this.name = name;
            this.age = age;
        }

        public String getName() {
            return name;
        }

        public int getAge() {
            return age;
        }

        @Override
        public String toString() {
            return "Entity{" +
                    "name='" + name + '\'' +
                    ", age=" + age +
                    '}';
        }
    }
}
```

**输出：**

```java
线程2 name:name1
改变之后Entity{name='name3', age=2}
线程2 nmae:1
```

### 可变对象（并发问题模拟）

**代码：**

```java
public class Changeable {

    public static void main(String[] args) throws InterruptedException {

        Entity entity = new Entity("name1", 1);

        new Thread(() -> {
            try {
                TimeUnit.SECONDS.sleep(1);
                entity.change("name2", 2);
                System.out.println("改变之后" + entity);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();

        new Thread(() -> {
            System.out.println("线程2获取属性" + entity.getName());
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("线程2获取属性" + entity.getAge());
        }).start();

        TimeUnit.SECONDS.sleep(2);
    }

}

class Entity {

    public String name;

    public int age;

    public Entity(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public synchronized String getName() {
        return name;
    }

    public synchronized int getAge() {
        return age;
    }

    public void change(String name, int age){
        synchronized (this) {
            this.name = name;
            this.age = age;
        }
    }

    @Override
    public String toString() {
        return "Entity{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

**输出：**

```java
线程2获取属性name1
改变之后Entity{name='name2', age=2}
线程2获取属性2
```
