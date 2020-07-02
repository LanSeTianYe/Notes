时间：2019/6/18 23:41:29   


## Java 文档注释 

**模板代码：**

	/**
	 * @param <T> 对象类型
	 */
	public class TestDoc<T> {
	
	    private T data;
	
	    /**
	     * 保存对象
	     *
	     * @param data 对象
	     */
	    public TestDoc(T data) {
	        this.data = data;
	    }
	
	    private enum Fruits {
	        /**
	         * 苹果
	         */
	        APPLE,
	        /**
	         * 香蕉
	         */
	        ORANGE,
	        /**
	         * 橘子
	         */
	        BANANA,
	        ;
	
	    }
	
	    /**
	     * 测试文档 <br>
	     * {@literal |x+y| < |x| + |y|} <br>
	     * {@link java.util.FormattableFlags} <br>
	     *
	     * @param arg1 参数一 正整数不许大于等于0
	     * @param arg2 参数二 不能为空
	     * @param arg3 参数三
	     * @return 0
	     * @throws IllegalArgumentException 当 {@code arg2 <= 0 or null == arg2 }
	     */
	    public int method(int arg1, String arg2, Object arg3) {
	        //do nothing
	        if (arg1 <= 0) {
	            throw new IllegalArgumentException();
	        }
	        if (null == arg2) {
	            throw new IllegalArgumentException();
	        }
	        return 0;
	    }
	}