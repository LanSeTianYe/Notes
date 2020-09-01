##   
时间：2017/2/18 15:44:50 

## 总结
1. `where` 对 `select`语句进行筛选，`group by` 对 `select` 或者 `where` 筛选之后的数据进行分组，`having` 对 `group` 之后的数据进行筛选。
2. mySql的 group by 子句里面没有的列也可以出现在 select后面，SqlServer则不允许这种情况。

## 简单查询  

1. 查询对应表中所有数据

		select * from Student
2. 查询查询指定列

		select no,name from student
3. 去除重复  
	`distinct` 关键字，查询列的组合是否重复。

		select distinct name, sex from student
4. 条件查询
	* 比较：`= ,>, >=,<=,<,<>,!=,!>,!< NOT +`
	* 范围：`between...and  ,not between...and`
	* 确定集合： `in ,  not in`
	* 字符串匹：`like,not like`
		* `_` 匹配任意一个字符
		* `%` 匹配零个或多个字符 
		* `[]` 匹配 `[]` 中的任意一个字符
		* `[^]` 不匹配 `[]` 中存在的字符
	* 空值 : `is null ,is not null`
	* 多重条件: `and,or`
	
			select * from student where name like '_王%'
			select * from student where name like '%王%'
			select * from student where name like '%王%'
			select * from student where id is not null
5. 排序

		select * from student where sex = '女' order by name asc, no desc
6. 聚合函数

	* count(*) 统计表中元素的个数
	* count(distinct<列名>) 统计非空列的个数
	* sum(<列名>) 计算列值的和
	* avg(<列名>) 计算平均值
	* max(<列名>) 计算最大值
	* min(<列名>) 计算最小值
		
			select count(name) from student
			select count(distinct name) from student
7. 分组  
统计名字重复的人数

		select no,name, count(name) as nameNumber from student group by name
8. having   
找出名字重复的数据

		select *, name, count(name) as nameNumber from student group by name having nameNumber > 1

9. 连接查询

	1. 内连接: 只有两个表都有的才会出现在结果中

			select * from student s inner join hobby h on s.no = h.no
			select * from student s inner join hobby h on s.no = h.no where h.hobby = '乒乓球'
	2. 自连接：特殊的内连接（层级关系）

			select * from student s1 inner join student s2 on s1.dept = s2.dept
	3. 左外连接：左表全部出现，右表没有则为空

			select * from student s left join hobby h on s.no = h.no order by s.no
	4. 右外连接：右表全部出现，左表没有则为空

			select * from student s right join hobby h on s.no = h.no order by s.no
	5. 全连接：全部出现，没有为空（MySQL 不支持 full关键字）

10. limit 限制结果数目

		//从3开始4条
		select * from student order by no asc limit 2,4
11. 子查询

		//查询刘晨所在系的全部学生	
		select * from student where dept in( select dept from student where name ='刘晨')
		//查询平均分大于75的学生
		select * from student s where s.no in(select g.no from grade g group by g.no having avg(g.grade) > 75)
		//查询平均分大于75的学生
		select s.no, avg(g.grade) as avgGrade from student s inner join grade g on s.no = g.no group by s.no having avgGrade > 75
		//查询平均分数大于总体平均分的成绩
		select * from grade where grade > (select avg(grade) from grade)
		//查询有科成绩大于90的学生
		select * from student s where s.no = some(select g.no from grade g where grade > 90)
12. 相关子查询（SqlServer）
内层查询利用外层查询提供的信息执行，然后经内层查询的结果返回给外层查询，外层查询再利用这个结果判断当前数据是否是满足要求的数据。

	例1
	
		select Cname ,Semester ,Credit
		from Course c1
		where Credit in ( select min (Credit ) from Course c2 where c1.Semester = c2 .Semester )
		order by Semester
	例2

		select Sno ,Cno ,Grade from SC sc1 where
		Sno in ( select Top 2 with ties Sno From SC sc2
		        where sc1 .Cno = sc2 .Cno
		        order by Grade desc
		        )
		and Grade is not null
		order by Cno asc ,Grade desc

	例3

		select Cno ,Sno ,Grade from SC sc1 where
		Grade < ( select avg (Grade ) from SC sc2 where sc1 .Cno = sc2 .Cno )

	例4

		select Semester from Course c1
		group by Semester
		having MAX (Credit ) >=
		all ( select 1.5* AVG( Credit) from Course c2 where c1 .Semester = c2.Semester )

	例5

		select Sname ,Sdept ,(select coutn (*) from SC where Sno = Student.Sno ) as CountCno from Student
	例6

		select Sname from Student where
		exists ( select * from SC where Sno = Student .Sno and Cno = 'C002')
	例7
		
		select Sname ,Sdept ,from Student
		where exusts (
		      select * from   SC
		      where exists(
		      select * from Course where Cno = SC .Cno and Cname = 'JAVA')
		      and Sno = Student.Sno
		)
	例8

		select Sname , Sdept from Student where
		not exists( select * from SC where Sno = Student .Sno and Cno = 'C001')
13. 存储过程（SqlServer）
	* 无参数
		
			create procedure p_Student as
			select * from Student
			
			exec p_Student
	* 有参数

			create procedure p_Student1 @dept char (20 )
			as
			select * from Student where Sdept = @dept
	* 多个参数

			create procedure p_Student2 @dept char (20 ),@Sex char (2 ) = '男'
			as
			select * from Student where Sdept = @dept and Ssex = @Sex
	* 有返回值
		
			create procedure p_Student4 @Count int output
			as
			select @Count = count(*) from Student
			
			declare @result int
			exec p_Student4 @result output
			print @result

