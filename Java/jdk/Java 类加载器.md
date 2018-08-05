时间：2018/1/25 22:50:25 

参考：  

1. [深入探讨 Java 类加载器](https://www.ibm.com/developerworks/cn/java/j-lo-classloader/)
2. [jdk1.6 中文文档](http://tool.oschina.net/apidocs/apidoc?api=jdk-zh)

##  Java 类加载器简介 

**虚拟机生成类过程：** 

编写Java源代码 -> 编译生成class文件 -> 类加载器找到class文件 -> 生成类实例

**类加载器结构：**

引导类加载器 -> 扩展类加载器 `ExtClassLoader` -> 系统类加载器 `AppClassLoader` -> 自定义类加载器

**类相同的定义：**

 * 全名相同
 * 类加载器相同

**类加载器加载顺序：**

类加载器在尝试自己去查找某个类的字节代码并定义它时，会先代理给其父类加载器，由父类加载器先去尝试加载这个类，依次类推。  

## 相关类简介

### ClassLoader 类

 * `public final ClassLoader getParent()` ：当前类加载器的父加载器。
 * `public Class<?> loadClass(String name)` :加载名称为name的类(包含包路径)。
 * `protected final Class<?> findLoadedClass(String name)` :查找名称为 name的已经被加载过的类。
 * `protected final Class<?> defineClass(String name, byte[] b, int off, int len)` :把字节数组中的内容转换成Java类。
 * `protected final void resolveClass(Class<?> c) `: 链接指定的 Java 类。

虚拟机内置类加载器 `bootstrap class loader`

同一个类文件被不同的类加载器加载之后生成的类实例不是相同的类型。

* 定义类加载器：
* 启动类加载器：

## 自定义类加载器

* 文件类加载器：

		public class FileSystemClassLoader extends ClassLoader {
		
		    private final String classPath;
		
		    public FileSystemClassLoader(String filePath) {
		        this.classPath = filePath;
		    }
		
		    @Override
		    protected Class<?> findClass(String name) throws ClassNotFoundException {
		        byte[] fileData = getFileData(name);
		        if (fileData == null) {
		            return super.loadClass(name);
		        }
		        return defineClass(name, fileData, 0, fileData.length);
		    }
		
		    private byte[] getFileData(String name) {
		        String fileName = classToFileName(name);
		        File file = new File(classPath + fileName);
		        if (!file.exists()) {
		            return null;
		        }
		
		        try (InputStream ins = new FileInputStream(file);
		             ByteArrayOutputStream tempCache = new ByteArrayOutputStream()) {
		            int bufferSize = 4096;
		            byte[] buffer = new byte[bufferSize];
		            int bytesNumRead = 0;
		            while ((bytesNumRead = ins.read(buffer)) != -1) {
		                tempCache.write(buffer, 0, bytesNumRead);
		            }
		            return tempCache.toByteArray();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		        return null;
		    }
		
		    private String classToFileName(String className) {
		        int index = className.lastIndexOf(".");
		        return className.substring(index + 1) + ".class";
		    }
		}

* 使用

		public static void main(String[] args) throws ClassNotFoundException, IllegalAccessException, InstantiationException, InterruptedException, NoSuchMethodException, InvocationTargetException {
	        //确保target目录加载到Simple.Class文件,如果有的话父类加载器会加载到类文件
	        FileSystemClassLoader fileSystemClassLoader1 = new FileSystemClassLoader("D:\\");
	        FileSystemClassLoader fileSystemClassLoader2 = new FileSystemClassLoader("D:\\");
	
	        Class<?> simpleCLass1 = fileSystemClassLoader1.loadClass("com.sun.xiaotian.demo.test.cl.Simple");
	        Class<?> simpleCLass2 = fileSystemClassLoader2.loadClass("com.sun.xiaotian.demo.test.cl.Simple");
	        System.out.println(simpleCLass1.getClassLoader());
	        System.out.println(simpleCLass2.getClassLoader());
	        TimeUnit.SECONDS.sleep(1);
	
	        Object simple1 = simpleCLass1.newInstance();
	        Object simple2 = simpleCLass2.newInstance();
	
	        Method setInstance = simpleCLass1.getMethod("setInstance", Object.class);
	        setInstance.invoke(simple1, simple2);
	    }

* 辅助类

		public class Simple {
		
		    private Simple instance;
		
		    public void setInstance(Object instance) {
		        this.instance = ((Simple) instance);
		    }
		}