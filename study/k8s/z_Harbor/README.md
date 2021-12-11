# Harbor

## Overview

镜像管理工具

## 简介

> Harobor的每个组件都是以Docker容器的形式创建，使用Docker compose对他进行部署。
> 用于部署Harbor的Docker compose模板位于/Deployer/docker-compose.yml中。
> 由5个容器组成，这几个容器通过Docker link的形式连接在一起，在容器之间通过容器名字互相访问。
> 对终端用户而言，只需要暴露Proxy(即nginx)的服务端口即可

* Proxy
  * 由nginx服务器构成的反向代理
* Registry
  * 由Docker官方开源的Registry镜像构成的容器实例
* UI
  * 即架构中的core services服务，构成此容器的代码是Harbor项目的本体
* Mysql
  * 由官方mysql镜像构成的数据库容器
* Log
  * 运行着rsyslogd的容器，通过log-driver的形式收集其他容器的日志

## 企业级环境中搭建Harbor

> [企业级环境中基于 Harbor 搭建](https://link.segmentfault.com/?enc=7mLeqY5nx%2FfkcsNi%2F4ciqw%3D%3D.F4RYntujNXz7hXTgzjn1EtJTRtNhl%2FNcmRKgs7lBY77edFAVqu0sd8oXtHZUR3v4zpWs%2B4GBePdC2lOjwFBheDCm6WxseWfMBnB51ofX6u%2BNcWQDwZ6Frcbhjc1mAH8EhrA53d2M0prUZKzB6iOCisEZ43cq0N5zoARcvF1bqyr11Togjg2GSx9ZbqQu4MA2BxZY%2FAZeY0rebSlMdAGR3VYzGe1Vl8Sn27qvNb%2BJuuYjwxN99eF%2FZR9l9TYAH34DE2%2Fqe14pxaCGQe9LwrRdpQB37KhZC6SO8rEd7WRdVuunJcn96j9SofnKU105rT1s9MUh0Pq5qPQbqYbW5kyWbPRwDLeRLJ1Wi%2FEPYLt1njM%3D)
