# kubeadm basic train

> kubeadm 简易创建集群
> 参考<https://segmentfault.com/a/1190000037682150>

## 环境搭建

1. 安装docker

[install docker on centos](https://docs.docker.com/engine/install/centos/)

参考[install docker](../../docker/docker/README.md)作以下配置

```shell
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 设置k8s环境准备条件

```shell
# 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld
# 关闭selinux
# 临时禁用selinux
setenforce 0
# 永久关闭 修改/etc/sysconfig/selinux文件设置
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
# 禁用交换分区
swapoff -a
# 永久禁用，打开/etc/fstab注释掉swap那一行。
sed -i 's/.*swap.*/#&/' /etc/fstab
# 修改内核参数
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

## 安装kubeadm、kubelet、kubectl

```shell
# 执行配置k8s阿里云源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
# 安装kubeadm、kubectl、kubelet
yum install -y kubectl-1.16.0-0 kubeadm-1.16.0-0 kubelet-1.16.0-0
# 启动kubelet服务
systemctl enable kubelet && systemctl start kubelet
```

## 配置master节点

```shell
# 初始化服务
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.16.0 --apiserver-advertise-address 192.168.99.104 --pod-network-cidr=10.244.0.0/16 --token-ttl 0

# --apiserver-advertise-address 指定服务地址
# --pod-network-cidr            指定网段
# --token-ttl                   指定token有效时长，0为永久
```

启动master服务后

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

通过以下命令直接打印出对应加入集群的命令

```shell
kubeadm token create --print-join-command
```

注：

1. --node-name 可以配置节点名称

## 配置node节点

```shell
kubeadm join 192.168.99.104:6443 --token ncfrid.7ap0xiseuf97gikl 
    --discovery-token-ca-cert-hash sha256:47783e9851a1a517647f1986225f104e81dbfd8fb256ae55ef6d68ce9334c6a2
```

## 运行镜像

使用[app.yaml](./app.yaml)

```shell
# 运行配置
kubectl apply -f app.yaml

# 查看所有的pod状态
kubectl get pods -A
```

## 获取当前集群节点和状态

```shell
# 获取当前所有节点
kubectl get nodes

# 获取当前运行的pods
kubectl get pod
```

## 问题总结

1. join失败问题
   1. docker没装
   2. cgroup没有配置
      1. daemon.json加入`"exec-opts": ["native.cgroupdriver=systemd"]`
   3. health check失败
      1. 一般情况下时网络设置问题，修改init的ip/网段即可
