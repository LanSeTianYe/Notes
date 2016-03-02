## rman增量备份
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
* 每周执行一次的累计增量备份

        run {
        	backup incremental level 1 cumulative database tag 'everyday_1_c' format "d:\backup\everyday_1_c_%d_%T_%t" skip inaccessible  include current controlfile plus archivelog delete all input ;
        }
* 每天执行一次的差异增量备份

        run {
        	backup incremental level 1 database tag 'everyweek_1_d' format "d:\backup\everymonth_0_all_%d_%T_%t" skip inaccessible  include current controlfile plus archivelog delete all input ;
        }

### 编写运行这些脚本的 *.bat的脚本，用于windows的计划任务。

    set oracle_sid = orcl
    rman target sys/password log S:\RmanLog\everyday_1_c.txt cmdfile=S:\everyday_1_c.rman
### 在Windows里面创建计划任务，实现定时调用
在控制面板里面搜索计划任务，创建定时执行任务，然后指定对应的.bat脚本即可。