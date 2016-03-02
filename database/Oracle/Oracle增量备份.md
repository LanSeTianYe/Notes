## 增量备份
> 差异增量(Differential incremental backup)：差异增量备份备份的是自上一次同级别的差异备份或者是上一次更高级别的备份完成之后的数据库发生改变的数据块。（对于上级甚至平级的备份是认同的）
> 累积增量(Cumulative incremental backup)：备份的自上一次上一级增量备份完成以来数据库发生改变的数据块（对于上级是认同的）

Oracle中，增量备份时分等级的，级别从0开始，一级一级递增，不过实际上用的最多的也就是0级和1级了，0级增量备份是后面级别的增量备份的 基础，0级备份实际上就是一个完全备份，与普通的完全备份唯一的不同点是0级备份可以作为其他级别增量备份的基础，而普通的完全备份是不能的。  
从级别1开始，Oracle的增量备份分为差异增量备份和积累增量备份两种，其中差异增量备份备份的是自上一次同级别的差异备份或者是上一次更高级 别的备份完成之后的数据库发生改变的数据块；而积累增量备份则是备份的自上一次上一级增量备份完成以来数据库发生改变的数据块。在《Backup and Recovery User’s Guide》的“增量备份”一节中有两幅图很形象的描述了这两个增量备份之间的异同：  
![](http://itpubpic.img168.net/forum/itpub/attachment/08/92/45_016648_1094117661.gif)  
差异增量备份图示  
![](http://itpubpic.img168.net/forum/itpub/attachment/08/92/46_016648_1094117732.gif)  
积累增量备份图示  

如果数据库运行于不归档模式下，那么你只能在数据库干净关闭的情况下(以NORMAL、IMMEDIATE、TRANSACTIONAL方式关闭)才能进行一致性的增量备份，如果数据库运行于归档模式下，那即可以在数据库关闭状态进行，也可以在数据库打开状态进行备份。

### 打开归档模式

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
### 0级增量备份
全备和0级增量备份都是全备，但是也是有区别的，0级增量备份可以用于增量备份恢复的基础，而单独的全备不能用于增量备份的恢复基础！0级增量备份的命令如下：

    RMAN>  backup incremental level 0 database;
    
    启动 backup 于 02-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动增量级别 0 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNND0_TAG20160302T135100_CFDZT5B9_.BKP 标记=TAG20160302T135100 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:25
    完成 backup 于 02-3月 -16
    
    启动 Control File and SPFILE Autobackup 于 02-3月 -16
    段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905435486_CFDZTYO5_.BKP comment=NONE
    完成 Control File and SPFILE Autobackup 于 02-3月 -16
    
    RMAN> list backupset;
    
    备份集列表
    ===================
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    27      Incr 0  1.10G      DISK        00:00:23     02-3月 -16
            BP 关键字: 27   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135100
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNND0_TAG20160302T135100_CFDZT5B9_.BKP
      备份集 27 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    28      Full    9.36M      DISK        00:00:00     02-3月 -16
            BP 关键字: 28   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135126
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905435486_CFDZTYO5_.BKP
      包含的 SPFILE: 修改时间: 02-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1080778      Ckp 时间: 02-3月 -16

### 1级增量备份

    RMAN> backup incremental level 1 database;
    
    启动 backup 于 02-3月 -16
    使用通道 ORA_DISK_1
    通道 ORA_DISK_1: 正在启动增量级别 1 数据文件备份集
    通道 ORA_DISK_1: 正在指定备份集内的数据文件
    输入数据文件: 文件号=00001 名称=I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
    输入数据文件: 文件号=00002 名称=I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
    输入数据文件: 文件号=00003 名称=I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
    输入数据文件: 文件号=00005 名称=I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
    输入数据文件: 文件号=00006 名称=I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    输入数据文件: 文件号=00004 名称=I:\ORACLE\ORADATA\ORCL\USERS01.DBF
    通道 ORA_DISK_1: 正在启动段 1 于 02-3月 -16
    通道 ORA_DISK_1: 已完成段 1 于 02-3月 -16
    段句柄=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNND1_TAG20160302T135630_CFF04H5F_.BKP 标记=TAG20160302T135630 注释=NONE
    通道 ORA_DISK_1: 备份集已完成, 经过时间:00:00:15
    完成 backup 于 02-3月 -16
    
    启动 Control File and SPFILE Autobackup 于 02-3月 -16
    段 handle=I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905435806_CFF04YK0_.BKP comment=NONE
    完成 Control File and SPFILE Autobackup 于 02-3月 -16

    RMAN> list backupset;
    
    备份集列表
    ===================
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    27      Incr 0  1.10G      DISK        00:00:23     02-3月 -16
            BP 关键字: 27   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135100
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNND0_TAG20160302T135100_CFDZT5B9_.BKP
      备份集 27 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    0  Incr 1080755    02-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    28      Full    9.36M      DISK        00:00:00     02-3月 -16
            BP 关键字: 28   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135126
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905435486_CFDZTYO5_.BKP
      包含的 SPFILE: 修改时间: 02-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1080778      Ckp 时间: 02-3月 -16
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    29      Incr 1  568.00K    DISK        00:00:11     02-3月 -16
            BP 关键字: 29   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135630
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2016_03_02\O1_MF_NNND1_TAG20160302T135630_CFF04H5F_.BKP
      备份集 29 中的数据文件列表
      文件 LV 类型 Ckp SCN    Ckp 时间   名称
      ---- -- ---- ---------- ---------- ----
      1    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSTEM01.DBF
      2    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\SYSAUX01.DBF
      3    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\UNDOTBS01.DBF
      4    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\USERS01.DBF
      5    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\EXAMPLE01.DBF
      6    1  Incr 1081014    02-3月 -16 I:\ORACLE\ORADATA\ORCL\ENERBOS.DBF
    
    BS 关键字  类型 LV 大小       设备类型 经过时间 完成时间
    ------- ---- -- ---------- ----------- ------------ ----------
    30      Full    9.36M      DISK        00:00:00     02-3月 -16
            BP 关键字: 30   状态: AVAILABLE  已压缩: NO  标记: TAG20160302T135646
    段名:I:\ORACLE\FLASH_RECOVERY_AREA\ORCL\AUTOBACKUP\2016_03_02\O1_MF_S_905435806_CFF04YK0_.BKP
      包含的 SPFILE: 修改时间: 02-3月 -16
      SPFILE db_unique_name: ORCL
      包括的控制文件: Ckp SCN: 1081039      Ckp 时间: 02-3月 -16
    
    RMAN>
### 1级累积增量备份

    backup incremental level 1 cumulative database;
