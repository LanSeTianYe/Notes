#### SpringMvc 注解使用
1. `@Controller`   
 Controller控制器是通过服务接口定义的提供访问应用程序的一种行为，它解释用户的输入，将其转换成一个模型然后将试图呈献给用户。Spring MVC 使用 @Controller 定义控制器，它还允许自动检测定义在类路径下的组件并自动注册。如想自动检测生效，需在XML头文件下引入 spring-context:  

		<context:component-scan base-package="com.sun.main.controller"/>
2. `@RequestMapping`  
我们可以 @RequestMapping 注解将类似 “/favsoft”这样的URL映射到 `整个类` 或 `特定的处理方法` 上。一般来说，类级别的注解映射特定的请求路径到表单控制器上，而方法级别的注解只是映射为一个特定的HTTP方法请求（“GET”，“POST”等）或HTTP请求参数。

		@Controller
		@RequestMapping("/favsoft")
		public class AnnotationController {
		     
		    @RequestMapping(method=RequestMethod.GET)
		    public String get(){
		        return "";
		    }
		     
		    @RequestMapping(value="/getName", method = RequestMethod.GET)
		    public String getName(String userName) {
		        return userName;
		    }
		     
		    @RequestMapping(value="/{day}", method=RequestMethod.GET)
		    public String getDay(Date day){
		        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		        return df.format(day);
		    }
		     
		    @RequestMapping(value="/addUser", method=RequestMethod.GET)
		    public String addFavUser(@Validated FavUser favUser,BindingResult result){
		        if(result.hasErrors()){
		            return "favUser";
		        }
		        //favUserService.addFavUser(favUser);
		        return "redirect:/favlist";
		    }
		 
		    @RequestMapping("/test")
		    @ResponseBody
		    public String test(){
		        return "aa";
		    }
		     
		}
 @RequestMapping 既可以作用在类级别，也可以作用在方法级别。当它定义在类级别时，标明该控制器处理所有的请求都被映射到 /favsoft 路径下。@RequestMapping中可以使用 method 属性标记其所接受的方法类型，如果不指定方法类型的话，可以使用 HTTP GET/POST 方法请求数据，但是一旦指定方法类型，就只能使用该类型获取数据。

    @RequestMapping 可以使用 @Validated与BindingResult联合验证输入的参数，在验证通过和失败的情况下，分别返回不同的视图。

    @RequestMapping支持使用URI模板访问URL。URI模板像是URL模样的字符串，由一个或多个变量名字组成，当这些变量有值的时候，它就变成了URI。
3. `@PathVariable`  
在Spring MVC中，可以使用 @PathVariable 注解方法参数并将其绑定到URI模板变量的值上。

		@RequestMapping(value="/owners/{ownerId}/pets/{petId}", 
						method=RequestMethod.GET)
		public String findPet(@PathVariable String ownerId,
							@PathVariable String petId, Model model{
		    Owner owner = ownerService.findOwner(ownerId);
		    Pet pet = owner.getPet(petId);
		    model.addAttribute("pet", pet);
			return "displayPet";
		}
@PathVariable中的参数可以是任意的简单类型，如int, long, Date等等。Spring会自动将其转换成合适的类型或者抛出 TypeMismatchException异常。当然，我们也可以注册支持额外的数据类型。  
@PathVariable支持使用正则表达式，这就决定了它的超强大属性，它能在路径模板中使用占位符，可以设定特定的前缀匹配，后缀匹配等自定义格式。 
4. `@RequestParam`  
@RequestParam将请求的参数绑定到方法中的参数上，如下面的代码所示。其实，即使不配置该参数，注解也会默认使用该参数。如果想自定义指定参数的话，需要将@RequestParam的 required 属性设置为false（如@RequestParam（value="id",required=false））。

		public String setupForm
			(@RequestParam("petId") int petId, ModelMap model) {  
		        Pet pet = this.clinic.loadPet(petId);  
		        model.addAttribute("pet", pet);  
		        return "petForm";  
		}
5. `@RequestBody`  
@RequestBody是指方法参数应该被绑定到HTTP请求Body上。  

		@RequestMapping(value = "/something", method = RequestMethod.PUT)
		public void handle(@RequestBody String body, Writer writer) 
				throws IOException {
		    writer.write(body);
		}
如果觉得@RequestBody不如@RequestParam趁手，我们可以使用 HttpMessageConverter将request的body转移到方法参数上， HttMessageConverser将 HTTP请求消息在Object对象之间互相转换，但一般情况下不会这么做。事实证明，@RequestBody在构建REST架构时，比@RequestParam有着更大的优势。
6. `@ResponseBody`  
@ResponseBody与@RequestBody类似，它的作用是将返回类型直接输入到HTTP response body中。@ResponseBody在输出JSON格式的数据时，会经常用到，代码见下图：

		@RequestMapping(value = "/something", method = RequestMethod.PUT)
		@ResponseBody
		public String helloWorld() {
			return "Hello World";
		}
7. ` @RestController`  
我们经常见到一些控制器实现了REST的API，只为服务于JSON，XML或其它自定义的类型内容，@RestController用来创建REST类型的控制器，与@Controller类型。@RestController就是这样一种类型，它避免了你重复的写@RequestMapping与@ResponseBody。

		@RestController
		public class FavRestfulController {

			@RequestMapping(value="/getUserName",method=RequestMethod.POST)
			public String getUserName(@RequestParam(value="name") String name){
				return name;
			}

		}
8. `HttpEntity`  
HttpEntity除了能获得request请求和response响应之外，它还能访问请求和响应头，如下所示：

		@RequestMapping("/something")
		public ResponseEntity<String> handle(HttpEntity<byte[]> requestEntity)
						throws UnsupportedEncodingException {

		    String requestHeader = requestEntity.getHeaders().getFirst("MyRequestHeader"));
			// do something with request header and body
			byte[] requestBody = requestEntity.getBody();    
		
		    HttpHeaders responseHeaders = new HttpHeaders();
		    responseHeaders.set("MyResponseHeader", "MyValue");
			return new ResponseEntity<String>("Hello World", responseHeaders, HttpStatus.CREATED);
		}
9. `@ModelAttribute`  
@ModelAttribute可以作用在方法或方法参数上，当它作用在方法上时，标明该方法的目的是添加一个或多个模型属性（model attributes）。该方法支持与@RequestMapping一样的参数类型，但并不能直接映射成请求。控制器中的@ModelAttribute方法会在@RequestMapping方法调用之前而调用，示例如下：

		@ModelAttribute
		public Account addAccount(@RequestParam String number) {
		    return accountManager.findAccount(number);
		}
		
		@ModelAttribute
		public void populateModel(@RequestParam String number, Model model) {
		    model.addAttribute(accountManager.findAccount(number));    
		    // add more ...
		}
@ModelAttribute方法用来在model中填充属性，如填充下拉列表、宠物类型或检索一个命令对象比如账户（用来在HTML表单上呈现数据）。  
@ModelAttribute方法有两种风格：一种是添加隐形属性并返回它。另一种是该方法接受一个模型并添加任意数量的模型属性。用户可以根据自己的需要选择对应的风格。