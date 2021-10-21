时间： 2019-08-01 21:19

## 　MongoDB 配置信息

启动:  `./mongod 配置1 配置2`。

使用 `mongod --help` 查看帮助信息。

停止:  `kill pid` or `kill -2 pid`。

* `mongod --dbpath` 数据文件存放位置，默认 `/data/db`。
* `mongod --port` 服务端口，默认 `27017`。
* `mongod --fork` 后台进程方式运行。
* `mongod --logpath` 日志文件存放目录。
* `mongod --config` 指定配置文件位置。  

## 安全配置

第一步 添加管理员用户 `use admin` `db.addUser('admin','admin',readonly)`。一定要先在admin添加管理员用户。管理员用户拥有数据库的所有权限。

其它数据库的权限，在对应数据库添加用户。

添加用户：`db.addUser('name','password',readonly)`

认证: `db.auth('username', 'password')`
