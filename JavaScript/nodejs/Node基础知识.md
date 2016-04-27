## `Node` 安装
Windows下载msi文件即可安装。

## `npm` 安装模块

**全局安装**  
把模块安装到全局目录,在电脑的任何位置都可以使用该模块。

    npm install -g 模块名
**局部安装**

    npm install 模块名
安装 Node 模块时，如果指定了 `--save` 参数，那么此模块将被添加到 package.json 文件中 dependencies 依赖列表中。 然后通过 npm install 命令即可自动安装依赖列表中所列出的所有模块。

    npm install 模块名 --save
    npm install -g 模块名 --save

## 在 `js` 文件中引用模块

    var logger = require('模块名');

## 使用安装的模块
使用模块主要是使用模块中的方法, 这些方法封装了一些底层的业务方法，让我们可以快速简单的实现需要的功能。

    var nodemailer = require('nodemailer');
    
    //使用SMTP协议发送邮件
    //支持的服务 
    //'1und1' 'AOL' 'DebugMail.io' 'DynectEmail' 'FastMail'
    //'GandiMail' 'Gmail' 'Godaddy' 'GodaddyAsia' 'GodaddyEurope'
    //'hot.ee' 'Hotmail' 'iCloud' 'mail.ee' 'Mail.ru' 'Mailgun'
    //'Mailjet' 'Mandrill' 'Naver' 'Postmark' 'QQ' 'QQex' 'SendCloud'
    //'SendGrid' 'SES' 'Sparkpost' 'Yahoo' 'Yandex' 'Zoho'
    
    var transporter = nodemailer.createTransport({
        service: 'QQ',
        auth: {
            user: '781397320@qq.com',
            pass: '******'
        }
    });
    
    //邮件的内容
    var mailOptions = {
        from: 'Fred Foo <781397320@qq.com>', 	//发件人地址
        to: '1498282352@qq.com', 				//收件人地址
        subject: 'Hello(Subject)', 				//邮件的标题
        text: 'Hello world(text)', 				//邮件的内容
        html: '<b>Hello world(html)</b>' 		//html body
    };
    
    //发送邮件
    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            console.log(error);
        }else{
            console.log('Message sent: ' + info.response);
        }
    });