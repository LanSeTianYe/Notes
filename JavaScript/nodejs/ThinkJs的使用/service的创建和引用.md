#### 创建service
首先要进入项目目录

* **1、** 创建默认的service，生成的文件 `src/common/service/test.js`

		thinkjs service test
* **2、** 指定模块，生成的文件 `src/home/service/test.js`

		thinkjs service home/test

默认情况下创建的service会在common目录下面


#### 使用service

1. 跨模块加载
		
		//test-->service   home-->模块名
		let testService = think.service("test", "home"); 
		let instance = new testService();
2. 不跨模块加载


		let testService = think.service("test"); 
		let instance = new testService();