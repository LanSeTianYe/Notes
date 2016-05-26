### 信息
	时间：            2015/12/30
	SpringMVC 版本:   Spring-MVC 1.1.3
	Js:				  jQuery\angular
### 说明
所有的用法都经过实际测试

### 总结
> 感觉使用 `ajax` 的方法会比较方便，不论是 `get` 还是 `post` 方法后台的接收方法基本一样。  
使用Angular的 `$http` 后台的接收方法参数的注解方式可能不同。最大的问题在于使用post传递普通的参数和对象+普通参数，实现比较困难，虽然网上也有实现的方法，但是需要额外的配置，没有 `Ajax` 用起来那么简单。


## angular篇
$http的配置项：

	method   方法(Get Post ...)
	url      路径
	params   GET请求的参数
	data     post请求的参数
	headers  请求头
	transformRequest   请求预处理函数
	transformResponse  响应预处理函数
	cache              缓存
	timeout            超时毫秒，超时的请求会被取消
	withCredentials    跨域安全策略的一个东西 

1. 传递普通的参数---GET  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
			idList:['1','2','3']
		};
		//angular_get_普通参数
		$http({
			  method: 'GET',
			  url: rootPath+"/transmissionParam/receiveStringAndInteger.do",
			  params:param,
		}).then(function (data) {
			$scope.content = data.data;
		});
后台代码：

		@RequestMapping("/transmissionParam/receiveStringAndInteger")
		@ResponseBody
		public ReturnMessage receiveStringAndInteger(String name,
									Integer age, String[] idList) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData("name"+name+"age:"+age);
			return retMsg;
		}
注意：后台接收的时候`String[] idList` 改为 `Long[] idList`也是可以的

2. 传递普通参数---POST（没能实现）  
js

		var data = {
	        id:'3213',
	        oldPassword:'oldPassword',
	        newPassword:'newPassword',
	    }
	    $http({
	        method: 'POST',
	        url: '/authorityUser/changePassword',
	        data: $.param(data),
	        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
	    }).success(function(sysMsg){
	
	    });
java
	
		@RequestMapping(value = "/authorityUser/changePassword", method = RequestMethod.POST)
	    @ResponseBody
	    public SystemMessage changePassword(String id, String oldPassword, String newPassword) {

3. 传递对象------Get  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
		};
		$http({
			  method: 'GET',
			  url: rootPath+"/transmissionParam/receiveGetObject.do",
			  params:param,
		}).then(function (data) {
			$scope.content = data.data;
		});
后台接收：

		@RequestMapping(value = "/transmissionParam/receiveGetObject", method=RequestMethod.GET)
		@ResponseBody
		public ReturnMessage receiveGetObject(User user) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}
4. 传递对象------Post  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
		};
		$http({
			  method: 'POST',
			  url: rootPath+"/transmissionParam/receivePostObject.do",
			  data:param,
		}).then(function (data) {
			$scope.content = data.data;
		});
后台接收:

		@RequestMapping(value = "/transmissionParam/receivePostObject", method=RequestMethod.POST)
		@ResponseBody
		public ReturnMessage receivePostObject(@RequestBody User user) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}

5. 传递对象和普通参数----GET  
js:  

		var param = {
			name:"lognlongxiao",
			age:"22",
			info:"info"
		};
		$http({
			  method: 'GET',
			  url: rootPath+"/transmissionParam/receiveGetObjectAndOtherParam.do",
			  params:param,
		}).then(function (data) {
			$scope.content = data.data;
		});
后台接收:

		@RequestMapping(value = "/transmissionParam/receiveGetObjectAndOtherParam", method=RequestMethod.GET)
		@ResponseBody
		public ReturnMessage receiveGetObjectAndOtherParam(User user, String info) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}

6. 传递对象和普通参数----POST（没能实现）
## jQuery篇
******************************
配置项：  

* `url`  String	(默认: 当前页地址) 发送请求的地址。  
* `type`  String	(默认: "GET") 请求方式 ("POST" 或 "GET")， 默认为 "GET"。注意：其它 HTTP 请求方法，如 PUT 和 DELETE 也可以使用，但仅部分浏览器支持。
* `timeout`	Number	设置请求超时时间（毫秒）。此设置将覆盖全局设置。
* `async`	Boolean	(默认: true) 默认设置下，所有请求均为异步请求。如果需要发送同步请求，请将此选项设置为 false。注意，同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行。  
* `beforeSend`	Function	发送请求前可修改 XMLHttpRequest 对象的函数，如添加自定义 HTTP 头。XMLHttpRequest 对象是唯一的参数。  

		function (XMLHttpRequest) {
			this; // the options for this ajax request
		}
* `cache`	Boolean	(默认: true) jQuery 1.2 新功能，设置为 false 将不会从浏览器缓存中加载请求信息。
* `complete`	Function	请求完成后回调函数 (请求成功或失败时均调用)。参数： XMLHttpRequest 对象，成功信息字符串。

		function (XMLHttpRequest, textStatus) {  
			this; // the options for this ajax request
		}
* `contentType`	String	(默认: "application/x-www-form-urlencoded") 发送信息至服务器时内容编码类型。默认值适合大多数应用场合。
* `data`	Object,String	发送到服务器的数据。将自动转换为请求字符串格式。GET 请求中将附加在 URL 后。查看 processData 选项说明以禁止此自动转换。必须为 Key/Value 格式。如果为数组，jQuery 将自动为不同值对应同一个名称。如 {foo:["bar1", "bar2"]} 转换为 '&foo[]=bar1&foo[]=bar2'。
* `dataType` String  预期服务器返回的数据类型。如果不指定，jQuery 将自动根据 HTTP 包 MIME 信息返回 responseXML 或 responseText，并作为回调函数参数传递，可用值:
 * `xml`: 返回 XML 文档，可用 jQuery 处理。
 * `html`: 返回纯文本 HTML 信息；包含 script 元素。
 * `script`: 返回纯文本 JavaScript 代码。不会自动缓存结果。
 * `json`: 返回 JSON 数据 。
 * `jsonp`: JSONP 格式。使用 JSONP 形式调用函数时，如 "myurl?callback=?" jQuery 将自动替换 ? 为正确的函数名，以执行回调函数。
* `error`	Function	(默认: 自动判断 (xml 或 html)) 请求失败时将调用此方法。这个方法有三个参数：XMLHttpRequest 对象，错误信息，（可能）捕获的错误对象。

		function (XMLHttpRequest, textStatus, errorThrown) {  
			// 通常情况下textStatus和errorThown只有其中一个有值
			this; 
			// the options for this ajax request
		}
* `global`	Boolean	(默认: true) 是否触发全局 AJAX 事件。设置为 false 将不会触发全局 AJAX 事件，如 ajaxStart 或 ajaxStop 。可用于控制不同的Ajax事件
* `ifModified`	Boolean	(默认: false) 仅在服务器数据改变时获取新数据。使用 HTTP 包 Last-Modified 头信息判断。
* `processData`	Boolean	(默认: true) 默认情况下，发送的数据将被转换为对象(技术上讲并非字符串) 以配合默认内容类型 "application/x-www-form-urlencoded"。如果要发送 DOM 树信息或其它不希望转换的信息，请设置为 false。
* `success`	Function	请求成功后回调函数。这个方法有两个参数：服务器返回数据，返回状态
	
		function (data, textStatus) { 
			// data could be xmlDoc, jsonObj, html, text, etc...  this;
			// the options for this ajax request
		}
*************************
1. 传递普通参数----GET  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
			idList:['1','2','3']
		};
		jQuery.ajax({
			type:"GET",
	        url : rootPath+"/transmissionParam/receiveGetStringAndIntegerAndStringArr.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        }
	   });  
后台代码:

		@RequestMapping("/transmissionParam/receiveGetStringAndIntegerAndStringArr")
		@ResponseBody
		public ReturnMessage receiveGetStringAndIntegerAndStringArr(String name, Integer age, @RequestParam(value="idList[]") String[] idList) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData("name"+name+"age:"+age+"StringArr"+idList.toString());
			return retMsg;
		}
注意：和$http不同的是，数组的名字在拼接参数的时候会变成 `idlIts[]` ,因此，在后台接收的时候需要指定参数的名字为 `idList[]`

2. 传递普通参数----POST  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
			idList:['1','2','3']
		};
		jQuery.ajax({
			type:"POST",
	        url : rootPath+"/transmissionParam/receivePostStringAndIntegerAndLongArr.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        }
	   });  
后台接收代码:

		@RequestMapping(value = "/transmissionParam/receivePostStringAndIntegerAndLongArr", 
							method=RequestMethod.POST)
		@ResponseBody
		public ReturnMessage receivePostStringAndIntegerAndLongArr
				(String name, Integer age, @RequestParam(value="idList[]") Long[] idList) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData("name"+name+"age:"+age+"LongArr"+idList.toString());
			return retMsg;
		}

3. 传递对象-----GET  
js:

		var param = {
			name:"lognlongxiao",
			age:"22",
		};
		jQuery.ajax({
			type:"GET",
	        url : rootPath+"/transmissionParam/receiveGetObject.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        }
	   	});  
后台代码:  

		@RequestMapping(value = "/transmissionParam/receiveGetObject", method=RequestMethod.GET)
		@ResponseBody
		public ReturnMessage receiveGetObject(User user) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}


4. 传递对象-----POST  
js:  

		var param = {
			name:"lognlongxiao",
			age:"22",
		};
		jQuery.ajax({
			type: "POST",
	        url : rootPath+"/transmissionParam/receivePostObject.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        	alert("s");
	        }
	   	});
后台接收代码:

		@RequestMapping(value = "/transmissionParam/receivePostObject", method=RequestMethod.POST)
		@ResponseBody
		public ReturnMessage receivePostObject( User user) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}
5. 传递对象和普通参数----GET  
js：

		var param = {
			name:"lognlongxiao",
			age:"22",
			info:"info",
		};
		jQuery.ajax({
			type: "GET",
	        url : rootPath+"/transmissionParam/receiveGetObjectAndOtherParam.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        	alert("s");
	        }
	   });  
后台接收:

		@RequestMapping(value = "/transmissionParam/receiveGetObjectAndOtherParam", method=RequestMethod.GET)
		@ResponseBody
		public ReturnMessage receiveGetObjectAndOtherParam(User user, String info) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}

6. 传递对象和普通参数----POST  
js: 

		var param = {
			name:"lognlongxiao",
			age:"22",
			info:"info",
		};
		jQuery.ajax({
			type: "POST",
	        url : rootPath+"/transmissionParam/receivePostObjectAndOtherParam.do",
	        data : param,
	        dataType:'json',
	        success : function(data) {
	        	$scope.content = data.data;
	        }
	   	});
后台代码:

		@RequestMapping(value = "/transmissionParam/receivePostObjectAndOtherParam", method=RequestMethod.POST)
		@ResponseBody
		public ReturnMessage receivePostObjectAndOtherParam(User user, String info) {
			ReturnMessage retMsg = new ReturnMessage();
			retMsg.setSuccess(true);
			retMsg.setData(JSON.toJSON(user).toString());
			return retMsg;
		}

