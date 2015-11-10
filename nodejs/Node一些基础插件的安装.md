## 注意事项
1. 使用`nvmw`的时候，提示**没有文件扩展“.js”的脚本引擎**，需要进入注册表修改即可：、

		在运行中输入“regedit”进入注册表，
		只需要把[HKEY_CLASSES_ROOT-->.js] 然后双击`.js`
		把右边的默认值改成 "JSFile" 即可

## 安装nvmw（安装好之后并不能用）
1. 在github上面下载zip包，解压之后把文件夹路径配入path中即可(E:\nvmw-master)。
2. 更改下载文件的来源

		set "NVMW_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node"
		set "NVMW_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs"
		set "NVMW_NPM_MIRROR=http://npm.taobao.org/mirrors/npm"
## 3.ubuntu安装nvm插件
1. 需要安装git版本管理工具。
2. 克隆到本地

		git clone https://github.com/creationix/nvm.git
3. 进入目录，检出最新版本。

		git describe --abbrev=0 --tags`
4. 在系统中应用nvm，进入nvm的目录中执行。

		source nvm.sh
5. 安装最新版本的node

		nvm install node
6. 查看远端版本

		nvm ls-remote