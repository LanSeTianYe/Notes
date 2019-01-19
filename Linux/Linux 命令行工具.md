* 时间：2019/1/19 16:36:58  
* 参考：

	1. [http://blog.jobbole.com/114638/](http://blog.jobbole.com/114638/)
	2. [命令行雪花](http://climagic.org/coolstuff/let-it-snow.html)
 
* 系统版本： 	`Centos7`

## Linux 命令行工具

以可视化文本显示信息，通过命令行 `telnet` `curl` 等命令请求服务。

注：软件安装过时，系统可能缺少依赖包。

### 实用工具
1. [boxes](https://github.com/ascii-boxes/boxes) 字符串包装工具。

	语法：`echo "xiaotian" | boxes [[option] [option argument]] ...`

	**option：**
		
	* `-d` : 样式 。`parchment` `diamonds` `simple` `dog` `html` `peek` `shell` 等。  

	示例文档: [http://boxes.thomasjensen.com/examples.html](http://boxes.thomasjensen.com/examples.html)
	
			_________
			/\        \
			\_| hello |
			  |       |
			  |   ____|_
			   \_/______/
	
	注：源码安装之后需要把配置文件拷贝到 `/usr/share/boxes` 目录。详细可参考官方文档。
		
		make && cp ./boxes-config /usr/share/boxes && link ./src/boxes /usr/bin/boxes

2. [figlet](https://github.com/cmatsuoka/figlet.git) 文字转换。

		   _____
		  / ___/
		 (__  )
		/____/

2. [lolcat](https://github.com/busyloop/lolcat) 命令行文本转换成彩虹色
  
     安装 : `yum install gem && gem install lolcat`

     示例 : `curl www.sunfeilong.com | boxes -d cat | lolcat`
3. 天气预报

		curl wttr.in
4. `cal` : 日历。 
	
		cal | boxes -d dog -a c | lolcat -F 0.1
		# 雪花日历
		$ clear;cal|boxes -d diamonds -p a1t2l3|boxes -a c -d scroll|lolcat;sleep 3;while :;do echo $LINES $COLUMNS $(($RANDOM%$COLUMNS)) $(printf "\u2744\n");sleep 0.1;done|gawk '{a[$3]=0;for(x in a) {o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH ",o,x;printf "\033[%s;%sH%s \033[0;0H",a[x],x,$4;}}'
### 小游戏  

1. [2048](https://github.com/tiehuis/2048-cli) 

### 小故事 

1. 星球大战 

		# ctrl + ] -> quit 退出
		telnet towel.blinkenlights.nl   
2. [奔跑的小猫](https://github.com/klange/nyancat)
3. [显示矩阵](https://github.com/abishekvashok/cmatrix)：[下载地址](https://codeload.github.com/abishekvashok/cmatrix/tar.gz/1.2), （建议使用 release 版本安装）。
4. [aafire](http://aa-project.sourceforge.net/aalib/) : 显示火的图像。

		aafire | lolcat -F 0.00001 -p 1

### 其他工具  

* [sl](https://github.com/mtoyoda/sl)：命令行玩笑工具，输入 `sl` 命令行会有一列火车通过。

		git clone https://github.com/mtoyoda/sl.git
		cd sl
		make && link ./sl /usr/sbin/sl
* [espeak](http://espeak.sourceforge.net/): 读文字。
		