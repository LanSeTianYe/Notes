时间：2018/8/7 18:03:19 

参考：

1. [REST API Documentation](https://dzone.com/articles/rest-api-documentation-part-2-1)

## 

### [RAML](https://raml.org/)

> The simplest way to design APIs.

RAML(RESTful API Modeling Language 即 RESTful API 建模语言)是对 RESTful API的一种简单和直接的描述。它是一种让人们易于阅读并且能让机器对特定的文档能解析的语言。RAML 是基于 YAML,能帮助设计 RESTful API 和鼓励对API的发掘和重用,依靠标准和最佳实践从而编写更高质量的API。通过RAML定义,因为机器能够看得懂,所以可以衍生出一些附加的功能服务,像是解析并自动生成对应的客户端调用代码、服务端代码 结构, API说明文档。

生命周期：设计、构建、文档、测试和分享。

API在线编辑工具：[https://restlet.com/modules/studio/](https://restlet.com/modules/studio/)

### [Swagger](https://swagger.io)

> The Best APIs are Built with Swagger Tools.

Swagger与RAML相比，RAML解决的问题是设计阶段的问题，而Swagger则是侧重解决现有API的文档问题，它们最大的不同是RAML需要单独维护一套文档，而Swagger则是通过一套反射机制从代码中生成文档，并且借助ajax可以直接在文档中对API进行交互。因为代码与文档是捆绑的所以在迭代代码的时候，就能方便的将文档也更新了。不会出现随着项目推移代码与文档不匹配的问题。另外Swagger是基于JSON进行文档定义的。

生命周期：设计、构建、文档、测试和规范等。 

* Swagger UI：生成美观的API文档。
* Swagger CodeGen: 初始化客户端代码，支持多种语言。
* Swagger Ecosystem： 生态系统， 


### [API BluePrint](https://apiblueprint.org/)

> A powerful high-level API description language for web APIs.

不推荐使用：

* github 最后一次更新时间是 2017年5月。
* 插件化带来灵活性的同时，也带来了使用和配置的复杂性。且官方平台第三方插件支持也不稳定，遇到问题很难解决。
* 类似于Markdown的弱规范语法，书写容易出错。
* 是 [apiary](https://apiary.io/) 开源的规范，apiary 官方提供一站式的在线文档工具，包含文档生成、mock 和测试等功能，免费版限制较多，付费版功能比较完善。