时间   2016/12/14 13:33:19 

# KairosDB 数据备份和恢复
 
# `kairosdb.sh` 参数
    Usage: <main class> [options]
      Options:
            --help
           Help message.
           Default: false
        -a
           Appends to the export file. By default, the export file is overwritten.
           Default: false
        -c
           Command to run: export, import, run, start.
        -f
           File to save export to or read from depending on command.
        -h
           Help message.
           Default: false
        -n
           Name of metrics to export. If not specified, then all metrics are
           exported.
        -p
           A custom properties file
        -r
           Full path to a recovery file. The file tracks metrics that have been
           exported. If export fails and is run again it uses this file to pickup where it
           left off.


## Windows 系统

### 数据备份
1. 安装 `git-gui`。
2. 在 KairosDB 的 `bin` 右键打开 `git-bash`。
3. 执行下面命令备份数据。

        kaiosdb.sh export -f 要备份的文件名.txt
4. 生成的文件会保存在 kairosdb 根目录下。
### 备份数据恢复

1. 执行下面命令导入备份数据。

        kaiosdb.sh import -f 要还原的文件名.txt


## Linux 系统

### 数据备份
在 kairosdb 的 bin目录执行下面命令：  

    ./kaiosdb.sh export -f 要备份的文件名.txt

### 备份数据恢复
在 kairosdb 的 bin目录执行下面命令

    ./kaiosdb.sh import -f 要还原的文件名.txt

## 遇到的问题
1. Windows 运行 `kairosd.sh` 提示 如下：

        ./kairosdb.sh: line 33: conditional binary operator expected
        ./kairosdb.sh: line 33: syntax error near `=~'
        ./kairosdb.sh: line 33: `       if [[ `uname` =~ "CYGWIN" ]] ; then'

    对应的代码是：

        # Load up the classpath
        CLASSPATH="conf/logging"
        for jar in $KAIROSDB_LIB_DIR/*.jar; do
        	if [[ `uname` =~ "CYGWIN" ]] ; then
        		CLASSPATH="$CLASSPATH;$jar"
        	else 
        		CLASSPATH="$CLASSPATH:$jar"
        	fi
        done
    解决办法：这段代码是根据当前操作系统类型，选择jar包的路径，对于windows改成下面即可。  

        CLASSPATH="conf/logging"
        for jar in $KAIROSDB_LIB_DIR/*.jar; do
        	CLASSPATH="$CLASSPATH;$jar"
        done

2. 导入数据的过程中，提示下面错误：

        metric[0](name=kairosdb.datastore.cassandra.key_query_time).tags count must be greater than or equal to 1.
    解决办法： `kairosdb.datastore.cassandra.key_query_time` 对应的 `tags` 为空，对数据导入没有影响。 