	//加载模块
	var Oriento = require('oriento');
	//设置连接信息
	var server = Oriento({
	  host: '127.0.0.1',
	  port: 2424,
	  username: 'root',
	  password: '000000'
	});
	
	// List databases
	server.list().then(function (dbs) {
	  console.log('There are ' + dbs.length + ' databases on the server.');
	});
	
	//创建新的数据库
	//server.create({
	//name: 'mydb',
	//type: 'graph',
	//storage: 'plocal'
	//}).then(function (db) {
	//console.log('Created a database called ' + db.name);
	//});
	
	//使用已经存在的服务器
	var db = server.use('demo');
	console.log('Using database: ' + db.name);
	
	//指定用户使用已经存在的数据库
	var db1 = server.use({
	  name: 'mydb',
	  username: 'root',
	  password: '000000'
	});
	console.log('Using database: ' + db1.name);
	
	//插入数据
	db.query('insert into student (name, age, birthday) values (:name, :age, :birthday)',
	  {
	    params: {
	      name: 'longlongxiao',
	      age: '22',
	      birthday: '2314-04-04'
	    }
	  }
	).then(function (response){
	  console.log(response); //an Array of records inserted
	});
	
	//查询数据
	db.query('select from student where name=:name', {
		params: {
		    name: 'longlongxiao'
		},
		limit: 2
	}).then(function (results){
		console.log(results);
	});
	
	//查询
	db.exec('select from student where name=:name', {
	  params: {
	    name: 'longlongxiao'
	  }
	}).then(function (response){
	  console.log(response.results);
	});
	
	//插入，返回插入的记录
	db.insert().into('student').set({name: 'demo', age: '22', birthday: '2014-02-02'}).one()
	.then(function (student) {
	  console.log('created', student);
	});
	
	//更新，返回更新的个数
	db.update('student').set({age: '23'}).where({name: 'longlongxiao'}).scalar()
	.then(function (total) {
	  console.log('updated', total, 'student');
	});
	
	//删除，返回删除的个数
	db.delete().from('student').where({name: 'longlongxiao'}).limit(1).scalar()
	.then(function (total) {
	  console.log('deleted', total, 'users');
	});
	
	//查询,返回查询的结果
	db.select().from('student').where({age: '22'}).all()
	.then(function (users) {
	  console.log('active users', users);
	});
	
	//查询 ,文本查找
	db.select().from('student').containsText({name: 'lo'}).all()
	.then(function (users) {
	  console.log('文本查找', users);
	});
	
	//查询，包含函数
	db.select('count(*)').from('student').where({age: '22'}).scalar()
	.then(function (total) {
	  console.log('年龄为22的用户共有:', total,"个");
	});
	
	//查询,(不清楚具体含义)
	db.select().from('student').where({age: '22'}).fetch({role: 50}).all()
	.then(function (users) {
	  console.log("----------------------------");
	  console.log('active users', users);
	});
	
	//查询,(不清楚具体含义)
	db.traverse().from('student').where({name: 'demo'}).all()
	.then(function (records) {
	  console.log('found records', records);
	});
	
	//查询特定的值，然后根据名字排序
	db.select('name').from('student')
	.where({age: '22'})
	.column('name')
	.all()
	.then(function (names) {
	  console.log('active user names', names.join(', '));
	});
	
	//查询，处理查询的结果之后返回
	db
	.select('name')
	.from('student')
	.where({age: '22'})
	.transform({
	  name: function (name) {
	    return name.toLowerCase();
	  }
	})
	.limit(1)
	.one()
	.then(function (student) {
	  console.log('student name: ', student.name); 
	});
	
	function Student(name) {
		this.name = name;
		return this;
	}
	
	//查询，把查询之后的信息转换为对象
	db
	.select('name')
	.from('student')
	.where({age: '22'})
	.transform(function (record) {
	  return new Student(record);
	})
	.limit(1)
	.one()
	.then(function (student) {
	  console.log('student is an instance of User?', (student instanceof Student)); // true
	});
	
	//查询,添加属性
	db
	.select('name')
	.from('student')
	.where({age: '22'})
	.defaults({
	  something: 123
	})
	.limit(1)
	.one()
	.then(function (user) {
	  console.log(user.name, user.something);
	});
	
	
	//更新,把一个map放入到一个map中
	db
	.update('#12:1')
	.put('mapProperty', {
	  key: 'value',
	  foo: 'bar'
	})
	.scalar()
	.then(function (total) {
	  console.log('updated', total, 'records');
	});
	
	//根据，record获取记录(no)
	db.record.get('#13:22')
	.then(function (record) {
	  console.log('Loaded record:', record);
	});
	
	//列出所有的class(no)
	db.class.list()
	.then(function (classes) {
	  console.log('There are ' + classes.length + ' classes in the db:', classes);
	});
	
	//创建新的class
	//db.class.create('MyClass')
	//.then(function (MyClass) {
	//console.log('Created class: ' + MyClass.name);
	//});
	
	//创建一个新的class包含另外一个class
	//db.class.create('MyOtherClass', 'MyClass')
	//.then(function (MyOtherClass) {
	//console.log('Created class: ' + MyOtherClass.name);
	//});
	
	//获取已经存在的class
	db.class.get('MyClass')
	.then(function (MyClass) {
	  console.log('Got class: ' + MyClass.name);
	});
	
	//更新已经存在的class
	db.class.update({
	  name: 'MyClass',
	  superClass: 'V'
	})
	.then(function (MyClass) {
	  console.log('Updated class: ' + MyClass.name + ' that extends ' + MyClass.superClass);
	  //列出class的属性
	  MyClass.property.list()
	  .then(function (properties) {
		console.log('The class has the following properties:', properties);
	  });
	});
	
	
