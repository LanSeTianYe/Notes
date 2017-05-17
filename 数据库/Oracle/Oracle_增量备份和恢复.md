## 备份前的准备
创建数据库：

    create table process(name varchar(200));

插入数据 ：

    insert into process values('0级备份之前');

数据库信息，需要sysdba身份登录

    SQL> archive log list;
    数据库日志模式            存档模式
    自动存档             启用
    存档终点            USE_DB_RECOVERY_FILE_DEST
    最早的联机日志序列     41
    下一个存档日志序列   43
    当前日志序列           43
备份记录：

    RMAN> list backup;
    说明与资料档案库中的任何备份都不匹配
数据库当前时间：

    SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;
    
    TO_CHAR(SYSDATE,'
    -----------------
    16-03-03 15:12:19

## 增加数据并且备份
#### 数据库配置信息:

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

#### 第一次备份，进行0级备份：

    RMAN> backup incremental level 0 database plus archivelog;
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=41 RECID=28 STAMP=905505645
    输入归档日志线程=1 序列=42 RECID=29 STAMP=905518850
    输入归档日志线程=1 序列=43 RECID=30 STAMP=905526977
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151617_CFHS61N8_.BKP 标记=TAG20160303T151617 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:03
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动增量级别 0 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP 标记=TAG20160303T151620 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:25
    通道 ORA_DISK_1: 正在启动增量级别 0 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    备份集内包括当前的 SPFILE
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN0_TAG20160303T151620_CFHS6Z5V_.BKP 标记=TAG20160303T151620 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=44 RECID=31 STAMP=905527008
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151648_CFHS70NY_.BKP 标记=TAG20160303T151648 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
#### 0级备份完成时间

    SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;
    
    TO_CHAR(SYSDATE,'
    -----------------
    16-03-03 15:19:07
#### 第一次备份之后的文件

    RMAN> list backup;
    
    备份集列表
    ===================
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    97      46.69M     DISK        00:00:01     03-3月 -16
            BP 关键字: 97   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151617
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151617_CFHS61N8_.BKP
    
      备份集 97 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    98      Incr 0  1.11G      DISK        00:00:24     03-3月 -16
            BP 关键字: 98   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP
      备份集 98 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    99      Incr 0  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 99   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN0_TAG20160303T151620_CFHS6Z5V_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1149753      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    100     14.50K     DISK        00:00:00     03-3月 -16
            BP 关键字: 100   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151648
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151648_CFHS70NY_.BKP
    
      备份集 100 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
    
    RMAN>
#### 插入数据

    insert into process values('0级备份之后');
    insert into process values('0级备份之后和第二次备份_1级差异增量备份之间');

    时间
    
        SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;
        
        TO_CHAR(SYSDATE,'
        -----------------
        16-03-03 15:27:20

    insert into process values('第二次备份_1级差异增量备份之前');

#### 第二次备份，1级差异增量备份（备份上级或同计备份之后的变化）

    RMAN> backup incremental level 1 database plus archivelog;
    
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=41 RECID=28 STAMP=905505645
    输入归档日志线程=1 序列=42 RECID=29 STAMP=905518850
    输入归档日志线程=1 序列=43 RECID=30 STAMP=905526977
    输入归档日志线程=1 序列=44 RECID=31 STAMP=905527008
    输入归档日志线程=1 序列=45 RECID=32 STAMP=905528198
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153638_CFHTD6XS_.BKP 标记=TAG20160303T153638 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动增量级别 1 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP 标记=TAG20160303T153640 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:25
    通道 ORA_DISK_1: 正在启动增量级别 1 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    备份集内包括当前的 SPFILE
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T153640_CFHTF2K0_.BKP 标记=TAG20160303T153640 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=46 RECID=33 STAMP=905528227
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153707_CFHTF406_.BKP 标记=TAG20160303T153707 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:02
    完成 backup 于 03-3月 -16

#### 第二次备份完成时间

    SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;
    
    TO_CHAR(SYSDATE,'
    -----------------
    16-03-03 15:37:54
#### 第二次备份之后，数据集列表

    RMAN> list backup;
    
    备份集列表
    ===================
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    97      46.69M     DISK        00:00:01     03-3月 -16
            BP 关键字: 97   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151617
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151617_CFHS61N8_.BKP
    
      备份集 97 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    98      Incr 0  1.11G      DISK        00:00:24     03-3月 -16
            BP 关键字: 98   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP
      备份集 98 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    99      Incr 0  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 99   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN0_TAG20160303T151620_CFHS6Z5V_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1149753      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    100     14.50K     DISK        00:00:00     03-3月 -16
            BP 关键字: 100   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151648
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151648_CFHS70NY_.BKP
    
      备份集 100 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    101     47.66M     DISK        00:00:01     03-3月 -16
            BP 关键字: 101   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153638
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153638_CFHTD6XS_.BKP
    
      备份集 101 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
      1    45      1149759    03-3月 -16 1150910    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    102     Incr 1  1.84M      DISK        00:00:21     03-3月 -16
            BP 关键字: 102   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153640
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP
      备份集 102 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    103     Incr 1  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 103   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153640
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T153640_CFHTF2K0_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1150956      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    104     230.50K    DISK        00:00:01     03-3月 -16
            BP 关键字: 104   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153707
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153707_CFHTF406_.BKP
    
      备份集 104 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    46      1150910    03-3月 -16 1150961    03-3月 -16
    
    RMAN>

##### 插入数据


    insert into process values('第二次备份_1级差异增量备份之后');
    insert into process values('第二次备份_1级差异增量备份之后和第三次备份_1级累计增量备份之间');

    时间
        SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;

        TO_CHAR(SYSDATE,'
        -----------------
        16-03-03 15:44:45

    insert into process values('第三次备份_1级累计增量备份之前');

#### 第三次备份，1级累积增量备份
    
    RMAN> backup incremental level 1 cumulative database plus archivelog;
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=41 RECID=28 STAMP=905505645
    输入归档日志线程=1 序列=42 RECID=29 STAMP=905518850
    输入归档日志线程=1 序列=43 RECID=30 STAMP=905526977
    输入归档日志线程=1 序列=44 RECID=31 STAMP=905527008
    输入归档日志线程=1 序列=45 RECID=32 STAMP=905528198
    输入归档日志线程=1 序列=46 RECID=33 STAMP=905528227
    输入归档日志线程=1 序列=47 RECID=34 STAMP=905529052
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155052_CFHV6W6J_.BKP 标记=TAG20160303T155052 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:03
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动增量级别 1 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T155055_CFHV6ZL9_.BKP 标记=TAG20160303T155055 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:25
    通道 ORA_DISK_1: 正在启动增量级别 1 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    备份集内包括当前的 SPFILE
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T155055_CFHV7SOS_.BKP 标记=TAG20160303T155055 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
    
    启动 backup 于 03-3月 -16
    当前日志已存档
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动归档日志备份集
    通道 ORA_DISK_1: 正在指定备份集内的归档日志
    输入归档日志线程=1 序列=48 RECID=35 STAMP=905529082
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155122_CFHV7V18_.BKP 标记=TAG20160303T155122 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
    
    RMAN>

#### 第三次备份完成时间

    SQL> select to_char(sysdate,'yy-mm-dd hh24:mi:ss') from dual;
    
    TO_CHAR(SYSDATE,'
    -----------------
    16-03-03 15:52:36
#### 第三次备份之后的备份集


    RMAN> list backup;
    
    备份集列表
    ===================
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    97      46.69M     DISK        00:00:01     03-3月 -16
            BP 关键字: 97   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151617
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151617_CFHS61N8_.BKP
    
      备份集 97 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    98      Incr 0  1.11G      DISK        00:00:24     03-3月 -16
            BP 关键字: 98   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP
      备份集 98 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    0  Incr 1149727    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    99      Incr 0  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 99   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151620
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN0_TAG20160303T151620_CFHS6Z5V_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1149753      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    100     14.50K     DISK        00:00:00     03-3月 -16
            BP 关键字: 100   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T151648
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151648_CFHS70NY_.BKP
    
      备份集 100 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    101     47.66M     DISK        00:00:01     03-3月 -16
            BP 关键字: 101   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153638
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153638_CFHTD6XS_.BKP
    
      备份集 101 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
      1    45      1149759    03-3月 -16 1150910    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    102     Incr 1  1.84M      DISK        00:00:21     03-3月 -16
            BP 关键字: 102   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153640
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP
      备份集 102 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    1  Incr 1150916    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    103     Incr 1  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 103   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153640
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T153640_CFHTF2K0_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1150956      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    104     230.50K    DISK        00:00:01     03-3月 -16
            BP 关键字: 104   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T153707
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153707_CFHTF406_.BKP
    
      备份集 104 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    46      1150910    03-3月 -16 1150961    03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    105     48.36M     DISK        00:00:01     03-3月 -16
            BP 关键字: 105   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T155052
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155052_CFHV6W6J_.BKP
    
      备份集 105 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    41      1096736    02-3月 -16 1118298    03-3月 -16
      1    42      1118298    03-3月 -16 1139240    03-3月 -16
      1    43      1139240    03-3月 -16 1149720    03-3月 -16
      1    44      1149720    03-3月 -16 1149759    03-3月 -16
      1    45      1149759    03-3月 -16 1150910    03-3月 -16
      1    46      1150910    03-3月 -16 1150961    03-3月 -16
      1    47      1150961    03-3月 -16 1151730    03-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    106     Incr 1  2.24M      DISK        00:00:19     03-3月 -16
            BP 关键字: 106   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T155055
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T155055_CFHV6ZL9_.BKP
      备份集 106 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    1  Incr 1151736    03-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    107     Incr 1  9.77M      DISK        00:00:01     03-3月 -16
            BP 关键字: 107   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T155055
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T155055_CFHV7SOS_.BKP
      包含的 SPFILE: 修改时间: 03-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1151744      Ckp 时间: 03-3月 -16
    
    BS 关键字  大小       设备类型占用时间 完成时间
    ------- ---------- ----------- ------------ ----------
    108     5.50K      DISK        00:00:00     03-3月 -16
            BP 关键字: 108   状态: AVAILABLE  已压缩: NO  标记: TAG20160303T155122
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155122_CFHV7V18_.BKP
    
      备份集 108 中的已存档日志列表
      线程序列     低 SCN    时间下限   下一个 SCN   下一次
      ---- ------- ---------- ---------- ---------- ---------
      1    48      1151730    03-3月 -16 1151750    03-3月 -16
    RMAN>

## 开始恢复

#### 进行一次控制文件的备份

    RMAN> backup current controlfile;
    
    启动 backup 于 03-3月 -16
    分配的通道: ORA_DISK_1
    通道 ORA_DISK_1: SID=63 设备类型=DISK
    通道 ORA_DISK_1: 正在启动全部数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    备份集内包括当前控制文件
    通道 ORA_DISK_1: 正在启动段 1 于 03-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 03-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCNNF_TAG20160303T162247_CFHX2RSN_.BKP 标记=TAG20160303T162247 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:01
    完成 backup 于 03-3月 -16
#### spfile的位置

    SQL> show parameter spfile;
    
    NAME                                 TYPE        VALUE
    ------------------------------------ ----------- ------------------------------
    spfile                               string      I:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\SPFILEORCL.ORA
    SQL>
#### 删除所有的数据库文件
关闭数据库
    
    RMAN> shutdown immediate;
    数据库已关闭
    数据库已卸装
    Oracle 实例已关闭
进入目录，删除数据库文件
删除了控制文件，数据库文件和日志文件，之后数据库不能启动。

#### 查看数据库的dbid

    SQL> select dbid from v$database;
    
          DBID
    ----------
    1433138754
    
    SQL>
#### 启动数据库

    RMAN> startup;
    
    启动失败: ORA-01078: failure in processing system parameters
    LRM-00109: ???????????????? 'I:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\INITORCL.ORA'
    
    在没有参数文件的情况下启动 Oracle 实例以检索 spfile
    RMAN-00571: ===========================================================
    RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
    RMAN-00571: ===========================================================
    RMAN-03002: startup 命令 (在 03/03/2016 16:45:31 上) 失败
    RMAN-04025: 无法生成临时文件

#### 连接rman，设置dbid

    C:\Users\zclf>rman target sys/password;
    
    恢复管理器: Release 11.2.0.1.0 - Production on 星期四 3月 3 16:46:44 2016
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    已连接到目标数据库 (未启动)
    
    RMAN> set dbid 1433138754;
    
    正在执行命令: SET DBID
#### 启动数据库

RMAN> startup nomount;

    启动失败: ORA-01078: failure in processing system parameters
    LRM-00109: ???????????????? 'I:\ORACLE\PRODUCT\11.2.0\DBHOME_1\DATABASE\INITORCL.ORA'
    
    在没有参数文件的情况下启动 Oracle 实例以检索 spfile
    RMAN-00571: ===========================================================
    RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
    RMAN-00571: ===========================================================
    RMAN-03002: startup 命令 (在 03/03/2016 16:48:48 上) 失败
    RMAN-04025: 无法生成临时文件
####  从第二次增量备份恢复控制文件

    RMAN>  restore controlfile from "I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP";
    
    启动 restore 于 03-3月 -16
    使用通道 ORA_DISK_1
    
    通道 ORA_DISK_1: 正在还原控制文件
    通道 ORA_DISK_1: 还原完成, 用时: 00:00:01
    输出文件名=I:\ORACLE\ORADATA\ORCL\CONTROL01.CTL
    输出文件名=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\CONTROL02.CTL
    完成 restore 于 03-3月 -16
####　恢复第二次增量备份之后和第三次增量备份之前之间　时的数据文件

恢复第二次增量备份时的数据文件

    run
    {
        alter database mount;
        //set until time "to_date('16-03-03 15:44:45','yy-mm-dd hh24:mi:ss')";
        restore database from "I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP";
    }
输出内容：

    RMAN> run{
    2>         alter database mount;
    3>         set until time "to_date('16-03-03 15:44:45','yy-mm-dd hh24:mi:ss')";
    4>         restore database;
    5>     }
    
    数据库已装载
    释放的通道: ORA_DISK_1
    
    正在执行命令: SET until clause
    
    启动 restore 于 03-3月 -16
    启动 implicit crosscheck backup 于 03-3月 -16
    分配的通道: ORA_DISK_1
    通道 ORA_DISK_1: SID=63 设备类型=DISK
    已交叉检验的 2 对象
    完成 implicit crosscheck backup 于 03-3月 -16
    
    启动 implicit crosscheck copy 于 03-3月 -16
    使用通道 ORA_DISK_1
    完成 implicit crosscheck copy 于 03-3月 -16
    
    搜索恢复区中的所有文件
    正在编制文件目录...
    目录编制完毕
    
    已列入目录的文件的列表
    =======================
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\ARCHIVELOG\2016_03_03\O1_MF_1_44_CFHS70HJ_.ARC
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\ARCHIVELOG\2016_03_03\O1_MF_1_45_CFHTD6OT_.ARC
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\ARCHIVELOG\2016_03_03\O1_MF_1_46_CFHTF3SL_.ARC
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\ARCHIVELOG\2016_03_03\O1_MF_1_47_CFHV6VY7_.ARC
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\ARCHIVELOG\2016_03_03\O1_MF_1_48_CFHV7TW1_.ARC
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T151648_CFHS70NY_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153638_CFHTD6XS_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T153707_CFHTF406_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155052_CFHV6W6J_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_ANNNN_TAG20160303T155122_CFHV7V18_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCNNF_TAG20160303T162247_CFHX2RSN_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN0_TAG20160303T151620_CFHS6Z5V_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T153640_CFHTF2K0_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NCSN1_TAG20160303T155055_CFHV7SOS_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T153640_CFHTD8BT_.BKP
    文件名: I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND1_TAG20160303T155055_CFHV6ZL9_.BKP
    
    使用通道 ORA_DISK_1
    
    通道 ORA_DISK_1: 正在开始还原数据文件备份集
    通道 ORA_DISK_1: 正在指定从备份集还原的数据文件
    通道 ORA_DISK_1: 将数据文件 00001 还原到 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    通道 ORA_DISK_1: 将数据文件 00002 还原到 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    通道 ORA_DISK_1: 将数据文件 00003 还原到 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    通道 ORA_DISK_1: 将数据文件 00004 还原到 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 将数据文件 00005 还原到 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    通道 ORA_DISK_1: 将数据文件 00006 还原到 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    通道 ORA_DISK_1: 正在读取备份片段 I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP
    通道 ORA_DISK_1: 段句柄 = I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_03\O1_MF_NNND0_TAG20160303T151620_CFHS650C_.BKP 标记 = TAG20160303T151620
    通道 ORA_DISK_1: 已还原备份片段 1
    通道 ORA_DISK_1: 还原完成, 用时: 00:00:35
    完成 restore 于 03-3月 -16
##### 恢复数据库

    run {
        alter database mount;
        set until time "to_date('16-03-03 15:44:45','yy-mm-dd hh24:mi:ss')";
        recover database;
    }
##### ...
到这里实验进行不下去了。。。。


## 简单的数据恢复

##### 恢复到一个时间点

    run {
        shutdown immediate;
        startup mount;
        set until time "to_date('16-03-04 15:15:03','yy-mm-dd hh24:mi:ss')";
        restore database;
        recover database;
        sql 'alter database open resetlogs';
    }
先卸载数据库，然后以mount的方式打开，设置时间点，开始恢复，恢复完成之后打开数据库。能恢复到指定时间数据库的状态。

#### 从备份完全恢复

    run {
        shutdown immediate;
        startup mount;
        restore database;
        recover database;
        startup;
    }
可以恢复最新的数据库内容

#### 恢复到其他主机上
需要查看数据库的dbid

    RMAN> connect target sys/enerbos_123
    
    连接到目标数据库: ORCL (DBID=1433138754)

