### 第一步，创建 Java 文件

	package com.sun.xiaotian.learing.thinking_in_java.native_;
	
	/**
	 * Description   :
	 * Project Name  :   XiaoTian
	 * Author        :   FieLong Sun
	 * Date          :   2016-06-22  20:33
	 */
	
	
	public class HelloWorld {
	
	    public native void sayHelloWorld();
	
	    //装入动态链接库，"HelloWorld"是要装入的动态链接库名称。
	    static {
	        System.loadLibrary("HelloWorld");
	    }
	}
### 第二步，生成 class 文件，并生成对应的 .h 文件



	>javac -d . -encoding UTF-8 HelloWorld.java
	
	>javah -jni com.sun.xiaotian.learing.thinking_in_java.native_.HelloWorld
### 第三步，创建 c++ 项目，生成对应的 .dll 文件