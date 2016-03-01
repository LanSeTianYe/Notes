### 连接到数据库
###### 连接到本地数据库
    
    set oracle_sid=orcl
    rman target username/password
注：orcl为数据库实例的名字，username使用sys，密码使用系统的密码。

###### 连接到远程数据库
    rman
然后

    connect target /@192.168.1.66:1521/orcl2