## 
时间：2017/5/3 17:33:22 

## 常用编码
* ASCII : 8位（0 ~ (2^7 -1)），ASCII编码包括 控制字符和可见字符。

  * 控制字符（不可见）:`空字符（Null）` `标题开始`
		
* Unicode : 16位（0 ~ （2^16-1）），可以表示65535种不同字符，前127个和ASCII对应，后面的字符用于表示其他语言。
  * 汉字的范围 : `0x4E00 ~ 0x9FA5`

			
			public class Test {
			
			    private final static int ZN_CHStart = 0x4E00;
			    private final static int ZN_CHEnd = 0x9FA5;
			
			    public static void main(String[] args) {
			        for (int index = ZN_CHStart; index <= ZN_CHEnd; index++) {
			            addIndexEvery16(index);
			            printCharToConsole(index);
			        }
			    }
			
			    private static void addIndexEvery16(int index){
			        if(index % 16 == 0) {
			            addNewLineEvery16(index);
			            System.out.print(Integer.toHexString(index) + "  ");
			        }
			    }
			
			    private static void addNewLineEvery16(int index){
			        if(index != ZN_CHStart) {
			            System.out.println("");
			        }
			    }
			
			
			    private static void printCharToConsole(int index){
			        System.out.print(((char) index) + "  ");
			    }
			}


## JAVA 字符编码

在 Java 中一个字符占两个字节16位，Java中的字符使用 Unicode 编码，因此可以方便的表示常用汉字（7000个左右）。

	int unicodeLength = 2<<16 - 1;
    for (int i = 0; i < unicodeLength; i++) {
        System.out.println(((char) i));
    }

