时间：2025-01-17 10:23:23

参考：

1. [https://github.com/caddyserver/caddy.git](https://github.com/caddyserver/caddy.git)
2. [https://github.com/coredns/coredns](https://github.com/coredns/coredns)

## 源码分析 Caddy

`coredns` 通过配置文件加载不同的插件。看代码时候发现底层是调用 `Caddy` 实现的，对 `Caddy` 产生了兴趣，就决定看一下 `Caddy` 的源码。

看 `Caddy` 源码时，发现 `Caddy` 的模块加载机制实现比较巧妙，这里记录一下。



