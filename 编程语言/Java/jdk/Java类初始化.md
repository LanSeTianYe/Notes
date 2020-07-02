##  

时间：2017/9/3 22:06:04   

参考：  
1. Java编程思想第四版 [319|94] 页  

##  类初始化相关  
  
1. 静态变量和静态域只会被初始化一次。
2. 访问编译期常量（static 和 final共同修饰的 基本类型以及String类型）不会触发静态变量和静态域的初始化。static或final修饰的被访问会触发静态变量和静态域的初始化。
3. `ClassName.class` 被调用不会执行类的初始化。
3. `Class.forName()` 加载类会调用类的静态变量和静态域的初始化。
4. 使用 `new` 创建变量会触发变量静态和非静态域的初始化，初始化顺序如下：
	1. 按顺序初始化静态变量和静态域，如果有父类先初始化父类的静态变量和静态域。
	3. 按顺序初始化非静态变量和非静态域，然后执行构造函数。如果有父类，先初始化父类的非静态变量和非静态域，然后执行父类的构造函数，按顺序初始化非静态变量和非静态域，然后执行构造函数。

	    Parent：   

			public class Parent {
			
			    public Parent() {
			        System.out.println("Parent Construct ...");
			    }
			
			    static {
			        System.out.println("Parent Static Init");
			    }
			
			    {
			        System.out.println("Parent Non Static Init");
			    }
			}

	    Child：

			public class Child extends Parent{
			
			    public Child() {
			        super();
			        System.out.println("Child Construct ... ");
			    }
			
			    static {
			        System.out.println("Child Static Init");
			    }
			
			    {
			        System.out.println("Child Non Sttaic Init");
			    }
			}

		new Child() 输出：

			Parent Static Init
			Child Static Init
			Parent Non Static Init
			Parent Construct ...
			Child Non Sttaic Init
			Child Construct ... 


