2016-5-3 22:05:58 
## 说明
只增加了一些简单的代码片段，主要是方便自己以后参考。详细内容可参考[XiaoTian](https://git.oschina.net/sunfeilong1993/XiaoTian.git)项目

## 需要引入的文件

	<script type="text/javascript" src="../plugins/angular-1.4.8/angular.js"></script>
    <script type="text/javascript" src="../plugins/angular-1.4.8/angular-ui-router.js"></script>

## html 文件内容

第一层

	<div class="bottom_container">
        <div class="bottom_left">
            <li>
                <a ui-sref="system_manage.user">系统管理</a>
            </li>
        </div>
        <div class="cut_off_rule"></div>
        <div class="bottom_right">
            <div ui-view class="h_w_100"></div>
        </div>
    </div>
第二层

	<div class="bottom_left_container" ng-conroller="system_controller">
	    <div class="bottom_left_container_top">
	        <li>
	            <a ui-sref="system_manage.user">用户管理</a>
	            <a ui-sref="system_manage.person">人员管理</a>
	        </li>
	    </div>
	
	    <div ui-view></div>
	</div>

## js 文件

	(function(angular) {
	    'use strict'
	
	    angular.module('index_module', [
	        'ui.router',
	        'toaster',
	        'system_module',
	        'system_user_module',
	        'system_person_module',
	    ])
	    .controller('index_controller', function ($scope) {
	        $scope.name = "hello";
	    })
	    .config(['$stateProvider', '$urlRouterProvider', function ( $stateProvider, $urlRouterProvider ) {
	
	        /* 使用when来对一些不合法的路由进行重定向 */
	        //$urlRouterProvider.when('', '/main');
	
	        /* 通过$stateProvider的state()函数来进行路由定义 */
	        $stateProvider
	            .state('/',
	            {
	                url: '/',
	                templateUrl: 'view/index.html'
	            })
	            .state('system_manage',
	            {
	                url: '/system_manage',
	                templateUrl: 'view/system_manage/system.html'
	            })
	            .state('system_manage.user',
	            {
	                url: '/user',
	                templateUrl: 'view/system_manage/system_user.html'
	            })
	            .state('system_manage.person',
	            {
	                url: '/person',
	                templateUrl: 'view/system_manage/system_person.html'
	            });
	    }]);
	})(window.angular);


## 存在的问题以及解决方案

1. `ui-route` 的 `templateUrl` 里面的 `html` 缓存问题

**问题描述：** 

`templateUrl` 里引用的 `html` 会被缓存，导致修改对应的 `html` 文件之后，刷新页面，修改的内容不会被应用的页面上，给开发时的调试带来了很大的麻烦。

** 解决办法 **  
监听 `$stateChangeSuccess` 事件，当模板删除缓存。


	 angular.module('MyAPP', [])
		.run(['$rootScope','$templateCache', function ($rootScope, $templateCache) {
	        //监听页面跳转时间,删除ui-route 的模板缓存
	        var stateChangeSuccess = $rootScope.$on('$stateChangeSuccess', stateChangeSuccess);
	        function stateChangeSuccess($rootScope) {
	            $templateCache.removeAll();
	        }
	    }]);



