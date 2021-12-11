# Scheduler

> 集群调度
> 集群中多台服务的配置是不一致的，这就导致资源的分配是不均匀的。比如有些服务节点需要用来运行进行计算密集型的服务，而有些服务来运行需要大量内存的服务。

Scheduler是Kubernetes的调度器，主要任务是把定义的Pod分配到集群的节点上。需要考虑一下几个问题：

* 公平
  * 如何保证每个节点都能被分配到资源
* 资源高效利用
  * 集群所有资源最大化被使用
* 效率
  * 调度的性能要好，能够尽快地对大批量的Pod完成调度工作
* 灵活
  * 允许用户根据自己的需求控制调度的逻辑

> Scheduer 是作为单独的程序运行的，启动后会一直坚挺API Server，获取PodSpec.NodeName为空的Pod,对每个Pod都会创建一个binding，表明该Pod应该放到哪个节点上。
> [Kubernetes 之集群调度](https://link.segmentfault.com/?enc=6N0UgiaI10VCRc38kyK6xg%3D%3D.o%2FIRhPoBreEL8rg%2BDuolqJvEjmiySUXy0qPrihlL%2BD7x5IAPpLH7UjpbC2Y6TE0tJTx3z%2FEfLcx6eoJ5tejqzo9bdi3w9MmM5hOgkCCvRiJwONVU3qRfPBXPxe%2B%2F3Yz28hRh148i8Rp%2BI0NAvgHIdjkpC6x%2F8mbhNQ%2FK3X4XNcwYRiAHcaBrDqgnK1fBRj6sXoCf22um96icibDnI7%2BfWn3eYibTXPpFy3W4d5eyrFKsEv9444rMHQ%2B7qXC%2FGEzXnM4jQJN0T8E576zD61%2F0lfEjFKH1A1vSSk765SZVFfC6BAaB96bgCC2Unu%2FJCMg9arbgBLSIRrjmbfP7UDdIKN2QBZfyQ%2B19XsWQ21ojl3w%3D)
