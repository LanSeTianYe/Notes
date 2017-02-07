2016/12/17 18:05:50 
## 通过input双向绑定数据

    <div>
        <input id="startDate" type="text" onchange="" ng-model="currClickLineData.startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
    </div>

## 绑定input，通过watch监测不到input数据变化问题解决
 
选中日期之后触发 `onpicked` 事件，把 `input` 的值赋给另外一个标签，然后触发另外一个标签的点击事件。另外一个标签的点击事件绑定 angular 的方法。在方法中通过 jquery 根据标签的id获取对应的数据。

绑定数据

    <label ng-click="setViewType('month')" onclick="WdatePicker({el:'monthView',dateFmt:'yyyy-MM',maxDate:'%y-%M', onpicked:function(){$('#currDate').text($('#monthView').val());$('#currDate').click()}})">月视图</label>
    <input ng-hide="true" type="text" id="monthView" ng-model="selectMonth" ng-cloak />
另外一个标签  

    <div id="currDate" ng-click="initChart_Click()" ng-cloak>{{currSelectDate}}</div>

js获取数据  

    //input数值改变初始化图表
     $scope.initChart_Click = function(){
         $scope.currSelectDate = $("#currDate").text();
         $scope.initChart();
     }
