时间 ： 2017/1/3 12:13:36

参考内容 ： 

1. [客户端用https连接服务器的一点心得](http://wwwww.iteye.com/blog/94854);
2. [ 解决PKIX：unable to find valid certification path to requested target 的问题](http://blog.csdn.net/faye0412/article/details/6883879)
3. [解决PKIX：unable to find valid certification path to requested target 的问题](http://www.cnblogs.com/AloneSword/p/3244434.html)  未使用
4. [java.security.InvalidAlgorithmParameterException](http://stackoverflow.com/questions/4764611/java-security-invalidalgorithmparameterexception-the-trustanchors-parameter-mus) 未使用

************************ 

## 安装证书
使用下面代码安装证书，证书会被安装到当前目录下。 

	/**
     * 根据主机地址和端口号安装证书
     * @param host          //主机地址，不能为空
     * @param port          //端口号, 默认为443
     * @param passphrase    //口令，默认 changeit
     * @throws Exception
     */
    public static void installByHostAndPort (String host, int port, String passphrase) throws Exception {

        char[] passphraseCharArr;

        //选择第几个证书，默认第一个
        int certNum = 0;

        //自动选择安装证书，如果没有合适的则跑出RuntimeException，然后安装第一个
        String hostName;
        try {
           hostName = host.split("\\.")[1];
        } catch (Exception e) {
            throw new RuntimeException("host地址格式非法", e);
        }


        //检测主机名
        if (host == null || host.equals("")) {
            System.out.println("主机地址不能为空！");
            return;
        }

        //端口号
        port = port <= 0 ? 443:port;

        //口令
        if (passphrase == null || passphrase.equals("")) {
            passphrase = "changeit";
        }
        passphraseCharArr = passphrase.toCharArray();

        //当前目录下生成证书
        File file = new File("jssecacerts");
        if (file.isFile() == false) {
            char SEP = File.separatorChar;
            File dir = new File(System.getProperty("java.home") + SEP + "lib"
                    + SEP + "security");
            file = new File(dir, "jssecacerts");
            if (file.isFile() == false) {
                file = new File(dir, "cacerts");
            }
        }

        System.out.println("Loading KeyStore " + file + "...");
        InputStream in = new FileInputStream(file);
        KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
        ks.load(in, passphraseCharArr);
        in.close();

        //握手 验证证书
        SSLContext context = SSLContext.getInstance("TLS");
        TrustManagerFactory tmf = TrustManagerFactory
                .getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(ks);
        X509TrustManager defaultTrustManager = (X509TrustManager) tmf
                .getTrustManagers()[0];
        SavingTrustManager tm = new SavingTrustManager(defaultTrustManager);
        context.init(null, new TrustManager[] { tm }, null);
        SSLSocketFactory factory = context.getSocketFactory();

        System.out.println("Opening connection to " + host + ":" + port + "...");

        SSLSocket socket = (SSLSocket) factory.createSocket(host, port);
        socket.setSoTimeout(10000);
        try {
            System.out.println("Starting SSL handshake...");
            socket.startHandshake();
            socket.close();
            System.out.println();
            System.out.println("No errors, certificate is already trusted");
        } catch (SSLException e) {
            System.out.println();
            e.printStackTrace(System.out);
        }

        //接受服务器发送的证书
        X509Certificate[] chain = tm.chain;
        if (chain == null) {
            System.out.println("Could not obtain server certificate chain");
            return;
        }


        System.out.println();
        System.out.println("Server sent " + chain.length + " certificate(s):");
        System.out.println();
        MessageDigest sha1 = MessageDigest.getInstance("SHA1");
        MessageDigest md5 = MessageDigest.getInstance("MD5");

        for (int i = 0; i < chain.length; i++) {
            X509Certificate cert = chain[i];
            System.out.println(" " + (i + 1) + " Subject "
                    + cert.getSubjectDN());
            System.out.println("   Issuer  " + cert.getIssuerDN());
            sha1.update(cert.getEncoded());
            System.out.println("   sha1    " + toHexString(sha1.digest()));
            md5.update(cert.getEncoded());
            System.out.println("   md5     " + toHexString(md5.digest()));
            System.out.println();
            if(cert.getSubjectDN().toString().contains(hostName)) {
                certNum = i;
            }
        }
        System.out.println("安装第" + (certNum +  1) + "个证书......");
        Thread.sleep(2000);


        X509Certificate cert = chain[certNum];
        String alias = host + "-" + (certNum + 1);
        ks.setCertificateEntry(alias, cert);

        OutputStream out = new FileOutputStream("jssecacerts");
        ks.store(out, passphraseCharArr);
        out.close();

        System.out.println();
        System.out.println(cert);
        System.out.println();
        System.out.println("Added certificate to keystore 'jssecacerts' using alias '"+ alias + "'");
    }

    private static final char[] HEXDIGITS = "0123456789abcdef".toCharArray();

    //byte数组转换为16进制字符
    private static String toHexString(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 3);
        for (int b : bytes) {
            b &= 0xff;
            sb.append(HEXDIGITS[b >> 4]);
            sb.append(HEXDIGITS[b & 15]);
            sb.append(' ');
        }
        return sb.toString();
    }

    //
    private static class SavingTrustManager implements X509TrustManager {
        private final X509TrustManager tm;
        private X509Certificate[] chain;

        SavingTrustManager(X509TrustManager tm) {
            this.tm = tm;
        }

        public X509Certificate[] getAcceptedIssuers() {
            throw new UnsupportedOperationException();
        }

        public void checkClientTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {
            throw new UnsupportedOperationException();
        }

        public void checkServerTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {
            this.chain = chain;
            tm.checkServerTrusted(chain, authType);
        }
    }


## 模拟代码
依赖包如下

		<!--JSON数据解析-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.8</version>
        </dependency>


        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.25</version>
        </dependency>

        <dependency>
            <groupId>org.apache.httpcomponents</groupId>
            <artifactId>httpclient</artifactId>
            <version>4.5.1</version>
        </dependency>
代码：

	public JSONObject POST_HTTPS(String url, JSONObject params){

        CloseableHttpClient client = HttpClients.createDefault();
        String responseText = "";
        CloseableHttpResponse response = null;
        JSONObject jsonObject = null;
        try {
            HttpPost method = new HttpPost(url);
            if (params != null) {
                List<NameValuePair> paramList = new ArrayList<NameValuePair>();

                for (Map.Entry<String, Object> param : params.entrySet()) {
                    NameValuePair pair = new BasicNameValuePair(param.getKey(), String.valueOf(param.getValue()));
                    paramList.add(pair);
                }
                method.setEntity(new UrlEncodedFormEntity(paramList, ENCODING));
            }
            response = client.execute(method);
            HttpEntity entity = response.getEntity();
            if (entity != null) {
                responseText = EntityUtils.toString(entity);
            }
            //转换为对象
            jsonObject = stringToJSONObject(responseText);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                response.close();
            } catch (Exception e) {
                throw new RuntimeException("流关闭错误");
            }
        }

        return jsonObject;
    }

	//字符串转换为JSON对象
    private static JSONObject stringToJSONObject(String dataStr) {
        JSONObject jsonObject = null;
        try {
            jsonObject = (JSONObject) JSON.parse(dataStr);
        } catch (Exception e) {
            jsonObject = new JSONObject();
        }
        return jsonObject;
    }

