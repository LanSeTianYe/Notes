##  
时间：2017/9/1 21:45:09     
参考： 

* Spring 技术内幕 [计文柯]
* Spring源码版本3.1.1

##  SpringAop源码解析

### 核心概念  
1. Advice（通知）：在切点做什么。  
2. PointCut（切点）：决定通知作用在什么地方。
3. Advistor（通知器）：结合Advice和PointCut。  
### 带着问题看源码  
1. Aop怎么实现，怎么产生代理对象？  

    SpringAop 是基于Java动态代理和Cglib实现的。代理类都实现了 `AopProxy` 接口，有两种实现： `JdkDynamicAopProxy.java` 和 `Cglib2AopProxy` 。
    
    JdkDynamicAopProxy 实现 	InvocationHandler 接口

		public Object getProxy(ClassLoader classLoader) {
			if (logger.isDebugEnabled()) {
				logger.debug("Creating JDK dynamic proxy: target source is " + this.advised.getTargetSource());
			}
			Class[] proxiedInterfaces = AopProxyUtils.completeProxiedInterfaces(this.advised);
			findDefinedEqualsAndHashCodeMethods(proxiedInterfaces);
			// 产生代理对象
			return Proxy.newProxyInstance(classLoader, proxiedInterfaces, this);
		}


	Cglib2AopProxy 基于Cglib机制：


		public Object getProxy(ClassLoader classLoader) {
				... ...
				Class rootClass = this.advised.getTargetClass();
				Assert.state(rootClass != null, "Target class must be available for creating a CGLIB proxy");
	
				Class proxySuperClass = rootClass;
				if (ClassUtils.isCglibProxyClass(rootClass)) {
					proxySuperClass = rootClass.getSuperclass();
					Class[] additionalInterfaces = rootClass.getInterfaces();
					for (Class additionalInterface : additionalInterfaces) {
						this.advised.addInterface(additionalInterface);
					}
				}
	
				// Validate the class, writing log messages as necessary.
				validateClassIfNecessary(proxySuperClass);
	
				// Configure CGLIB Enhancer...
				Enhancer enhancer = createEnhancer();
				if (classLoader != null) {
					enhancer.setClassLoader(classLoader);
					if (classLoader instanceof SmartClassLoader &&
							((SmartClassLoader) classLoader).isClassReloadable(proxySuperClass)) {
						enhancer.setUseCache(false);
					}
				}
				enhancer.setSuperclass(proxySuperClass);
				enhancer.setStrategy(new UndeclaredThrowableStrategy(UndeclaredThrowableException.class));
				enhancer.setInterfaces(AopProxyUtils.completeProxiedInterfaces(this.advised));
				enhancer.setInterceptDuringConstruction(false);
	
				Callback[] callbacks = getCallbacks(rootClass);
				enhancer.setCallbacks(callbacks);
				enhancer.setCallbackFilter(new ProxyCallbackFilter(
						this.advised.getConfigurationOnlyCopy(), this.fixedInterceptorMap, this.fixedInterceptorOffset));
	
				Class[] types = new Class[callbacks.length];
				for (int x = 0; x < types.length; x++) {
					types[x] = callbacks[x].getClass();
				}
				enhancer.setCallbackTypes(types);
	
				// Generate the proxy class and create a proxy instance.
				Object proxy;
				if (this.constructorArgs != null) {
					proxy = enhancer.create(this.constructorArgTypes, this.constructorArgs);
				}
				else {
					proxy = enhancer.create();
				}
	
				return proxy;
		... ...
		}
	   
2. Advice（通知）怎么应用到切入点？ 

    以 `ProxyFactory` 为例，Aop构建代码如下：

		ProxyFactory proxyFactory = new ProxyFactory();
        SumCalculate sumCalculateProxyFactory = new SumCalculate();

		//设置代理目标，切入点
        proxyFactory.setTarget(sumCalculateProxyFactory);
        Class<?>[] interfaces = sumCalculateProxyFactory.getClass().getInterfaces();
		//设置代理接口
        proxyFactory.setInterfaces(interfaces);

		//增加通知
        proxyFactory.addAdvice(new BeforeAdvice());
        proxyFactory.addAdvice(new AfterAdvice());

		//创建代理对象
        Calculate calculateProxy = (Calculate) proxyFactory.getProxy();
		//调用方法的时候，会在合适的地方执行 Advice（通知）
        calculateProxy.calculate();

    首先 `proxyFactory.addAdvice(new AfterAdvice())` 的时候会添加相应的 `Advisor`.

	代码1：    

		public void addAdvice(Advice advice) throws AopConfigException {
			int pos = this.advisors.size();
			//进入代码2
			addAdvice(pos, advice);
		}

    代码2：   
	
		public void addAdvice(int pos, Advice advice) throws AopConfigException {
			Assert.notNull(advice, "Advice must not be null");
			if (advice instanceof IntroductionInfo) {
				// We don't need an IntroductionAdvisor for this kind of introduction:
				// It's fully self-describing.
				addAdvisor(pos, new DefaultIntroductionAdvisor(advice, (IntroductionInfo) advice));
			}
			else if (advice instanceof DynamicIntroductionAdvice) {
				// We need an IntroductionAdvisor for this kind of introduction.
				throw new AopConfigException("DynamicIntroductionAdvice may only be added as part of IntroductionAdvisor");
			}
			else {
				//一般情况下，会执行这里，进入代码3
				addAdvisor(pos, new DefaultPointcutAdvisor(advice));
			}
		}

    代码3：  `DefaultPointcutAdvisor` 

		public DefaultPointcutAdvisor(Advice advice) {
			// Pointcut.TRUE 参考代码4
			this(Pointcut.TRUE, advice);
		}

    代码4： 

		class TruePointcut implements Pointcut, Serializable {
			
			public static final TruePointcut INSTANCE = new TruePointcut();
		
			private TruePointcut() {}
		
			public ClassFilter getClassFilter() {
				return ClassFilter.TRUE;
			}
		
			public MethodMatcher getMethodMatcher() {
				return MethodMatcher.TRUE;
			}
			
			private Object readResolve() {
				return INSTANCE;
			}
		}

	到这里为止，可以看到所有的ClassFilter和MethodMatcher都会返回True。下面分析代理怎么执行以及执行过程。

	代码5：在 `JdkDynamicAopProxy.invoke()` 里面
		
		//获取调用方法的拦截器链 ，具体实现参考代码6 
		List<Object> chain = this.advised.getInterceptorsAndDynamicInterceptionAdvice(method, targetClass);

    代码6：  

		public List<Object> getInterceptorsAndDynamicInterceptionAdvice(Method method, Class targetClass) {
			//缓存
			MethodCacheKey cacheKey = new MethodCacheKey(method);
			List<Object> cached = this.methodCache.get(cacheKey);
			if (cached == null) {
				//进入代码7 
				cached = this.advisorChainFactory.getInterceptorsAndDynamicInterceptionAdvice(
						this, method, targetClass);
				this.methodCache.put(cacheKey, cached);
			}
			return cached;
		}

    代码7：  

		public List<Object> getInterceptorsAndDynamicInterceptionAdvice(
				Advised config, Method method, Class targetClass) {
	
			// This is somewhat tricky... we have to process introductions first,
			// but we need to preserve order in the ultimate list.
			List<Object> interceptorList = new ArrayList<Object>(config.getAdvisors().length);
			boolean hasIntroductions = hasMatchingIntroductions(config, targetClass);
			//适配器，用于把MethodAdvice转换成MethodInterceptor
			AdvisorAdapterRegistry registry = GlobalAdvisorAdapterRegistry.getInstance();
			for (Advisor advisor : config.getAdvisors()) {
				if (advisor instanceof PointcutAdvisor) {
					// Add it conditionally.
					PointcutAdvisor pointcutAdvisor = (PointcutAdvisor) advisor;
					//类匹配
					if (config.isPreFiltered() || pointcutAdvisor.getPointcut().getClassFilter().matches(targetClass)) {
						MethodInterceptor[] interceptors = registry.getInterceptors(advisor);
						MethodMatcher mm = pointcutAdvisor.getPointcut().getMethodMatcher();
						//方法匹配  
						if (MethodMatchers.matches(mm, method, targetClass, hasIntroductions)) {
							if (mm.isRuntime()) {
								// Creating a new object instance in the getInterceptors() method
								// isn't a problem as we normally cache created chains.
								for (MethodInterceptor interceptor : interceptors) {
									interceptorList.add(new InterceptorAndDynamicMethodMatcher(interceptor, mm));
								}
							}
							else {
								interceptorList.addAll(Arrays.asList(interceptors));
							}
						}
					}
				}
				else if (advisor instanceof IntroductionAdvisor) {
					IntroductionAdvisor ia = (IntroductionAdvisor) advisor;
					if (config.isPreFiltered() || ia.getClassFilter().matches(targetClass)) {
						Interceptor[] interceptors = registry.getInterceptors(advisor);
						interceptorList.addAll(Arrays.asList(interceptors));
					}
				}
				else {
					Interceptor[] interceptors = registry.getInterceptors(advisor);
					interceptorList.addAll(Arrays.asList(interceptors));
				}
			}
			return interceptorList;
		}
			
	到这为止调用链（方法被调用时需要执行的增强处理）已经创建好了，怎么确定确定调用链的执行顺序？  

	原理大概是这样的（递归实现）：  

		public class BeforeAndAfter {
		
		    private static List<Invoke> invokeList = new ArrayList();
		    private static int currIndex = 0;
		
		    static {
		        Random random = new SecureRandom();
		        int nextInt = random.nextInt(10);
		        for (int i = 0; i < 10; i++) {
		            if(nextInt > 5) {
		                invokeList.add(new Before());
		            } else {
		                invokeList.add(new After());
		            }
		            nextInt = random.nextInt();
		        }
		    }
		
		    public void process() {
		        if(currIndex == invokeList.size()) {
		            invoke();
		        } else {
		            invokeList.get(currIndex ++).invoke(this);
		        }
		    }
		
		    public void invoke() {
		        System.out.println(this.getClass().getSimpleName());
		    };
		    public static void main(String[] args) {
		        BeforeAndAfter beforeAndAfter = new BeforeAndAfter();
		        beforeAndAfter.process();
		    }
		}
		
		interface Invoke {
		    public void invoke(BeforeAndAfter beforeAndAfter);
		}
		
		class Before implements Invoke {
		    public void invoke(BeforeAndAfter beforeAndAfter) {
		        System.out.println(this.getClass().getSimpleName());
		        beforeAndAfter.process();
		    }
		}
		
		class After implements Invoke {
		    public void invoke(BeforeAndAfter beforeAndAfter) {
		        beforeAndAfter.process();
		        System.out.println(this.getClass().getSimpleName());
		    }
		}

	具体代码： 还是在 `invoke()` 方法里面

    代码8：

		if (chain.isEmpty()) {
				// We can skip creating a MethodInvocation: just invoke the target directly
				// Note that the final invoker must be an InvokerInterceptor so we know it does
				// nothing but a reflective operation on the target, and no hot swapping or fancy proxying.
				retVal = AopUtils.invokeJoinpointUsingReflection(target, method, args);
			}
			else {
				// We need to create a method invocation...
				invocation = new ReflectiveMethodInvocation(proxy, target, method, args, targetClass, chain);
				// Proceed to the joinpoint through the interceptor chain.
				// 进入代码9
				retVal = invocation.proceed();
			}

	代码9：  


		public Object proceed() throws Throwable {
			//	We start with an index of -1 and increment early.
			if (this.currentInterceptorIndex == this.interceptorsAndDynamicMethodMatchers.size() - 1) {
				return invokeJoinpoint();
			}
	
			Object interceptorOrInterceptionAdvice =
			    this.interceptorsAndDynamicMethodMatchers.get(++this.currentInterceptorIndex);
			if (interceptorOrInterceptionAdvice instanceof InterceptorAndDynamicMethodMatcher) {
				// Evaluate dynamic method matcher here: static part will already have
				// been evaluated and found to match.
				InterceptorAndDynamicMethodMatcher dm =
				    (InterceptorAndDynamicMethodMatcher) interceptorOrInterceptionAdvice;
				if (dm.methodMatcher.matches(this.method, this.targetClass, this.arguments)) {
					// 根据不同类型的 invocation 确定调用顺序，比如代码10和代码11，执行顺序如
					// beforeA, beforeB ...
					// invokeJoinpoint()
					// afterA, afterB ...
					return dm.interceptor.invoke(this);
				}
				else {
					// Dynamic matching failed.
					// Skip this interceptor and invoke the next in the chain.
					return proceed();
				}
			}
			else {
				// It's an interceptor, so we just invoke it: The pointcut will have
				// been evaluated statically before this object was constructed.
				return ((MethodInterceptor) interceptorOrInterceptionAdvice).invoke(this);
			}
		}

	代码10：  

		public class AfterReturningAdviceInterceptor implements MethodInterceptor, AfterAdvice, Serializable {
	
			private final AfterReturningAdvice advice;
		
		
			/**
			 * Create a new AfterReturningAdviceInterceptor for the given advice.
			 * @param advice the AfterReturningAdvice to wrap
			 */
			public AfterReturningAdviceInterceptor(AfterReturningAdvice advice) {
				Assert.notNull(advice, "Advice must not be null");
				this.advice = advice;
			}
		
			public Object invoke(MethodInvocation mi) throws Throwable {
				Object retVal = mi.proceed();
				this.advice.afterReturning(retVal, mi.getMethod(), mi.getArguments(), mi.getThis());
				return retVal;
			}
		
		}

	代码11：  

		public class MethodBeforeAdviceInterceptor implements MethodInterceptor, Serializable {
		
			private MethodBeforeAdvice advice;
		
		
			/**
			 * Create a new MethodBeforeAdviceInterceptor for the given advice.
			 * @param advice the MethodBeforeAdvice to wrap
			 */
			public MethodBeforeAdviceInterceptor(MethodBeforeAdvice advice) {
				Assert.notNull(advice, "Advice must not be null");
				this.advice = advice;
			}
		
			public Object invoke(MethodInvocation mi) throws Throwable {
				this.advice.before(mi.getMethod(), mi.getArguments(), mi.getThis() );
				return mi.proceed();
			}
		
		}

		


	



 


