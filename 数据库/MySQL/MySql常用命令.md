1. 查看数据库版本。

		select version();
1. 查看数据库编码信息

		show variables like 'character_set_%';
2. 查看当前使用的数据库

        SELECT DATABASE();
3. 查看所有的数据库

        SHOW DATABASES;
4. 查看当前库里面的表
 
        show tables;
5. 显示表的结构

        describe alarminfo;
7. 显示表信息。

		show create table tablename;
		SHOW TABLE STATUS\G;
8. 变更表的存储引擎。

		alter table person engine=innodb;
6. 查看数据库配置信息

        show variables;
7. 查看端口

        show variables  like 'port';
8. 设务隔离级别

		set session transaction isolation level read committed;

8. 查看存储引擎

        show variables  like '%storage%';
9. 查看数据库编码

        show variables  like 'character%';

10. 查看MySql的版本

        show variables  like 'version';
11. 查询表有多少行

        select count(*) from alarminfo
12. 限制查询条目，跳过30条之后的20条  

		SELECT * FROM employees ORDER BY emp_no LIMIT 30, 20  
12. 创建索引

        -- 唯一索引
        CREATE UNIQUE INDEX index_u_alarminfo_uid ON alarminfo(uid)
        -- 普通索引
        ALTER TABLE alarminfo ADD INDEX index_time_num (time,num)
13. 创建触发器

        CREATE TRIGGER alarminfo_row_add_tri AFTER INSERT ON alarminfo FOR EACH ROW
        BEGIN
        	update row_count_table set alarminfo_rows = 1 + alarminfo_rows;
        END;
        -- 创建触发器，删除记录的时候总条数减一
        CREATE TRIGGER alarminfo_row_minus_tri AFTER DELETE ON alarminfo FOR EACH ROW
        BEGIN
        	update row_count_table set alarminfo_rows = alarminfo_rows - 1;
        END;
14. 分析Sql语句 `EXPLAIN`

        EXPLAIN SELECT * from alarminfo WHERE uid = 999
15. 创建表并添加索引

        CREATE TABLE `table` (
        	`id` int(11) NOT NULL AUTO_INCREMENT ,
        	`title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
        	`content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
        	`time` int(10) NULL DEFAULT NULL ,
        	PRIMARY KEY (`id`),
        	UNIQUE INDEX index_name (title(255))
        )
16. 视图，可以通过视图更新原表数据但是有条件限制。

		创建视图
		CREATE VIEW testView AS
		  SELECT
		    emp_no,
		    dept_no,
		    from_date
		  FROM dept_emp c
		  WHERE c.dept_no = 'd004' WITH CHECK OPTION;
		替换视图
		CREATE OR REPLACE VIEW testView AS
		  SELECT
		    emp_no,
		    dept_no,
		    from_date
		  FROM dept_emp c
		  WHERE c.dept_no = 'd004' WITH CHECK OPTION;