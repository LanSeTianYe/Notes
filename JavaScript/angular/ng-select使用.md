#### 用法一

	<select ng-model="Select1" ng-options="m.ProductName for m in Model">
		<option value="">-- 请选择 --</option>
	</select>
这种情况下
> option 标签的 value 是 m  
> 下拉框的文本是 m.ProductName

#### 用法二

	<select ng-model="Select2" ng-options="(m.ProductName + m.Price) for m in Model">
		<option value="">-- 请选择 --</option>
	</select>
这种情况下
> option 标签的 value 是 m   
> 下拉框的文本是 m.ProductName + m.Price

#### 用法三 (分组)

	<select ng-model="Select3" ng-options="(m.ProductColor + m.ProductName) group by m.MainCategory for m in Model">
		<option value="">-- 请选择 --</option>
	</select>

这种情况下
> option 标签的 value 是 m  
> 下拉框的文本是  m.ProductColor + m.ProductName    
> 会根据 m.MainCategory 进行分组

#### 用法四（自定义 ng-model 部分）
	
	<select ng-model="Select4" ng-options="m.id as m.ProductName for m in Model">
		<option value="">-- 请选择 --</option>
	</select>

这种情况下
> option 标签的 value 是 m
> 下拉框的文本是 m.ProductName  
> 会把 m.id 绑定到 Select4上