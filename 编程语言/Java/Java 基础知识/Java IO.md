时间：2020-10-28 11:03:03

## Java IO

每种输入流都有对应的输出流。

输入：读取数据。
输出：写入数据。

### 字节输入输出

> java.io.InputStream 字节输入流
>
> > FileInputStream 文件字节输入流。
> > 
> > ByteArrayInputStream 字节数组输入流，把字节数组封装成一个输入流。
> > 
> > ObjectInputStream 对象输入流。
> >   
> > PipedInputStream 管道输入流，结合PipedOutputStream使用，数据写入到输出流之后可以从输入流读取到。
> > 
> > SequenceInputStream 连接多个输入流。
> > 
> > FilterInputStream 需要被继承使用，覆盖方法，实现其它功能。
> 
> java.io.OutputStream 字节输出流
>
> > FileOutputStream 文件字节输出流。
> > 
> > ByteArrayOutputStream 字节数组输出流，把字节数组封装成一个输出流。
> > 
> > ObjectOutputStream 对象输出流。
> >   
> > PipedOutputStream 管道输出流。
> > 
> > FilterOutputStream 需要被继承使用，覆盖方法，实现其它功能。
> > >
> > > BufferedOutputStream 可缓冲的输出流。
> > > 
> > > CipherOutputStream 加密写入数据。
> > > 
> > > CheckedOutputStream 返回校验和。
> > > 
> > > DigestOutputStream  返回摘要。
> > > 
> > > PrintStream 不会抛出异常。

### 字符输入输出

> java.io.Reader 字符读取器。
> >
> > InputStreamReader 输入流中字符读取器。
> > >
> > > FileReader 文件字符读取器。
> >
> > CharArrayReader 字符数组字符读取器。
> > 
> > BufferedReader 缓冲字节读取器，使用字符读取器，可以读取一行。
> > >
> > > LineNumberReader 行字符读取器，可以读取一行，以及设置读取第几行。
> > 
> > FilterReader 需要被继承使用，覆盖方法，实现其它功能。
> > >
> > > PushbackReader 允许把已经读取的字符再放回读取器中。
> > 
> > PipedReader 管道字符读取器。
> > 
> > StringReader 字符串字符读取器。
> 
> java.io.Writer 字符读写入器。
> >
> > OutputStreamWriter 输入流中字符写入器。
> >
> > CharArrayWriter 字符数组字符写入器。
> > 
> > BufferedWriter  缓冲字节写入取器，写入字节。
> > 
> > FilterWriter 需要被继承使用，覆盖方法，实现其它功能。
> > 
> > PipedWriter  管道字符写入器。
> > 
> > PrintWriter 格式化写入器，不会抛出异常。
> > 
> > StringWriter 字符串写入器。
