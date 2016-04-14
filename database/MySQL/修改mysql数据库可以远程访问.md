## 修改用户表解决，使root用户可以远程登录。
1. 在 cmd 连接 mysql

        mysql -h localhost -u root -p
2. 使用 `mysql` 数据库

        use mysql;
3. 修改用户 `host` 限制

        update user set host = '%' where user = 'root';
4. 刷新

        FLUSH PRIVILEGES;