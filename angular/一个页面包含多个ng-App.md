## angular的三种启动方式

1.  Angular会自动的找到ng-app，将它作为启动点，自动启动
  * html


			<!DOCTYPE html>
			<html ng-app="myModule">
			
			<head>
			    <title>New Page</title>
			    <meta charset="utf-8" />
			    <script type="text/javascript" src="../../vendor/bower_components/angular/angular.min.js"></script>
			    <script type="text/javascript" src="./02.boot1.js"></script>
			</head>
			
			<body>
			    <div ng-controller="MyCtrl">
			        <span></span>
			    </div>
			</body>
			</html>

  * js

			var myModule = angular.module("myModule", []);
			myModule.controller('MyCtrl', ['$scope',
			    function($scope) {
			        $scope.Name = "Puppet";
			    }
			]);

2. 手动启动
    > 在没有ng-app的情况下，只需要在js中添加一段注册代码即可

			<body>
			    <div ng-controller="MyCtrl">
			        <span></span>
			    </div>
			</body>

   * js

			var myModule = angular.module("myModule", []);
			myModule.controller('MyCtrl', ['$scope',
			    function($scope) {
			        $scope.Name = "Puppet";
			    }
			]);
			
			/**
			 * 这里要用ready函数等待文档初始化完成
			 */
			angular.element(document).ready(function() {
			    angular.bootstrap(document, ['myModule']);
			});

3. 启动多个  
> ng中，angular的ng-app是无法嵌套使用的，在不嵌套的情况下有多个ng-app，他默认只会启动第一个ng-app，第二个第三个需要手动启动(注意，不要手动启动第一个，虽然可以运行，但会抛异常)

  * html

		<!DOCTYPE html>
		<html>
			<head>
				<meta charset="utf-8">
				
				<script type="text/javascript" src="../InitAngular/js/angular-1.4.3/angular.js" " ></script>
				<script type="text/javascript" src="../InitAngular/js/init.js" ></script>
				
				<title></title>
			</head>
			<body>
				<div ng-app="firstApp" ng-controller="FirstController">
					{{number}}
				</div>
				
				<div id="secondAppId" ng-app="secondApp" ng-controller="FirstController">
					{{number}}
				</div>
				
			</body>
		</html>
  * js
  
		//第一个模块
		var firstModule = angular.module("firstApp",[]);
		
		firstModule.controller('FirstController',function($scope){
			$scope.number = 1;
		});
		
		
		//第二个模块
		var secondModule = angular.module("secondModule", []);
		secondModule.controller('FirstController',function($scope) {
		        $scope.number = "2";
		});
		angular.element(document).ready(function() {
		    angular.bootstrap(secondAppId, ['secondModule']);
		});