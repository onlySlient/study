# kubectl 使用指南

> kubectl是Kubernetes自带的客户端，可以用它直接操作Kubernetes集群。

## 使用参数

* get       #显示一个或多个资源
* describe  #显示资源详情
* create    #从文件或标准输入创建资源
* update   #从文件或标准输入更新资源
* delete   #通过文件名、标准输入、资源名或者 label 删除资源
* log       #输出 pod 中一个容器的日志
* rolling-update  #对指定的 RC 执行滚动升级
* exec  #在容器内部执行命令
* port-forward #将本地端口转发到 Pod
* proxy   #为 Kubernetes API server 启动代理服务器
* run     #在集群中使用指定镜像启动容器
* expose   #将 SVC 或 pod 暴露为新的 kubernetes service
* label     #更新资源的 label
* config   #修改 kubernetes 配置文件
* cluster-info #显示集群信息
* api-versions #以”组/版本”的格式输出服务端支持的 API 版本
* version       #输出服务端和客户端的版本信息
* help         #显示各个命令的帮助信息
* ingress-nginx  #管理 ingress 服务的插件(官方安装和使用方式)

## 使用相关配置

kubectl自动补全

```shell
source <(kubectl completion zsh)
source <(kubectl completion bash)
```

显示合并后的kubeconfig配置

```shell
kubectl config view
```

获取pod和svc的文档

```shell
kubectl explain pods,svc
```

## 创建资源对象

分步创建

```shell
# yaml
kubectl create -f xxx-rc.yaml
kubectl create -f xxx-service.yaml

# json
kubectl create -f ./pod.json
cat pod.json | kubectl create -f -

# yaml2json
kubectl create -f docker-registry.yaml --edit -o json
```

一次性创建

```shell
kubectl create -f xxx-service.yaml -f xxx-rc.yaml
```

根据目录下所有的yaml文件定义内容进行创建

```shell
kubectl create -f <目录>
```

使用url来创建资源

```shell
kubectl create -f https://git.io/vPieo
```

查看资源对象

```shell
# 查看所有node
kubectl get nodes

# 查看所有namespace
kubectl get namespace
```

查看所有Pod对象

```shell
# 列出默认namespace中的所有pod
kubectl get pods

# 列出指定namespace中所有pod
kubectl get pods --namespace=test

# 列出所有namespace中的所有pod
kubectl get pods --all-namespaces

# 列出所有pod并显示详细信息
kubectl get pods -o wide

# 理出该namespace中所有pod包括未初始化的
kubectl get pods,rc,services --include-uninitialized
```

查看所有RC对象

```shell
kubectl get rc
```

查看所有Deplyment对象

```shell
# 查看全部deployment
kubectl get deployment

# 列出指定deployment
kubectl get deployment my-app
```

查看所有Service对象

```shell
kubectl get svc
kubectl get service
```

查看不同Namespace下的Pod对象

```shell
kubectl get pods -n default
kubectl get pods --all-namespace
```

查看资源描述  

显示Pod详细信息

```shell
kubectl describe pods/nginx
kubectl describe pods my-pod
kubectl describe -f pod.json
```

查看Node详细信息

```shell
kubectl describe nodes c1
```

查看RC关联的Pod信息

```shell
kubectl describe pods <rc-name>
```

更新修补资源  

滚动更新

```shell
# 滚动更新 pod frontend-v1
kubectl rolling-update frontend-v1 -f frontend-v2.json

# 更新资源名称并更新镜像
kubectl rolling-update frontend-v1 frongtend-v2 --image=image:v2

# 更新 frontend pod中的镜像
kubectl rolling-update frontend --image=image:v2

# 退出已存在的进行中的滚动更新
kubectl rolling-update frontend-v1 frontend-v2 --rollback

# 强制替换；删除后重新创建资源；服务会中断
kubectl replace --force -f ./pod.json

# 添加标签
kubectl label pods my-pod new-label=awesone

# 添加注解
kubectl annotate pods my-pod icon-url=http://goo.gl/XXBTWq
```

修补资源

```shell
# 部分更新节点
kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'

# 更新容器镜像; spec.containers[*].name是必须的，因为这是合并的关键字
kubectl patch pod valid-pod -p '{"spec":{"containers":[{"name":"kubernetes-serve-hostname","image":"new image"}]}}'
```

Scale资源

```shell
# Scale a replicaset named 'foo' to 3
kubectl scale --replicas=3 rs/foo

# Scale a resource specified in "foo.yaml" to 3
kubectl scale --replicas=3 -f foo.yaml

# If the deployment named mysql's current size is 2, scale mysql to 3
kubectl scale --current-replicas=2 --replicas=3 deployment/mysql

# Scale multiple replication controllers
kubectl scale --replicas=5 rc/foo rc/bar rc/baz
```

删除资源对象

基于yaml文件删除pod对象

```shell
# yaml 文件名字是你创建的名字
kubectl delete -f xxx.yaml
```

删除某个label的pod对象

```shell
kubectl delete pods -l name=<label-name>
```

删除包括某个label的service对象

```shell
kubectl delete services -l name=<label-name>
```

删除包括某个label的pod和service

```shell
kubectl delete pods,services -l name=<label-name>
```

删除所有pod/services对象

```shell
kubectl delete pods,service,deployment --all
```

编辑资源对象

在编辑器中编辑任何API资源

```shell
# 编辑名为docker-registry的service
kubectl edit svc/docker-registry
```

直接执行命令  

在主机上，不进入容器直接执行命令  

执行pod的date命令，默认使用pod的第一个容器执行

```shell
kubectl exec mypod -- date
kubectl exec mypod --namespace=test -- date
```

指定pod中某个容器执行date命令

```shell
kubectl exec mypod -c ruby-container -- date
```

进入某个容器

```shell
kubectl exec mypod -c ruby-container -it -- bash
```

查看容器日志

直接查看日志

```shell
# 不实时刷新kubectl logs mypod
kubectl logs mypod --namespace-test
```

查看日志实时刷新

```shell
kubectl logs -f mypod -c ruby-container
```

