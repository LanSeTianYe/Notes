时间：2020-09-10 18:06:06


## Dgraph Graph QL 语法

语法类似于Facebook开源的的API语法 [GraphQL](https://graphql.org/)。

### 添加数据

* `_:michael` 空白节点，表示数据库中不存在，执行命令后会在数据库中创建节点，创建成功后返回节点对应的uid。`_:michael` 可以用来标识一条执行语句中的节点。

* `<name> <age> <friend> <owns_pet>` 表示边，标识关系。可以这样读  `michael 有一个 name 是 Michael` `michael 有一个 friend 是 amit`。

    ```
    {
      set {
        _:michael <name> "Michael" .
        _:michael <dgraph.type> "Person" .
        _:michael <age> "39" .
        _:michael <friend> _:amit .
        _:michael <friend> _:sarah .
        _:michael <friend> _:sang .
        _:michael <friend> _:catalina .
        _:michael <friend> _:artyom .
        _:michael <owns_pet> _:rammy .

        _:amit <name> "अमित"@hi .
        _:amit <name> "অমিত"@bn .
        _:amit <name> "Amit"@en .
        _:amit <dgraph.type> "Person" .
        _:amit <age> "35" .
        _:amit <friend> _:michael .
        _:amit <friend> _:sang .
        _:amit <friend> _:artyom .

        _:luke <name> "Luke"@en .
        _:luke <dgraph.type> "Person" .
        _:luke <name> "Łukasz"@pl .
        _:luke <age> "77" .

        _:artyom <name> "Артём"@ru .
        _:artyom <name> "Artyom"@en .
        _:artyom <dgraph.type> "Person" .
        _:artyom <age> "35" .

        _:sarah <name> "Sarah" .
        _:sarah <dgraph.type> "Person" .
        _:sarah <age> "55" .

        _:sang <name> "상현"@ko .
        _:sang <name> "Sang Hyun"@en .
        _:sang <dgraph.type> "Person" .
        _:sang <age> "24" .
        _:sang <friend> _:amit .
        _:sang <friend> _:catalina .
        _:sang <friend> _:hyung .
        _:sang <owns_pet> _:goldie .

        _:hyung <name> "형신"@ko .
        _:hyung <name> "Hyung Sin"@en .
        _:hyung <dgraph.type> "Person" .
        _:hyung <friend> _:sang .

        _:catalina <name> "Catalina" .
        _:catalina <dgraph.type> "Person" .
        _:catalina <age> "19" .
        _:catalina <friend> _:sang .
        _:catalina <owns_pet> _:perro .

        _:rammy <name> "Rammy the sheep" .
        _:rammy <dgraph.type> "Animal" .

        _:goldie <name> "Goldie" .
        _:goldie <dgraph.type> "Animal" .

        _:perro <name> "Perro" .
        _:perro <dgraph.type> "Animal" .
      }
    }
    ```

    边属性初始化数据
    
    ```
    {
      set {

        # -- Facets on scalar predicates
        _:alice <name> "Alice" .
        _:alice <mobile> "040123456" (since=2006-01-02T15:04:05) .
        _:alice <car> "MA0123" (since=2006-02-02T13:01:09, first=true) .

        _:bob <name> "Bob" .
        _:bob <car> "MA0134" (since=2006-02-02T13:01:09) .

        _:charlie <name> "Charlie" .
        _:dave <name> "Dave" .

        # -- Facets on UID predicates
        _:alice <friend> _:bob (close=true, relative=false) .
        _:alice <friend> _:charlie (close=false, relative=true) .
        _:alice <friend> _:dave (close=true, relative=true) .

        # -- Facets for variable propagation
        _:movie1 <name> "Movie 1" .
        _:movie2 <name> "Movie 2" .
        _:movie3 <name> "Movie 3" .
    
        _:alice <rated> _:movie1 (rating=3) .
        _:alice <rated> _:movie2 (rating=2) .
        _:alice <rated> _:movie3 (rating=5) .
    
        _:bob <rated> _:movie1 (rating=5) .
        _:bob <rated> _:movie2 (rating=5) .
        _:bob <rated> _:movie3 (rating=5) .
    
        _:charlie <rated> _:movie1 (rating=2) .
        _:charlie <rated> _:movie2 (rating=5) .
        _:charlie <rated> _:movie3 (rating=1) .
      }
    }
    ```


### 查询语法

#### 支持的函数

* uid: `func uid(real_uid)` 根据uid查询。
* eq: `func eq(edge_name, "value")` 相等。
* allOfTerms: `func: allOfTerms(edge_name, "value ... value")`  和所有的值都匹配。
* anyofterms: `func: anyofterms(edge_name, "value ... value")` 和任意一个匹配。
* ge:  `func ge(edge_name, 27)` 大于。
* le: `func le(edge_name, 27)` 小于。
* gt: `func gt(edge_name, 27)` 大于等于。
* lt: `func lt(edge_name, 27)` 小于等于。
* filter: `@filter(ge(age, 27))` 过滤条件。
* AND OR NOT:  `@filter(ge(age, 27) AND le(age,40))` 与、或、非，结合filter使用。
* orderasc/orderdesc：正序或倒序排序。
* 分页：first 多少个元素，offset 跳过多少个元素，after，从指定uid开始。
* count: `count(edge_name)` 个数。
* has:  `has(edge_name)` 有指定的边。
* cascade: `@cascade` 排除有空边的数据。
* normalize:  `@normalize` 只返回有别名的边，并且拉平内嵌结构。
* @facets: `@facets` 边属性。 

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
4. 过滤查询 `@filter(ge(age,27))`。

    ```
    {
      michaels_friends_filter(func: allofterms(name@., "अमित Amit")) {
        name@.
        age
        friend @filter(ge(age, 27)){
          name@.
          age
        }
      }
    }
    ```
5. 根据年龄排序。

    ```
    {
      michaels_friends_filter(func: allofterms(name@., "अमित Amit")) {
        name@.
        age
        friend (orderdesc:age){
          name@.
          age
        }
      }
    }
    ```

6. 分页,从第一个元素开始，取两个。以0为基数。

    ```
    {
      michael_friends_first(func: allofterms(name@., "Michael")) {
        name
        age
        friend (orderasc: name@., offset: 1, first: 2) {
          name@.
        }
      }
    }
    ```

7. 查询年龄大于20，并且有3个朋友的用户。

    ```
    {
      find(func:ge(age, 20)) @filter(eq(count(friend),3)){
        name@.
        age 
        count(friend)
      }
    }
    ```

8. 指定别名。

    ```
    {
      has_friend(func: has(friend)){
        name@.
        age
        friend_count : count(friend)
      }
    }
    ```

9. 排除有边指向的节点为空的数据。

    ```
    {
      michael_friends_with_pets(func: allofterms(name@., "Michael")) @cascade {
        name
        age
        friend {
          name@.
          owns_pet
        }
      }
    }
    ```