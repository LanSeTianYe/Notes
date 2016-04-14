时间 ： 2016/4/11 17:16:05 
*****
#### 所需软件及版本
1. [grafana-3.0.0-beta2](http://pan.baidu.com/s/1bRK4Ei)
2. [KairosDB数据库](http://pan.baidu.com/s/1bo8LDSz)
3. [grafana kariosDB插件](http://pan.baidu.com/s/1i4GGTA9)
4. [TDM-GCC](http://pan.baidu.com/s/1geRAsWr)

#### 环境搭建步骤
1. 安装kairosDB，在Linux下面，解压下载的文件，然后运行服务，在浏览器打开查询页面。(默认使用8080端口)。

        $ tar -zvxf kairosdb-1.1.1-1.tar.gz 
        //在bin目录
        $ ./kairosdb.sh run     To start KairosDB and run in the foreground type
        $ ./kairosdb.sh start   To run KairosDB as a background process type
        $ ./kairosdb.sh stop    To stop KairosDB when running as a background process type
2. 安装 `TDM-GCC` 插件，目前不清楚不安装这个插件会出现什么问题。
3. 安装 `grafana-3.0.0-beta2`, 下载之后解压即可，直接在cmd里面启动 `grafana-server.exe`。
4. 安装 `grafana kariosDB插件`, 下载之后解压，在 `grafana-3.0.0-beta2\public\` 目录下创建 `plugins\kairosdb` 目录，把加压的内容拷贝进去即可。

注意：步骤一和步骤2 的顺序可以调换

#### KariosDb数据的配置
1. 启动 `grafana-server.exe`, 在浏览器中访问 `http://127.0.0.1:3000/`.
2. 默认的用户名和密码是 `admin` 和 `admin`。
3. 配置数据源。  
步骤一：新增
![新增](http://7xle4i.com1.z0.glb.clouddn.com/xinzeng.png)
步骤二：填写信息并保存
![填写信息](http://7xle4i.com1.z0.glb.clouddn.com/baocun.png)
4. 配置图表。  
步骤一： 新建 `dashboard`  
![新建 dashboard](http://7xle4i.com1.z0.glb.clouddn.com/new.png)
步骤二，点击左上角绿色长方形, 在 `dashboard` 里面新建一个图表
![](http://7xle4i.com1.z0.glb.clouddn.com/xinjiantubaio.png)
步骤三： 配置查询条件
![配置查询条件](http://7xle4i.com1.z0.glb.clouddn.com/peizhishujuyuan.png)
