时间: 2020-07-23 14:24:24

# 列表 List

类似于数组，支持从列表的左右两侧存取数据，取数据的时候支持阻塞操作。列表的下标从0开始，负数表示。

`RPOPLPUSH` 源列表和目的地列表指定同一个列表可以用于实现循环列表。
`RPOPLPUSH` 消费者先从源列表获取数据进行处理，同时放入备份队列，处理完成之后从本分队列删除。

## List 常用命令：

|命令|语法|描述|返回值|
|::|::|::|::|
|LPUSH  | `LPUSH key value1 [value]` |把数据放入列表左侧|插入之后列表的长度|
|LPUSHX | `LPUSHX key value`         |当列表存在的时候，把数据放入列表左侧|插入之后列表的长度|
|RPUSH  | `RPUSH key value1 [value]` |把数据放入列表右侧|插入之后列表的长度|
|RPUSHX | `RPUSHX key value`         |当列表存在的时候，把数据放入列表右侧|插入之后列表的长度|
|LLEN   | `LLEN key`                 |查看列表的长度   |列表的长度       |
|LINDEX | `LINDEX key index`         |返回index位置的数据 | 列表 index 位置的数据，越界返回空|
|LSET   | `LSET key index value`     |设置 index 位置的值 |OK 设置成功，越界报错|
|LRANGE | `LRANGE key start end`     |返回 [start,end] 范围内的数据,如果start的实际位置小于end的位置将返回空|列表范围内的数据|
|LINSERT| `LINSERT key [BEFORE|AFTER] value insert_value`|在指定值前面或后面插入数据| 插入数据之后列表的长度|
|LPOP   | `LPOP key`                  |删除列表左边第一个元素，并返回|列表左边第一个元素，或空|
|BLPOP   | `BLPOP key timeout`        |删除列表左边第一个元素，并返回，当源列表没有数据时阻塞,阻塞时间为`timeout`|列表左边第一个元素，或空|
|RPOP   | `RPOP key`                  |删除列表右边第一个元素，并返回|列表右边第一个元素，或空|
|BRPOP   | `BRPOP key timeout`        |删除列表右边第一个元素，并返回，当源列表没有数据时阻塞,阻塞时间为`timeout`|列表右边第一个元素，或空|
|LPOS   | `LPOS key element [count c] [rank r]`|返回元素的坐标。count表示数量，rank表示第一个，rank小于零从右边开始查找|返回元素的坐标|
|LREM   | `LREM key count element`    |从列表中删除count个指定元素, `count > 0`从左边开始,`count < 0` 从右边开始删除,`count = 0` 删除全部 |删除的元素个数|
|LTRIM  | `LTRIM key start end`       |删除指定范围外的元素|删除是否成功|
|RPOPLPUSH| `RPOPLPUSH source destination`|从源列表删除一个元素, 放到目标列表|移动的元素|
|BRPOPLPUSH| `BRPOPLPUSH source destination timeout`|从源列表删除一个元素, 放到目标列表,当源列表没有数据时阻塞，阻塞时间为`timeout`|移动的元素|