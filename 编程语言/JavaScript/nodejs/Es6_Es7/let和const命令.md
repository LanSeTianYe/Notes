### let块级作用域

ES6新增了let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效。

	{
	  let a = 10;
	  var b = 1;
	}
	
	a // ReferenceError: a is not defined.
	b // 1
上面代码在代码块之中，分别用let和var声明了两个变量。然后在代码块之外调用这两个变量，结果let声明的变量报错，var声明的变量返回了正确的值。这表明，let声明的变量只在它所在的代码块有效。

for循环的计数器，就很合适使用let命令。

## const命令
const也用来声明变量，但是声明的是常量。一旦声明，常量的值就不能改变。  
const声明的变量不得改变值，这意味着，const一旦声明变量，就必须立即初始化，不能留到以后赋值  
对于复合类型的变量，变量名不指向数据，而是指向数据所在的地址。const命令只是保证变量名指向的地址不变，并不保证该地址的数据不变，所以将一个对象声明为常量必须非常小心。  

		const foo = {};
		foo.prop = 123;
		
		foo.prop
		// 123
		
		foo = {} // TypeError: "foo" is read-only不起作用
上面代码中，常量foo储存的是一个地址，这个地址指向一个对象。不可变的只是这个地址，即不能把foo指向另一个地址，但对象本身是可变的，所以依然可以为其添加新属性。  

## 跨模块常量
上面说过，const声明的常量只在当前代码块有效。如果想设置跨模块的常量，可以采用下面的写法。

		// constants.js 模块
		export const A = 1;
		export const B = 3;
		export const C = 4;
		
		// test1.js 模块
		import * as constants from './constants';
		console.log(constants.A); // 1
		console.log(constants.B); // 3
		
		// test2.js 模块
		import {A, B} from './constants';
		console.log(A); // 1
		console.log(B); // 3
## 全局对象的属性
全局对象是最顶层的对象，在浏览器环境指的是window象，在Node.js指的是global对象。ES5之中，全局对象的属性与全局变量是等价的。
	
	window.a = 1;
	a // 1
	
	a = 2;
	window.a // 2
上面代码中，全局对象的属性赋值与全局变量的赋值，是同一件事。（对于Node来说，这一条只对REPL环境适用，模块环境之中，全局变量必须显式声明成global对象的属性。）

这种规定被视为JavaScript语言的一大问题，因为很容易不知不觉就创建了全局变量。ES6为了改变这一点，一方面规定，var命令和function命令声明的全局变量，依旧是全局对象的属性；另一方面规定，let命令、const命令、class命令声明的全局变量，不属于全局对象的属性。

	var a = 1;
	// 如果在Node的REPL环境，可以写成global.a
	// 或者采用通用方法，写成this.a
	window.a // 1
	
	let b = 1;
	window.b // undefined
上面代码中，全局变量a由var命令声明，所以它是全局对象的属性；全局变量b由let命令声明，所以它不是全局对象的属性，返回undefined。