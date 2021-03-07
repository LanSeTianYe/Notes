时间：2018/12/31 10:44:10 

## Linux 软件安装 

### CentOS yum 命令

#### 简介 

yum 全称 Yellow dog Updater, Modified，是一个在 Fedora 和 RedHat 以及 SUSE 中的 Shell 前端软件包管理器。基于 RPM 包管理，可以自动处理依赖关系，简单好用。

支持同时配置多个软件仓库。

#### yum-config-manager yum 配置管理 

* `yum-config-manager --add-repo [file/url]`：添加仓库。
* `yum-config-manager --disable "仓库名"`：启用仓库。
* `yum-config-manager --enable "仓库名"`：禁用仓库。

#### yum 软件管理 

**语法：** `yum [option] [commands] [package ...]`

**选项 [option]：**

* `-h`：显示帮助信息。
* `-y`：安装过程全部使用yes。
* `-q`：静默安装，不显示安装过程。  
* `-localinstall`：安装本地软件包。
* `--downloadonly`：只下载不安装。

**命令 [command]：** 

* `yum search`：搜索软件。
* `yum deplist package_name`：列出报的依赖信息。
* `yum install software_name`：下载安装软件，或者安装一个电脑上的软件包。
* `yum reinstall software_name`：重新安装软件。
* `yum update`：更新全部软件。
* `yum update package_name`：更新指定软件。
* `yum check-update`：检查可更新的软件。
* `yum remove software_name`：删除软件。
* `yum list`:列出所有软件软件。
	* `yum list installed`：列出已经安装软件。
	* `yum list updates`：列出需要更新的软件。
	* `yum list extras`：列出已经安装，但不在 yum 仓库中的软件。
* `yum info`：列出所有软件的信息。
	*  `yum info git`：列出指定软件的信息。
	*  `yum info updates`: 列出需要更新的软件的信息。
* `yum provides info`：查询哪一个软件包中包含执行信息。
* `yum clean`：清除所有缓存。yum 会把下载的软件包和header信息缓存在 `/var/cache/yum` 目录，可以使用该命令清除缓存。
	* `yum clean packages`：清除缓存的软件包。
	* `yum clean headers`：清除缓存 header 信息。
	* `yum clean oldheaders`：清除缓存目录下旧的 headers。
* `yum grouplist`：查看可以批量安装的列表。
* ` yum repolist`：显示配置的仓库列表。仓库配置文件在 `/etc/yum.repos.d` 目录下，需要配置可以在目录下添加文件。

**软件包[package]：**

* `yum-plugin-fastestmirror`：从镜像仓库中选择最快的仓库地址。
* [bash-completion](https://www.cyberciti.biz/faq/fedora-redhat-scientific-linuxenable-bash-completion/)：命令补全工具。 
