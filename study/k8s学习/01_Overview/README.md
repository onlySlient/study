# Overview

## 概念

> Kubernetes集群都是由一组Master节点和一些列的Worker节点组成，其中Master节点主要负责存储集群的状态并为Kubernetes对象分配和调度资源。

### 主节点服务 - Master架构

接收客户端请求，安排容器执行控制循环，将集群的状态向目标状态进行迁移。  

Master节点由下面4个组件构成

1. API server
   1. 对外提供restful接口
   2. 处理来自用户的请求
   3. 注：唯一一个与etcd集群通讯的组件
2. etcd
   1. 兼具一致性和高可用性的键值数据库
   2. 用于保存Kubernetes所有集群数据的后台数据库
3. Scheduler
   1. 主节点上的组件
   2. 监视新创建的未指定运行节点Pod,并选择节点让Pod运行
   3. 调度决策考虑因素
      1. 单个Pod和Pod集合的资源需求、硬件/软件/策略约束、亲和性和反亲和性规范、数据位置、工作负载间的干扰和最后时限
4. Controller-Manager
   1. 主节点上的组件
   2. 分类
      1. 节点控制
         1. 负责在节点处故障时进行通知和相应
      2. 副本控制器
         1. 负责为系统中的每个副本控制器对象维护正确数量的Pod
      3. 端点控制器
         1. 填充端点EndPoints对象
            1. 注入Service和Pod
      4. 服务账户
      5. 令牌控制器
         1. 为新的命名空间创建默认账户和API访问令牌

### 工作节点 - Node架构

> 主要是由kubelet和kube-proxy组成

1. kubelet
   1. 工作节点执行操作的agent
   2. 容器生命周期的管理
   3. 上报pod运行状态
2. kube-proxy
   1. 网络访问代理
   2. Load Balancer
   3. 将访问到某个服务的请求具体分配给工作节点上同一类标签的Pod
   4. 本质：就是通过操作防火墙规则(iptables或者ipvs)来实现Pod的映射
3. Container Runtime
   1. 运行容器的软件
   2. k8s支持的容器运行环境
      1. Docker
      2. Containerd
      3. cri-o
      4. rktlet
      5. 其他实现kubernetes CRI(容器运行环境接口)的软件

### 调用流程(FIXME)

1. apiserver: watch Services and Endpoints
2. open proxy port and set portal rules
3. connect to service address
4. redirect to (random) proxy port
5. proxy to a backend

## 关于K8s的一些基本概念

* apiserver
  * 服务访问的唯一入口
  * 提供认证、授权、访问控制、API注册和服务发现等机制
* controller manager
  * 负责维护集群的状态，比如副本期望数量、故障检测、自动扩展、滚动更新
* scheduler
  * 资源的调度，按照预定的调度策略将Pod调度到相应的机器上
* etcd
  * 键值对数据库，保存了整个集群的状态
* kubelet
  * 负责维护容器的生命周期，同时也负责Volume和网络的管理
* kube-proxy
  * 负责为Service提供cluster内部的服务发现和负载均衡
* Container runtime
  * 负责镜像管理以及Pod和容器的真正运行

推荐的插件

* CoreDNS
  * 可以为集群中的SVC创建一个域名IP的对应关系解析的DNS服务
* Dashboard
  * 给K8S集群提供了一个B/S架构的访问入口
* Ingress Controller
  * 官方能够实现四层网络代理，而Ingress可以实现七层的网络代理
* Prometheus
  * 可以给K8S集群提供资源监控的能力
* Federation
  * 提供一个可以跨集群中心多K8s的统一管理功能，提供跨可用区的集群

## Kubernetes集群的四大基本对象

> Pod、Service、Volume和Namespace是k8s集群中的四大基本对象。他们能够表示系统中部署的应用、工作负载、网络和磁盘资源，共同定义了集群的状态。K8s中其他很多资源其实只是对这些基本对象进行了整合。

1. Pod
   1. 集群中的基本单元
2. Service
   1. 解决如何访问Pod里面服务的问题
3. Volume
   1. 集群中的存储卷
4. Namespace
   1. 命名空间为集群提供虚拟的隔离作用
