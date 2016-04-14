2016/4/14 16:09:25 
***
# 工具介绍
简介：   
`Grafana` 是一个简单易用的数据展示工具。展示数据的过程为，新建一个 `Dashboard`,在新建的 `Dashboard` 添加面板(Panel)，然后配置面板的数据，保存之后就可以在 `Dashboard` 看到配置的内容。  
支持的五种面板:  

* DashBoard List : 该面板可以添加多个Dashboard。
* Graph ： 图表
* Text : 文本，支持三种模板: txt、markdown和 html。
* Table : 表格
* Singlestat : 一个值  

其他功能：  

1. 播放 Dashboard (`PlayList`).
2. 对当前展示的Dashboard内容建立快照.
3. 用户和组织管理.
4. `Dashboard` 的导入与导出.
# 功能使用
## 1.通过浏览器访问
1. 启动 `grafana-server.exe`, 在浏览器中访问 `http://127.0.0.1:3000/`.
2. 默认的用户名和密码是 `admin` 和 `admin`。
## 2. 配置一个 `KairosDB` 数据库
步骤一：新增
![新增](http://7xle4i.com1.z0.glb.clouddn.com/xinzeng.png)
步骤二：填写信息并保存
![填写信息](http://7xle4i.com1.z0.glb.clouddn.com/baocun.png)

## 3. Grafana创建图表

1. 新建 `Dashboard`
![新建 Dashboard](http://7xle4i.com1.z0.glb.clouddn.com/createdashboard.png)
2. 修改 `Dashboard`的名字.
![](http://7xle4i.com1.z0.glb.clouddn.com/changeDashboardname.png)
![](http://7xle4i.com1.z0.glb.clouddn.com/changname.png)
3. 新建 `Graph` (图表)
![](http://7xle4i.com1.z0.glb.clouddn.com/newgraphy.png)
4. 设置图表的名字等信息
![](http://7xle4i.com1.z0.glb.clouddn.com/setchartinfo.png)
5. 配置图表的数据来源
![](http://7xle4i.com1.z0.glb.clouddn.com/peizhishujuyuan2.png)
6. 配置坐标轴信息
![](http://7xle4i.com1.z0.glb.clouddn.com/peizhizuobiaozhouxinxi.png)
7. 配置图表属性
![](http://7xle4i.com1.z0.glb.clouddn.com/peizhitubiaoshuxing11.png)