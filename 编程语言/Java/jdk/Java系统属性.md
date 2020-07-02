##  
时间：2017/4/13 13:25:39 

##  java.awt.headless
 * 描述：   
   Headless 是系统的一种配置模式，在该模式下系统缺少显示设备，键盘和鼠标。  
* 使用情况：   
  Web项目服务器一般没有显示设备和鼠标键盘，有时需要显示设备提供的功能，生成相应数据。 例如：JFreechart 生成图表。这时我们可以设置 `java.awt.headless = true` ， 之后服务器会使用计算本身的计算能力模拟生成数据，而不会借助其他硬件的帮助。


 * 遇到问题：  
   Web项目，使用 JFreechart 生成图表，在本地电脑部署项目可以正常生成，在服务器上出现如下错误：

		Handler processing failed; nested exception is java.lang.NoClassDefFoundError: Could not initialize class org.jfree.chart.JFreeChart
 * 问题原因：  
   服务器没有显示设备，导致生成图表的时候JFreechart初始化失败。



 * 解决思路：

		CATALINA_OPTS is immensely useful for setting debug parameters, Java memory settings, etc. One very common use is to set the system property java.awt.headless to true. Most graphical applications (like Jasper, JFreechart, LiquidOffice, StyleReport, etc.) will halt Tomcat when they render if something isn't done to disable display rendering, and this is by far the easiest method. (This problem occurs with most J2EE servers, not just Tomcat). Here's how to make this setting in UNIX.
 * 解决办法（在tomcat配置文件添加如下配置）：

		export CATALINA_OPTS: CATALINA_OPTS=-Djava.awt.headless=true
	* windows：Tomcat catalina.bat 添加如下配置
	
	 		set "CATALINA_OPTS=%CATALINA_OPTS% -Djava.awt.headless=true"
    * Linux：Tomcat catalina.sh 添加如下配置

			export CATALINA_OPTS="$CATALINA_OPTS -Djava.awt.headless=true"