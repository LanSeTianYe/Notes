##  
时间：2017/4/12 22:48:41 

## Shrio的功能
1. 认证（Authentication ）
2. 资源授权（Authorization）
3. 密码加密解密
4. 会话Session管理
5. Web Support


		<filter>
		    <filter-name>ShiroFilter</filter-name>
		    <filter-class>
		        org.apache.shiro.web.servlet.IniShiroFilter
		    </filter-class>
		    <!-- no init-param means load the INI config
		        from classpath:shiro.ini --> 
		</filter>

		<filter-mapping>
		     <filter-name>ShiroFilter</filter-name>
		     <url-pattern>/*</url-pattern>
		</filter-mapping>
## 核心概念

1. Subject:当前登录的用户

		Subject currentUser = SecurityUtils.getSubject();
2. SecurityManager

		//1. Load the INI configuration
		Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
		
		//2. Create the SecurityManager
		SecurityManager securityManager = factory.getInstance();
		
		//3. Make it accessible
		SecurityUtils.setSecurityManager(securityManager);
3. Realms：应用程序安全数据和Shiro的连接器例如认证和授权。

4. Authentication（认证，验证用户身份）

5. Authorization（授权，资源授权）

6. Session Management

	Session session = subject.getSession();
	Session session = subject.getSession(boolean create);

7. Cryptography
 * Hashing

			String hex = new Md5Hash(myFile).toHex();
			String encodedPassword = new Sha512Hash(password, salt, count).toBase64();
 * Ciphers

			AesCipherService cipherService = new AesCipherService();
			cipherService.setKeySize(256);

			//create a test key:
			byte[] testKey = cipherService.generateNewKey();
			
			//encrypt a file’s bytes:
			byte[] encrypted =
			cipherService.encrypt(fileBytes, testKey);