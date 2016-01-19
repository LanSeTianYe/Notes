#####   步骤
1. 自定义一个日期格式转换类
2. 注解使用该类

###### 自定义一个日期格式转换类	
	import com.fasterxml.jackson.core.JsonGenerator;
	import com.fasterxml.jackson.core.JsonProcessingException;
	import com.fasterxml.jackson.databind.JsonSerializer;
	import com.fasterxml.jackson.databind.SerializerProvider;
	
	import java.io.IOException;
	import java.text.SimpleDateFormat;
	
	
	public class CustomDateSerializer extends JsonSerializer {
	    @Override
	    public void serialize(Object value, JsonGenerator jgen, SerializerProvider serializerProvider)
	            throws IOException, JsonProcessingException {
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	        String formattedDate = formatter.format(value);
	        jgen.writeString(formattedDate);
	    }
	}


###### 注解使用该类（添加在get方法上面）


	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "finishtime")
	private Date finishTime;

	@JsonSerialize(using = CustomDateSerializer.class)
	public Date getFinishTime() {
		return finishTime;
	}

