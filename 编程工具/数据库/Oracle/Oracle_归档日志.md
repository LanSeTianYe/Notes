### 归档日志简介
Oracle可以将联机日志文件保存到多个不同的位置，将联机日志转换为归档日志的过程称之为归档。相应的日志被称为归档日志。  
#### 归档日志  
> 是联机重做日志组文件的一个副本。  
> 包含redo记录以及一个唯一的log sequence number。  
> 对日志组中的一个日志文件进行归档，如果该组其中一个损坏，则另一个可用的日志将会被归档。  
> 对于归档模式的日志切换，当日志归档完成后，下一个日志才能被覆盖或重新使用。  
> 自动归档功能如开启，则后台进程arcn在日志切换时自动完成归档，否则需要手动归档。   

归档日志用途：  

* 恢复数据库
* 更新standby数据库
* 使用LogMiner 提取历史日志的相关信息

#### 日志的两种模式

1. 非归档模式

        不适用与生产数据库
        创建数据库时，缺省的日志管理模式为非归档模式
        当日志切换，检查点产生后，联机重做日志文件即可被重新使用
        联机日志被覆盖后，介质恢复仅仅支持到最近的完整备份
        不支持联机备份表空间，一个表空间损坏将导致整个数据库不可用，需要删除掉损坏的表空间或从备份恢复
        对于操作系统级别的数据库备份需要将数据库一致性关闭
        应当备份所有的数据文件、控制文件(单个)、参数文件、密码文件、联机日志文件(可选)
2. 归档模式

        能够对联机日志文件进行归档，生产数据库强烈建议归档
        在日志切换时，下一个即将被写入日志组必须归档完成之后，日志组才可以使用
        归档日志的Log sequence number信息会记录到控制文件之中
        必须有足够的磁盘空间用于存放归档日志
        Oracle 9i 需要设置参数log_archive_start=true 才能够进行自动归档
        备份与恢复
                支持热备份，且当某个非系统表空间损坏，数据库仍然处于可用状态，且支持在线恢复
                使用归档日志能够实现联机或脱机时点恢复(即可以恢复到指定的时间点、指定的归档日志或指定的SCN)
两种模式的切换：

        C:\Users\zclf>sqlplus /nolog
        SQL> conn sys/password as sysdba
        已连接。
        SQL> archive log list
        数据库日志模式             非存档模式
        自动存档             禁用
        存档终点            USE_DB_RECOVERY_FILE_DEST
        最早的联机日志序列     12
        当前日志序列           14
        SQL> shutdown immediate;
        数据库已经关闭。
        已经卸载数据库。
        ORACLE 例程已经关闭。
        
        SQL> startup mount;
        ORACLE 例程已经启动。
        
        Total System Global Area 3390558208 bytes
        Fixed Size                  2180464 bytes
        Variable Size            1962936976 bytes
        Database Buffers         1409286144 bytes
        Redo Buffers               16154624 bytes
        数据库装载完毕。
        SQL> alter database archivelog;
        
        数据库已更改。
        
        SQL> alter database open;
        
        数据库已更改。
        
        SQL> archive log list;
        数据库日志模式            存档模式
        自动存档             启用
        存档终点            USE_DB_RECOVERY_FILE_DEST
        最早的联机日志序列     12
        下一个存档日志序列   14
        当前日志序列           14
        SQL>
