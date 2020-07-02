## 路由
路由是由一个 URI、HTTP 请求（GET、POST等）和若干个句柄组成，它的结构如下：

`app.METHOD(path, [callback...], callback)` 

`app` 是 express 对象的一个实例  
#### 路由方法  
`METHOD` , 是一个 HTTP 请求方法  

    Express 定义了如下和 HTTP 请求对应的路由方法：  
    get, post, put, head, delete, options, trace, copy, lock, mkcol, move, purge, propfind, proppatch, unlock, report, mkactivity, checkout, merge, m-search, notify, subscribe, unsubscribe, patch, search, 和 connect。  
注:  有些路由方法名不是合规的 JavaScript 变量名，此时使用括号记法 比如： `app['m-search']('/', function ..`

#### 路由路径 
`path` ，是服务器上的路径。  

路由路径和请求方法一起定义了请求的端点，它可以是字符串、字符串模式或者正则表达式。
#### 路由句柄 
`callback` ，是当路由匹配时要执行的函数。

可以为请求处理提供多个回调函数，其行为类似 中间件。唯一的区别是这些回调函数有可能调用 `next('route')` 方法而略过其他路由回调函数。可以利用该机制为路由定义前提条件，如果在现有路径上继续执行没有意义，则可将控制权交给剩下的路径。  

路由句柄有多种形式，可以是一个函数、一个函数数组，或者是两者混合。  

混合使用函数和函数数组处理路由：

    var cb0 = function (req, res, next) {
      console.log('CB0');
      next();
    }
    
    var cb1 = function (req, res, next) {
      console.log('CB1');
      next();
    }
    
    app.get('/example/d', [cb0, cb1], function (req, res, next) {
      console.log('response will be sent by the next function ...');
      next();
    }, function (req, res) {
      res.send('Hello from D!');
    });

##### 响应方法

下表中响应对象（res）的方法向客户端返回响应，终结请求响应的循环。如果在路由句柄中一个方法也不调用，来自客户端的请求会一直挂起。

|方法|描述|
|::|::|
|res.download()	|提示下载文件。|
|res.end()	|终结响应处理流程。|
|res.json()	|发送一个 JSON 格式的响应。|
|res.jsonp()	|发送一个支持 JSONP 的 JSON 格式的响应。|
|res.redirect()	|重定向请求。|
|res.render()	|渲染视图模板。|
|res.send()	|发送各种类型的响应。|
|res.sendFile	|以八位字节流的形式发送文件。|
|res.sendStatus()	|设置响应状态代码，并将其以字符串形式作为响应体的一部分发送。|

##### app.route()

可使用 app.route() 创建路由路径的链式路由句柄。由于路径在一个地方指定，这样做有助于创建模块化的路由，而且减少了代码冗余和拼写错误。请参考 Router() 文档 了解更多有关路由的信息。

    app.route('/book')
      .get(function(req, res) {
        res.send('Get a random book');
      })
      .post(function(req, res) {
        res.send('Add a book');
      })
      .put(function(req, res) {
        res.send('Update the book');
      });

##### express.Router

可使用 express.Router 类创建模块化、可挂载的路由句柄。Router 实例是一个完整的中间件和路由系统，因此常称其为一个 “mini-app”。  
下面的实例程序创建了一个路由模块，并加载了一个中间件，定义了一些路由，并且将它们挂载至应用的路径上。  
在 app 目录下创建名为 birds.js 的文件，内容如下：

    var express = require('express');
    var router = express.Router();
    
    // 该路由使用的中间件
    router.use(function timeLog(req, res, next) {
      console.log('Time: ', Date.now());
      next();
    });
    // 定义网站主页的路由
    router.get('/', function(req, res) {
      res.send('Birds home page');
    });
    // 定义 about 页面的路由
    router.get('/about', function(req, res) {
      res.send('About birds');
    });
    
    module.exports = router;

然后在应用中加载路由模块：
    
    var birds = require('./birds');
    ...
    app.use('/birds', birds);
应用即可处理发自 `/birds` 和 `/birds/about` 的请求，并且调用为该路由指定的 `timeLog` 中间件。