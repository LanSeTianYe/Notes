## Maven安装jar包到本地仓库

	mvn install:install-file -Dfile=G:\authorise-core.jar -DgroupId=com.enerbos -DartifactId=authorise-core -Dpackaging=jar -Dversion=2.0

## 安装dubbo

    mvn install:install-file -Dfile=./dubbo-2.8.4.jar -DgroupId=com.alibaba -DartifactId=dubbo -Dpackaging=jar -Dversion=2.8.4