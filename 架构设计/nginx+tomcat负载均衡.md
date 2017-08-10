## 系统环境
1. win8 64为
2. jdk1.8
3. 关闭系统防火墙。（如果不关闭可能需要对端口进行特殊处理）
## 软件版本
1. [nginx-1.10.1](http://nginx.org/en/download.html)
2. [tomcat-8.5.4](http://tomcat.apache.org/download-80.cgi)

## 为什么？
Tomca支持的并发数为300-500， nginx支持的并发数为 50000。

## nginx 安装
1. 下载 [nginx-1.10.1](http://nginx.org/en/download.html)
2. 双击 `nginx.exe` 启动nginx，如果启动失败可以查看logs下的日志文件分析错误原因。
3. 通过访问 `localhost:端口号` 查看nginx是否启动成功。

## tomcat 安装和配置
1. 下载 [tomcat-8.5.4](http://tomcat.apache.org/download-80.cgi)
2. 解压，解压之后复制一份 `apache-tomcat-8.5.4_8080` 和 `apache-tomcat-8.5.4_8090`,此时已经有两个tomcat。
3. 配置 `tomcat` 的端口，tomcat默认得到端口是8080，所以我们只需要修改一个即可。修改 `server.xml` 修改内容如下：

		//8005->8095, 8080->8090, 8443->8093,8009->8099
		//1 
		<Server port="8005" shutdown="SHUTDOWN">
		<Server port="8095" shutdown="SHUTDOWN">
		//2
		<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
		<Connector port="8090" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8093" />
		//3 
		<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
		<Connector port="8099" protocol="AJP/1.3" redirectPort="8093" />
		
4. 启动tomcat。进入bin目录，按下 SHIFT+鼠标右键，选择在此处打开命令行，输入 `startup.bat`即可。
5. 访问验证是否启动成功： `http://localhost:8090/` 和 `http://localhost:8090/` 。


## nginx 代理配置
1. 在 `#gzip  on;` 下面添加(`192.168.1.10` 是本机ip)
 
		#gzip  on;
			
		upstream 192.168.1.10 {
			server 127.0.0.1:8080 weight=5;
			server 127.0.0.1:8090 weight=5;
			ip_hash;
		}
2. 修改 `location /` 的内容如下：

		location / { 
            root   html; 
            index  index.html index.htm; 
            proxy_pass   http://192.168.1.10; 
            proxy_redirect    off; 
            proxy_set_header   Host $host; 
            proxy_set_header   X-Real-IP $remote_addr; 
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;  
            client_max_body_size   10m; 
            client_body_buffer_size   128k; 
            proxy_connect_timeout   90; 
            proxy_send_timeout   90; 
            proxy_read_timeout   90; 
            proxy_buffer_size   4k; 
            proxy_buffers   4 32k; 
            proxy_busy_buffers_size   64k; 
            proxy_temp_file_write_size  64k;         
        }

注意： 第二步的 ` proxy_pass`需要和第一步的 `192.168.1.10`对应。 

## 启动项目
1. 先启动tomcat。
2. 再启动nginx。

## 测试负载均衡是否有效
1. 修改tomcat的首页，文件位置 `webapps\ROOT\index.jsp`
找到：

		<h2>If you're seeing this, you've successfully installed Tomcat. Congratulations!</h2>
修改一下，例如

		<h2>Hello!</h2>
2. 重新启动tomcat和nginx。
3. 访问项目，观察分析访问的是哪一个tomcat，关闭访问的tomcat，刷新网页(加载时间可能会有点长)，会发现访问另一个tomcat。



## 可能出现的问题：
1. nginx默认使用80端口，端口可能被占用，此时结束占用80端口号的程序，也可以修改nginx的端口号。

		  server {
		        listen       88;		//这里是端口号的位置		
		        server_name  localhost;
		
		        #charset koi8-r;
		
		        #access_log  logs/host.access.log  main;
 