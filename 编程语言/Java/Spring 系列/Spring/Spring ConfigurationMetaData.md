时间：2018/9/25 11:45:17   

参考：  

1. [Appendix B. Configuration Metadata](https://docs.spring.io/spring-boot/docs/current/reference/html/configuration-metadata.html)

## Spring 配置元数据    

### 简介  

通过 `Json` 定义配置参数对应的类。Json文件由三部分组成，配置信息实体类需要添加 `@ConfigurationProperties` 注解。（结合 `@ConditionalOnProperty` 使用效果更好）

* groups: 定义一个分组， 如 `server`。
	* name: 分组的名称，必须有。
	* type：属性的类型，可以省略。
	* description：分组的描述，可以省略。
	* sourceType：提供配置类的名字，可以省略。
	* sourceMethod：方法的全名，可以省略。
* properties: 定义分组下的字段的类型和默认值等信息。
	* name：属性名。
	* type：数据类型。
	* description：描述。
	* sourceType：类名。
	* defaultValue：默认值。
	* deprecation：不推荐使用。
* hits: 指定字段的可选值。
	* name：属性名。
	* values:可选值列表。
	* providers: 属性值来源。

Json定义：  

	{
	  "groups": [
	    {
	      "name": "server",
	      "type": "org.springframework.boot.autoconfigure.web.ServerProperties",
	      "sourceType": "org.springframework.boot.autoconfigure.web.ServerProperties"
	    },
	    {
	      "name": "spring.jpa.hibernate",
	      "type": "org.springframework.boot.autoconfigure.orm.jpa.JpaProperties$Hibernate",
	      "sourceType": "org.springframework.boot.autoconfigure.orm.jpa.JpaProperties",
	      "sourceMethod": "getHibernate()"
	    }
	    ...
	  ],
	  "properties": [
	    {
	      "name": "server.port",
	      "type": "java.lang.Integer",
	      "sourceType": "org.springframework.boot.autoconfigure.web.ServerProperties"
	    },
	    {
	      "name": "server.servlet.path",
	      "type": "java.lang.String",
	      "sourceType": "org.springframework.boot.autoconfigure.web.ServerProperties",
	      "defaultValue": "/"
	    },
	    {
	      "name": "spring.jpa.hibernate.ddl-auto",
	      "type": "java.lang.String",
	      "description": "DDL mode. This is actually a shortcut for the \"hibernate.hbm2ddl.auto\" property.",
	      "sourceType": "org.springframework.boot.autoconfigure.orm.jpa.JpaProperties$Hibernate"
	    }
	    ...
	  ],
	  "hints": [
	    {
	      "name": "spring.jpa.hibernate.ddl-auto",
	      "values": [
	        {
	          "value": "none",
	          "description": "Disable DDL handling."
	        },
	        {
	          "value": "validate",
	          "description": "Validate the schema, make no changes to the database."
	        },
	        {
	          "value": "update",
	          "description": "Update the schema if necessary."
	        },
	        {
	          "value": "create",
	          "description": "Create the schema and destroy previous data."
	        },
	        {
	          "value": "create-drop",
	          "description": "Create and then destroy the schema at the end of the session."
	        }
	      ]
	    }
	  ]
	}

具体类：
	
	@ConfigurationProperties(prefix = "server", ignoreUnknownFields = true)
	public class ServerProperties {
	
		private Integer port;
	
		public void setPort(Integer port) {
			this.port = port;
		}
	}

### 其它 

**@ConfigurationProperties 源码：**


	@Target({ ElementType.TYPE, ElementType.METHOD })
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	public @interface ConfigurationProperties {
	
		/**
		 * The name prefix of the properties that are valid to bind to this object. Synonym
		 * for {@link #prefix()}.
		 * @return the name prefix of the properties to bind
		 */
		@AliasFor("prefix")
		String value() default "";
	
		/**
		 * The name prefix of the properties that are valid to bind to this object. Synonym
		 * for {@link #value()}.
		 * @return the name prefix of the properties to bind
		 */
		@AliasFor("value")
		String prefix() default "";
	
		/**
		 * Flag to indicate that when binding to this object invalid fields should be ignored.
		 * Invalid means invalid according to the binder that is used, and usually this means
		 * fields of the wrong type (or that cannot be coerced into the correct type).
		 * @return the flag value (default false)
		 */
		boolean ignoreInvalidFields() default false;
	
		/**
		 * Flag to indicate that when binding to this object unknown fields should be ignored.
		 * An unknown field could be a sign of a mistake in the Properties.
		 * @return the flag value (default true)
		 */
		boolean ignoreUnknownFields() default true;
	
	}
