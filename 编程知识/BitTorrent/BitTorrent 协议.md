时间：2020-11-02 11:14:14

参考：

1. [BitTorrent协议](https://zh.wikipedia.org/wiki/BitTorrent_(%E5%8D%8F%E8%AE%AE))
2. [种子文件解析网站](https://chocobo1.github.io/bencode_online/)
3. [torrent2magnet](http://torrent2magnet.com/)
4. [magnet2torrent](http://magnet2torrent.com/)
5. [The BitTorrent Protocol Specification](http://www.bittorrent.org/beps/bep_0003.html)

## BitTorrent 协议

BitTorrent（bt） 是一种点对点的文件分享协议。每个下载文件的客户端同时也是其它客户端下载文件的服务器。

协议内容由 `Tracker服务器信息` 和  `文件信息` 两部分组成。`Tracker服务器` 负责给下载客户端提供可下载服务器的IP地址列表。在 `BitTorrent协议` 中文件被分割成多个快（并不是真实的分割，只是逻辑上的分割），文件块大小是2的指数倍。客户端同时下载多个文件块，当下载完成一个文件块，又可以作为服务器让其它客户端从自己电脑下载文件，可以提高文件下载速度。

bt 文件内容：

* `announce`：tracker 服务器。
* `announce-list`：tracker 服务器列表。
* `info`: 文件信息

    * `piece length`：文件块长度，2的指数倍，通常是 `2^18B=256KB`，3.2 默认大小是使用 `2^20B = 1MB`。
    * `pieces`：20的整数倍，每20位代表一块文件的SHA-1编码。
    * `length`：文件长度。
    * `path`：

bt 文件解析后的内容：

```
{
   "announce": "udp://tracker.acg.gg:2710/announce",
   "announce-list": [
      [
         "udp://tracker.acg.gg:2710/announce"
      ],
      [
         "http://tracker3.itzmx.com:8080/announce"
      ],
      [
         "udp://inferno.demonoid.pw:3418/announce"
      ],
      [
         "http://tracker3.itzmx.com:8080/announce"
      ],
      [
         "udp://tracker.acg.gg:2710/announce"
      ]
   ],
   "comment": "Torrent downloaded from torrent cache at http://itorrents.org",
   "created by": "go.torrent",
   "creation date": 1538796049,
   "info": {
      "length": 1162936320,
      "name": "ubuntu-14.10-desktop-amd64.iso",
      "piece length": 524288,
      "pieces": "<hex>32 AD E5 A2 48 FB 76 60 15 89 D0 25 ... </hex>"
   }
}
```

另外一个例子

```
{
   "announce": "udp://tracker.openbittorrent.com:80/announce",
   "announce-list": [
      [
         "udp://tracker.openbittorrent.com:80/announce"
      ],
      [
         "udp://tracker.publicbt.com:80/announce"
      ]
   ],
   "comment": "Big Buck Bunny, Sunflower version",
   "created by": "uTorrent/3320",
   "creation date": 1387308159,
   "encoding": "UTF-8",
   "info": {
      "file-duration": [
         634
      ],
      "file-media": [
         0
      ],
      "length": 355856562,
      "name": "bbb_sunflower_1080p_60fps_normal.mp4",
      "piece length": 524288,
      "pieces": "<hex>99 71 9B 2C 2E AA B6 80 ... </hex>",
      "profiles": [
         {
            "acodec": "",
            "height": 1080,
            "vcodec": "AVC1",
            "width": 1920
         }
      ]
   },
   "url-list": [
      "http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4"
   ],
   "website": "http://bbb3d.renderfarming.net"
}

```


## 磁力链接

`magnet` 是一种文件搜索协议。常用于 bt 文件搜索。

`ubuntu-14.10-desktop-amd64` 种子文件的磁力连接。

```
`magnet:?xt=urn:btih:b415c913643e5ff49fe37d304bbb5e6e11ad5101&dn=ubuntu-14.10-desktop-amd64.iso`
```

协议组成如下：

* `magnet:?`：标识磁力连接协议。
* `xt`：exact topic 特定文件搜索，只会搜索到一个文件。根据指定算法对文件生成的一个唯一编码。

    * `urn:btin`：BitTorrent Info Hash 算法。
    * `urn:tree`：Tiger Tree散列函数。
    * `urn:sha1`：SHA-1算法。
    * `urn:bitprint`：BitPrint算法。
    * `urn:ed2k`：eD2k Hash算法。
    * `urn:md5`：MD5 摘要算法。

* `dn`：显示名称。磁链对应文件的名称。
* `kt`：关键字搜索，会搜索到多个文件。
* `mt`：文件列表，指向一个列表的URI。
