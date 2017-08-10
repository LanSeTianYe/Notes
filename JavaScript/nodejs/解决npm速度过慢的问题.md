## 使用淘宝的镜像
1. 安装cnpm命令代替npm命令

		npm install -g cnpm --registry=https://registry.npm.taobao.org

2. 安装模块

		cnpm install [name]

3. 同步模块

		cnpm sync connect

4. 支持 npm 除了 publish 之外的所有命令, 如:

		cnpm info connect