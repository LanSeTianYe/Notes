## 说明
 * Dictionary Server Protocol:字典服务协议。
 * [RFC2229](http://www.dict.org/rfc2229.txt)
 * 字典服务：
  * [http://www.dict.org](http://www.dict.org)


## 简介

The Dictionary Server Protocol (DICT) is a TCP transaction based query/response protocol that allows a client to access dictionary definitions from a set of natural language dictionary databases.

DICT是基于查询和响应的，允许客户端从一系列自然语言数据库查询单词定义和翻译的TCP传输协议。

## 帮助文档

	DEFINE word database         -- look up word in database
	MATCH word database strategy -- match word in database using strategy
	SHOW DB                      -- list all accessible databases
	SHOW DATABASES               -- list all accessible databases
	SHOW STRAT                   -- list available matching strategies
	SHOW STRATEGIES              -- list available matching strategies
	SHOW INFO database           -- provide information about the database
	SHOW SERVER                  -- provide site-specific information
	OPTION MIME                  -- use MIME headers
	CLIENT info                  -- identify client to server
	AUTH user string             -- provide authentication information
	STATUS                       -- display timing information
	HELP                         -- display this help information
	QUIT                         -- terminate connection
	
	下面是简化命令，在其他服务器可能不支持
	D word                       -- DEFINE * word
	D database word              -- DEFINE database word
	M word                       -- MATCH * . word
	M strategy word              -- MATCH * strategy word
	M database strategy word     -- MATCH database strategy word
	S                            -- STATUS
	H                            -- HELP
	Q                            -- QUIT

## curl 查询单词（多个参数用 `:` 分开）

	//查询bash的定义
	curl dict://dict.org/define:bash
	//显示可用数据路列表
	curl dict://dict.org/show:db
	//在 `fd-deu-fra` 中查找 bash的意思
	curl dict://dict.org/define:bash:fd-deu-fra
	//显示fd-deu-fra中f为后缀的单词
	curl dict://dict.org/match:f:fd-deu-fra:suffix


