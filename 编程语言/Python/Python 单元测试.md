时间：2018/1/6 14:36:55   
参考： 

1. [Testing Your Code](http://docs.python-guide.org/en/latest/writing/tests/)
2. [Unit testing framework](https://docs.python.org/3/library/unittest.html#module-unittest)


##  unittest

#### 核心类及方法

* TestCase 测试用例要实现的父类  
* TestSuite TestCase和TestSuite的组合

	例子：

		import unittest
	
		from tests.test_demo import TestDemo
		
		if __name__ == '__main__':
		
		    suite = unittest.TestSuite()
		    suite.addTests(unittest.TestLoader().loadTestsFromTestCase(TestDemo))
		
		    try:
		        with open("test.txt", mode="w", encoding="utf-8") as t:
		            runner = unittest.TextTestRunner(stream=t, verbosity=2)
		            runner.run(suite)
		    except FileNotFoundError as e:
		        print("测试出错", str(e))
* TestLoader  加载测试用例  
* TestResult 测试用例运行结果
* TextTestResult 运行测试用例
* main：启动入口

		if __name__ == '__main__':
		    unittest.main(verbosity=2)
* load_tests：自定义加载测试方法的方法


#### 测试命令

* 查看帮助文档

		python -m unittest -h

* 运行某个测试某个文件
	
		python -m unittest tests/test.py

* 不指定参数，会启动自动发现机制

		python -m unittest	
		python -m unittest discover
	
* 测试指定模块，路径分隔符替换成 `.`, python文件去掉 `.py` 后缀。 

		python -m unittest tests.test
* 指定参数：
	* `unittest` 支持的参数
	
			-b, --buffer
			The standard output and standard error streams are buffered during the test run. Output during a passing test is discarded. Output is echoed normally on test fail or error and is added to the failure messages.
			
			-c, --catch
			Control-C during the test run waits for the current test to end and then reports all the results so far. A second Control-C raises the normal KeyboardInterrupt exception.
			
			See Signal Handling for the functions that provide this functionality.
			
			-f, --failfast
			Stop the test run on the first error or failure.
			
			--locals
			Show local variables in tracebacks.

	* `discover` 发现机制支持的参数：

			-v, --verbose
			Verbose output
			
			-s, --start-directory directory
			Directory to start discovery (. default)
			
			-p, --pattern pattern
			Pattern to match test files (test*.py default)
			
			-t, --top-level-directory directory
			Top level directory of project (defaults to start directory)
	usecase：
	
			python -m unittest discover -s project_directory -p "*_test.py"
			python -m unittest discover project_directory "*_test.py"

### 测试方法

* 资源初始化和资源回收，每个测试方法运行和结束的时候都会调用

		def setUp(self):
	        self.widget = Widget('The widget')
	
	    def tearDown(self):
	        self.widget.dispose()
* 跳过测试 

	* 添加在方法上
	
			@unittest.skip("demonstrating skipping")
			@unittest.skipIf(mylib.__version__ < (1, 3), "not supported in this library version")
			@unittest.skipUnless(sys.platform.startswith("win"), "requires Windows")
	* 添加在class 上
	
			@unittest.skip("showing class skipping")
	* 写代码跳过
		
		    def test_skip_in_code(self):
		        self.skipTest("测试代码内跳过测试")
* 预期的异常

	 	@unittest.expectedFailure
	    def test_fail(self):
	        self.assertEqual(1, 0, "broken")
* 子测试，子测试里面遇到错误，上级测试不会结束，会继续进行测试

	    def test_even(self):
	        """
	        3.6版本没有效果
	        """
	        for i in range(0, 4):
	            with self.subTest(i=i):
	                self.assertEqual(i % 2, 0)


	
