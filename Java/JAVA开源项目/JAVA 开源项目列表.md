## 一些可能有用的开源项目

1.  图片效果制作的Jar包  EasyImage(有问题)

    > EasyImage是一个图片制作的第三方Jar包，可以做所有基础的图片操作：转换，裁剪，缩放，选择等；可以结合很多总操作，创造出很酷的效果；操作 简单等……    

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