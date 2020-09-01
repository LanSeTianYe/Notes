时间：2020/4/27 22:01:06

参考： 

1. [Install Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) 
2. [Installing Kubernetes with Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)

## 常用命令 

1. 使用内源启动。


		minikube.exe start --image-mirror-country=cn --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.8.0.iso --registry-mirror=https://xxxxxx.mirror.aliyuncs.com --vm-driver="hyperv" --hyperv-virtual-switch="minikube"