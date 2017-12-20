时间：2017/12/20 15:19:29    

参考：  

1. [控制相关度](https://www.elastic.co/guide/cn/elasticsearch/guide/current/controlling-relevance.html)


环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  
### 影响相关度的因素  

> 词频，逆向文档频率和字段归一值都是在索引时计算并存储的。

1. 词频（TF）：一个词在文档中出现的次数越高相关度越高。单词在文档中的词频是，该单词在文档中出现次数的平方根。

		tf(t in d) = √frequency

	如果不想让次的出现频率影响相关度，可以在字段映射中禁用词频统计（`"index_options": "docs"`）：

		PUT /my_index
		{
		  "mappings": {
		    "doc": {
		      "properties": {
		        "text": {
		          "type":          "string",
		          "index_options": "docs" 
		        }
		      }
		    }
		  }
		}
2. 逆向文档频率（IDF）。单词在所有文档中出现的频率，频率越高，权重越低。

	计算方法： 索引中文档数量除以所有包含该词的文档数，然后求其对数

		idf(t) = 1 + log ( numDocs / (docFreq + 1)) 
3. 字段归一值（norm）。字段越短，字段的权重越高。

	计算方法：字段中词数平方根的倒数
		
		norm(d) = 1 / √numTerms 
	在不想让字段长度影响评分的时候可以禁用归一值（`"norms": { "enabled": false } `）：

		PUT /my_index
		{
		  "mappings": {
		    "doc": {
		      "properties": {
		        "text": {
		          "type": "string",
		          "norms": { "enabled": false } 
		        }
		      }
		    }
		  }
		}
	注：禁用归一值可以节省内存。
4. 向量空间模型（vector space model）。合并多个词的权重（每个词根据上面三个公式计算出的权重）。
	
	如果查询 “happy hippopotamus” ，常见词 happy 的权重较低，不常见词 hippopotamus 权重较高，假设 happy 的权重是 2 ， hippopotamus 的权重是 5 ，可以将这个二维向量—— [2,5] ——在坐标系下作条直线，线的起点是 (0,0) 终点是 (2,5)。如下图所示：

	![向量图](http://7xle4i.com1.z0.glb.clouddn.com/xiangliangmoxing.png)

	现在，设想我们有三个文档：
	
	1. I am happy in summer 。
	2. After Christmas I’m a hippopotamus 。
	3. The happy hippopotamus helped Harry 。
	
	可以为每个文档都创建包括每个查询词—— happy 和 hippopotamus ——权重的向量，然后将这些向量置入同一个坐标系中。  
	
	文档 1： (happy, ____________ )  —— [2,0]  
	文档 2： ( ___ , hippopotamus )  —— [0,5]  
	文档 3： (happy,hippopotamus) —— [2,5]

	如图所示：

	![](http://7xle4i.com1.z0.glb.clouddn.com/xiangliangmoxing_2.png)

	向量之间是可以比较的，只要测量查询向量和文档向量之间的角度就可以得到每个文档的相关度，文档 1 与查询之间的角度最大，所以相关度低；文档 2 与查询间的角度较小，所以更相关；文档 3 与查询的角度正好吻合，完全匹配。

	同样的对于多维向量我们也可以计算出他们于标准之间的夹角从而计算出相似度。

	