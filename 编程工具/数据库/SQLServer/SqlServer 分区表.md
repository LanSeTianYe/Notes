### 关于分区表
如果你的数据库中某一个表中的数据满足以下几个条件，那么你就要考虑创建分区表了。

1. 数据库中某个表中的数据很多。很多是什么概念？一万条？两万条？还是十万条、一百万条？这个，我觉得是仁者见仁、智者见智的问题。当然数据表中的数据多到查询时明显感觉到数据很慢了，那么，你就可以考虑使用分区表了。如果非要我说一个数值的话，我认为是100万条。
2. 但是，数据多了并不是创建分区表的惟一条件，哪怕你有一千万条记录，但是这一千万条记录都是常用的记录，那么最好也不要使用分区表，说不定会得不偿失。只有你的数据是分段的数据，那么才要考虑到是否需要使用分区表。
3. 什么叫数据是分段的？这个说法虽然很不专业，但很好理解。比如说，你的数据是以年为分隔的，对于今年的数据而言，你常进行的操作是添加、修改、删除和查询，而对于往年的数据而言，你几乎不需要操作，或者你的操作往往只限于查询，那么恭喜你，你可以使用分区表。换名话说，你对数据的操作往往只涉及到一部分数据而不是所有数据的话，那么你就可以考虑什么分区表了。

#### 什么是分区表?
简单一点说，分区表就是将一个大表分成若干个小表。假设，你有一个销售记录表，记录着每个每个商场的销售情况，那么你就可以把这个销售记录表按时间分成几个小表，例如说5个小表吧。2009年以前的记录使用一个表，2010年的记录使用一个表，2011年的记录使用一个表，2012年的记录使用一个表，2012年以后的记录使用一个表。那么，你想查询哪个年份的记录，就可以去相对应的表里查询，由于每个表中的记录数少了，查询起来时间自然也会减少。  
但将一个大表分成几个小表的处理方式，会给程序员增加编程上的难度。以添加记录为例，以上5个表是独立的5个表，在不同时间添加记录的时候，程序员要使用不同的SQL语句，例如在2011年添加记录时，程序员要将记录添加到2011年那个表里；在2012年添加记录时，程序员要将记录添加到2012年的那个表里。这样，程序员的工作量会增加，出错的可能性也会增加。 
### 分区创建过程
### 1. 创建文件
    -- -------------分区方案 --------------
    -- 先创建存储分区的文件夹,文件目录手动创建
    -- D:\Data\Primary\
    -- D:\Data\FG1\
    -- ...
    -- D:\Data\FG12\
### ２.创建数据库，把数据库对应到分区上

    IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'AirAvCache')  
    DROP DATABASE [AirAvCache]
    GO
    CREATE DATABASE [AirAvCache]
    ON PRIMARY
    (NAME='Data Partition DB Primary FG',
    FILENAME='D:\Data\Primary\AirAvCache Primary FG.mdf',
    SIZE=200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG1]
    
    (NAME = 'AirAvCache FG1',
    FILENAME='D:\Data\FG1\AirAvCache FG1.ndf',  
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG2]
    
    (NAME = 'AirAvCache FG2',
    FILENAME = 'D:\Data\FG2\AirAvCache FG2.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG3] 
     
    (NAME = 'AirAvCache FG3',  
    FILENAME =  'D:\Data\FG3\AirAvCache FG3.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG4]
    
    
    (NAME = 'AirAvCache FG4',
    FILENAME = 'D:\Data\FG4\AirAvCache FG4.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG5]
    
    (NAME = 'AirAvCache FG5',
    FILENAME = 'D:\Data\FG5\AirAvCache FG5.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),  
    FILEGROUP [AirAvCache FG6]
    
    (NAME = 'AirAvCache FG6',  
    FILENAME = 'D:\Data\FG6\AirAvCache FG6.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG7]
    
    (NAME = 'AirAvCache FG7',
    FILENAME = 'D:\Data\FG7\AirAvCache FG7.ndf',  
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG8]
    
    (NAME = 'AirAvCache FG8',  
    FILENAME = 'D:\Data\FG8\AirAvCache FG8.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG9]
    
    (NAME = 'AirAvCache FG9',
    FILENAME =  'D:\Data\FG9\AirAvCache FG9.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG10]
    
    (NAME = 'AirAvCache FG10',
    FILENAME = 'D:\Data\FG10\AirAvCache FG10.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG11]
    
    (NAME = 'AirAvCache FG11',
    FILENAME = 'D:\Data\FG11\AirAvCache FG11.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 ),
    FILEGROUP [AirAvCache FG12]
    
    (NAME = 'AirAvCache FG12',
    FILENAME = 'D:\Data\FG12\AirAvCache FG12.ndf',
    SIZE = 200MB,
    MAXSIZE=unlimited,
    FILEGROWTH=200 )
###  3.创建分区函数
分区函数对应列的数据类型可以是除 text、ntext、image、xml、timestamp、varchar(max)、nvarchar(max)、varbinary(max)、别名数据类型或 CLR 用户定义数据类型外的所有数据类型。  
其他包括 数字、日期、字符串(char、nvarchar、text)、二进制字符串等。

    USE AirAvCache
    GO
    CREATE PARTITION FUNCTION [AirAvCache Partition FUNCTION](DATETIME)  
    AS RANGE LEFT FOR VALUES ('2015-09-01','2015-10-01','2015-11-01',
    '2015-12-01','2016-01-01','2016-02-01','2016-03-01','2016-04-01',
    '2016-05-01','2016-06-01','2010-06-01'); 
### 4.创建分区架构

    CREATE PARTITION SCHEME [AirAvCache Partition Scheme]  
    AS PARTITION [AirAvCache Partition FUNCTION]  
    TO ([AirAvCache FG1], [AirAvCache FG2], [AirAvCache FG3],[AirAvCache FG4],[AirAvCache FG5],[AirAvCache FG6],[AirAvCache FG7],[AirAvCache FG8],
    [AirAvCache FG9],[AirAvCache FG10],[AirAvCache FG11],[AirAvCache FG12]); 
### 5.创建使用分区架构的表 
使用[AirAvCache Partition Scheme]架构，根据FlightDate列分区

    CREATE TABLE [dbo].[AvCache](
        [CityPair] [varchar](6)  NOT NULL,
        [FlightNo] [varchar](10)  NULL,
        [FlightDate] [datetime] NOT NULL,
        [CacheTime] [datetime] NOT NULL   DEFAULT (getdate()), 
        [AVNote] [varchar](300)  NULL,
    )  ON [AirAvCache Partition Scheme] (FlightDate);
到这里，分区表已将创建好了，根据存储的FlightDate的日期进行分区，不同范围的会被分到不同的分区中。当然也可以通过Sql语句调整自己的分区函数，这样可以快速的合并分区，新增分区等。
