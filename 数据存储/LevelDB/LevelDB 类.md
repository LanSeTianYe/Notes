时间：2022-10-21 16:52:52

参考：

## LevelDB 类

**FileMetaData：**文件信息

```c++
struct FileMetaData {
  //文件被引用的次数  
  int refs;
  //允许无效访问的次数  
  int allowed_seeks;  // Seeks allowed until compaction
  //文件大小  
  uint64_t file_size;    // File size in bytes
  //最小key
  InternalKey smallest;  // Smallest internal key served by table
  //最大key
  InternalKey largest;   // Largest internal key served by table
};
```

**Compaction** 记录执行压缩的信息

```c++
class Compaction {
 private:
  friend class Version;
  friend class VersionSet;
  // 层级
  int level_;
  //最大输出文件大小，用于压缩向上优化时限制总文件大小  
  uint64_t max_output_file_size_;
  //当前版本信息  
  Version* input_version_;
  //压缩变更的信息
  VersionEdit edit_;

  // 当前层文件和下一层文件
  std::vector<FileMetaData*> inputs_[2];  // The two sets of inputs
  
  size_t level_ptrs_[config::kNumLevels];
};
```
