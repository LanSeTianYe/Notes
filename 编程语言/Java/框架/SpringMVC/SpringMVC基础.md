SpringMVC是spring的一个模块，提供Web层的解决方案，基于MVC。

![架构图](http://7xle4i.com1.z0.glb.clouddn.com/mackdown8b13632762d0f703ed7a0ff50afa513d2797c5cb.jpg)

* 前端控制器 DispatcherServlet
* 后端控制器
* 处理器映射器 HandlerMapping
* HandlerExecutionChain
* ModelAndView
* 视图解析器 ViewResolver

![](http://7xle4i.com1.z0.glb.clouddn.com/mackdownasdadasdasdnjksadlkzcxihasdansjd.jpg)

1. 用户发起request请求至控制器(Controller)
控制接收用户请求的数据，委托给模型进行处理  
2. 控制器通过模型(Model)处理数据并得到处理结果
模型通常是指业务逻辑  
3. 模型处理结果返回给控制器  
4. 控制器将模型数据在视图(View)中展示
web中模型无法将数据直接在视图上显示，需要通过控制器完成。如果在C/S应用中模型是可以将数据在视图中展示的。  
5. 控制器将视图response响应给用户通过视图展示给用户要的数据或处理结果。  


## 基于注解的开发

