##
日期 : 2016-5-16 22:27:41  
参考地址：   
[AngularJS 之 Factory vs Service vs Provider](http://www.oschina.net/translate/angularjs-factory-vs-service-vs-provider)

[AngularJS: Factory vs Service vs Provider](http://tylermcginnis.com/angularjs-factory-vs-service-vs-provider/)
 
## 说明
由于Factory和Service提供的功能完全相同，这里只记录Factory的使用(个人感觉这种Factory相对于Service的代码看起来更好理解)，以及Provider的使用.
## 说明及使用

### Factory
`Factory` 和 `Service`，相当于一个通用的方法集，你可以在其他模块引用该方法集，然后注入到 `Controler` 里面，就可以直接在 `Controller` 里面使用方法集里面的方法。
下面是定义 `Factory` 的代码

	angular.module('kendogrid.validation',[])
        .factory('validation', function() {

			//方法集变量,里面可以定义你想要的一切
			var validation = {
				sayHello : function() {
					console.log('Hello !');
				}
			}

			//返回方法集
			return validation;
		});

在其他的 `Controller` 里引用

	angular.module('myApp', ['kendogrid.validation'])
        .controller("MyController", function (validation) {
			//直接调用
			validation.test();
		});

`angular.module('myApp', ['kendogrid.validation'])` 引入依赖模块， `controller("MyController", function (validation)` 注入Factory, `validation.test();` 使用方法。

### Provider
`Provider` 定义的方法和 `Factory` 不同的是， 你可以在方法集执行之前，在 `config` 模块里对方法集的内容进行一些修改或配置，是这三种里唯一能够传入 `configure` 里面的。
代码如下:

定义 `provider` 

	angular.module('myProviderModule', [])
		.provider('myProvider', function() {
			
			//在configure 里面赋值
			this.text = '';
			
			this.$get = function(){
				return {
					sayHello: function() {
						console.log("Hello ");
					},
					text: this.text
				}
			}
			
		})

使用 `provider`



	angular.module('myApp',['myProviderModule'])
		.controller('myController', function($scope, myProvider) {
			myProvider.sayHello();
			console.log(myProvider.text);
		})
		.config(function(myProviderProvider){
			myProviderProvider.text = "World !";
		});
输出结果

	[Web浏览器] "Hello "	/FrontEndRepository/Learing/AngularJs/Provider/js/provider.js (10)
	[Web浏览器] "World !"	/FrontEndRepository/Learing/AngularJs/Provider/js/index.js (5)


