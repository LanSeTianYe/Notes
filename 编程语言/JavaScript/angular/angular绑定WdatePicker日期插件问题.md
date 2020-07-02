日期：2016/2/19 10:19:34 


### 解决在input上面添加 `ng-model` 不能绑定 `WdatePicker` 日期选择框选择的日期的问题

原代码:

    <input id="estimateTime" type="text" ng-model="currClickLineData.estimateTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'createTime\')}'})"  />

解决方案：在input标签里面添加 `onchange=""`

    <input id="estimateTime" type="text" onchange="" ng-model="currClickLineData.estimateTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'createTime\')}'})"  />