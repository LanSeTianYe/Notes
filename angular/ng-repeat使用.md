##　代码

	<div ng-repeat="links in slides">
		<div ng-repeat="link in links track by $index">{{link.name}}</div>
	</div>