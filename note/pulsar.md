# Pulsar

## Overview

> Location: [Plusar](https://pulsar.apache.org/)  
> Github: [Plusar](https://github.com/apache/pulsar)  
> Author: [Apache](https://www.apache.org/)  
> Doc: <https://pulsar.apache.org/docs/en/standalone/>

> Pulsar 是一个分布式发布-订阅消息平台，具有非常灵活的消息模型和直观的客户端 API。

## Future（To be verified）

* 水平可扩展（每秒发布数百万个独立主题和数百万条消息）
* 强排序和一致性保证
* 低延迟持久存储
* 主题和队列语义
* 负载均衡器
* 专为部署为托管服务而设计：
* 多租户
* 验证
* 授权
* 配额
* 支持混合非常不同的工作负载
* 可选硬件隔离
* 跟踪消费者光标位置
* 用于配置、管理和统计的 REST API
* 地域复制
* 分区主题的透明处理
* 消息的透明批处理

## Principle

TODO

## Train

### Install On docker

Document
> <https://pulsar.apache.org/docs/en/standalone-docker/>

Cli
> docker run -itd \
  -p 6650:6650 \
  -p 8080:8080 \
  --mount source=pulsardata,target=/pulsar/data \
  --mount source=pulsarconf,target=/pulsar/conf \
  apachepulsar/pulsar:2.8.1 \
  bin/pulsar standalone

### Install On K8s

Document:
> <https://pulsar.apache.org/docs/zh-CN/kubernetes-helm>

### Pulsar manager

> Pulsar Manager 是一个网页式可视化管理与监测工具，支持多环境下的动态配置。可用于管理和监测租户、命名空间、topic、订阅、broker、集群等。

Document:
> <https://pulsar.apache.org/docs/zh-CN/administration-pulsar-manager/>

Cli:
> docker run -itd \
    -p 9527:9527 -p 7750:7750 \
    -e SPRING_CONFIGURATION_FILE=/pulsar-manager/pulsar-manager/application.properties \
    apachepulsar/pulsar-manager:v0.2.0

## How to use

TODO

## Thought

TODO

## Summary

TODO
