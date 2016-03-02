### 数据库连接
#### 以sysdba的身份连接
有时候需要一些特殊的权限，因此需要使用sysdbade身份进行连接。

    C:\Users\zclf>sqlplus /nolog
    SQL> conn system/enerbos_123 as sysdba
    已连接。
    SQL> archive log list
    数据库日志模式             非存档模式
    自动存档             禁用
    存档终点            USE_DB_RECOVERY_FILE_DEST
    最早的联机日志序列     12
    当前日志序列           14
    SQL>
#### 查看数据库日志模式
需要 `sysdba`的权限

    SQL> archive log list
    数据库日志模式             非存档模式
    自动存档             禁用
    存档终点            USE_DB_RECOVERY_FILE_DEST
    最早的联机日志序列     12
    当前日志序列           14
    SQL>
