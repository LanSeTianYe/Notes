## 是什么？
> babel 是一个可以把使用ES6/ES7新特性编写的程序，转换为javascript支持的语法的工具。

## 安装

	npm install --global babel

## 怎么用？
* 把新特性编写的js文件转换为es5语法支持的代码

		$ babel testes6.js
 
* `-o` 参数将转换后的代码，从标准输出导入文件。

		$ babel es6.js -o es5.js
		# 或者
		$ babel es6.js --out-file es5.js

* `-d`参数用于转换整个目录。

		$ babel -d build-dir source-dir

         > 如果希望生成source map文件，则要加上-s参数。
         > build-dir 是转换后文件的目录
         > source-dir 是原文件的目录