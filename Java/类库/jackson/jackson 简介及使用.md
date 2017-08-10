##   
时间:2017/7/18 7:42:38   
参考： 
  
1. [https://github.com/FasterXML/jackson-databind](https://github.com/FasterXML/jackson-databind)
2. [Jackson JSON: deserialize a list of objects of subclasses of an abstract class](http://www.davismol.net/2015/03/05/jackson-json-deserialize-a-list-of-objects-of-subclasses-of-an-abstract-class/)

##  简介

对象序列化/反序列化（Java对象转换为JSON/JSON转换为Java对象）。  
核心概念：

 * databind（jackson-databind）：数据绑定
 * streaming（jackson-core）：流处理，数据写入文件
 * annotations（jackson-annotations）：注解

## 数据绑定

POJO：

	public class MyValue {
	  public String name;
	  public int age;
	  // NOTE: if using getters/setters, can keep fields `protected` or `private`
	}

1. 简单绑定POJO：（ObjectMapper可以很好的处理JDK的List、Map，不需要额外的配置）

	序列化反序列化：
	
		ObjectMapper mapper = new ObjectMapper();
		//写入
		mapper.writeValue(new File("result.json"), myResultObject);
		byte[] jsonBytes = mapper.writeValueAsBytes(myResultObject);
		String jsonString = mapper.writeValueAsString(myResultObject);
		//读取
		MyValue value = mapper.readValue(new File("data.json"), MyValue.class);
		value = mapper.readValue(new URL("http://some.com/api/entry.json"), MyValue.class);
		value = mapper.readValue("{\"name\":\"Bob\", \"age\":13}", MyValue.class);

2. 复杂对象使用 `TypeReference`

		Map<String, ResultValue> results = mapper.readValue(jsonSource,new TypeReference<Map<String, MyValue>>() { } );

3. TreeModel  
读取Json文件，对象转换为ObjectNode，数组转换为ArrayNode。

		ObjectNode root = mapper.readTree("stuff.json");
		String name = root.get("name").asText();
		int age = root.get("age").asInt();
		root.with("other").put("type", "student");
		String json = mapper.writeValueAsString(root);




## Stream

向文件中写入数据和从文件中读取数据，目前（2017/7/18 8:16:59 ）不常用。

	public static void main(String[] args) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonGenerator generator = objectMapper.getFactory().createGenerator(System.out, JsonEncoding.UTF8);
        Stream stream = new Stream();
        stream.setName("stream");
        generator.writeObject(stream);
        System.out.println();
        
        //写入文件, new JsonFactory 只能写入简单类型，写入复杂类型需要从ObjectMapper初始化工厂
        JsonFactory jsonFactory = new JsonFactory();
        JsonGenerator generator1 = jsonFactory.createGenerator(System.out, JsonEncoding.UTF8);
        generator1.writeStartObject();
        generator1.writeStringField("name", "sun");
        generator1.writeEndObject();
        generator1.flush();
        generator1.close();
    }

	class Stream {
	    private String name;
	    public String getName() {
	        return name;
	    }
	    public void setName(String name) {
	        this.name = name;
	    }
	}



## 配置
配置属性主要是几个 `ConfigFeature` 的实现，具体内容可以看实现类的注释。

* DeserializationFeature：反序列化相关配置
* MapperFeature：
* SerializationFeature：序列化相关配置

序列化：  

	// to enable standard indentation ("pretty-printing"):
	mapper.enable(SerializationFeature.INDENT_OUTPUT);
	// to allow serialization of "empty" POJOs (no properties to serialize)
	// (without this setting, an exception is thrown in those cases)
	mapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
	// to write java.util.Date, Calendar as number (timestamp):
	mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

反序列化：

	ObjectMapper objectMapper = new ObjectMapper();
    //反序列化的时候，如果反序列化的内容有忽略的属性，比如:person.age, 会抛出 IgnoredPropertyException
    objectMapper.configure(DeserializationFeature.FAIL_ON_IGNORED_PROPERTIES, true);
    //反序列化的时候，如果反序列化的内容未知的属性，需要关闭比JsonIgnoreProperties。如: person.sex1,会抛出 UnrecognizedPropertyException
    objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, true);
   

底层解析配置： 

	//For example, enabling this feature will represent a JSON array ["value1",,"value3",] as ["value1", null, "value3", null]
    objectMapper.configure(JsonParser.Feature.ALLOW_MISSING_VALUES, false);
    //开启之后会耗费性能，检查是否有重复的key。 JsonParseException: Duplicate field 'name'
    objectMapper.configure(JsonParser.Feature.STRICT_DUPLICATE_DETECTION, false);
	// to force escaping of non-ASCII characters:
	mapper.configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
	//允许字段名不带引号
	mapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);

## 注解

通过在类或字段上添加注解，控制序列化和反序列化的具体内容。

* `@JsonProperty`: 指定序列化和反序列化时，类字段对应的JSON字段名。
* `@JsonIgnoreProperties({ "foo", "bar" })`：注解在类上，在JSON文件中读取到对应的属性的时候会自动跳过，无论POJO对象上是否有对应的属性。
* `@JsonIgnore`:

		// means that if we see "foo" or "bar" in JSON, they will be quietly skipped
		// regardless of whether POJO has such properties
		@JsonIgnoreProperties({ "foo", "bar" })
		public class MyBean
		{
		   // will not be written as JSON; nor assigned from JSON:
		   @JsonIgnore
		   public String internal;
		
		   // no annotation, public field is read/written normally
		   public String external;
		
		   @JsonIgnore
		   public void setCode(int c) { _code = c; }
		
		   // note: will also be ignored because setter has annotation!
		   public int getCode() { return _code; }
		}

		//get方法加注解控制序列化过程，set方法加注解控制反序列化过程
		//in this case, no "name" property would be written out (since 'getter' is ignored); 
		//but if "name" property was found from JSON, it would be assigned to POJO property!
		public class ReadButDontWriteProps {
		   private String _name;
		   @JsonProperty public void setName(String n) { _name = n; }
		   @JsonIgnore public String getName() { return _name; }
		}
* ` @JsonCreator`: 自定义构造函数

		public class CtorBean
		{
		  public final String name;
		  public final int age;
		
		  @JsonCreator // constructor can be public, private, whatever
		  private CtorBean(@JsonProperty("name") String name,
		    @JsonProperty("age") int age){
		      this.name = name;
		      this.age = age;
		  }
		}
* `@JsonIgnoreProperties(ignoreUnknown = true)` ： 忽略未知属性
* `@JsonUnwrapped` : 标注在类的对象字段上，序列化的时候会把对象字段的属性放在类上。
* `@JsonSerialize`:自定义序列化实现
* `@JsonDeserialize`：自定义反序列化实现
	
		@JsonSerialize(using = AddSuffixJsonSerialize.class)
	    @JsonDeserialize(using = DeleteSuffixDeserialize.class)
	    public String sex;

		/**
		 * 序列化的时候添加后缀
		 */
		class AddSuffixJsonSerialize extends JsonSerializer<String> {
		
		    @Override
		    public void serialize(String value, JsonGenerator gen, SerializerProvider serializers)
		            throws IOException {
		        gen.writeString(value + "_suffix");
		    }
		}
		
		/**
		 * 反序列化的时候删除后缀
		 */
		class DeleteSuffixDeserialize extends JsonDeserializer<String> {
		
		    @Override
		    public String deserialize(JsonParser p, DeserializationContext ctxt)
		            throws IOException {
		        ctxt.setAttribute("name", "name");
		        return p.getText().replace("_suffix", "");
		    }
		}
	
* ` @JsonTypeInfo` : 继承和实现类注解，使用的属性可以灵活变化

		@JsonTypeInfo(
	            use = JsonTypeInfo.Id.NAME,
	            include = JsonTypeInfo.As.PROPERTY,
	            property = "type")
	    @JsonSubTypes({
	            @JsonSubTypes.Type(value = B.class, name = "b"),
	            @JsonSubTypes.Type(value = C.class, name = "c")
	    })
	    static interface A {
	        @JsonProperty
	        String getName();
	    }
	
	
	    static class B implements A {
	
	        public String name;
	
	        @Override
	        public String getName() {
	            return "A";
	        }
	
	        public void setName(String name) {
	            this.name = name;
	        }
	    }
	
	
	    static class C implements A {
	
	        public String name;
	
	        @Override
	        public String getName() {
	            return "B";
	        }
	
	        public void setName(String name) {
	            this.name = name;
	        }
	    }


## 类型转换


	// Convert from List<Integer> to int[]
	List<Integer> sourceList = ...;
	int[] ints = mapper.convertValue(sourceList, int[].class);
	// Convert a POJO into Map!
	Map<String,Object> propertyMap = mapper.convertValue(pojoValue, Map.class);
	// ... and back
	PojoType pojo = mapper.convertValue(propertyMap, PojoType.class);
	// decode Base64! (default byte[] representation is base64-encoded String)
	String base64 = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz";
	byte[] binary = mapper.convertValue(base64, byte[].class);