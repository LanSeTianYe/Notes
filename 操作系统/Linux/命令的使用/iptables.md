时间：2021-06-09 19:58:58

## iptables

1. 开放端口

```
iptables -I INPUT -p udp --dport 11301 -j ACCEPT && iptables -I INPUT -p udp --dport 12301 -j ACCEPT
```