时间：2021-08-09 15:19:19

## GO 网络模块

### net.Conn 网络连接 `net.Dial("TCP/UDP/IP", "43.225.158.198:80")`

面向字节流的网络连接。

```go
Read(b []byte) (n int, err error)
Write(b []byte) (n int, err error)
Close() error
LocalAddr() Addr
RemoteAddr() Addr
SetDeadline(t time.Time) error
SetReadDeadline(t time.Time) error
SetWriteDeadline(t time.Time) error
```

### net.PacketConn 

面向消息的连接。

```go
ReadFrom(p []byte) (n int, addr Addr, err error)
WriteTo(p []byte, addr Addr) (n int, err error)
Close() error
LocalAddr() Addr
SetDeadline(t time.Time) error
SetReadDeadline(t time.Time) error
SetWriteDeadline(t time.Time) error
```

### net.UDPConn <==> net.Conn + net.PacketConn `net.ListenUDP("udp", "8080")`

UDP 网络连接

```
Read(b []byte) (n int, err error)
Write(b []byte) (n int, err error)
ReadFrom(p []byte) (n int, addr Addr, err error)
WriteTo(p []byte, addr Addr) (n int, err error)
Close() error
LocalAddr() Addr
RemoteAddr() Addr
SetDeadline(t time.Time) error
SetReadDeadline(t time.Time) error
SetWriteDeadline(t time.Time) error
```

### net.Listener 网络服务器，监听一个地址 `net.Listen("tcp", ":8080")`

```go
Accept() (Conn, error)
Close() error
Addr() Addr
```

### net.Addr 网络地址

```go
Network() string
String() string
```


### net.Dialer  拨号器

包含连接相关的配置。

```go
Timeout time.Duration
Deadline time.Time
LocalAddr Addr
DualStack bool
FallbackDelay time.Duration
KeepAlive time.Duration
Resolver *Resolver
Cancel <-chan struct{}
Control func(network, address string, c syscall.RawConn) error
```
