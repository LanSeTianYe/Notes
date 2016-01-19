## 描述

	解决的问题：
		1.使用SpringMVC上传文件
		2.上传之后页面不跳转
	日期：2016/1/19 19:50:03 
	环境： SpringBoot
	可能存在的问题：直接使用可能会出现ClassNotFound的问题。

需要的文件：  
jquery.form.min.js：[http://pan.baidu.com/s/1KntO6](http://pan.baidu.com/s/1KntO6)

## 步骤
html代码：    
注意：为了实现表单提交之后页面不跳转，需要设置form的 `onsubmit="return false"`, 然后使用 `jqueryForm` 提交表单。

	<form id="uploadFileForm" action="/workFile/uploadFile" method="post" enctype="multipart/form-data" onsubmit="return false">
		<input type="file" id="file" name="file">
		<label class="col-sm-3 control-label" for="file">上传附件</label>
		<div class="col-sm-9 control-content">
			<a href="javascript:void(0);" class="btn-uopload" ng-click="uploadFile()">上传</a>
		</div>
	</form>

js代码：  
这里使用 jQuery的form提交表单，需要使用(jquery.form.min.js [http://pan.baidu.com/s/1KntO6](http://pan.baidu.com/s/1KntO6))

	//上传文件
	$scope.uploadFile = function() {
		$("#uploadFileForm").ajaxSubmit(function() {
			
		});
	}

Java代码：

	/**
     * 上传文件
     * @return
     */
    @RequestMapping(value="/workFile/uploadFile", method= RequestMethod.POST)
    @ResponseBody
    public void uploadFile(HttpServletRequest request){
        try {
            //目录不存在则创建目录
            String filePath = request.getSession().getServletContext().getRealPath("/");
            File fileFolder = new File(filePath+"//workFile//");
            if(!fileFolder.exists()) {
                fileFolder.mkdirs();
            }
            //读取上传的文件,(file是与前台html file input的名字对应)
            List<MultipartFile> files = ((MultipartHttpServletRequest) request).getFiles("file");
            
            for (int i = 0; i < files.size(); ++i) {
                MultipartFile file = files.get(i);
                String fileName = file.getOriginalFilename();
                Long fileSize = file.getSize()/1024;
                if (!file.isEmpty()) {
                    byte[] bytes = file.getBytes();
                    BufferedOutputStream out =null;
                    try {
                        out = new BufferedOutputStream(new FileOutputStream(new File(fileFolder+"//"+fileName)));
                        out.write(bytes);
                    }catch (IOException e) {
                        logger.error(e.getMessage(),e);
                    } finally {
                        if(out != null) {
                            try {
                                out.close();
                            } catch (IOException e) {
                                logger.error(e.getMessage(),e);
                            }
                        }
                    }
                }
            }
        } catch (RuntimeException e) {
            logger.error(e.getMessage(),e);
        } catch (IOException e) {
            logger.error(e.getMessage(),e);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
        }
    }

