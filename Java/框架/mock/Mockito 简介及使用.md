时间：2018/6/15 15:01:15   

参考：  

1. [官方文档](http://static.javadoc.io/org.mockito/mockito-core/2.18.3/org/mockito/Mockito.html)
2. [Mockito介绍](https://www.jianshu.com/p/1d41f5c28e2b)
3. [使用强大的 Mockito 测试框架来测试你的代码](https://juejin.im/entry/578f11aec4c971005e0caf82)

### Mock 简介
#### 为什么需要Mock  
测试驱动的开发(Test Driven Design, TDD)要求我们先写单元测试，再写实现代码。在写单元测试的过程中，我们往往会遇到要测试的类有很多依赖，这些依赖的类/对象/资源又有别的依赖，从而形成一个大的依赖树，要在单元测试的环境中完整地构建这样的依赖，是一件很困难的事情。

### Mockito 介绍及使用 

#### 简介

Mockito是一个模拟测试框架，可以让你用优雅，简洁的接口写出漂亮的单元测试。Mockito可以让单元测试易于可读，产生简洁的校验错误。

#### 使用场景  

* 提前创建测试，TDD（测试驱动开发）
* 团队可以并行工作
* 你可以创建一个验证或者演示程序
* 为无法访问的资源编写测试
* Mock可以交给用户
* 隔离系统

#### 准备工作
1. 引入依赖 [最新版点击此处](http://mvnrepository.com/search?q=mockito-core)

		<!-- https://mvnrepository.com/artifact/org.mockito/mockito-core -->
		<dependency>
		    <groupId>org.mockito</groupId>
		    <artifactId>mockito-core</artifactId>
		    <version>2.18.3</version>
		    <scope>test</scope>
		</dependency>

2. 导入 Mock 类

		import static org.mockito.Mockito.*;

#### 开始使用

1. 初始化选项

 * 调用对象引用的对象不会出现空指针异常
 
			mock(Human.class, Answers.RETURNS_DEEP_STUBS)
 * 智能赋值，常量常量的默认值，其它空

			mock(Human.class, Answers.RETURNS_SMART_NULLS);
2. 返回指定值。

		# 
		when(mock.getAll()).thenReturn(personList);
		# 匹配任意参数，get任意一个元素都会返回1
		when(list.get(anyInt())).thenReturn(1);
		# 自定义参数类型
		when(numbers.get(intThat(new OddNumberMatcher()))).thenReturn("奇数");
		# 实现类
		public class OddNumberMatcher implements ArgumentMatcher<Integer>, Serializable {
		    @Override
		    public boolean matches(Integer argument) {
		        return argument % 2 == 1;
		    }
		}


3. 验证方法调用。

		# 至少调用10次
		verify(mock, atLeast(10)).getAll();
		
3. 抛出异常

		# 有返回值的方法
		when(mock.getAll()).thenThrow(new RuntimeException());  
		# 无返回值方法
		doThrow(new IOException()).when(outputStream).close();

4. 使用注解,可以指定初始化选项,需要初始化。

		@Mock
		private List list; 

		public void ConstructMethod() {
			MockitoAnnotations.initMocks(this);
		}