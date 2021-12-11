# Resource

> 资源清单
> k8s中所有的内容都抽象为了资源，资源实例化之后就叫做对象
> 在Kubernetes系统中，Kubernetes对象是持久化的实体，Kubenetes使用这些实体去表示整个集群的状态。

* 哪些容器化应用在运行，以及在哪个node上
* 可以被应用使用的资源
* 关于应用运行时表现的策略，比如重启策略、升级策略，以及容错策略

> Kubernetes对象是"目标性记录"
> 一旦创建对象，Kubernetes系统将持续工作以确保对象存在。通过创建对象，本质上是在告知Kubernetes系统，所需要的集群工作负载看起来是什么样子的，这就是Kubernetes集群的期望状态。

具体介绍参考以下链接
> [Kubernetes 之资源清单详细介绍](https://link.segmentfault.com/?enc=gGgF5P80b0cqHrLiMNEwGA%3D%3D.3aR3qGzNvtVmSXwkCl%2FyP675FbyHCpN6abKUkBu%2Ffi%2Fmy9NdVw6HhD2Covg5snjqNo7YXD6FhInveHL%2Bx1qJ%2Ff7YPJVrWH639QElunblEy0Kz0Dm%2FHFTIFQw8Py74A3Tdl9PBmg%2BtnC4xzzSr75zO0QSQ2DHmS%2BFrTrazBs0aEzdAmwZoNwwj6QchC8s%2FEfeK%2B55O00H5hFotqRdRPjy%2B9Y99v%2B2GYuBUiALLswnQQWcs12425cEay8evTzRrd9%2FT8n3nd7WaqW1Mi9vDNFOmutxVvokBD2ShkdJ12A5E5uZ0dFvXtITBzvmeqeo0AnV5yDNVBb6LFtddwG%2F2Fru0ONzSbMLB55v%2FD5d7HTkW9s%3D)
