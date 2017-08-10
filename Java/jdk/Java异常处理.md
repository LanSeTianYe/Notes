## 异常丢失

	public class LostException {
		public static void f() throws ImportException {
			throw new ImportException("重要的异常");
		}
		
		public static void g() throws CommonException {
			 throw new CommonException();
		}
		
		public static void main(String[] args) {
			try{
				try{
					f();
				}finally {
					g();
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}

这里我们会丢失 `ImportException`的catch

正确的处理方法：

	public class LostException {
		public static void f() throws ImportException {
			throw new ImportException("重要的异常");
		}
		
		public static void g() throws CommonException {
			 throw new CommonException();
		}
		
		public static void main(String[] args) {
			try{
				try{
					f();
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					g();
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}