时间：2024-09-12 16:00:00

参考：

1. [how-to-install-epel-repository-on-centor-stream9](https://www.linuxcnf.com/2023/03/how-to-install-epel-repository-on.html)

## CentOS Stream 9 软件源

```
dnf config-manager --set-enabled crb

dnf install epel-release epel-next-release epel-rpm-macros

dnf repolist epel

dnf repolist epel-next

dnf repolist epel-rpm-macros
```