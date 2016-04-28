安装


    npm install jade
************************************************************
## 标签
标签就是一个简单的单词:  

    html
它会被转换为 `<html></html>`  

标签也是可以有 id 的:

    div#container
它会被转换为 `<div id="container"></div>`

怎么加 class 呢？

    div.user-details
转换为 `<div class="user-details"></div>`

多个 class 和 id? 也是可以搞定的:

    div#foo.bar.baz
转换为 `<div id="foo" class="bar baz"></div>`

简洁的添加id和class

    #foo
    .bar
上面的会输出：

    <div id="foo"></div><div class="bar"></div>

## 标签文本
只需要简单的把内容放在标签之后：

    p wahoo!
它会被渲染为 `<p>wahoo!</p>.`

大段的文本

    p
      | foo bar baz
      | rawr rawr
      | super cool
      | go jade go

渲染为 `<p>foo bar baz rawr.....</p>`

**结合数据的使用：**

传数据:

    router.get('/', function(req, res, next) {
      res.render('index', { title: 'Express' });
    });
接收数据:

    p Welcome to #{title}
结果:

    <p>Welcome to Express</p>

注：当要输出 #{} 的时候需要转义一下

    p \#{something}
渲染为 `<p>#{something}</p>`

同样可以使用非转义的变量 !{html}, 下面的模板将直接输出一个 `<script>` 标签:

    - var html = "<script></script>"
    | !{html}
内联标签同样可以使用文本块来包含文本：

    label
      | Username:
      input(name='user[name]')
或者直接使用标签文本:

    label Username:
      input(name='user[name]')
只 包含文本的标签，比如 `<script>`, `<style>`, 和 `<textarea>` 不需要前缀 `|` 字符, 比如:

    html
      head
        title Example
        script
          if (foo) {
            bar();
          } else {
            baz();
          }

这里还有一种选择，可以使用 . 来开始一段文本块，比如：

    p.
      foo asdf
      asdf
       asdfasdfaf
       asdf
      asd.

会被渲染为:

    <p>foo asdf
    asdf
      asdfasdfaf
      asdf
    asd
    .
    </p>

这和带一个空格的 . 是不一样的, 带空格的会被 Jade 的解析器忽略，当作一个普通的文字:

    p .
渲染为:

    <p>.</p>

需要注意的是文本块需要两次转义。比如想要输出下面的文本：

    </p>foo\bar</p>
使用:

    p.
      foo\\bar

## 注释
单行注释和 `JavaScript` 里是一样的，通过 `//` 来开始，并且必须单独一行：

    // just some paragraphs
    p foo
    p bar

渲染为：

    <!-- just some paragraphs -->
    <p>foo</p>
    <p>bar</p>

Jade 同样支持不输出的注释，加一个短横线就行了：

    //- will not output within markup
    p foo
    p bar

渲染为：

    <p>foo</p>
    <p>bar</p>

## 块注释

    body
      //
        #content
          h1 Example
渲染为：

    <body>
      <!--
      <div id="content">
        <h1>Example</h1>
      </div>
      -->
    </body>

Jade 同样很好的支持了条件注释：

    body
      //if IE
        a(href='http://www.mozilla.com/en-US/firefox/') Get Firefox

渲染为：

    <body>
      <!--[if IE]>
        <a href="http://www.mozilla.com/en-US/firefox/">Get Firefox</a>
      <![endif]-->
    </body>
## 内联
Jade 支持以自然的方式定义标签嵌套:
    
    ul
      li.first
        a(href='#') foo
      li
        a(href='#') bar
      li.last
        a(href='#') baz

块展开：  
块展开可以帮助你在一行内创建嵌套的标签，下面的例子和上面的是一样的：

    ul
      li.first: a(href='#') foo
      li: a(href='#') bar
      li.last: a(href='#') baz

## Case

`case` 表达式按下面这样的形式写:

    html
      body
        friends = 10
        case friends
          when 0
            p you have no friends
          when 1
            p you have a friend
          default
            p you have #{friends} friends
块展开在这里也可以使用:

    friends = 5
    html
      body
        case friends
          when 0: p you have no friends
          when 1: p you have a friend
          default: p you have #{friends} friends

## 属性
Jade 现在支持使用 `(` 和 `)` 作为属性分隔符

    a(href='/login', title='View login page') Login
当一个值是 `undefined` 或者 `null` 属性 不 会被加上,所以呢，它不会编译出 `something="null"`.

    div(something=null)
Boolean 属性也是支持的:

    input(type="checkbox", checked)
使用代码的 `Boolean` 属性只有当属性为 `true` 时才会有 `checked=someValue` 这一部分：

    input(type="checkbox", checked=someValue)
多行同样也是可用的：

    input(type='checkbox',
      name='agreement',
      checked)
多行的时候可以不加逗号：

    input(type='checkbox'
      name='agreement'
      checked)
加点空格，格式好看一点？同样支持

    input(
      type='checkbox'
      name='agreement'
      checked)
冒号也是支持的:

    rss(xmlns:atom="atom")

假如我有一个 `user` 对象 `{ id: 12, name: 'tobi' }`
我们希望创建一个指向 `/user/12` 的链接 `href` , 我们可以使用普通的 `JavaScript` 字符串连接，如下:

    a(href='/user/' + user.id)= user.name

或者我们使用 `Jade` 的修改方式, 这个我想很多使用 `Ruby` 或者 `CoffeeScript` 的人会看起来像普通的 JS..:

    a(href='/user/#{user.id}')= user.name
class 属性是一个特殊的属性，你可以直接传递一个数组，比如 `bodyClasses = ['user', 'authenticated']` :

    body(class=bodyClasses)

## HTML
内联的 HTML 是可以的，我们可以使用管道定义一段文本 :

    html
      body
        | <h1>Title</h1>
        | <p>foo bar baz</p>

或者我们可以使用 `.` 来告诉 `Jade` 我们需要一段文本：

    html
      body.
        <h1>Title</h1>
        <p>foo bar baz</p>

上面的两个例子都会渲染成相同的结果：

    <html><body><h1>Title</h1>
    <p>foo bar baz</p>
    </body></html>

## Doctypes

添加文档类型只需要简单的使用 `!!!` , 或者 `doctype` 跟上下面的可选项:

    !!!
会渲染出 transitional 文档类型, 或者:

    !!! 5
或

    !!! html
或

    doctype html

Doctype 是大小写不敏感的, 所以下面两个是一样的:

    doctype Basic
    doctype basic

当然也是可以直接传递一段文档类型的文本：

    doctype html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN"

渲染后:

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN">

会输出 HTML5 文档类型. 下面的默认的文档类型，可以很简单的扩展：

    var doctypes = exports.doctypes = {
      '5': '<!DOCTYPE html>',
      'xml': '<?xml version="1.0" encoding="utf-8" ?>',
      'default': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
      'transitional': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
      'strict': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
      'frameset': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">',
      '1.1': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
      'basic': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">',
      'mobile': '<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">'
    };
通过下面的代码可以很简单的改变默认的文档类型：


    jade.doctypes.default = 'whatever you want';

## 过滤器
过滤器前缀 `:` , 比如 `:markdown` 会把下面块里的文本交给专门的函数进行处理。查看顶部 特性 里有哪些可用的过滤器。
安装 `markdoen` 过滤器

    cnpm install markdown-js

引用过滤器

    var markdown = require('markdown-js');
代码：

    body
      :markdown
        Woah! jade _and_ markdown, very **cool**
        we can even link to [stuff](http://google.com)
渲染为:

    <body><p>Woah! jade <em>and</em> markdown, very <strong>cool</strong> we can even link to <a href="http://google.com">stuff</a></p></body>

## 代码
Jade 目前支持三种类型的可执行代码。第一种是前缀 -， 这是不会被输出的：

    - var foo = 'bar';
这可以用在条件语句或者循环中：

    - for (var key in obj)
      p= obj[key]

由于 Jade 的缓存技术，下面的代码也是可以的：

    - if (foo)
      ul
        li yay
        li foo
        li worked
    - else
      p oh no! didnt work

甚至是很长的循环也是可以的：

    - if (items.length)
      ul
        - items.forEach(function(item){
          li= item
        - })

下一步我们要 转义 输出的代码，比如我们返回一个值，只要前缀一个 `=` :

    - var foo = 'bar'
    = foo
    h1= foo
它会渲染为 `bar<h1>bar</h1>`. 为了安全起见，使用 `=` 输出的代码默认是转义的,如果想直接输出不转义的值可以使用 `!=`：

    p!= aVarContainingMoreHTML

Jade 同样是设计师友好的，它可以使 JavaScript 更直接更富表现力。比如下面的赋值语句是相等的，同时表达式还是通常的 JavaScript：

    - var foo = 'foo ' + 'bar'
    foo = 'foo ' + 'bar'

`Jade` 会把 `if`, `else if`, `else`, `until`, `while`, `unless` 同别的优先对待, 但是你得记住它们还是普通的 `JavaScript`：

    if foo == 'bar'
      ul
        li yay
        li foo
        li worked
    else
      p oh no! didnt work  

## 循环
尽管已经支持 JavaScript 原生代码，Jade 还是支持了一些特殊的标签，它们可以让模板更加易于理解，其中之一就是 each, 这种形式：

    each VAL[, KEY] in OBJ
一个遍历数组的例子 ：

    - var items = ["one", "two", "three"]
    each item in items
      li= item
渲染为:

    <li>one</li>
    <li>two</li>
    <li>three</li>

遍历一个数组同时带上索引：

    items = ["one", "two", "three"]
    each item, i in items
      li #{item}: #{i}
渲染为:

    <li>one: 0</li>
    <li>two: 1</li>
    <li>three: 2</li>
遍历一个数组的键值：

    obj = { foo: 'bar' }
    each val, key in obj
      li #{key}: #{val}

将会渲染为：`<li>foo: bar</li>`

## 条件语句

Jade 条件语句和使用了( `-` ) 前缀的 `JavaScript` 语句是一致的,然后它允许你不使用圆括号，这样会看上去对设计师更友好一点，同时要在心里记住这个表达式渲染出的是 常规   `JavaScript`：

    for user in users
      if user.role == 'admin'
        p #{user.name} is an admin
      else
        p= user.name
和下面的使用了常规 JavaScript 的代码是相等的：

    for user in users
      - if (user.role == 'admin')
        p #{user.name} is an admin
      - else
        p= user.name

Jade 同时支持 unless, 这和 if (!(expr)) 是等价的：

    for user in users
      unless user.isAnonymous
        p
          | Click to view
          a(href='/users/' + user.id)= user.name 

## 模板继承

Jade 支持通过 block 和 extends 关键字来实现模板继承。 一个块就是一个 Jade 的 block ，它将在子模板中实现，同时是支持递归的。

Jade 块如果没有内容，Jade 会添加默认内容，下面的代码默认会输出 `block scripts`, `block content`, 和 `block foot`.

    html
      head
        h1 My Site - #{title}
        block scripts
          script(src='/jquery.js')
      body
        block content
        block foot
          #footer
            p some footer content
现在我们来继承这个布局，简单创建一个新文件，像下面那样直接使用 extends，给定路径（可以选择带 .jade 扩展名或者不带）. 你可以定义一个或者更多的块来覆盖父级块内容, 注意到这里的 foot 块 没有 定义，所以它还会输出父级的 "some footer content"。

    extends extend-layout
    
    block scripts
      script(src='/jquery.js')
      script(src='/pets.js')
    
    block content
      h1= title
      each pet in pets
        include pet

同样可以在一个子块里添加块，就像下面实现的块 `content` 里又定义了两个可以被实现的块 `sidebar` 和 `primary`，或者子模板直接实现 `content`。

    extends regular-layout
    
    block content
      .sidebar
        block sidebar
          p nothing
      .primary
        block primary
          p nothing

## 前置、追加代码块

Jade允许你 替换 （默认）、 前置 和 追加 blocks. 比如，假设你希望在 所有 页面的头部都加上默认的脚本，你可以这么做：

    html
      head
        block head
          script(src='/vendor/jquery.js')
          script(src='/vendor/caustic.js')
      body
        block content

现在假设你有一个Javascript游戏的页面，你希望在默认的脚本之外添加一些游戏相关的脚本，你可以直接append上代码块：

    extends layout
    
    block append head
      script(src='/vendor/three.js')
      script(src='/game.js')

使用 `block append` 或 `block prepend` 时 `block` 是可选的:

    extends layout
    
    append head
      script(src='/vendor/three.js')
      script(src='/game.js')

## 包含

Includes 允许你静态包含一段 Jade, 或者别的存放在单个文件中的东西比如 CSS, HTML 非常常见的例子是包含头部和页脚。 假设我们有一个下面目录结构的文件夹：

    ./layout.jade
    ./includes/
      ./head.jade
      ./tail.jade

下面是 layout.jade 的内容: