日期：2016/2/19 10:35:32 

#### Angular日期格式化：
1. 在html页面中：

        {{myDate | date:'medium'}}
        <h1 ng-bind="myDate | date:'yyyy-MM-dd HH:mm:ss'"></h1>
        <h1 ng-model="myDate | date:'yyyy-MM-dd HH:mm:ss.sss'"></h1>

2. 在Js代码中：

        var myJsDate=$filter('date')($scope.myDate,'yyyy-MM-dd');

