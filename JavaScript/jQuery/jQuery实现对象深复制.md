2016/7/6 15:33:42 

#####　代码
    
    var o = {a: [1]};
    
    //浅拷贝
    var o1 = $.extend({}, o);
    console.log(o1.a === o.a);  // true
    
    //深拷贝
    var o2 = $.extend(true, {}, o);
    console.log(o2.a === o.a);  //false