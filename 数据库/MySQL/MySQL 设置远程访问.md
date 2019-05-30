## 修改用户表解决，使root用户可以远程登录  
1. 用命令行连接 mysql。   

        mysql -h localhost -u root -p
2. 选择 `mysql` 数据库。  

        use mysql;
3. 修改用户可以远程访问的主机地址。   

        update user set host = '%' where user = 'root';
4. 刷新数据库配置。 

        FLUSH PRIVILEGES;