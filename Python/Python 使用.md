时间：2019/7/7 16:23:26   

## Python 使用   

1. `Python` 的版本和 `pip` 的版本匹配，最好是下载安装包。

  	[Python3.7.3_64_gpu](https://www.python.org/ftp/python/3.7.3/python-3.7.3-amd64.exe)
  
2. Windows 配置国内仓库

	打开资源管理器，输入 `%appdata%` 目录，创建 `pip` 目录，在目录下创建 `pip.ini`文件，编辑文件配置仓库地址：

		[global]
		timeout = 6000
		index-url = https://pypi.tuna.tsinghua.edu.cn/simple
		trusted-host = pypi.tuna.tsinghua.edu.cn

	常用地址：
		
		阿里云 http://mirrors.aliyun.com/pypi/simple/ 
		中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/ 
		豆瓣(douban) http://pypi.douban.com/simple/ 
		清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/ 
		中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/