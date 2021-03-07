时间：2019-01-31 21:09:15 

## Linux 文件系统 

### 概念及简介 

`ext2` 使用索引结构通过索引连接 inode 和 data block，inde 里包含直接、双间接、三间接记录区，当文件数据过大时，使用双间接和三间接实现扩充功能，Linux 文件系统分以下几个概念。

在Linux中，目录和文件都会占用一个inode，对于目录来说 inode 中存储目录的属性，inode指向的 data block 记录目录下的文件及文件对应的inde位置。

磁盘经过分区，格式化（初始化节点数据）之后成为文件系统，此文件系统可以被挂载到目录上，一个磁盘只能挂载在一个目录上，一个目录上只能挂载一个文件系统，要挂载的目录最好是空目录。

* `superblock`：超级区块，记录整个文件系统的信息，
	* inode 和 block 数量，包含已经使用数量和未使用数量。
	* inode 和 block 大小，block 分 1K 2K 4K， inode 可以为 `12Byte` 或 `256` Byte。
	* 文件系统挂载时间，最近一次写入时间最近一次校验时间等。
	* 文件系统是否挂载。
* `File System Description`:文件系统描述与说明。记录blockgroup 开始和结束区块的号码。
* `block bitmap`:区块对照表，区块是否已经使用。
* `inode bitmap`:inode 是否已经使用。
* `inode table`：inode 的属性信息，所属用户，权限信息、创建时间等，文件和文件夹都占用一个inode。
* `data block`：存储文件数据的地方。

#### 链接文件 
虽然硬链接相较符号链接安全，当源文件删除时不会出现找不到文件为问题，但是由于硬链接文件限制较多，所以经常用的还是符号链接。  

* 硬链接（Hard Link）：在目录的数据块中新增一个文件名和inode的关联。假设A文件是B文件的硬链接文件，则更改A的数据B对应的数据也会改变。类似Java的引用机制。
	* 限制：硬链接文件不能跨文件系统，不能链接目录。
* 符号链接（Symbolic Link）：再创建一个文件让对文件的读取只想链接的文件。

#### XFS 文件系统 

xfs 是一个日志时文件系统，用于大容量磁盘及高性能文件系统，

* 数据区(data section): inode/data block/superblock 等。
* 文件系统活动登录区（log section）：类似于文件操作日志区，记录文件操作历史，用于文件系统快速检验。
* 实时运行区（realtime section）：创建文件时，xfs会在该区找到一个区块，存放要创建的文件，等分配完成之后再写入到实际存储位置。

### 命令使用 

 * `blkid`：显示挂载的文件系统的属性信息（UUID、文件系统类型）。
 * `dumpe2fs`：查看区段和 `superblock` 信息。
	 * `-b`：列出保留为坏轨的部分。
	 * `-f`：仅列出 superblock 的数据，不会列出其他的区段内容。

* `xfs_info`: 查看 xfs 文件系统信息。

		[root@centos_201 home]# xfs_info /dev/sda1
		meta-data=/dev/sda1              isize=512    agcount=4, agsize=65536 blks
		         =                       sectsz=512   attr=2, projid32bit=1
		         =                       crc=1        finobt=0 spinodes=0
		data     =                       bsize=4096   blocks=262144, imaxpct=25
		         =                       sunit=0      swidth=0 blks
		naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
		log      =internal               bsize=4096   blocks=2560, version=2
		         =                       sectsz=512   sunit=0 blks, lazy-count=1
		realtime =none                   extsz=4096   blocks=0, rtextents=0

* `ls -li /lib/modules/$(uname -r)/kernel/fs`: 查看Linux支持的文件系统。
* `cat /proc/filesystems`: 系统已经载入到内存中的文件系统。
* `ln`: 创建链接文件。
		
		ln 源文件 链接到的文件
		# 创建软链接
		ln -s 源文件 链接到的文件

* `lsblk`: 显示系统上所有的磁盘列表。
* `parted`: 查看磁盘的分区表类型和分区信息。

		parted /dev/sda1 print