时间：2018/6/29 11:47:51  

来源：  

1. [TensorFlow 基本概念](https://colab.research.google.com/notebooks/mlcc/tensorflow_programming_concepts.ipynb?hl=zh-cn#scrollTo=NzKsjX-ufyVY)

## 概念概览

TensorFlow 的名称源自**张量**，张量是任意维度的数组。借助 TensorFlow，您可以操控具有大量维度的张量。即便如此，在大多数情况下，您会使用以下一个或多个低维张量：

  * **标量**是零维数组（零阶张量）。例如，`\'Howdy\'` 或 `5`
  * **矢量**是一维数组（一阶张量）。例如，`[2, 3, 5, 7, 11]` 或 `[5]`
  * **矩阵**是二维数组（二阶张量）。例如，`[[3.1, 8.2, 5.9][4.3, -2.7, 6.5]]`

TensorFlow **指令**会创建、销毁和操控张量。典型 TensorFlow 程序中的大多数代码行都是指令。

TensorFlow **图**（也称为**计算图**或**数据流图**）是一种图数据结构。很多 TensorFlow 程序由单个图构成，但是 TensorFlow 程序可以选择创建多个图。图的节点是指令；图的边是张量。张量流经图，在每个节点由一个指令操控。一个指令的输出张量通常会变成后续指令的输入张量。TensorFlow 会实现**延迟执行模型**，意味着系统仅会根据相关节点的需求在需要时计算节点。

张量可以作为**常量**或**变量**存储在图中。您可能已经猜到，常量存储的是值不会发生更改的张量，而变量存储的是值会发生更改的张量。不过，您可能没有猜到的是，常量和变量都只是图中的一种指令。常量是始终会返回同一张量值的指令。变量是会返回分配给它的任何张量的指令。

要定义常量，请使用 `tf.constant` 指令，并传入它的值。例如：

	x = tf.constant([5.2])

同样，您可以创建如下变量：

	y = tf.Variable([5])

或者，您也可以先创建变量，然后再如下所示地分配一个值（注意：您始终需要指定一个默认值）：

	y = tf.Variable([0])
	y = y.assign([5])

定义一些常量或变量后，您可以将它们与其他指令（如 `tf.add`）结合使用。在评估 `tf.add` 指令时，它会调用您的 `tf.constant` 或 `tf.Variable` 指令，以获取它们的值，然后返回一个包含这些值之和的新张量。

图必须在 TensorFlow **会话**中运行，会话存储了它所运行的图的状态：

	with tf.Session() as session:：
		initialization = tf.global_variables_initializer()
		print y.eval()

在使用 `tf.Variable` 时，您必须在会话开始时调用 `tf.global_variables_initializer`，以明确初始化这些变量，如上所示。

**注意：**会话可以将图分发到多个机器上执行（假设程序在某个分布式计算框架上运行）。有关详情，请参阅[分布式 TensorFlow](https://www.tensorflow.org/deploy/distributed)。

### 总结

TensorFlow 编程本质上是一个两步流程：

1. 将常量、变量和指令整合到一个图中。
2. 在一个会话中评估这些常量、变量和指令。

## 创建一个简单的 TensorFlow 程序

我们来看看如何编写一个将两个常量相加的简单 TensorFlow 程序。

### 添加 import 语句

与几乎所有 Python 程序一样，您首先要添加一些 `import` 语句。
当然，运行 TensorFlow 程序所需的 `import` 语句组合取决于您的程序将要访问的功能。至少，您必须在所有 TensorFlow 程序中添加 `import tensorflow` 语句：

	import tensorflow as tf

**请勿忘记执行前面的代码块（`import` 语句）。**

其他常见的 import 语句包括：

	import matplotlib.pyplot as plt # 数据集可视化。
	import numpy as np              # 低级数字 Python 库。
	import pandas as pd             # 较高级别的数字 Python 库。

TensorFlow 提供了一个**默认图**。不过，我们建议您明确创建自己的 `Graph`，以便跟踪状态（例如，您可能希望在每个单元格中使用一个不同的 `Graph`）。

计算两个常量的和： 

	import tensorflow as tf
	
	# Create a graph.
	g = tf.Graph()
	
	# Establish the graph as the "default" graph.
	with g.as_default():
	  # Assemble a graph consisting of the following three operations:
	  #   * Two tf.constant operations to create the operands.
	  #   * One tf.add operation to add the two operands.
	  x = tf.constant(8, name="x_const")
	  y = tf.constant(5, name="y_const")
	  sum = tf.add(x, y, name="x_y_sum")
	
	
	  # Now create a session.
	  # The session will run the default graph.
	  with tf.Session() as sess:
	    print sum.eval()