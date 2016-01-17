##### 问题描述
在Js代码里面刷新数据，视图的数据不能刷新或者不能立即刷新。


#### 解决办法
在 js 中调用数据的时候，执行$apply();


	$scope.$apply(function() {
		//数据改变
		$scope.data =  newdata;
	});