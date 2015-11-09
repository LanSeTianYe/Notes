"use strict"

//定义常量
const PI = 3.1415926
console.log("定义常量"+PI);

//块作用域的变量let锁定变量，使得变量在块之外不能被访问
for(let i = 0; i < 2; i++) {
	let x = i;
}
//console.log(x);	//错误
for(var j = 0; j < 3; j++) {
	var y = j;
}
console.log(y);		// 输出2
//块作用域的方法,
{
    function foo () { return 1 }
    console.log("1", foo() === 1);		//true
    {
        function foo () { return 2 }
        console.log("2", foo() === 2);	//true
    }
    console.log("3", foo() === 1);		//true
}
//console.log("3", foo() === 1);		//错误

//默认参数
function testParam(a = 's', c) {
	console.log(a,c);
}

testParam(2,3);

//不定长参数
//function f (x, y, ...a) {
//  return (x + y) * a.length
//}
//console.log("不定长参数：",f(1, 2, "hello", true, 7) === 9);


var arrObj = ['alexchen',1,{}];
arrObj._name = 'attr-alexchen';
for (var i of arrObj) {
    console.log(i);//这里只会输出,alexchen,1,object{},不会输出attr-alexchen
    console.log(typeof(i))//这里会输出 string,number,object
    //满足条件之后跳出循环
//  if (i == 1) {
//      break;
//  }
}

//获取值
var arr = ['sun','fei','long'];
for(v of arr) {
	console.log(v);
}
//获取并存储
var names = ['sun','fei','long','1993'];
var longNameArr = [x for (name of names) if (name.length > 3)];

for(v of longNameArr) {
	console.log(v);
}








