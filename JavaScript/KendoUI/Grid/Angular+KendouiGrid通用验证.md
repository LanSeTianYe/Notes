日期 : 2016/5/16 14:49:38 

# 结合 `angular` 使用
## 怎么使用，在 `grid` 里面的代码

1. 创建一个factory

        angular.module("kendogrid.validation",[])
        .factory('validation', function() {
    
            //自定义验证
            var customValid = {
    
                //邮箱验证
                isEmail : function(input, name) {
                    if (input.attr("name") == name) {
                        input.attr("data-isEmail-msg", "邮箱格式错误！");
                        return regexEnum.email.test(input.val());
                    } else {
                        return true;
                    }
                },
                //非空验证
                notNull : function(input, name){
                    if (input.attr("name") == name) {
                        input.attr("data-notNull-msg", "内容不能为空！");
                        return (input.val() != null && input.val() != "");
                    } else {
                        return true;
                    }
                },
                //最大长度验证
                maxLength_N:function(input, name, maxLength) {
                    if (input.attr("name") == name) {
                        input.attr("data-maxLength_N-msg", "长度不能超过 "+maxLength+" !");
                        return (input.val().length <= maxLength);
                    } else {
                        return true;
                    }
                },
                //最小长度验证
                minLength_N:function(input, name, minLength) {
                    if (input.attr("name") == name) {
                        input.attr("data-minLength_N-msg", "长度不能小于 "+minLength+" !");
                        return (input.val().length >= minLength);
                    } else {
                        return true;
                    }
                },
                //长度范围验证
                lengthRange_Min_Max: function(input, name, minLength, maxLength) {
                    if (input.attr("name") == name) {
                        if(input.val().length < minLength) {
                            input.attr("data-lengthRange_Min_Max-msg", "长度不能小于 "+minLength+" !");
                        } else if(input.val().length > maxLength){
                            input.attr("data-lengthRange_Min_Max-msg", "长度不能超过 "+maxLength+" !");
                        }
                        return (input.val().length >= minLength && input.val().length <= maxLength);
                    } else {
                        return true;
                    }
                },
                //手机号码
                isTel: function(input, name) {
                    if (input.attr("name") == name) {
                        input.attr("data-isTel-msg", "手机号码错误！");
                        return regexEnum.tel.test(input.val());
                    } else {
                        return true;
                    }
                },
                //boolean值验证
                isBoolean: function(input, name) {
                    if (input.attr("name") == name) {
                        input.attr("data-isBoolean-msg", "请输入true或false！");
                        return (
                            input.val() == "true" || input.val() == "false" ||
                            input.val() == true || input.val() == false ||
                            input.val() == 1 || input.val() == 0
                        )
                    } else {
                        return true;
                    }
                }
            }
    
            //用于特殊验证的正则表达式
            var regexEnum  = {
                intege:"^-?[1-9]\\d*$",                     //整数
                intege1:"^[1-9]\\d*$",                      //正整数
                intege2:"^-[1-9]\\d*$",                     //负整数
                num:"^([+-]?)\\d*\\.?\\d+$",                //数字
                num1:"^[1-9]\\d*|0$",                       //正数（正整数 + 0）
                num2:"^-[1-9]\\d*|0$",                      //负数（负整数 + 0）
                decmal:"^([+-]?)\\d*\\.\\d+$",              //浮点数
                decmal1:"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*$", //正浮点数
                decmal2:"^-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*)$",//负浮点数
                decmal3:"^-?([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0)$",         //浮点数
                decmal4:"^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0$",             //非负浮点数（正浮点数 + 0）
                decmal5:"^(-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*))|0?.0+|0$",        //非正浮点数（负浮点数 + 0）
                email: /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/,   //邮件
                color:"^[a-fA-F0-9]{6}$",                                       //颜色
                url:"^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$",    //url
                chinese:"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$",                  //仅中文
                ascii:"^[\\x00-\\xFF]+$",                                       //仅ACSII字符
                zipcode:"^\\d{6}$",                                             //邮编
                mobile:"^13[0-9]{9}|15[012356789][0-9]{8}|18[0256789][0-9]{8}|147[0-9]{8}$",            //手机
                ip4:"^(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)$",  //ip地址
                notempty:"^\\S+$",                                              //非空
                picture:"(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$",   //图片
                rar:"(.*)\\.(rar|zip|7zip|tgz)$",                               //压缩文件
                date:"^\\d{4}(\\-|\\/|\.)\\d{1,2}\\1\\d{1,2}$",                 //日期
                qq:"^[1-9]*[1-9][0-9]*$",                                       //QQ号码
                tel:/^1\d{10}$/,
                username:"^\\w+$",                                              //用来用户注册。匹配由数字、26个英文字母或者下划线组成的字符串
                letter:"^[A-Za-z]+$",                                           //字母
                letter_u:"^[A-Z]+$",                                            //大写字母
                letter_l:"^[a-z]+$",                                            //小写字母
                idcard:"^[1-9]([0-9]{14}|[0-9]{17})$"                           //身份证
            }
    
            return customValid;
        })

2. 引入factory

        angular.module("myApp", ['kendogrid.validation'])
        .controller("MyController", function (validation) {

3. 使用 


        model: {
            id: "id",
            fields: {
                siteName: {
                    validation: {
                        notNull:function(input) {
                            return validation.notNull(input, 'siteName');
                        },
                        lengthRange_Min_Max:function(input) {
                            return validation.lengthRange_Min_Max(input, 'siteName', 5 , 50);
                        }
                    }
                },
                siteCode:{
                    notNull:function(input) {
                        return validation.notNull(input, 'siteCode');
                    },
                    lengthRange_Min_Max:function(input) {
                        return validation.lengthRange_Min_Max(input, 'siteCode', 5 , 50);
                    }
                },
                isActive:{
        
                },
                description: {
        
                },
                createDate: {type: "date", editable: false}
            }
        }   

