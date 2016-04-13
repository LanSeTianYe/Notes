日期 ：2016-4-7 22:16:48 

[参考地址](http://stackoverflow.com/questions/16098430/angular-ie-caching-issue-for-http)

#### 问题描述：
今天演示项目，在IE浏览器下面新增数据，IE页面内容不刷新，数据库里面已经有数据，开发者模式查看请求，原来Get请求只要请求的参数不变，就不会去后台取数据，而是直接在缓存中取数据。
#### 问题分析：
由于项目已经有一定的规模，修改每一个Get请求会花费大量的时间，需要找到一个通用的解决方法。
#### 解决方法：
网上找了几种方法，发现最实用的方法是拦截所有的GET请求，然后把请求的参数加上时间戳，这样就能保证每次请求都会向后台发送一个的请求，而不是直接在缓存中取数据。

代码如下：

	angular.module('MyApp')
	.config(['$httpProvider', function($httpProvider) {
		$httpProvider.interceptors.push('noCacheInterceptor');
	}])
	.factory('noCacheInterceptor', function () {
        return {
            request: function (config) {
                if(config.method=='GET'){
                    var separator = config.url.indexOf('?') === -1 ? '?' : '&';
                    config.url = config.url+separator+'noCache=' + new Date().getTime();
                }
                return config;
           }
       };
    });
