## rman增量备份
需要备份的东西：
1. 数据文件
2. 控制文件
3. 归档日志文件

步骤：  

1. 制定备份策略。
1. 根据备份策略编写增量备份的脚本 *.rman
2. 编写运行这些脚本的 *.bat的脚本，用于windows的计划任务。
3. 在Windows里面创建计划任务，实现定时调用。

### 备份策略
* 每月进行一次全备份。
* 每周进行一次累计增量备份
* 每天进行一次差异增量备份
### 备份所需要的脚本
* 每月执行一次的全备份

        run {
        	backup incremental level 0 database tag 'everymonth_0_all' format "d:\backup\everymonth_0_all_%d_%T_%t" skip inaccessible  include current controlfile plus archivelog delete all input ;
        }
说明：
 * `backup incremental level 0 database` 0级增量备份
 * `tag 'everymonth_0_all'` 备份的标签
 * `format "d:\backup\everymonth_0_all_%d_%T_%t"` 输出文件的位置及名字 `%d`数据库名字 `%T`(YYYYMMDD) `%t` 时间戳，防止文件名冲突
 * `skip inaccessible` 跳过不可读的文件
 * `include current controlfile` 增加控制文件的备份
 * `plus archivelog` 增加归档日志的备份  
    该命令的作用是，在备份开始前备份一下日志，在备份结束之后再次备份日志。
 * `delete all input` 删除没用的日志备份
* 每周执行一次的累计增量备份

        run {
        	backup incremental level 1 cumulative database tag 'everyday_1_c' format "d:\backup\everyday_1_c_%d_%T_%t" skip inaccessible  include current controlfile plus archivelog delete all input ;
        }
* 每天执行一次的差异增量备份

        run {
        	backup incremental level 1 database tag 'everyweek_1_d' format "d:\backup\everymonth_0_all_%d_%T_%t" skip inaccessible  include current controlfile plus archivelog delete all input ;
        }

### 编写运行这些脚本的 `*.bat` 的脚本，用于windows的计划任务。

    set oracle_sid = orcl
    rman target sys/password log S:\RmanLog\everyday_1_c.txt cmdfile=S:\everyday_1_c.rman
### 在Windows里面创建计划任务，实现定时调用
在控制面板里面搜索计划任务，创建定时执行任务，然后指定对应的.bat脚本即可。