## 信息
日期 : 2016-7-5 7:12:30

## 基本概念
浅复制：
> 被复制对象的所有变量都含有与原来的对象相同的值，而所有的对其他对象的引用仍然指向原来的对象。换言之，浅复制仅仅复制所考虑的对象，而不复制它所引用的对象。

深复制：
> 被复制对象的所有变量都含有与原来的对象相同的值，除去那些引用其他对象的变量。那些引用其他对象的变量将指向被复制过的新对象，而不再是原有的那些被引用的对象。换言之，深复制把要复制的对象所引用的对象都复制了一遍。

## 深复制（clone()）
1. 实现 `Cloneable` 接口，对象的引用也需要实现该方法。
2. 重载 `clone()` 方法。
### 具体代码

Teacher  

	public class Teacher implements Cloneable, Serializable {
	
	    private String name;
	
	    public String getName() {
	        return name;
	    }
	
	    public void setName(String name) {
	        this.name = name;
	    }
	
	    public Teacher(String name) {
	        this.name = name;
	    }
	
	    @Override
	    protected Object clone() throws CloneNotSupportedException {
	        return super.clone();
	    }
	}


Student


	public class Student implements Cloneable, Serializable{
	
	    private String name;
	
	    private Teacher teacher;
	
	    public Student(String name, Teacher teacher) {
	        this.name = name;
	        this.teacher = teacher;
	    }
	
	    @Override
	    protected Object clone() throws CloneNotSupportedException {
	        Student student = null;
	        student = (Student) super.clone();
	        student.teacher = (Teacher) student.teacher.clone();
	        return student;
	    }
	
	    //深复制
	    public Object deepCopy () throws IOException, ClassNotFoundException {
	        ByteArrayOutputStream bo = new ByteArrayOutputStream();
	        ObjectOutputStream oo = new ObjectOutputStream(bo);
	        oo.writeObject(this);
	        //从流里读出来
	        ByteArrayInputStream bi = new ByteArrayInputStream(bo.toByteArray());
	        ObjectInputStream oi = new ObjectInputStream(bi);
	        return (oi.readObject());
	    }
	
	    public String getName() {
	        return name;
	    }
	
	    public void setName(String name) {
	        this.name = name;
	    }
	
	    public Teacher getTeacher() {
	        return teacher;
	    }
	
	    public void setTeacher(Teacher teacher) {
	        this.teacher = teacher;
	    }
	}

测试类


	
	public class StudentTest {
	
	    @Test
	    public void testDeepCopy() throws CloneNotSupportedException, IOException, ClassNotFoundException {
	        Teacher teacher = new Teacher("teacher");
	        Student student = new Student("student", teacher);
	
	        //进行深复制
	        Student studentCopy = (Student) student.clone();
	        Student studentCopy1 = (Student) student.deepCopy();
	        //
	        Assert.assertNotEquals(student, studentCopy);
	        Assert.assertNotEquals(student.getTeacher(), studentCopy.getTeacher());
	        Assert.assertNotEquals(student.getTeacher(), studentCopy1.getTeacher());
	
	    }
	
	}


## 深复制---序列化实现

在Java中有一个 `Serializable` 接口，实现该接口的对象都有一个序列化标志，可以直接使用java的对象写入方法，把实现序列化接口的对象写入到输出流中，然后再把输入流转换为对象，由此可以实现对象的深层复制。通过一些java关键字的控制，可以屏蔽一些不想复制的字段。

### 具体代码

Teacher

	public class Teacher implements Cloneable, Serializable {
	
	    private String name;
	
	    public String getName() {
	        return name;
	    }
	
	    public void setName(String name) {
	        this.name = name;
	    }
	
	    public Teacher(String name) {
	        this.name = name;
	    }
	
	    @Override
	    protected Object clone() throws CloneNotSupportedException {
	        return super.clone();
	    }
	}

Student

	
	public class Student implements Cloneable, Serializable{
	
	    private String name;
	
	    private Teacher teacher;
	
	    public Student(String name, Teacher teacher) {
	        this.name = name;
	        this.teacher = teacher;
	    }
	
	    @Override
	    protected Object clone() throws CloneNotSupportedException {
	        Student student = null;
	        student = (Student) super.clone();
	        student.teacher = (Teacher) student.teacher.clone();
	        return student;
	    }
	
	    //深复制
	    public Object deepCopy () throws IOException, ClassNotFoundException {
	        ByteArrayOutputStream bo = new ByteArrayOutputStream();
	        ObjectOutputStream oo = new ObjectOutputStream(bo);
	        oo.writeObject(this);
	        //从流里读出来
	        ByteArrayInputStream bi = new ByteArrayInputStream(bo.toByteArray());
	        ObjectInputStream oi = new ObjectInputStream(bi);
	        return (oi.readObject());
	    }
	
	    public String getName() {
	        return name;
	    }
	
	    public void setName(String name) {
	        this.name = name;
	    }
	
	    public Teacher getTeacher() {
	        return teacher;
	    }
	
	    public void setTeacher(Teacher teacher) {
	        this.teacher = teacher;
	    }
	}

测试类



	public class StudentTest {
	
	    @Test
	    public void testDeepCopy() throws CloneNotSupportedException, IOException, ClassNotFoundException {
	        Teacher teacher = new Teacher("teacher");
	        Student student = new Student("student", teacher);
	
	        //进行深复制
	        Student studentCopy = (Student) student.clone();
	        Student studentCopy1 = (Student) student.deepCopy();
	        //
	        Assert.assertNotEquals(student, studentCopy);
	        Assert.assertNotEquals(student.getTeacher(), studentCopy.getTeacher());
	        Assert.assertNotEquals(student.getTeacher(), studentCopy1.getTeacher());
	
	    }
	
	}
