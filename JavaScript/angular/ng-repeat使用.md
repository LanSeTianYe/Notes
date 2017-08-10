## 代码  

	<div ng-repeat="links in slides">
		<div ng-repeat="link in links track by $index">{{link.name}}</div>
	</div>

##  获取父级的标识(index)
原理其实也不难，在父级ng-repeat时利用ng-init写入一个变量即可，子循环是可以访问到的。

	<div ng-repeat="links in slides">
		<div ng-init="p_index=$index">
			<div ng-repeat="link in links track by $index" ng-click="leftMenuClick_Child(p_index,$index)">{{link.name}}</div>
		</div>
	</div>

