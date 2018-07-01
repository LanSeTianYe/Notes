时间：2018/6/30 10:00:38 

参考： 

## HTTP 请求工具

### [okhttp](http://square.github.io/okhttp/)

Android和Java的Http客户端。
特点：  

* 支持Http2.0，允许到相同host的请求共用Socket。
* 使用连接池减少请求延迟。
* 数据压缩，减少传输数据大小。
* 缓存响应结果，避免重复请求。
* 支持同步和异步请求。

请求示例：

	OkHttpClient client = new OkHttpClient();

    RequestBody body = new FormBody.Builder()
            .add("status", "1")
            .add("age", "23")
            .build();

    Request request = new Request.Builder()
            .url("http://www.sunfeilong.cn")
            .post(body)
            .build();

    Response response = client.newCall(request).execute();
    
    System.out.println(response.body().string());

### [Retrofit](http://square.github.io/retrofit/)   

依赖okhttp，并且属于同一个组织。、

类型安全的 andriod/java http 客户端。支持同步和异步（callback）的请求方式。基于注解构造请求信息。支持的注解如下：  

* @Header：请求头

		@Headers({
		    "Accept: application/vnd.github.v3.full+json",
		    "User-Agent: Retrofit-Sample-App"
		})
* @Body：对象参数
* @Path：路径参数
* @FormUrlEncoded：表单请求结合 `@Field` 使用
* @Multipart：包含文件结合 `@Part` 使用

请求接口：

	public interface GetArticle {
	
	    @GET("/fileInfo/getContentByFilePath")
	    Call<ResponseBody> getArticleInfo(@Query("id") String id, @Query("type") String type);
	
	    @POST("/fileInfo/getContentByFilePath")
	    Call<ResponseBody> getArticleInfoPost(@Query("id") String id, @Query("type") String type);
	}

接口调用：

 	private static final String baseUrl = "http://www.abc.com";

    public static void main(String[] args) throws IOException {
        Retrofit retrofit = new Retrofit
                .Builder()
                .baseUrl(baseUrl)
                .build();

    GetArticle getArticle = retrofit.create(GetArticle.class);
    Call<ResponseBody> call = getArticle.getArticleInfo("id", "type");

    Response<ResponseBody> response = call.execute();
    if(response.isSuccessful()) {
        System.out.println(response.toString());
    }

### [Async Http Client](https://github.com/AsyncHttpClient/async-http-client)

使Java应用程序可以很方便的执行http请求和异步处理响应结果，支持 WebSocket 协议。基于Netty实现。

特点：  

* 异步请求，支持jdk1.8 CompletableFuture 和回调函数的方式。
* 中断请求：可以在响应的各个阶段中断请求，减少后续处理耗费的时间。
* 支持WebSocket。
* WebDEV协议：操作服务器文件。
* 客户端重复利用，一个JVM内创建一个客户端接即可。

代码示例：  

	Future<Response> whenResponse = asyncHttpClient.prepareGet("http://www.example.com/").execute();

	# 响应的中间状态
	Future<Integer> whenStatusCode = asyncHttpClient.prepareGet("http://www.example.com/").execute(new AsyncHandler<Integer>() {
		private Integer status;
		@Override
		public State onStatusReceived(HttpResponseStatus responseStatus) throws Exception {
			status = responseStatus.getStatusCode();
			return State.ABORT;
		}
		@Override
		public State onHeadersReceived(HttpHeaders headers) throws Exception {
			return State.ABORT;
		}
		@Override
		public State onBodyPartReceived(HttpResponseBodyPart bodyPart) throws Exception {
			return State.ABORT;
		}
		@Override
		public Integer onCompleted() throws Exception {
			return status;
		}
		@Override
		public void onThrowable(Throwable t) {
		}
	});
