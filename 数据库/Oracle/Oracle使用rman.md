##### rman连接到数据库
###### 连接到本地数据库
    
    set oracle_sid=orcl
    rman target username/password
注：orcl为数据库实例的名字，username使用sys，密码使用系统的密码。

###### 连接到远程数据库
    rman
然后

    connect target /@192.168.1.66:1521/orcl2
###### 记录操作日志
开启操作日志之后，cmd命令框里面，不会显示操作的记录，操作记录会被直接写入到指定的文件中。

    rman target sys/enerbos_123 log d:\rman_log.txt
###### 退出连接

    RMAN> exit

###### 启动或关闭数据库
关闭数据库之后，数据库不能连接连接。

    RMAN> shutdown immediate
    数据库已关闭
    数据库已卸装
    Oracle 实例已关闭

    RMAN> startup
    已连接到目标数据库 (未启动)
    Oracle 实例已启动
    数据库已装载
    数据库已打开
    系统全局区域总计    3390558208 字节
    Fixed Size                     2180464 字节
    Variable Size               1962936976 字节
    Database Buffers            1409286144 字节
    Redo Buffers                  16154624 字节
也可以执行startup mount，然后再利用alter database open命令打开数据库以及shutdown normal,shutdown abort等。
###### 返回操作系统的cmd框
    
    RMAN> host;
    Microsoft Windows [版本 10.0.10586]
    (c) 2015 Microsoft Corporation。保留所有权利。
    C:\Users\zclf>exit
    主机命令完成
    RMAN> 

###### rman配置

    RMAN> show all;
    
    db_unique_name 为 ORCL 的数据库的 RMAN 配置参数为:
    CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
    CONFIGURE BACKUP OPTIMIZATION OFF; # default
    CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
    CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
    CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
    CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
    CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
    CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
    CONFIGURE MAXSETSIZE TO UNLIMITED; # default
    CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
    CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
    CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
    CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
    CONFIGURE SNAPSHOT CONTROLFILE NAME TO 'I:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\SNCFORCL.ORA'; # default

注：配置项后面跟了# default的表示该项仍是初始配置，未被修改过。

该命令使用也相当灵活，其后跟上不同的类型的配置参数，即可以显示不同类型的配置，如：
    
    SHOW CHANNEL;
    
    SHOW DEVICE TYPE;
    
    SHOW DEFAULT DEVICE TYPE;
##### 备份形式
1. 镜像复制(Image Copies)  
镜像复制实际上就是数据文件、控制文件或归档文件的复制，与用户通过操作系统命令建立的文件复制实质一样，只不过RMAN是利用目标数据库中的服务进程来完成文件复制，而用户则是用操作系统命令。所以镜像复制的方式体现不出RMAN的优势。
2. 备份集(Backup Sets)  
备份集是通过RMAN创建的逻辑备份对象。一个备份集中可以包含多个数据文件、控制文件或归档文件。备份集在物理上是由多个备份片段组成，每个备份片段是一个操作系统文件。  

注：进行RMAN的备份是非Catalog的备份，非Catalog的备份是将备份信息写入到Control File文件中，那么你的Archive Log模式必须为存档模式才行。

    SQL> archive log list
    数据库日志模式             非存档模式
    自动存档             禁用
    存档终点            USE_DB_RECOVERY_FILE_DEST
    最早的联机日志序列     12
    当前日志序列           14
    SQL>
更改数据库日志模式

    SQL> alter database archivelog;
    alter database archivelog
    *
    第 1 行出现错误:
    ORA-01126: 数据库必须已装载到此实例并且不在任何实例中打开
    SQL>
不能直接更改存档模式，必须在mount状态下开启

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

###### 完全备份
普通备份

    RMAN> backup database;
    启动 backup 于 02-3月 -16
    使用目标数据库控制文件替代恢复目录
    分配的通道: ORA_DISK_1
    通道 ORA_DISK_1: SID=134 设备类型=DISK
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T105523_CFDOJVW3_.BKP 标记=TAG20160302T105523 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:25
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    备份集内包括当前的 SPFILE
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCSNF_TAG20160302T105523_CFDOKOTO_.BKP 标记=TAG20160302T105523 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 02-3月 -16
备份到指定位置

    RMAN> backup database format "d:\backup\%U";
    
    启动 backup 于 02-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=D:\BACKUP\0BQVFC65_1_1 标记=TAG20160302T105813 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:35
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    备份集内包括当前的 SPFILE
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=D:\BACKUP\0CQVFC78_1_1 标记=TAG20160302T105813 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 02-3月 -16
###### 查看备份信息

    RMAN> list backup of database;
    
    备份集列表
    ===================
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    4       Full    1.09G      DISK        00:00:23     02-3月 -16
            BP 关键字: 4   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T105523
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T105523_CFDOJVW3_.BKP
      备份集 4 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6       Full 1068754    02-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    6       Full    1.10G      DISK        00:00:27     02-3月 -16
            BP 关键字: 6   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T105813
    段名:D:\BACKUP\0BQVFC65_1_1
      备份集 6 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF

###### 备份表空间
只要实例启动并处于加载状态，不论数据库是否打开，都可以在rman中对表空间进行备份。

    RMAN> backup tablespace enerbos;
    
    启动 backup 于 02-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T110152_CFDOX0BR_.BKP 标记=TAG20160302T110152 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:03
    完成 backup 于 02-3月 -16
    
    RMAN> backup tablespace enerbos format "d:\backup\%U";
    
    启动 backup 于 02-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=D:\BACKUP\0EQVFCEP_1_1 标记=TAG20160302T110249 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:03
    完成 backup 于 02-3月 -16
###### 查看表空间的备份

    RMAN> list backup of tablespace enerbos;
###### 备份指定数据文件
1. 查看表空间对应的数据文件及其序号

        SQL> select  file_name,file_id,tablespace_name  from  dba_data_files;
        
        FILE_NAME
        --------------------------------------------------------------------------------
           FILE_ID TABLESPACE_NAME
        ---------- ------------------------------
        I:\ORACLE\ORADATA\ORCL\USERS01.DBF
                 4 USERS
        
        I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
                 3 UNDOTBS1
        
        I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
                 2 SYSAUX
        
        
        FILE_NAME
        --------------------------------------------------------------------------------
           FILE_ID TABLESPACE_NAME
        ---------- ------------------------------
        I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
                 1 SYSTEM
        
        I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
                 5 EXAMPLE
        
        I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
                 6 ENERBOS
        
        
        已选择6行。
2. 备份指定的文件

        RMAN> backup datafile 1;
        
        启动 backup 于 02-3月 -16
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T111747_CFDPTVG0_.BKP 标记=TAG20160302T111747 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:03:46
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        备份集内包括当前控制文件
        备份集内包括当前的 SPFILE
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCSNF_TAG20160302T111747_CFDQ1Z17_.BKP 标记=TAG20160302T111747 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
        完成 backup 于 02-3月 -16
        
        RMAN>
3. 查看指定数据文件的备份

        RMAN> list backup of datafile 1;
        
        备份集列表
        ===================
        
        BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
        ------- ---- -- ---------- ----------- ------------ ----------
        6       Full    1.10G      DISK        00:00:27     02-3月 -16
                BP 关键字: 6   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T105813
        段名:D:\BACKUP\0BQVFC65_1_1
          备份集 6 中的数据文件列表
          文件 LV 类型 Ckp SCN    Ckp 时间   名称
          ---- -- ---- ---------- ---------- ----
          1       Full 1069584    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
        
        BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
        ------- ---- -- ---------- ----------- ------------ ----------
        10      Full    590.14M    DISK        00:00:11     02-3月 -16
                BP 关键字: 10   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T111747
        段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T111747_CFDPTVG0_.BKP
          备份集 10 中的数据文件列表
          文件 LV 类型 Ckp SCN    Ckp 时间   名称
          ---- -- ---- ---------- ---------- ----
          1       Full 1071729    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
        
        RMAN>
###### 备份控制文件的方法
1. 最简单的方式，通过CONFIGURE命令将CONTROLFILE AUTOBACKUP置为ON。然后你再通过rman做任何备份操作的同时，都会自动对控制文件做备份。在自动备份打开的情况下，备份任意表空间操作时，RMAN均会自动对控制文件做备份。

        RMAN> configure controlfile autobackup on;
        
        新的 RMAN 配置参数:
        CONFIGURE CONTROLFILE AUTOBACKUP ON;
        已成功存储新的 RMAN 配置参数
2. 执行备份命令

        RMAN> backup current controlfile;
        
        启动 backup 于 02-3月 -16
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        备份集内包括当前控制文件
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCNNF_TAG20160302T112653_CFDQCYCK_.BKP 标记=TAG20160302T112653 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
        完成 backup 于 02-3月 -16
        
        启动 Control File and SPFILE Autobackup 于 02-3月 -16
        段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905426815_CFDQCZP1_.BKP comment=NONE
        完成 Control File and SPFILE Autobackup 于 02-3月 -16
3. 执行backup时指定 `include current controlfile` 参数，例如：

        RMAN> backup database include current controlfile;
        
        启动 backup 于 02-3月 -16
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
        输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
        输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
        输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
        输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
        输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T112842_CFDQHBD7_.BKP 标记=TAG20160302T112842 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:35
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        备份集内包括当前控制文件
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCNNF_TAG20160302T112842_CFDQJGJ3_.BKP 标记=TAG20160302T112842 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
        完成 backup 于 02-3月 -16
        
        启动 Control File and SPFILE Autobackup 于 02-3月 -16
        段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905426959_CFDQJHTJ_.BKP comment=NONE
        完成 Control File and SPFILE Autobackup 于 02-3月 -16
4. 查看备份的控制文件

        RMAN> list backup of controlfile;
        
        备份集列表
        ===================
        
        BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
        ------- ---- -- ---------- ----------- ------------ ----------
        1       Full    9.36M      DISK        00:00:01     02-3月 -16
                BP 关键字: 1   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T103046
        段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCSNF_TAG20160302T103046_CFDN2QK7_.BKP
          包括的控制文件: Ckp SCN: 1066750      Ckp 时间: 02-3月 -16
        
        BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
        ------- ---- -- ---------- ----------- ------------ ----------
        2       Full    9.36M      DISK        00:00:02     02-3月 -16
                BP 关键字: 2   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T103128
        段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NCSNF_TAG20160302T103128_CFDN420L_.BKP
          包括的控制文件: Ckp SCN: 1066808      Ckp 时间: 02-3月 -16
        
        BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
###### 备份归档日志文件
归档日志对于数据库介质恢复相当关键，其虽然不像控制文件那样一旦损坏则数据库马上崩溃但重要性丝毫不减。归档日志文件能确保我们将数据库恢复到备份之前的任意时刻。在RMAN中备份归档日志有两种方式：  
1. 利用 ` backup archivelog` 命令备份

    RMAN> backup archivelog all;
    
    启动 backup 于 02-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=14 RECID=1 STAMP=905427311
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_ANNNN_TAG20160302T113511_CFDQVH5N_.BKP 标记=TAG20160302T113511 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 02-3月 -16
    
    启动 Control File and SPFILE Autobackup 于 02-3月 -16
    段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905427312_CFDQVJL1_.BKP comment=NONE
    完成 Control File and SPFILE Autobackup 于 02-3月 -16
2. 在backup过程中利用 `plus archivelog` 参数备份,在备份数据库的同时自动对所有归档文件进行备份。

        RMAN> backup database plus archivelog;
        
        启动 backup 于 02-3月 -16
        当前日志已存档
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动归档日志备份集
        通道 ORA_DISK_1: 正在指定备份集内的归档日志
        输入归档日志线程=1 序列=14 RECID=1 STAMP=905427311
        输入归档日志线程=1 序列=15 RECID=2 STAMP=905427378
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_ANNNN_TAG20160302T113618_CFDQXLSL_.BKP 标记=TAG20160302T113618 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
        完成 backup 于 02-3月 -16
        
        启动 backup 于 02-3月 -16
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动全部数据文件备份集
        通道 ORA_DISK_1: 正在指定备份集内的数据文件
        输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
        输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
        输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
        输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
        输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
        输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNNDF_TAG20160302T113619_CFDQXN4M_.BKP 标记=TAG20160302T113619 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:35
        完成 backup 于 02-3月 -16
        
        启动 backup 于 02-3月 -16
        当前日志已存档
        使用通道 ORA_DISK_1
        通道 ORA_DISK_1: 正在启动归档日志备份集
        通道 ORA_DISK_1: 正在指定备份集内的归档日志
        输入归档日志线程=1 序列=16 RECID=3 STAMP=905427415
        通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
        通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
        段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_ANNNN_TAG20160302T113655_CFDQYQH5_.BKP 标记=TAG20160302T113655 注释=NONE
        通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
        完成 backup 于 02-3月 -16
        
        启动 Control File and SPFILE Autobackup 于 02-3月 -16
        段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905427416_CFDQYRVY_.BKP comment=NONE
        完成 Control File and SPFILE Autobackup 于 02-3月 -16

这种方式与上种的区别，`backup database plus archivelog` 命令在备份过程中会依次执行下列步骤：  

    1. 运行ALTER SYSTEM ARCHIVE LOG CURRENT语句对当前redolog进行归档。
    
    2. 执行BACKUP ARCHIVELOG ALL命令备份所有已归档日志。
    
    3. 执行BACKUP命令对指定项进行备份。
    
    4. 再次运行ALTER SYSTEM ARCHIVE LOG CURRENT对当前redolog归档。
    
    5. 对新生成的尚未备份的归档文件进行备份。

在完成归档日志文件备份后，我们通过需要删除已备份过的归档文件(归档文件记录下了数据库进行过的所有操作，如果数据库操作频繁而且量大，那归档文件大小也是相当恐怖，备份后删除释放存储空间是相当有必要地)。RMAN提供了 `delete all input` 参数，加在BACKUP命令后，则会在完成备份后自动删除归档目录中已备份的归档日志。

    backup database plus archivelog delete all input;

###### 删除备份
用于删除RMAN备份记录及相应的物理文件。当使用RMAN执行备份操作时，会在RMAN资料库中生成RMAN备份记录，并且RMAN备份记录被存放在目标数据库的控制文件中，如果配置了恢复目录，那么该备份记录也会被存放到恢复目录中。  

1. 删除陈旧备份  
当使用RMAN执行备份操作时，RMAN会根据备份冗余策略确定陈旧备份。

        RMAN> delete obsolete ;
2. 删除EXPIRED备份  
执行crosscheck命令核对备份集，那么会将该备份集标记为EXPIRED状态。为了删除相应的备份记录，可以执行delete expired backup命令。

        RMAN> delete expired backup;
3. 删除EXPIRED副本

        RMAN> delete expired copy;
4. 删除特定备份集

        RMAN> delete backupset 19;
5. 删除特定备份片

        RMAN> delete backuppiece ¨d:\backup\DEMO_19.bak¨;
6. 删除所有备份集

        RMAN> delete backup;
7. 删除特定映像副本

        RMAN> delete datafilecopy ¨d:\backup\DEMO_19.bak¨;
8. 删除所有映像副本

        RMAN> delete copy;
9. 在备份后删除输入对象

        RMAN> delete archivelog all delete input;
        RMAN> delete backupset 22 format = "d:\backup\%u.bak" delete input;
###### FORMAT字符串替代变量
使用FORMAT参数时可使用的各种替换变量，如下：  

1. %c ：备份片的拷贝数(从1开始编号)
2. %d ：数据库名称
3. %D ：位于该月中的天数 (DD)
4. %M ：位于该年中的月份 (MM)
5. %F ：一个基于DBID 唯一的名称,这个格式的形式为c-IIIIIIIIII-YYYYMMDD-QQ,其中IIIIIIIIII 为该数据库的DBID，YYYYMMDD 为日期，QQ 是一个1-256 的序列
6. %n ：数据库名称，并且会在右侧用x字符进行填充，使其保持长度为8
7. %u ：是一个由备份集编号和建立时间压缩后组成的8字符名称。利用%u可以为每个备份集生成一个唯一的名称
8. %p ：表示备份集中备份片段的编号，从1开始编号
9. %U ：是 `%u_%p_%c` 的简写形式，利用它可以为每一个备份片段（即磁盘文件）生成一个唯一名称，这是最常用的命名方式
10. %s ：备份集的号
11. %t ：备份集时间戳
12. %T ：年月日格式(YYYYMMDD)  

注：如果在BACKUP命令中没有指定FORMAT选项，则RMAN默认使用%U为备份片段命名。
###### CONFIGURE配置
* 查看配置项

        MAN> show all;
        
        使用目标数据库控制文件替代恢复目录
        db_unique_name 为 ORCL 的数据库的 RMAN 配置参数为:
        CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
        CONFIGURE BACKUP OPTIMIZATION OFF; # default
        CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
        CONFIGURE CONTROLFILE AUTOBACKUP ON;
        CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
        CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
        CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
        CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
        CONFIGURE MAXSETSIZE TO UNLIMIT
* 把更改过的配置项改回默认的配置

        configure *** clear;
        例如:
        configure retention policy clear;
###### `CONFIGURE RETENTION POLICY` 配置备份保留策略

* 基于时间：

        CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF  n  DAYS;
* 基于冗余数量：

        CONFIGURE RETENTION POLICY TO REDUNDANCY  n ;
* 也可以取消备份保留策略：

        CONFIGURE RETENTION POLICY TO NONE;
###### `CONFIGURE BACKUP OPTIMIZATION` 配置备份优化

* 打开备份优化：

        CONFIGURE BACKUP OPTIMIZATION ON;
* 关闭备份优化：

        CONFIGURE BACKUP OPTIMIZATION O FF ;
###### `CONFIGURE DEFAULT DEVICE TYPE`  配置IO设备类型

RMAN 支持的IO设备类型有两种：磁盘(DISK)和磁带(SBT)，默认情况下为磁盘。

  * 使用磁盘设备：
    
        CONFIGURE DEFAULT DEVICE TYPE TO DISK;
    
  * 使用磁带设置：
    
        CONFIGURE DEFAULT DEVICE TYPE TO SBT;

  * 在这里需要注意的一点是：如果IO设备发生变化，相关配置项也需要修改。例如：

        RMAN> CONFIGURE DEVICE TYPE  DISK  PARALLELISM 2;


###### `CONFIGURE CONTROLFILE AUTOBACKUP` 配置控制文件自动备份

是否自动备份，包含两个状态：OFF和ON

打开自动备份

    CONFIGURE CONTROLFILE AUTOBACKUP  ON
禁止自动备份

    CONFIGURE CONTROLFILE AUTOBACKUP  OFF
同时可以通过如下配置指定备份的控制格式，路径。例如：

    CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE  TYPE   DISK TO ¨d:/backup/%F¨;

在备份期间，将产生一个控制文件的快照，用于控制文件的读一致性，这个快照可以通过如下配置：

    CONFIGURE SNAPSHOT CONTROLFILE NAME TO ¨ D:/BACKUP/ SNCFJSSWEB.ORA¨;

###### `CONFIGURE DEVICE TYPE`  设置并行备份
RMAN 支持并行备份与恢复，也可以在配置中指定默认的并行程度。例如：

    CONFIGURE DEVICE TYPE DISK PARALLELISM 2;

指定在以后的备份与恢复中，将采用并行度为2，同时开启2个通道进行备份与恢复，当然也可以在run中指定通道来决定备份与恢复的并行程度。

并行的数目决定了开启通道的个数。如果指定了通道配置，将采用指定的通道，如果没有指定通道，将采用默认通道配置。有点儿绕是吧，我来给你白话一把。

默认情况下，自动分配通道的并行度为1，如果你通过设置PARALLELISM设置了并行通道为2，那么在run块中，如果你没有单独通过ALLOCATE CHANNEL命令指定通道，它会默认使用2条并行通道，如果你在run命令块中指定了数个ALLOCATE CHANNEL，那么rman在执行备份命令时会以你设置的channel为准，而不管configure中配置了多少个并行通道。需要注意的一点是，在backup命令中有一个FILESPERSET参数，该参数是指rman建立的每个备份集中所能包含的备份片段(即磁盘文件)的最大数，该参数默认值为64，如果在执行backup命令时没有指定该参数值，那么rman会仅使用第一个通道来执行备份，其它通道将处于空闲状态。关于通道数与FILESPERSET值之间也有一个大小关系，逻辑稍显复杂这些就不多废话了，总之一条，filesperset值不要小于你设定的通道数。
    
* `通道数` 和 `filesperset`之间的关系: 一个参考标准是(文件/通道数)m,一个通道负责m个文件, 另外一个参考标准是文件集大小(filesperset)n，一个文件集包含n个文件。为了保证通道被最大化利用。当m>n时，按照n的大小确定备份集的大小，可以这样理解，如果一个通道负责的文件个数大于文件集的大小，则每个文件集的文件个数由文件集的大小确定。如果 m<n 则按照m的大小确定备份集的大小来保证通道被最大化利用，可以这样理解，如果一个通道负责的问价个数小于文件及的大小，则每个文件集的大小由一个通道负责的文件个数确定。


####### `CONFIGURE DATAFILE BACKUP COPIES`  设置备份文件冗余度

####### `CONFIGURE MAXSETSIZE  配置备份集的最大尺寸` 
该配置限制通道上备份集的最大尺寸。单位支持bytes,K,M,G。默认值是unlimited。