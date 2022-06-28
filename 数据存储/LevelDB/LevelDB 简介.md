时间：2021-08-12 17:24:24

参考：

1. [leveldb](https://github.com/google/leveldb)
2. [Format of an immutable Table file](https://github.com/google/leveldb/blob/master/doc/table_format.md)
3. [Format of a log file](https://github.com/google/leveldb/blob/master/doc/log_format.md)
4. [Implementation notes](https://github.com/google/leveldb/blob/master/doc/impl.md)
5. [leveldb-handbook](https://leveldb-handbook.readthedocs.io/zh/latest/basic.html)

## LevelDB 简介

基于LSM（Log Structured-Merge Tree）实现，放弃部分读性能，换取最大的写性能。

LevelDB 是key/value存储，key/value都以字节的形式存储。

支持批量更新。

在存储中key有序，支持自定义比较器。

支持数据压缩。

支持迭代器，正向和逆向迭代。

支持缓存，可以在内存中缓存经常使用的数据。从数据库读取数据的时候可以设置不向缓存填充数据选项，避免非必须数据填充缓存，导致缓存内容被更新。

数据存储在磁盘中，直接保存在文件中。

同时只能有一个进程打开数据库，多个进程可以使用同一个打开的数据库，但是不能同时打开多个。


存储目录结构如下：

```shell
├── 000001.ldb
├── 000002.ldb
├── 000003.ldb
├── ... ...
├── 000202.ldb
├── CURRENT
├── CURRENT.bak
├── LOCK
├── LOG
└── MANIFEST-000012
```

### 使用

```go
# 打开一个存储仓库 
fileStorage, err := storage.OpenFile(path, false)

# 打开一个数据库
db, err := leveldb.Open(fileStorage, options)

# 存储数据/获取/删除数据
key := []byte("key")
value := []byte("value")
db.Put(key, value, writeOptions)
db.Get(key, nil) []byte
db.Delete(key)

# 批量更新
batch := new(leveldb.Batch)
batch.Put([]byte("foo"), []byte("value"))
batch.Put([]byte("bar"), []byte("another value"))
batch.Delete([]byte("baz"))
err = db.Write(batch, nil)

# 迭代获取所有元素
iterator := db.NewIterator(nil, nil)

for next := iterator.Next(); next; next = iterator.Next() {
    key := iterator.Key()
    value := iterator.Value()
    fmt.Printf("key:%s, value:%s\n", string(key), string(value))
}
```