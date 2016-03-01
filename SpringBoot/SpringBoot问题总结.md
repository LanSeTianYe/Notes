时间：2016-2-29 22:57:29 

		<spring.boot.version>1.3.3.RELEASE</spring.boot.version>

## 启动报错
#### 错误提示：  

	Your ApplicationContext is unlikely to start due to a 
	@ComponentScan of the default package
#### 错误描述：
启动的时候，报错  
#### 解决方法：  
需要把启动类放在一个包里面，不能直接放在main目录下面
### 扫描不到Controller
## 问题描述：
项目突然不能扫描Controller所有的Controller都不能访问。
#### 解决：
原来是 `@ComponentScan` 只能扫描当前类所在保下面的类，由于把启动类单独移动到了一个保下面，所以不能扫描到其他包里面的Controller。使用 `@ComponentScan(basePackages = {"com.sun.xiaotian.authority"})` 即可.  
一份比较完整的启动类注解：

	@Controller
	@SpringBootApplication
	@EntityScan("com.sun.xiaotian.authority")
	@EnableJpaRepositories("com.sun.xiaotian.authority.repository")
	@ComponentScan(basePackages = {"com.sun.xiaotian.authority"})
	public class RunProjectApplication {
	
	    public static void main(String[] args) throws Exception {
	        SpringApplication.run(RunProjectApplication.class, args);
	    }
	
	    @RequestMapping("/")
	    @ResponseBody
	    public String index() {
	        return "Greetings from Spring Boot!";
	    }
	
	}


