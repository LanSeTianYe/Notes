## 安装最新版本
1. 依次执行下面命令即可

		sudo add-apt-repository ppa:chris-lea/node.js
		sudo apt-get update
		sudo apt-get install nodejs

2. 查看版本

		node -v


3. 查看主机环境对ES6新特性的支持

		$ npm install -g es-checker
		$ es-checker
		
		=========================================
		Passes 24 feature Dectations
		Your runtime supports 57% of ECMAScript 6
		=========================================