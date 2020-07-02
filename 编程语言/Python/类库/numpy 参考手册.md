时间：2019-08-10 

##  numpy 参考手册   

numpy 是 numerical python 的缩写。提供数值计算相关的函数库，包含矩阵计算。大部分函数底层用C语言实现，性能较python实现要高很多。

数组相乘：`行*列` 最后求和。

	a = [
			[a,b,c],
			[d,e,f]
		]
	b = [
			[h,i],
			[k,l],
			[n,o]	
		]

	a * b = [
				[ah+bk+cn,ai+bl+cn],
				[dh+ek+fn,di+el+fo]
			]

## 数组   

定义变量：

	a = np.random.rand(5)
	b = np.random.rand(5)
	2_d_array = np.ones((2,5))
### 变量  

* `np.pi`：PI。
* `np.NAN`：nan，float 类型。

### 函数  
* `np.array([1, 2, 3])`：以为数组。
* `np.array([[1, 2, 3], [4, 5, 6]])`：二维数组。
* `np.zeros(5)`：一维数组。
* `np.ones(5)`：一维数组。
* `np.zeros((2,3))`：两行三列的二维数组。
* `np.full((i,j),m)`：使用 `m` 填充 `i` 行 `j` 列的数组。
* `np.random.rand(5)`：一维数组。
* ` np.linspace(a, b, m)`：`[a,b]` 之间生成 `m` 个元素，包含 `a、b`。
* `2_d_array[1,:]`：取第一行。
* `2_d_array[:,1]`：取第一列。
* `2_d_array[n:,i:j]`：取第 `n` 行，第 `[i-1,j-1)` 列的元素。
* `2_d_array[::2,::2]` 取 `[0, 2, 4 ..]` 行和列的元素。
* `a+b` `a-b` `a*b` `a/b` `a%b`：对应行列运算，而不是线性代数里面的矩阵运算。
* `a.sum()`：求和。
* `a.min()`：最小值。
* `a.max()`：最大值。
* `a.cumsum()`：求和过程数组，第一个元素是数组的第一个元素，最后一个元素是数组元素的和。
* `a.dot(b)`：矩阵乘法。
* `np.where()`：返回满足条件的值的下标。
* `np.eye()`：二维单位矩阵。除了 `a[i][i]` 是1，其余都是0。类似于数字中的一，任何矩阵和单位举证相乘都是本身。
* `np.transpose(np.array([[2,1,3]]))`：矩阵转置。
* `np.repeat(a, 3)`：每个元素重复三次。
* `np.tile(a, 3)`：整个数组重复三次。
* `np.intersect1d()`：数组中相同的项（索引可以不一样）。
* `np.setdiff1d(a,b)`：从 `a` 中 删除 `b` 中有的元素。
* `np.vstack((a,b))`：数组堆叠，垂直方向堆叠。
* `np.hstack((a,b))`：数组堆叠，水平方向堆叠。

### 数组属性  

用于查看数据记录的元素的属性，如大小、形状、数据类型等。

* `type(a)`：数组 `a` 的类型。
* `a.dtype`：数组 `a` 里元素的数据类型。
* `a.size` ：数组里有多少个元素。
* `a.shape`：数组的形状，几行几列。
* `a.itemsize`：每个元素占用空间的大小，单位字节。
* `a.nbytes`： `a.size * a.itemsize`：数组元素的实际大小，单位字节。
* `a.ndim`：数组的维数。

### 其它用法  

#### boolean 过滤 

	line = np.linspace(0, 2 * np.pi, 50)
	# 正弦函数
	sine_line = np.sin(line)
	# 正弦值大于零的部分 
	mask = sine_line >= 0
	plt.plot(line, sine_line)
	plt.plot(line[mask], sine_line[mask], 'bo')
	# 正弦值大于零，且 x 小于 np.pi/2 的部分
	mask = (sine_line >= 0) & (line <= np.pi / 2)
	plt.plot(line[mask], sine_line[mask], 'go')
	plt.show()

### 数组索引 
* 切片索引：使用切片语法生成的一个数组的视图，切片索引和原始数组用的同一份数据，改变切片的数据，原始数据也会改变。

 

* 整数索引： 

		a = np.array([[1,2], [3, 4], [5, 6]])
		print(a[[0, 1, 2], [0, 1, 0]]) -> a[0][0] a[1][1] a[2][0]
		

