时间：2018/2/12 17:09:47  

## 图片处理（JAVA）

### 图片压缩

#### guetzli 
 
* 简介：Google 开源的 `JPEG` 编码格式图片压缩工具。压缩之后图片大小减少 20%~30%，但是图片的视觉效果并不会变差，反而可能变的更好。  
* 参考文章：[GUETZLI - 高品質圖像壓縮](https://tachingchen.com/tw/blog/google-guetzli-image-compression-algorithm/)
* 项目地址：[guetzli](https://github.com/google/guetzli/)  
* 原理：对图片进行重新编码。
* 用途：压缩图片，减少占用空间，减小网络压力。  
* 缺点：压缩过程比较耗时。   

#### [EasyImage](https://dzone.com/articles/easyimage-%E2%80%93-third-party-jar)

EasyImage是一个图片制作的第三方Jar包，可以做所有基础的图片操作：转换，裁剪，缩放，选择等；可以结合很多总操作，创造出很酷的效果；操作 简单等。    

* 融合两张图片，代码如下：

		Image image  = new Image("c:/pics/p1.jpg");
		image.combineWithPicture("c:/pics/p2.jpg");
		image.saveAs("c:/pics/p1combinedWithp2.jpg");

    效果如下：

    ![](http://www.oschina.net/uploads/img/201003/10110300_rdwT.jpg)

* 要强调图像的某个部分：

		Image image  = new Image("c:/pics/p1.jpg");
		image.emphasize(250, 200, 2300, 500);
		image.saveAs("c:/pics/p1Emphesized.jpg");

	![](http://www.oschina.net/uploads/img/201003/10110357_6Cfu.jpg)
* 可支持的图像处理方法有：
	
		* Open image.
		* Save image
		* Convert image
		* Re-size image
		* Crop image
		* Convert to black and white image
		* Rotate image
		* Flip image
		* Add color to image
		* Create image with multiple instance of the original
		* Combining 2 images together
		* Emphasize parts of the image
		* Affine transform image