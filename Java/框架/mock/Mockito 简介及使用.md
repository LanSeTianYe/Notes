时间：2018/6/15 15:01:15   

参考：  

1. [官方文档](http://static.javadoc.io/org.mockito/mockito-core/2.18.3/org/mockito/Mockito.html)

### Mockito 使用

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