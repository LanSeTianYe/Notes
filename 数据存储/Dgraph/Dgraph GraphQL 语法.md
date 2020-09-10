时间：2020-09-10 18:06:06


## Dgraph Graph QL 语法

语法类似于Facebook开源的的API语法 [GraphQL](https://graphql.org/)。

### 添加数据

`michael` 点的名字。`<name> <age>` 点普通属性。 `<friend> _:amit` 一条出边。`_:` 可以理解为连接到，代表一条边。`dgraph.type` 属性表示点的类型。

```
{
  set {
    _:michael <name> "Michael" .
    _:michael <dgraph.type> "Person" .
    _:michael <age> "39" .
    _:michael <friend> _:amit .
    _:michael <owns_pet> _:goldie .
    
    _:amit <name> "अमित"@hi .
    _:amit <name> "অমিত"@bn .
    _:amit <name> "Amit"@en .
    _:amit <dgraph.type> "Person" .
    _:amit <age> "35" .
    _:amit <friend> _:michael .
    _:amit <friend> _:sang .
    _:amit <friend> _:artyom .
    
    _:goldie <name> "Goldie" .
    _:goldie <dgraph.type> "Animal" .
    }
}
```

### 查询语法

#### 支持的函数

* uid: `func uid(real_uid)` 根据uid查询。
* eq: `func eq(edge_name, "value")` 相等。
* allOfTerms: `func: allOfTerms(edge_name, "value ... value")`  所有的都匹配。
* anyofterms: `func: anyofterms(edge_name, "value ... value")` 任意一个匹配。
* ge:  `func ge(edge_name, 27)` 大于。
* le: `func le(edge_name, 27)` 小于。
* gt: `func gt(edge_name, 27)` 大于等于。
* lt: `func lt(edge_name, 27)` 小于等于。

#### 查询列子 

1. 根据uid查询。

    ```
    {
      find_by_uid(func:uid(0x7)){
        name@.
        age
      }
    }
    ```

2. 根据名字查询

    ```
    {
      find_by_name(func:eq(name@., "Michael")){
        name@.
        age
      }
    }
    ```

3. 嵌套查询，查询用户的朋友。

    ```
    {
      find_by_name(func:eq(name@., "Michael")){
        name@.
        age
        friend{
          name@.
        }
      }
    }
    ```