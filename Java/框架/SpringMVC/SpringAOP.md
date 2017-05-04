## 
时间： 2017/5/4 17:05:39   
参考：[Spring Aop](http://docs.spring.io/spring/docs/current/spring-framework-reference/htmlsingle/#aop)

## concepts and terminology 概念和术语

* Aspect：
* Join point: 
* Advice：
 * Before advice
 * After returning advice
 * After throwing advice
 * After (finally) advice
 * Around advice
* Pointcut：
* Introduction：
* Target object:
* AOP proxy：JDK dynamic proxy or a CGLIB proxy。
* Weaving：

## 使用
1. 配置 `@AspectJ`可用

		@Configuration
		@EnableAspectJAutoProxy
		public class AppConfig {
		
		}

2.  Declaring an aspect

		@Component
		@Aspect
		public class NotVeryUsefulAspect {
		
		}
3. Declaring a pointcut

		@Pointcut("execution(* transfer(..))")// the pointcut expression
		private void anyOldTransfer() {}// the pointcut signature
4. Supported Pointcut Designators

	* execution - for matching method execution join points, this is the primary pointcut designator you will use when working with Spring AOP
	* within - limits matching to join points within certain types (simply the execution of a method declared within a matching type when using Spring AOP)
	* this - limits matching to join points (the execution of methods when using Spring AOP) where the bean reference (Spring AOP proxy) is an instance of the given type
	* target - limits matching to join points (the execution of methods when using Spring AOP) where the target object (application object being proxied) is an instance of the given type
	* args - limits matching to join points (the execution of methods when using Spring AOP) where the arguments are instances of the given types
	* @target - limits matching to join points (the execution of methods when using Spring AOP) where the class of the executing object has an annotation of the given type
	* @args - limits matching to join points (the execution of methods when using Spring AOP) where the runtime type of the actual arguments passed have annotations of the given type(s)
	* @within - limits matching to join points within types that have the given annotation (the execution of methods declared in types with the given annotation when using Spring AOP)
	* @annotation - limits matching to join points where the subject of the join point (method being executed in Spring AOP) has the given annotation

5. Combining pointcut expressions  
 pointcuts 可见性与private，protected，public有关，和Java类相似。
	

		@Pointcut("execution(public * *(..))")
		private void anyPublicOperation() {}
		
		@Pointcut("within(com.xyz.someapp.trading..*)")
		private void inTrading() {}
		
		@Pointcut("anyPublicOperation() && inTrading()")
		private void tradingOperation() {}
6. Sharing common pointcut definitions

		@Aspect
		public class SystemArchitecture {
		  
		    @Pointcut("within(com.xyz.someapp.web..*)")
		    public void inWebLayer() {}
		
		    @Pointcut("within(com.xyz.someapp.service..*)")
		    public void inServiceLayer() {}
		
		    @Pointcut("within(com.xyz.someapp.dao..*)")
		    public void inDataAccessLayer() {}
		
		    @Pointcut("execution(* com.xyz.someapp..service.*.*(..))")
		    public void businessService() {}
		
		    @Pointcut("execution(* com.xyz.someapp.dao.*.*(..))")
		    public void dataAccessOperation() {}
		
		}

7. Declaring advice
 * Before advice
 
			@Aspect
			public class BeforeExample {
			
			    @Before("com.xyz.myapp.SystemArchitecture.dataAccessOperation()")
			    public void doAccessCheck() {
			        // ...
			    }
			
			}
 * After returning advice
 
			@Aspect
			public class AfterReturningExample {
			
			    @AfterReturning("com.xyz.myapp.SystemArchitecture.dataAccessOperation()")
			    public void doAccessCheck() {
			        // ...
			    }
			
			}

			//获取返回值
			@Aspect
			public class AfterReturningExample {
			
			    @AfterReturning(
			        pointcut="com.xyz.myapp.SystemArchitecture.dataAccessOperation()",
			        returning="retVal")
			    public void doAccessCheck(Object retVal) {
			        // ...
			    }
			
			}

 * After throwing advice

			@Aspect
			public class AfterThrowingExample {
			
			    @AfterThrowing("com.xyz.myapp.SystemArchitecture.dataAccessOperation()")
			    public void doRecoveryActions() {
			        // ...
			    }
			
			}

 * After (finally) advice

			@Aspect
			public class AfterFinallyExample {
			
			    @After("com.xyz.myapp.SystemArchitecture.dataAccessOperation()")
			    public void doReleaseLock() {
			        // ...
			    }
			
			}

* Around advice

		@Aspect
		public class AroundExample {
		
		    @Around("com.xyz.myapp.SystemArchitecture.businessService()")
		    public Object doBasicProfiling(ProceedingJoinPoint pjp) throws Throwable {
		        // start stopwatch
		        Object retVal = pjp.proceed();
		        // stop stopwatch
		        return retVal;
		    }
		
		}
